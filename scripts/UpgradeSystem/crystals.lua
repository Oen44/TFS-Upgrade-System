local CrystalsAction = Action()

function CrystalsAction.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if not target or not target:isItem() or not target:getType():isUpgradable() then
        return false
    end
    if toPosition.y <= CONST_SLOT_AMMO then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "You can't use that on equipped item!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end
    if item.itemid ~= US_CONFIG.ITEM_SCROLL_IDENTIFY and target:isUnidentified() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is unidentified and can't be modified!")
        player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        return true
    end
    if target:isMirrored() then
        player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is mirrored and can't be modified!")
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
                            player:sendTextMessage(MESSAGE_INFO_DESCR, "Upgrade failed! Item protected from being destroyed!")
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
                player:sendTextMessage(MESSAGE_INFO_DESCR, "Item upgrade level increased to " .. upgrade .. "!")
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
    elseif item.itemid == US_CONFIG.ITEM_MIND_CRYSTAL then
        if not item:hasMemory() then
            if target:isUnidentified() then
                player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item is unidentified and can't be copied!")
                player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
            elseif not target:getBonusAttributes() then
                player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, this item doesn't have any attributes!")
                player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
            elseif target:isUnique() then
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
    elseif item.itemid == US_CONFIG.ITEM_LIMITLESS_CRYSTAL then
        if not target:isLimitless() then
            player:sendTextMessage(MESSAGE_INFO_DESCR, "Required Item Level removed from the item!")
            target:setLimitless(true)
            item:remove(1)
        else
            player:sendTextMessage(MESSAGE_STATUS_WARNING, "Sorry, there are no Uniques available for this item!")
            player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
        end
    elseif item.itemid == US_CONFIG.ITEM_MIRRORED_CRYSTAL then
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
    elseif item.itemid == US_CONFIG.ITEM_VOID_CRYSTAL then
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

-- can't use table as parameter, so...
CrystalsAction:id(
    US_CONFIG[1][ITEM_UPGRADE_CRYSTAL],
    US_CONFIG[1][ITEM_ENCHANT_CRYSTAL],
    US_CONFIG[1][ITEM_ALTER_CRYSTAL],
    US_CONFIG[1][ITEM_CLEAN_CRYSTAL],
    US_CONFIG[1][ITEM_FORTUNE_CRYSTAL],
    US_CONFIG[1][ITEM_FAITH_CRYSTAL],
    US_CONFIG.ITEM_MIND_CRYSTAL,
    US_CONFIG.ITEM_LIMITLESS_CRYSTAL,
    US_CONFIG.ITEM_MIRRORED_CRYSTAL,
    US_CONFIG.ITEM_VOID_CRYSTAL,
    US_CONFIG.ITEM_SCROLL_IDENTIFY
)
CrystalsAction:register()
