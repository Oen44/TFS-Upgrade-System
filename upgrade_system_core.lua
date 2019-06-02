dofile("data/upgrade_system_const.lua")

US_CONDITIONS = {}
US_BUFFS = {}

function us_onUse(player, item, fromPosition, target, toPosition, isHotkey)
  if not target or not target:isItem() or not target:getType():isUpgradable() then
    return false
  end
  if target:isMirrored() then
    player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is already mirrored and can't be modified!")
    player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    return true
  end
  local itemType = ItemType(target.itemid)
  if item.itemid == US_CONFIG[1][ITEM_UPGRADE_CRYSTAL] then
    if itemType:isUpgradable() then
      local upgrade = target:getUpgradeLevel()
      if upgrade < US_CONFIG.MAX_UPGRADE_LEVEL then
        upgrade = upgrade + 1
        if upgrade >= US_CONFIG.UPGRADE_LEVEL_DESTROY then
          if math.random(100) > US_CONFIG.UPGRADE_DESTROY_CHANCE[upgrade] then
            if player:getItemCount(US_CONFIG.ITEM_UPGRADE_CATALYST) > 0 then
              player:sendTextMessage(MESSAGE_INFO_DESCR, "Upgrade failed! Item protected from destroying!")
              player:removeItem(US_CONFIG.ITEM_UPGRADE_CATALYST, 1)
              item:remove(1)
              player:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)
              return true
            end
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Upgrade failed! Item destroyed!")
            target:remove(1)
            item:remove(1)
            player:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)
            return true
          end
        else
          if math.random(100) > US_CONFIG.UPGRADE_SUCCESS_CHANCE[upgrade] then
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Upgrade failed! Upgrade level -1!")
            target:reduceUpgradeLevel()
            item:remove(1)
            player:getPosition():sendMagicEffect(CONST_ME_GROUNDSHAKER)
            return true
          end
        end

        target:setUpgradeLevel(upgrade)

        item:remove(1)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Item upgrade level increased by " .. upgrade .. "!")
        player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
        player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_YELLOW)
        if target:getItemLevel() == 0 then
          target:setItemLevel(1, true)
        end
      else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Maximum upgrade level reached!")
      end
    else
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      return true
    end
  elseif item.itemid == US_CONFIG[1][ITEM_ENCHANT_CRYSTAL] then
    if target:isUnique() then
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cant add attributes to Unique items!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    else
      if itemType then
        local weaponType = itemType:getWeaponType()
        if not target:rollAttribute(player, itemType, weaponType) then
          player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        else
          item:remove(1)
        end
      end
    end
  elseif item.itemid == US_CONFIG[1][ITEM_ALTER_CRYSTAL] then
    if target:isUnique() then
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cant remove Unique attributes!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    else
      local bonuses = target:getBonusAttributes()
      if bonuses then
        local last = target:getLastSlot()
        target:removeCustomAttribute("Slot" .. last)
        item:remove(1)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Successfuly removed last attribute.")
      else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item has no attributes!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      end
    end
  elseif item.itemid == US_CONFIG[1][ITEM_CLEAN_CRYSTAL] then
    if target:isUnique() then
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "You cant remove Unique attributes!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    else
      local bonuses = target:getBonusAttributes()
      if bonuses then
        for i = 1, #bonuses do
          target:removeCustomAttribute("Slot" .. i)
        end
        item:remove(1)
        player:sendTextMessage(MESSAGE_INFO_DESCR, "Successfuly removed all attributes.")
      else
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item has no attributes!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      end
    end
  elseif item.itemid == US_CONFIG[1][ITEM_FORTUNE_CRYSTAL] then
    local bonuses = target:getBonusAttributes()
    if bonuses then
      local last = target:getLastSlot()
      local values = target:getBonusAttribute(last)
      local attr = US_ENCHANTMENTS[values[1]]
      local item_level = target:getItemLevel()
      values[2] = attr.VALUES_PER_LEVEL and math.random(1, math.ceil(item_level * attr.VALUES_PER_LEVEL)) or 1
      target:setAttributeValue(last, values[1] .. "|" .. values[2])
      item:remove(1)
    else
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item has no attributes!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    end
  elseif item.itemid == US_CONFIG[1][ITEM_FAITH_CRYSTAL] then
    local bonuses = target:getBonusAttributes()
    if bonuses then
      for i = 1, #bonuses do
        local values = bonuses[i]
        local attr = US_ENCHANTMENTS[values[1]]
        local item_level = target:getItemLevel()
        values[2] = attr.VALUES_PER_LEVEL and math.random(1, math.ceil(item_level * attr.VALUES_PER_LEVEL)) or 1
        target:setAttributeValue(i, values[1] .. "|" .. values[2])
      end
      item:remove(1)
    else
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "Item has no attributes!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    end
  elseif item.itemid == US_CONFIG.ITEM_SCROLL_IDENTIFY then
    if target:isUnidentified() then
      if itemType then
        local weaponType = itemType:getWeaponType()
        if target:identify(player, itemType, weaponType) then
          item:remove(1)
        else
          player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        end
      end
    end
  elseif item.itemid == US_CONFIG[1][ITEM_MIND_CRYSTAL] then
    if not item:hasMemory() then
      if not target:isUnique() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is unidentified and can't be copied!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      elseif not target:getBonusAttributes() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item doesn't have any attributes!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      elseif not target:isUnique() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is Unique and can't be copied!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      else
        local crystal = Game.createItem(item.itemid, 1)
        local maxAttr = target:getMaxAttributes()
        for i = 1, maxAttr do
          local attr = target:getBonusAttribute(i)
          if attr then
            crystal:addAttribute(i, attr[1], attr[2])
            target:removeCustomAttribute("Slot" .. i)
          end
        end
        crystal:setMemory(true)
        if player:addItemEx(crystal) then
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Item attributes saved into crystal's memory!")
          item:remove(1)
        end
      end
    else
      if target:getBonusAttributes() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item already have attributes!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      else
        local maxAttr = target:getMaxAttributes()
        for i = 1, maxAttr do
          local attr = item:getBonusAttribute(i)
          if attr then
            target:addAttribute(i, attr[1], attr[2])
          end
        end
        item:remove(1)
      end
    end
  elseif item.itemid == US_CONFIG[1][ITEM_LIMITLESS_CRYSTAL] then
    if not target:isLimitless() then
      player:sendTextMessage(MESSAGE_INFO_DESCR, "Required Item Level removed from the item!")
      target:setLimitless(true)
      item:remove(1)
    else
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, there are no Uniques available for this item!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
    end
  elseif item.itemid == US_CONFIG[1][ITEM_MIRRORED_CRYSTAL] then
    local copy = Game.createItem(target.itemid, 1)
    copy:setRarity(target:getRarityId())
    copy:setCustomAttribute("upgrade", target:getUpgradeLevel())
    copy:setCustomAttribute("item_level", target:getItemLevel())
    if target:getBonusAttributes() then
      for i = 1, target:getMaxAttributes() do
        local attr = target:getBonusAttribute(i)
        if attr then
          copy:addAttribute(i, attr[1], attr[2])
        end
      end
    end
    if target:isUnique() then
      copy:setCustomAttribute("unique", target:getUnique())
    end
    if target:isLimitless() then
      copy:setLimitless(true)
    end

    if target:getAttribute(ITEM_ATTRIBUTE_ATTACK) > 0 then
      copy:setAttribute(ITEM_ATTRIBUTE_ATTACK, target:getAttribute(ITEM_ATTRIBUTE_ATTACK))
    end
    if target:getAttribute(ITEM_ATTRIBUTE_DEFENSE) > 0 then
      copy:setAttribute(ITEM_ATTRIBUTE_DEFENSE, target:getAttribute(ITEM_ATTRIBUTE_DEFENSE))
    end
    if target:getAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE) > 0 then
      copy:setAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE, target:getAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE))
    end
    if target:getAttribute(ITEM_ATTRIBUTE_ARMOR) > 0 then
      copy:setAttribute(ITEM_ATTRIBUTE_ARMOR, target:getAttribute(ITEM_ATTRIBUTE_ARMOR))
    end
    if target:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) > 0 then
      copy:setAttribute(ITEM_ATTRIBUTE_HITCHANCE, target:getAttribute(ITEM_ATTRIBUTE_HITCHANCE))
    end

    copy:setMirrored(true)
    if player:addItemEx(copy) then
      player:sendTextMessage(MESSAGE_INFO_DESCR, "Item mirrored and placed in your backpack!")
      item:remove(1)
    end
  elseif item.itemid == US_CONFIG[1][ITEM_VOID_CRYSTAL] then
    local usItemType = target:getItemType()
    local canUnique = false
    for i = 1, #US_UNIQUES do
      if US_UNIQUES[i].minLevel <= target:getItemLevel() and bit.band(usItemType, US_UNIQUES[i].itemType) ~= 0 then
        canUnique = true
        break
      end
    end
    if not canUnique then
      player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, there are no Uniques available for this item!")
      player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
      return true
    end
    if canUnique then
      local unique = math.random(#US_UNIQUES)
      while US_UNIQUES[unique].minLevel > target:getItemLevel() or bit.band(usItemType, US_UNIQUES[unique].itemType) == 0 do
        unique = math.random(#US_UNIQUES)
      end
      local slots = target:getMaxAttributes()
      for i = 1, slots do
        target:removeCustomAttribute("Slot" .. i)
      end
      target:setUnique(unique)
      player:sendTextMessage(MESSAGE_INFO_DESCR, "Unique item " .. target:getUniqueName() .. " discovered!")
      item:remove(1)
    end
  end

  return true
end

function us_onMoveItem(player, item, fromPosition, toPosition)
  if item:isUnidentified() then
    if toPosition.y <= CONST_SLOT_AMMO and toPosition.y ~= CONST_SLOT_BACKPACK then
      player:sendTextMessage(MESSAGE_STATUS_SMALL, "You can't wear unidentified items.")
      return false
    end
  end

  if US_CONFIG.REQUIRE_LEVEL == true then
    if player:getLevel() < item:getItemLevel() and not item:isLimitless() then
      if toPosition.y <= CONST_SLOT_AMMO and toPosition.y ~= CONST_SLOT_BACKPACK then
        player:sendTextMessage(MESSAGE_STATUS_SMALL, "You need higher level to equip that item.")
        return false
      end
    end
  end

  if toPosition.y <= CONST_SLOT_AMMO then
    if toPosition.y ~= CONST_SLOT_BACKPACK then
      if fromPosition.y >= 64 or fromPosition.x ~= CONTAINER_POSITION then
        -- remove old
        local oldItem = player:getSlotItem(toPosition.y)
        if oldItem then
          if oldItem:getType():isUpgradable() then
            local oldBonuses = oldItem:getBonusAttributes()
            if oldBonuses then
              for key, value in pairs(oldBonuses) do
                local attr = US_ENCHANTMENTS[value[1]]
                if attr then
                  if attr.combatType == US_TYPES.CONDITION then
                    if US_CONDITIONS[value[1]] and US_CONDITIONS[value[1]][value[2]] then
                      if US_CONDITIONS[value[1]][value[2]]:getType() ~= CONDITION_MANASHIELD then
                        player:removeCondition(
                          US_CONDITIONS[value[1]][value[2]]:getType(),
                          CONDITIONID_COMBAT,
                          US_CONDITIONS[value[1]][value[2]]:getSubId()
                        )
                      else
                        player:removeCondition(US_CONDITIONS[value[1]][value[2]]:getType(), CONDITIONID_COMBAT)
                      end
                    end
                  end
                end
              end
            end
          end
        end

        -- apply new
        if item:getType():isUpgradable() then
          local newBonuses = item:getBonusAttributes()
          if newBonuses then
            for key, value in pairs(newBonuses) do
              local attr = US_ENCHANTMENTS[value[1]]
              if attr then
                if attr.combatType == US_TYPES.CONDITION then
                  if not US_CONDITIONS[value[1]] then
                    US_CONDITIONS[value[1]] = {}
                  end
                  if not US_CONDITIONS[value[1]][value[2]] then
                    US_CONDITIONS[value[1]][value[2]] = Condition(attr.condition)
                    if attr.condition ~= CONDITION_MANASHIELD then
                      US_CONDITIONS[value[1]][value[2]]:setParameter(attr.param, attr.percentage == true and 100 + value[2] or value[2])
                      US_CONDITIONS[value[1]][value[2]]:setParameter(CONDITION_PARAM_TICKS, -1)
                      US_CONDITIONS[value[1]][value[2]]:setParameter(CONDITION_PARAM_SUBID, 1000 + math.ceil(value[1] ^ 2) + value[2])
                    else
                      US_CONDITIONS[value[1]][value[2]]:setParameter(CONDITION_PARAM_TICKS, 86400000)
                    end
                    US_CONDITIONS[value[1]][value[2]]:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
                    player:addCondition(US_CONDITIONS[value[1]][value[2]])
                    if attr == BONUS_TYPE_MAXHP then
                      if player:getHealth() == maxHP then
                        player:addHealth(player:getMaxHealth())
                      end
                    end
                    if attr == BONUS_TYPE_MAXMP then
                      if player:getMana() == maxMP then
                        player:addMana(player:getMaxMana())
                      end
                    end
                  else
                    player:addCondition(US_CONDITIONS[value[1]][value[2]])
                    if attr.param == CONDITION_PARAM_STAT_MAXHITPOINTS then
                      if player:getHealth() == maxHP then
                        player:addHealth(player:getMaxHealth())
                      end
                    end
                    if attr.param == CONDITION_PARAM_STAT_MAXMANAPOINTS then
                      if player:getMana() == maxMP then
                        player:addMana(player:getMaxMana())
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  return true
end

function onUpgradeMoved(player, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
  if not item:getType():isUpgradable() then
    return
  end
  if toPosition.y <= CONST_SLOT_AMMO and toPosition.y ~= CONST_SLOT_BACKPACK then
    return
  end
  if fromPosition.y >= 64 and toPosition.y >= 64 then
    return
  end
  if fromPosition.y >= 64 and toPosition.y == CONST_SLOT_BACKPACK then
    return
  end

  local bonuses = item:getBonusAttributes()
  if bonuses then
    for key, value in pairs(bonuses) do
      local attr = US_ENCHANTMENTS[value[1]]
      if attr then
        if attr.combatType == US_TYPES.CONDITION then
          if US_CONDITIONS[value[1]] and US_CONDITIONS[value[1]][value[2]] then
            if US_CONDITIONS[value[1]][value[2]]:getType() ~= CONDITION_MANASHIELD then
              player:removeCondition(
                US_CONDITIONS[value[1]][value[2]]:getType(),
                CONDITIONID_COMBAT,
                US_CONDITIONS[value[1]][value[2]]:getSubId()
              )
            else
              player:removeCondition(US_CONDITIONS[value[1]][value[2]]:getType(), CONDITIONID_COMBAT)
            end
          end
        end
      end
    end
  end
end

function us_onLogin(player)
  player:registerEvent("UpgradeSystemKill")
  player:registerEvent("UpgradeSystemHealth")
  player:registerEvent("UpgradeSystemMana")
  player:registerEvent("UpgradeSystemPD")

  for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
    local item = player:getSlotItem(slot)
    if item then
      local bonuses = item:getBonusAttributes()
      if bonuses then
        for key, value in pairs(bonuses) do
          local attr = US_ENCHANTMENTS[value[1]]
          if attr then
            if attr.combatType == US_TYPES.CONDITION then
              if US_CONDITIONS[value[1]] and US_CONDITIONS[value[1]][value[2]] then
                if US_CONDITIONS[value[1]][value[2]]:getType() ~= CONDITION_MANASHIELD then
                  player:removeCondition(
                    US_CONDITIONS[value[1]][value[2]]:getType(),
                    CONDITIONID_COMBAT,
                    US_CONDITIONS[value[1]][value[2]]:getSubId()
                  )
                else
                  player:removeCondition(US_CONDITIONS[value[1]][value[2]]:getType(), CONDITIONID_COMBAT)
                end
              end
            end
          end
        end
      end
    end
  end
end

function us_onManaChange(creature, attacker, manaChange, origin)
  if not creature or not attacker or creature == attacker then
    return manaChange
  end

  if creature:isPlayer() then
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = creature:getSlotItem(slot)
      if item then
        local values = item:getBonusAttributes()
        if values then
          for key, value in pairs(values) do
            value[1] = value[1]
            value[2] = value[2]
            local attr = US_ENCHANTMENTS[value[1]]
            if attr then
              if attr.combatType and attr.combatType == US_TYPES.TRIGGER then
                if attr.triggerType == US_TRIGGERS.HIT then
                  attr.execute(creature, attacker, value[2])
                end
              end
            end
          end
        end
      end
    end
  end

  return manaChange
end

function us_onHealthChange(creature, attacker, primaryDamage, primaryType, secondaryDamage, secondaryType, origin)
  if not creature or not attacker then
    return primaryDamage, primaryType, secondaryDamage, secondaryType
  end
  if primaryType == COMBAT_LIFEDRAIN or secondaryType == COMBAT_LIFEDRAIN then
    return primaryDamage, primaryType, secondaryDamage, secondaryType
  end
  if creature == attacker then
    return primaryDamage, primaryType, secondaryDamage, secondaryType
  end
  if origin == ORIGIN_CONDITION then
    return primaryDamage, primaryType, secondaryDamage, secondaryType
  end

  if primaryType == COMBAT_HEALING or secondaryType == COMBAT_HEALING then
    if attacker:isPlayer() then
      for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
        local item = attacker:getSlotItem(slot)
        if item then
          local values = item:getBonusAttributes()
          if values then
            for key, value in pairs(values) do
              value[1] = value[1]
              value[2] = value[2]
              local attr = US_ENCHANTMENTS[value[1]]
              if attr then
                if attr.name == "Increased Healing" then
                  if primaryType == COMBAT_HEALING then
                    primaryDamage = math.floor(primaryDamage + (primaryDamage * value[2] / 100))
                  end
                  if secondaryType == COMBAT_HEALING then
                    secondaryDamage = math.floor(secondaryDamage + (secondaryDamage * value[2] / 100))
                  end
                end
              end
            end
          end
        end
      end
    end
    if creature:isPlayer() then
      for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
        local item = creature:getSlotItem(slot)
        if item then
          local values = item:getBonusAttributes()
          if values then
            for key, value in pairs(values) do
              value[1] = value[1]
              value[2] = value[2]
              local attr = US_ENCHANTMENTS[value[1]]
              if attr then
                if attr.name == "Increased Healing" then
                  if primaryDamage > 0 then
                    primaryDamage = math.floor(primaryDamage + (primaryDamage * value[2] / 100))
                  end
                  if secondaryDamage > 0 then
                    secondaryDamage = math.floor(secondaryDamage + (secondaryDamage * value[2] / 100))
                  end
                end
              end
            end
          end
        end
      end
    end
    return primaryDamage, primaryType, secondaryDamage, secondaryType
  end

  if attacker:isPlayer() then
    local pid = attacker:getId()
    if US_BUFFS[pid] then
      if US_BUFFS[pid][1] then
        if primaryDamage ~= 0 then
          primaryDamage = primaryDamage + (primaryDamage * US_BUFFS[pid][1].value / 100)
        end
        if secondaryDamage ~= 0 then
          secondaryDamage = secondaryDamage + (secondaryDamage * US_BUFFS[pid][1].value / 100)
        end
      end
    end
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = attacker:getSlotItem(slot)
      if item then
        local values = item:getBonusAttributes()
        if values then
          for key, value in pairs(values) do
            value[1] = value[1]
            value[2] = value[2]
            local attr = US_ENCHANTMENTS[value[1]]
            if attr then
              if attr.combatType and attr.combatType ~= US_TYPES.CONDITION then
                if attr.combatType == US_TYPES.TRIGGER then
                  if attr.triggerType == US_TRIGGERS.ATTACK then
                    attr.execute(attacker, creature, value[2])
                  end
                elseif attr.name == "Double Damage" then
                  if math.random(100) < value[2] then
                    primaryDamage = primaryDamage * 2
                    secondaryDamage = secondaryDamage * 2
                  end
                else
                  if (attr.combatDamage % (primaryType + primaryType) >= primaryType) == true then
                    if attr.combatType == US_TYPES.OFFENSIVE then
                      primaryDamage = math.floor(primaryDamage + (primaryDamage * value[2] / 100))
                    end
                  end
                  if (attr.combatDamage % (secondaryType + secondaryType) >= secondaryType) == true then
                    if attr.combatType == US_TYPES.OFFENSIVE then
                      secondaryDamage = math.floor(secondaryDamage + (secondaryDamage * value[2] / 100))
                    end
                  end

                  local damage = (primaryDamage + secondaryDamage)
                  if damage < 0 then
                    damage = damage * -1
                  end

                  if attr.name == "Life Steal" then
                    local lifeSteal = math.floor((damage * (value[2] / 100)))
                    if lifeSteal > 0 then
                      attacker:addHealth(lifeSteal)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  if creature:isPlayer() then
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = creature:getSlotItem(slot)
      if item then
        local values = item:getBonusAttributes()
        if values then
          for key, value in pairs(values) do
            value[1] = value[1]
            value[2] = value[2]
            local attr = US_ENCHANTMENTS[value[1]]
            if attr then
              if attr.combatType and attr.combatType ~= US_TYPES.CONDITION then
                if attr.combatType == US_TYPES.TRIGGER then
                  if attr.triggerType == US_TRIGGERS.HIT then
                    attr.execute(creature, attacker, value[2])
                  end
                else
                  if (attr.combatDamage % (primaryType + primaryType) >= primaryType) == true then
                    if attr.combatType == US_TYPES.DEFENSIVE and creature:isPlayer() then
                      primaryDamage = math.floor(primaryDamage - (primaryDamage * value[2] / 100))
                    end
                  end
                  if (attr.combatDamage % (secondaryType + secondaryType) >= secondaryType) == true then
                    if attr.combatType == US_TYPES.DEFENSIVE and creature:isPlayer() then
                      secondaryDamage = math.floor(secondaryDamage - (secondaryDamage * value[2] / 100))
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end

  return primaryDamage, primaryType, secondaryDamage, secondaryType
end

function us_onDeath(creature, corpse, lasthitkiller, mostdamagekiller, lasthitunjustified, mostdamageunjustified)
  if not lasthitkiller or not creature:isMonster() or not corpse or not corpse:isContainer() then
    return true
  end
  if not lasthitkiller:isPlayer() and not lasthitkiller:getMaster() then
    return true
  end
  addEvent(
    us_CheckCorpse,
    10,
    creature:getType(),
    corpse:getPosition(),
    lasthitkiller:getMaster() and lasthitkiller:getMaster():getId() or lasthitkiller:getId()
  )
  return true
end

function us_onKill(player, target, lastHit)
  if not player or not player:isPlayer() or not target or not target:isMonster() then
    return
  end
  local center = target:getPosition()
  for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
    local item = player:getSlotItem(slot)
    if item then
      local values = item:getBonusAttributes()
      if values then
        for key, value in pairs(values) do
          value[1] = value[1]
          value[2] = value[2]
          local attr = US_ENCHANTMENTS[value[1]]
          if attr then
            if attr.triggerType == US_TRIGGERS.KILL then
              attr.execute(player, value[2], center, target)
            end
          end
        end
      end
    end
  end
end

function us_onPrepareDeath(creature, killer)
  if creature:isPlayer() then
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = creature:getSlotItem(slot)
      if item then
        local values = item:getBonusAttributes()
        if values then
          for key, value in pairs(values) do
            value[1] = value[1]
            value[2] = value[2]
            local attr = US_ENCHANTMENTS[value[1]]
            if attr then
              if attr.name == "Revive on death" then
                if math.random(100) < value[2] then
                  creature:addHealth(creature:getMaxHealth())
                  creature:addMana(creature:getMaxMana())
                  creature:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
                  creature:sendTextMessage(MESSAGE_INFO_DESCR, "You have been revived!")
                  return false
                end
              end
            end
          end
        end
      end
    end
  end
  return true
end

function us_onGainExperience(player, source, exp, rawExp)
  for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
    local item = player:getSlotItem(slot)
    if item then
      local values = item:getBonusAttributes()
      if values then
        for key, value in pairs(values) do
          value[1] = value[1]
          value[2] = value[2]
          local attr = US_ENCHANTMENTS[value[1]]
          if attr then
            if attr.name == "Experience" then
              exp = exp + math.ceil(exp * value[2] / 100)
            end
          end
        end
      end
    end
  end
  return exp
end

function us_CheckCorpse(monsterType, corpsePosition, killerId)
  local killer = Player(killerId)
  local corpse = Tile(corpsePosition):getTopDownItem()
  if killer and killer:isPlayer() and corpse and corpse:isContainer() then
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = killer:getSlotItem(slot)
      if item then
        local values = item:getBonusAttributes()
        if values then
          for key, value in pairs(values) do
            value[1] = value[1]
            value[2] = value[2]
            local attr = US_ENCHANTMENTS[value[1]]
            if attr then
              if attr.name == "Additonal Gold" then
                local cc,
                  plat,
                  gold = 0, 0, 0
                for i = 1, corpse:getSize() do
                  local item = corpse:getItem(i)
                  if item then
                    if item.itemid == 2160 then
                      gold = gold + (item:getCount() * 10000)
                    elseif item.itemid == 2152 then
                      gold = gold + (item:getCount() * 100)
                    elseif item.itemid == 2148 then
                      gold = gold + item:getCount()
                    end
                  end
                end

                gold = math.floor(gold * value[2] / 100)

                while gold >= 10000 do
                  gold = gold / 10000
                  cc = cc + 1
                end

                if cc > 0 then
                  local crystalCoin = Game.createItem(2160, cc)
                  corpse:addItemEx(crystalCoin)
                end

                while gold >= 100 do
                  gold = gold / 100
                  plat = plat + 1
                end

                if plat > 0 then
                  local platinumCoin = Game.createItem(2152, plat)
                  corpse:addItemEx(platinumCoin)
                end

                if gold > 0 then
                  local goldCoin = Game.createItem(2148, gold)
                  corpse:addItemEx(goldCoin)
                end
              end
            end
          end
        end
      end
    end
    if math.random(US_CONFIG.CRYSTAL_FOSSIL_DROP_CHANCE) == 1 then
      corpse:addItem(US_CONFIG.CRYSTAL_FOSSIL, 1)
    end
    for i = 1, corpse:getCapacity() do
      local item = corpse:getItem(i)
      if item then
        local itemType = item:getType()
        if itemType then
          if itemType:isUpgradable() then
            local iLvl = calculateItemLevel(monsterType)
            item:setItemLevel(math.min(US_CONFIG.MAX_ITEM_LEVEL, math.random(math.max(1, iLvl - 5), iLvl)), true)
            if math.random(US_CONFIG.UNIDENTIFIED_DROP_CHANCE) == 1 then
              item:unidentify()
            end
          end
        end
      end
    end
  end
end

function us_RemoveBuff(pid, buffId, buffName)
  if US_BUFFS[pid] then
    US_BUFFS[pid][buffId] = nil
    local player = Player(pid)
    if player then
      player:sendTextMessage(MESSAGE_STATUS_WARNING, buffName .. " ended!")
    end
  end
end

function onItemUpgradeLook(player, thing, position, distance, description)
  if thing:isItem() and thing.itemid == US_CONFIG[1][ITEM_MIND_CRYSTAL] and thing:hasMemory() then
    for i = 4, 1, -1 do
      local enchant = thing:getBonusAttribute(i)
      if enchant then
        local attr = US_ENCHANTMENTS[enchant[1]]
        description = description:gsub(thing:getName() .. "%.", "%1\n" .. attr.format(enchant[2]))
      end
    end
  elseif thing:isItem() then
    if thing:getType():isUpgradable() then
      local upgrade = thing:getUpgradeLevel()
      local itemLevel = thing:getItemLevel()
      if upgrade > 0 then
        description = description:gsub(thing:getName(), "%1 +" .. upgrade)
      end
      if description:find("(%)%.?)") then
        description = description:gsub("(%)%.?)", "%1\nItem Level: " .. itemLevel)
      else
        if upgrade > 0 then
          description = description:gsub("+" .. upgrade .. "%.", "%1\nItem Level: " .. itemLevel)
        else
          description = description:gsub(thing:getName(), "%1\nItem Level: " .. itemLevel)
        end
      end
      if thing:isUnidentified() then
        description = description:gsub(thing:getName(), "unidentified %1")
        if thing:getArticle():len() > 0 and thing:getArticle() ~= "an" then
          description = description:gsub("You see (" .. thing:getArticle() .. "%S?)", "You see an")
        end
      else
        description = description:gsub(thing:getName(), thing:getRarity().name .. " %1")
        if thing:getArticle():len() > 0 and thing:getRarity().name == "epic" and thing:getArticle() ~= "an" then
          description = description:gsub("You see (" .. thing:getArticle() .. "%S?)", "You see an")
        end
        if thing:isUnique() then
          description = description:gsub("Item Level: " .. itemLevel, thing:getUniqueName() .. "\n%1")
        end
        for i = thing:getMaxAttributes(), 1, -1 do
          local enchant = thing:getBonusAttribute(i)
          if enchant then
            local attr = US_ENCHANTMENTS[enchant[1]]
            description = description:gsub("Item Level: " .. itemLevel, "%1\n" .. attr.format(enchant[2]))
          end
        end
      end
      if description:find("of level (%d+) or higher") then
        for match in description:gmatch("of level (%d+) or higher") do
          if tonumber(match) < itemLevel then
            description = description:gsub("of level (%d+) or higher", "of level " .. itemLevel .. " or higher")
          end
        end
      elseif description:find("It can only be wielded properly by") then
        description =
          description:gsub(
          "It can only be wielded properly by (.+).\n",
          "It can only be wielded properly by %1 of level " .. itemLevel .. " or higher.\n"
        )
      else
        if description:find("It weighs") then
          description =
            description:gsub("It weighs", "It can only be wielded properly by players of level " .. itemLevel .. " or higher.\nIt weighs")
        else
          description = description .. "\nIt can only be wielded properly by players of level " .. itemLevel .. " or higher."
        end
      end
      if thing:isLimitless() then
        if description:find("It weighs") then
          description = description:gsub("oz.(.+)", "oz.%1\nRemoved required Item Level to wear.")
        else
          description = description .. "\nRemoved required Item Level to wear."
        end
      end
      if thing:isMirrored() then
        if description:find("It weighs") then
          description = description:gsub("oz.(.+)", "oz.%1\nMirrored")
        else
          description = description .. "\nMirrored"
        end
      end
    end
  elseif thing:isPlayer() then
    local iLvl = 0
    for slot = CONST_SLOT_HEAD, CONST_SLOT_AMMO do
      local item = thing:getSlotItem(slot)
      if item then
        iLvl = iLvl + item:getItemLevel()
      end
    end
    description = description .. "\nTotal Item LeveL: " .. iLvl
  end
  return description
end

function Item.rollAttribute(self, player, itemType, weaponType, unidentify)
  if not itemType:isUpgradable() or self:isUnique() then
    return false
  end
  local attrIds = {}
  local item_level = self:getItemLevel()
  if unidentify then
    local upgrade_level = 1
    for i = US_CONFIG.MAX_UPGRADE_LEVEL, 1, -1 do
      if i >= US_CONFIG.UPGRADE_LEVEL_DESTROY then
        if math.random(100) <= US_CONFIG.UPGRADE_DESTROY_CHANCE[i] then
          upgrade_level = i
          break
        end
      else
        if math.random(100) <= US_CONFIG.UPGRADE_SUCCESS_CHANCE[i] then
          upgrade_level = i
          break
        end
      end
    end
    self:setUpgradeLevel(upgrade_level)
    local slots = math.random(1, self:getMaxAttributes())
    local usItemType = self:getItemType()
    for i = 1, slots do
      local attrId = math.random(1, #US_ENCHANTMENTS)
      local attr = US_ENCHANTMENTS[attrId]
      while isInArray(attrIds, attrId) or attr.minLevel and item_level < attr.minLevel or bit.band(usItemType, attr.itemType) == 0 or
        attr.chance and math.random(100) >= attr.chance do
        attrId = math.random(1, #US_ENCHANTMENTS)
        attr = US_ENCHANTMENTS[attrId]
      end
      table.insert(attrIds, attrId)
      local value = attr.VALUES_PER_LEVEL and math.random(1, math.ceil(item_level * attr.VALUES_PER_LEVEL)) or 1
      self:setCustomAttribute("Slot" .. i, attrId .. "|" .. value)
    end
    return true
  else
    local bonuses = self:getBonusAttributes()
    if bonuses then
      if #bonuses >= self:getMaxAttributes() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Max number of bonuses reached!")
        return false
      end
      for v, k in pairs(bonuses) do
        table.insert(attrIds, k[1])
      end
    end
    local usItemType = self:getItemType()
    local attrId = math.random(1, #US_ENCHANTMENTS)
    local attr = US_ENCHANTMENTS[attrId]
    while isInArray(attrIds, attrId) or attr.minLevel and item_level < attr.minLevel or bit.band(usItemType, attr.itemType) == 0 or
      attr.chance and math.random(100) >= attr.chance do
      attrId = math.random(1, #US_ENCHANTMENTS)
      attr = US_ENCHANTMENTS[attrId]
    end
    local value = attr.VALUES_PER_LEVEL and math.random(1, math.ceil(item_level * attr.VALUES_PER_LEVEL)) or 1
    self:setCustomAttribute("Slot" .. self:getLastSlot() + 1, attrId .. "|" .. value)
    return true
  end
  return false
end

function Item.addAttribute(self, slot, attr, value)
  self:setCustomAttribute("Slot" .. slot, attr .. "|" .. value)
end

function Item.setAttributeValue(self, slot, value)
  self:setCustomAttribute("Slot" .. slot, value)
end

function Item.getBonusAttribute(self, slot)
  local bonuses = self:getCustomAttribute("Slot" .. slot)
  if bonuses then
    local data = {}
    for bonus in bonuses:gmatch("([^|]+)") do
      data[#data + 1] = tonumber(bonus)
    end
    return data
  end

  return nil
end

function Item.getBonusAttributes(self)
  local data = {}
  for i = 1, self:getMaxAttributes() do
    local bonuses = self:getCustomAttribute("Slot" .. i)
    if bonuses then
      local t = {}
      for bonus in bonuses:gmatch("([^|]+)") do
        t[#t + 1] = tonumber(bonus)
      end
      data[#data + 1] = t
    end
  end

  return #data > 0 and data or nil
end

function Item.getLastSlot(self)
  local last = 0
  for i = 1, self:getMaxAttributes() do
    if self:getCustomAttribute("Slot" .. i) then
      last = i
    end
  end
  return last
end

function Item.setItemLevel(self, level, first)
  local oldLevel = self:getItemLevel()
  local itemType = ItemType(self.itemid)
  local finalValue = 0
  if oldLevel < level then
    value = (level - oldLevel)
  else
    value = (oldLevel - level)
  end
  if itemType:getAttack() > 0 then
    finalValue = math.floor((value / US_CONFIG.ATTACK_PER_ITEM_LEVEL) * US_CONFIG.ATTACK_FROM_ITEM_LEVEL)
    if oldLevel < level then
      self:setAttribute(
        ITEM_ATTRIBUTE_ATTACK,
        (self:getAttribute(ITEM_ATTRIBUTE_ATTACK) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_ATTACK) + finalValue) or
          (itemType:getAttack() + finalValue)
      )
    else
      self:setAttribute(
        ITEM_ATTRIBUTE_ATTACK,
        (self:getAttribute(ITEM_ATTRIBUTE_ATTACK) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_ATTACK) - finalValue) or
          (itemType:getAttack() - finalValue)
      )
    end
  end
  if itemType:getDefense() > 0 then
    finalValue = math.floor((value / US_CONFIG.DEFENSE_PER_ITEM_LEVEL) * US_CONFIG.DEFENSE_FROM_ITEM_LEVEL)
    if oldLevel < level then
      self:setAttribute(
        ITEM_ATTRIBUTE_DEFENSE,
        (self:getAttribute(ITEM_ATTRIBUTE_DEFENSE) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_DEFENSE) + finalValue) or
          (itemType:getDefense() + finalValue)
      )
    else
      self:setAttribute(
        ITEM_ATTRIBUTE_DEFENSE,
        (self:getAttribute(ITEM_ATTRIBUTE_DEFENSE) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_DEFENSE) - finalValue) or
          (itemType:getDefense() - finalValue)
      )
    end
  end
  if itemType:getArmor() > 0 then
    finalValue = math.floor((value / US_CONFIG.ARMOR_PER_ITEM_LEVEL) * US_CONFIG.ARMOR_FROM_ITEM_LEVEL)
    if oldLevel < level then
      self:setAttribute(
        ITEM_ATTRIBUTE_ARMOR,
        (self:getAttribute(ITEM_ATTRIBUTE_ARMOR) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_ARMOR) + finalValue) or
          (itemType:getArmor() + finalValue)
      )
    else
      self:setAttribute(
        ITEM_ATTRIBUTE_ARMOR,
        (self:getAttribute(ITEM_ATTRIBUTE_ARMOR) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_ARMOR) - finalValue) or
          (itemType:getArmor() - finalValue)
      )
    end
  end
  if itemType:getHitChance() > 0 then
    finalValue = math.floor((value / US_CONFIG.HITCHANCE_PER_ITEM_LEVEL) * US_CONFIG.HITCHANCE_FROM_ITEM_LEVEL)
    if oldLevel < level then
      self:setAttribute(
        ITEM_ATTRIBUTE_HITCHANCE,
        (self:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) + finalValue) or
          (itemType:getHitChance() + finalValue)
      )
    else
      self:setAttribute(
        ITEM_ATTRIBUTE_HITCHANCE,
        (self:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) > 0) and (self:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) - finalValue) or
          (itemType:getHitChance() - finalValue)
      )
    end
  end
  if first then
    if itemType:getAttack() > 0 then
      level = level + US_CONFIG.ITEM_LEVEL_PER_ATTACK
    end
    if itemType:getDefense() > 0 then
      level = level + US_CONFIG.ITEM_LEVEL_PER_DEFENSE
    end
    if itemType:getArmor() > 0 then
      level = level + US_CONFIG.ITEM_LEVEL_PER_ARMOR
    end
    if itemType:getHitChance() > 0 then
      level = level + US_CONFIG.ITEM_LEVEL_PER_HITCHANCE
    end
  end
  return self:setCustomAttribute("item_level", level)
end

function Item.getItemLevel(self)
  return self:getCustomAttribute("item_level") and self:getCustomAttribute("item_level") or 0
end

function Item.setUpgradeLevel(self, level)
  local itemType = ItemType(self.itemid)
  local oldLevel = self:getUpgradeLevel()
  if itemType:getAttack() > 0 then
    if oldLevel < level then
      self:setAttribute(ITEM_ATTRIBUTE_ATTACK, itemType:getAttack() + level * US_CONFIG.ATTACK_PER_UPGRADE)
    else
      self:setAttribute(ITEM_ATTRIBUTE_ATTACK, self:getAttribute(ITEM_ATTRIBUTE_ATTACK) - US_CONFIG.ATTACK_PER_UPGRADE)
    end
  end
  if itemType:getDefense() > 0 then
    if oldLevel < level then
      self:setAttribute(ITEM_ATTRIBUTE_DEFENSE, itemType:getDefense() + level * US_CONFIG.DEFENSE_PER_UPGRADE)
    else
      self:setAttribute(ITEM_ATTRIBUTE_DEFENSE, self:getAttribute(ITEM_ATTRIBUTE_DEFENSE) - US_CONFIG.DEFENSE_PER_UPGRADE)
    end
  end
  if itemType:getExtraDefense() > 0 then
    if oldLevel < level then
      self:setAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE, itemType:getExtraDefense() + level * US_CONFIG.EXTRADEFENSE_PER_UPGRADE)
    else
      self:setAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE, self:getAttribute(ITEM_ATTRIBUTE_EXTRADEFENSE) - US_CONFIG.EXTRADEFENSE_PER_UPGRADE)
    end
  end
  if itemType:getArmor() > 0 then
    if oldLevel < level then
      self:setAttribute(ITEM_ATTRIBUTE_ARMOR, itemType:getArmor() + level * US_CONFIG.ARMOR_PER_UPGRADE)
    else
      self:setAttribute(ITEM_ATTRIBUTE_ARMOR, self:getAttribute(ITEM_ATTRIBUTE_ARMOR) - US_CONFIG.ARMOR_PER_UPGRADE)
    end
  end
  if itemType:getHitChance() > 0 then
    if oldLevel < level then
      self:setAttribute(ITEM_ATTRIBUTE_HITCHANCE, itemType:getHitChance() + level * US_CONFIG.HITCHANCE_PER_UPGRADE)
    else
      self:setAttribute(ITEM_ATTRIBUTE_HITCHANCE, self:getAttribute(ITEM_ATTRIBUTE_HITCHANCE) - US_CONFIG.HITCHANCE_PER_UPGRADE)
    end
  end
  self:setCustomAttribute("upgrade", level)
  if oldLevel < level then
    self:setItemLevel(self:getItemLevel() + (US_CONFIG.ITEM_LEVEL_PER_UPGRADE * level - oldLevel))
  else
    self:setItemLevel(self:getItemLevel() - (US_CONFIG.ITEM_LEVEL_PER_UPGRADE * oldLevel - level))
  end
end

function Item.getUpgradeLevel(self)
  return self:getCustomAttribute("upgrade") and self:getCustomAttribute("upgrade") or 0
end

function Item.reduceUpgradeLevel(self)
  self:setUpgradeLevel(self:getUpgradeLevel() - 1)
  self:setItemLevel(self:getItemLevel() - US_CONFIG.ITEM_LEVEL_PER_UPGRADE)
end

function Item.unidentify(self)
  self:setCustomAttribute("unidentified", true)
end

function Item.isUnidentified(self)
  return self:getCustomAttribute("unidentified")
end

function Item.identify(self, player, itemType, weaponType)
  self:removeCustomAttribute("unidentified")
  local usItemType = self:getItemType()
  local canUnique = false
  for i = 1, #US_UNIQUES do
    if US_UNIQUES[i].minLevel <= self:getItemLevel() and bit.band(usItemType, US_UNIQUES[i].itemType) ~= 0 then
      canUnique = true
      break
    end
  end
  self:rollRarity()
  if canUnique and math.random(US_CONFIG.UNIQUE_CHANCE) == 1 then
    local unique = math.random(#US_UNIQUES)
    while US_UNIQUES[unique].minLevel > self:getItemLevel() or bit.band(usItemType, US_UNIQUES[unique].itemType) == 0 do
      unique = math.random(#US_UNIQUES)
    end
    self:setUnique(unique)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Unique item " .. self:getUniqueName() .. " discovered!")
  else
    self:rollAttribute(player, itemType, weaponType, true)
    player:sendTextMessage(MESSAGE_INFO_DESCR, "Item successfully identified!")
  end
  return true
end

function Item.setUnique(self, uniqueId)
  self:setCustomAttribute("unique", uniqueId)
  local unique = US_UNIQUES[uniqueId]
  if unique then
    for i = 1, #unique.attributes do
      local attrId = unique.attributes[i]
      local attr = US_ENCHANTMENTS[attrId]
      local value = attr.VALUES_PER_LEVEL and math.random(1, math.ceil(self:getItemLevel() * attr.VALUES_PER_LEVEL)) or 1
      self:setCustomAttribute("Slot" .. self:getLastSlot() + 1, attrId .. "|" .. value)
    end
  end
end

function Item.getUnique(self)
  return self:getCustomAttribute("unique") and self:getCustomAttribute("unique") or nil
end

function Item.isUnique(self)
  return self:getCustomAttribute("unique") and true or false
end

function Item.getUniqueName(self)
  return US_UNIQUES[self:getUnique()].name
end

function Item.setMemory(self, value)
  self:setCustomAttribute("memory", value)
end

function Item.hasMemory(self)
  return self:getCustomAttribute("memory")
end

function Item.setLimitless(self, value)
  self:setCustomAttribute("limitless", value)
end

function Item.isLimitless(self)
  return self:getCustomAttribute("limitless")
end

function Item.setMirrored(self, value)
  self:setCustomAttribute("mirrored", value)
end

function Item.isMirrored(self)
  return self:getCustomAttribute("mirrored")
end

function Item.getItemType(self)
  local itemType = self:getType()
  local slot = itemType:getSlotPosition() - SLOTP_LEFT - SLOTP_RIGHT

  local weaponType = itemType:getWeaponType()
  if weaponType > 0 then
    if weaponType == WEAPON_SHIELD then
      return US_ITEM_TYPES.SHIELD
    end
    if weaponType == WEAPON_DISTANCE then
      return US_ITEM_TYPES.WEAPON_DISTANCE
    end
    if weaponType == WEAPON_WAND then
      return US_ITEM_TYPES.WEAPON_WAND
    end
    if isInArray({WEAPON_SWORD, WEAPON_CLUB, WEAPON_AXE}, weaponType) then
      return US_ITEM_TYPES.WEAPON_MELEE
    end
  else
    if slot == SLOTP_HEAD then
      return US_ITEM_TYPES.HELMET
    end
    if slot == SLOTP_ARMOR then
      return US_ITEM_TYPES.ARMOR
    end
    if slot == SLOTP_LEGS then
      return US_ITEM_TYPES.LEGS
    end
    if slot == SLOTP_FEET then
      return US_ITEM_TYPES.BOOTS
    end
    if slot == SLOTP_NECKLACE then
      return US_ITEM_TYPES.NECKLACE
    end
    if slot == SLOTP_RING then
      return US_ITEM_TYPES.RING
    end
  end
  return US_ITEM_TYPES.ALL
end

function Item.setRarity(self, rarity)
  self:setCustomAttribute("rarity", rarity)
end

function Item.rollRarity(self)
  local rarity = COMMON
  for i = #US_CONFIG.RARITY, 1, -1 do
    if math.random(US_CONFIG.RARITY[i].chance) == 1 then
      rarity = i
      break
    end
  end
  self:setRarity(rarity)
end

function Item.getRarity(self)
  return self:getCustomAttribute("rarity") and US_CONFIG.RARITY[self:getCustomAttribute("rarity")] or US_CONFIG.RARITY[COMMON]
end

function Item.getRarityId(self)
  return self:getCustomAttribute("rarity") and self:getCustomAttribute("rarity") or COMMON
end

function Item.getMaxAttributes(self)
  if self:isUnique() then
    return #US_UNIQUES[self:getUnique()].attributes
  end
  local rarity = self:getRarity()
  return rarity.maxBonus
end

function ItemType.isUpgradable(self)
  if self:isStackable() or self:getTransformEquipId() > 0 then
    return false
  end
  local slot = self:getSlotPosition() - SLOTP_LEFT - SLOTP_RIGHT

  local weaponType = self:getWeaponType()
  if weaponType > 0 then
    if weaponType == WEAPON_AMMO then
      return false
    end
    if
      weaponType == WEAPON_SHIELD or weaponType == WEAPON_DISTANCE or weaponType == WEAPON_WAND or
        isInArray({WEAPON_SWORD, WEAPON_CLUB, WEAPON_AXE}, weaponType)
     then
      return true
    end
  else
    if slot == SLOTP_HEAD or slot == SLOTP_ARMOR or slot == SLOTP_LEGS or slot == SLOTP_FEET or slot == SLOTP_NECKLACE or slot == SLOTP_RING then
      return true
    end
  end
  return false
end

function calculateItemLevel(monsterType)
  local level = 1
  local monsterValue = monsterType:getMaxHealth() + monsterType:getExperience()
  if monsterValue / 1000 >= 100 then
    level = math.ceil(math.log(monsterValue) * 10)
  elseif monsterValue / 100 >= 100 then
    level = math.ceil(math.log(monsterValue / 2) * 10)
  elseif monsterValue / 100 >= 10 then
    level = math.ceil(math.log(monsterValue / 4) * 8)
  elseif monsterValue / 10 >= 100 then
    level = math.ceil(math.log(monsterValue / 6) * 6)
  elseif monsterValue / 10 >= 10 then
    level = math.ceil(math.log(monsterValue / 8) * 4)
  else
    level = math.ceil(math.log(monsterValue / 10) * 2)
  end

  return math.max(1, level)
end
