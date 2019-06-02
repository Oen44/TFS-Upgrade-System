local UPGRADE_SYSTEM_VERSION = "2.0.0"
print(">> Loaded Upgrade System v" .. UPGRADE_SYSTEM_VERSION)

ITEM_UPGRADE_CRYSTAL = 1
ITEM_ENCHANT_CRYSTAL = 2
ITEM_ALTER_CRYSTAL = 3
ITEM_CLEAN_CRYSTAL = 4
ITEM_FORTUNE_CRYSTAL = 5
ITEM_FAITH_CRYSTAL = 6
ITEM_MIND_CRYSTAL = 7
ITEM_LIMITLESS_CRYSTAL = 8
ITEM_MIRRORED_CRYSTAL = 9
ITEM_VOID_CRYSTAL = 10

COMMON = 1
RARE = 2
EPIC = 3
LEGENDARY = 4

US_CONFIG = {
  {
    [ITEM_UPGRADE_CRYSTAL] = 26383, -- Upgrade Crystal item id
    [ITEM_ENCHANT_CRYSTAL] = 26384, -- Enchantment Crystal item id
    [ITEM_ALTER_CRYSTAL] = 26385, -- Alteration Crystal item id
    [ITEM_CLEAN_CRYSTAL] = 26386, -- Cleansing Crystal item id
    [ITEM_FORTUNE_CRYSTAL] = 26387, -- Fortune Crystal item id
    [ITEM_FAITH_CRYSTAL] = 26388, -- Faith Crystal item id
    [ITEM_MIND_CRYSTAL] = 26393, -- Mind Crystal item id
    [ITEM_LIMITLESS_CRYSTAL] = 26394, -- Limitless Crystal item id
    [ITEM_MIRRORED_CRYSTAL] = 26395, -- Mirrored Crystal item id
    [ITEM_VOID_CRYSTAL] = 26396 -- Void Crystal item id
  },
  ITEM_SCROLL_IDENTIFY = 26389, -- Scrol of Identification item id
  ITEM_UPGRADE_CATALYST = 26390, -- Upgrade Catalyst item id
  CRYSTAL_EXTRACTOR = 26391, -- Crystal Extractor item id
  CRYSTAL_FOSSIL = 26392, -- Crystal Fossil item id
  --
  UPGRADE_SUCCESS_CHANCE = {[1] = 100, [2] = 100, [3] = 95, [4] = 80, [5] = 65, [6] = 40}, -- % chance for the upgrade at given upgrade level, -1 upgrade level on failure
  UPGRADE_LEVEL_DESTROY = 7, -- at which upgrade level should it break if failed, for example if = 7 then upgrading from +6 to +7-9 can destroy item on failure.
  UPGRADE_DESTROY_CHANCE = {[7] = 30, [8] = 15, [9] = 5}, -- chance for the item to break at given upgrade level
  --
  MAX_ITEM_LEVEL = 300, -- max that Item Level can be assigned to item
  MAX_UPGRADE_LEVEL = 9, -- max level that item can be upgraded to,
  --
  ATTACK_PER_ITEM_LEVEL = 10, -- every X Item Level +ATTACK_FROM_ITEM_LEVEL attack
  ATTACK_FROM_ITEM_LEVEL = 1, -- +X bonus attack for every ATTACK_PER_ITEM_LEVEL
  DEFENSE_PER_ITEM_LEVEL = 10, -- every X Item Level +DEFENSE_FROM_ITEM_LEVEL defense
  DEFENSE_FROM_ITEM_LEVEL = 1, -- +X bonus defense for every DEFENSE_PER_ITEM_LEVEL
  ARMOR_PER_ITEM_LEVEL = 10, -- every X Item Level +ARMOR_FROM_ITEM_LEVEL armor
  ARMOR_FROM_ITEM_LEVEL = 1, -- +X bonus armor for every ARMOR_PER_ITEM_LEVEL
  HITCHANCE_PER_ITEM_LEVEL = 10, -- every X Item Level +HITCHANCE_FROM_ITEM_LEVEL hit chance
  HITCHANCE_FROM_ITEM_LEVEL = 1, -- +X bonus hit chance for every HITCHANCE_PER_ITEM_LEVEL
  --
  ITEM_LEVEL_PER_ATTACK = 6, -- +1 to Item Level for every X Attack in item
  ITEM_LEVEL_PER_DEFENSE = 15, -- +1 to Item Level for every X Defense in item
  ITEM_LEVEL_PER_ARMOR = 10, -- +1 to Item Level for every X Armor in item
  ITEM_LEVEL_PER_HITCHANCE = 3, -- +1 to Item Level for every X Hit Chance in item
  ITEM_LEVEL_PER_UPGRADE = 4, -- additional item level per upgrade level
  --
  ATTACK_PER_UPGRADE = 2, -- amount of bonus attack per upgrade level
  DEFENSE_PER_UPGRADE = 2, -- amount of bonus defense per upgrade level
  EXTRADEFENSE_PER_UPGRADE = 1, -- amount of bonus extra defense per upgrade level
  ARMOR_PER_UPGRADE = 2, -- amount of bonus armor per upgrade level
  HITCHANCE_PER_UPGRADE = 3, -- amount of bonus hit chance per upgrade level
  --
  CRYSTAL_FOSSIL_DROP_CHANCE = 8, -- 1:X chance that Crystal Fossil will drop from monster, X means that approximately every X monster will drop Crystal Fossil
  UNIDENTIFIED_DROP_CHANCE = 1, -- 1:X chance that item in monster corpse will be unidentified, X means that approximately every X item will be unidentified
  CRYSTAL_BREAK_CHANCE = 5, -- 1:X chance that Crystal will break when extracted from Fossil, X means that approximately every X Crystal will break
  UNIQUE_CHANCE = 15, -- 1:X chance that unidentified item will become Unique, X means that approximately every X unidentified item will become unique
  REQUIRE_LEVEL = true, -- block equipping items with higher Item Level than Player Level
  RARITY = {
    [COMMON] = {
      name = "common",
      maxBonus = 1, -- max amount of bonus attributes
      chance = 1 -- 1:X chance that item will be common (1 = 100%)
    },
    [RARE] = {
      name = "rare",
      maxBonus = 2, -- max amount of bonus attributes
      chance = 4 -- 1:X chance that item will be common (1 = 100%)
    },
    [EPIC] = {
      name = "epic",
      maxBonus = 3, -- max amount of bonus attributes
      chance = 8 -- 1:X chance that item will be common (1 = 100%)
    },
    [LEGENDARY] = {
      name = "legendary",
      maxBonus = 4, -- max amount of bonus attributes
      chance = 16 -- 1:X chance that item will be common (1 = 100%)
    }
  }
}

US_ITEM_TYPES = {
  ALL = 1,
  WEAPON_MELEE = 2,
  WEAPON_DISTANCE = 4,
  WEAPON_WAND = 8,
  SHIELD = 16,
  HELMET = 32,
  ARMOR = 64,
  LEGS = 128,
  BOOTS = 256,
  RING = 512,
  NECKLACE = 1024,
  WEAPON_ANY = 14
}

US_UNIQUES = {
  [1] = {
    name = "Flame Spirit",
    attributes = {
      1, -- Max HP
      4, -- Melee Skills
      12, -- Life Steal
      30 -- Flame Strike on Attack
    },
    minLevel = 100, -- Required Item Level to become Unique
    itemType = US_ITEM_TYPES.WEAPON_MELEE + US_ITEM_TYPES.SHIELD -- Can be rolled only for items like Swords, Axes and Clubs
  },
  [2] = {
    name = "Ice Spirit",
    attributes = {
      2, -- Max MP
      3, -- Magic Level
      32, -- Ice Strike on Attack
      44 -- Regenerate Mana on Kill
    },
    minLevel = 70, -- Required Item Level to become Unique
    itemType = US_ITEM_TYPES.WEAPON_WAND + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE -- Can be rolled only for items like Wands, Rods, Rings, Necklaces
  },
  [3] = {
    name = "Terra Spirit",
    attributes = {
      1, -- Max HP
      2, -- Max MP
      3, -- Magic Level
      34 -- Terra Strike on Attack
    },
    minLevel = 70, -- Required Item Level to become Unique
    itemType = US_ITEM_TYPES.WEAPON_WAND + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE -- Can be rolled only for items like Wands, Rods, Rings, Necklaces
  }
}

US_TYPES = {
  CONDITION = 0,
  OFFENSIVE = 1,
  DEFENSIVE = 2,
  TRIGGER = 3
}

US_TRIGGERS = {
  ATTACK = 0,
  HIT = 1,
  KILL = 2
}

US_ENCHANTMENTS = {
  [1] = {
    name = "Max HP",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_STAT_MAXHITPOINTS,
    VALUES_PER_LEVEL = 3,
    format = function(value)
      return "Max HP +" .. value
    end,
    itemType = US_ITEM_TYPES.HELMET + US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.LEGS + US_ITEM_TYPES.BOOTS
  },
  [2] = {
    name = "Max MP",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_STAT_MAXMANAPOINTS,
    VALUES_PER_LEVEL = 4,
    format = function(value)
      return "Max MP +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [3] = {
    name = "Magic Level",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_STAT_MAGICPOINTS,
    VALUES_PER_LEVEL = 0.1,
    format = function(value)
      return "Magic Level +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [4] = {
    name = "Melee Skills",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_MELEE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Melee Skills +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [5] = {
    name = "Fist Fighting",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_FIST,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Fist Fightning +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [6] = {
    name = "Sword Fighting",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_SWORD,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Sword Fighting +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [7] = {
    name = "Axe Fighting",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_AXE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Axe Fighting +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [8] = {
    name = "Club Fighting",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_CLUB,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Club Fighting +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [9] = {
    name = "Distance Fighting",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_DISTANCE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Distance Fighting +" .. value
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [10] = {
    name = "Shielding",
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_ATTRIBUTES,
    param = CONDITION_PARAM_SKILL_SHIELD,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Shielding +" .. value
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [11] = {
    name = "Mana Shield",
    minLevel = 50,
    combatType = US_TYPES.CONDITION,
    condition = CONDITION_MANASHIELD,
    format = function(value)
      return "Mana Shield"
    end,
    itemType = US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE
  },
  [12] = {
    name = "Life Steal",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_PHYSICALDAMAGE + COMBAT_ENERGYDAMAGE + COMBAT_EARTHDAMAGE + COMBAT_FIREDAMAGE + COMBAT_ICEDAMAGE +
      COMBAT_HOLYDAMAGE +
      COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.1,
    format = function(value)
      return "Heal for " .. value .. "%% of dealt damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_MELEE + US_ITEM_TYPES.WEAPON_DISTANCE,
    chance = 10
  },
  [13] = {
    name = "Experience",
    VALUES_PER_LEVEL = 0.35,
    format = function(value)
      return "Experience +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.BOOTS,
    chance = 30
  },
  [14] = {
    name = "Physical Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_PHYSICALDAMAGE,
    VALUES_PER_LEVEL = 0.3,
    format = function(value)
      return "Physical Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [15] = {
    name = "Energy Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_ENERGYDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Energy Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [16] = {
    name = "Earth Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_EARTHDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Earth Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [17] = {
    name = "Fire Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_FIREDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Fire Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [18] = {
    name = "Ice Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_ICEDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Ice Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [19] = {
    name = "Holy Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_HOLYDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Holy Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [20] = {
    name = "Death Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Death Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [21] = {
    name = "Elemental Damage",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_ENERGYDAMAGE + COMBAT_EARTHDAMAGE + COMBAT_FIREDAMAGE + COMBAT_ICEDAMAGE + COMBAT_HOLYDAMAGE + COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.2,
    format = function(value)
      return "Elemental Damage +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS,
    chance = 10
  },
  [22] = {
    name = "Physical Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_PHYSICALDAMAGE,
    VALUES_PER_LEVEL = 0.1,
    format = function(value)
      return "Physical Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [23] = {
    name = "Energy Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_ENERGYDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Energy Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [24] = {
    name = "Earth Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_EARTHDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Earth Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [25] = {
    name = "Fire Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_FIREDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Fire Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [26] = {
    name = "Ice Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_ICEDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Ice Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [27] = {
    name = "Holy Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_HOLYDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Holy Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [28] = {
    name = "Death Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.15,
    format = function(value)
      return "Death Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [29] = {
    name = "Elemental Protection",
    combatType = US_TYPES.DEFENSIVE,
    combatDamage = COMBAT_ENERGYDAMAGE + COMBAT_EARTHDAMAGE + COMBAT_FIREDAMAGE + COMBAT_ICEDAMAGE + COMBAT_HOLYDAMAGE + COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.05,
    format = function(value)
      return "Elemental Protection +" .. value .. "%%"
    end,
    itemType = US_ITEM_TYPES.ARMOR + US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.BOOTS + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS,
    chance = 10
  },
  [30] = {
    name = "Flame Strike on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_FIRE)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_FIREDAMAGE, 1, damage, CONST_ME_FIREATTACK, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Flame Strike on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [31] = {
    name = "Flame Strike on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_FIRE)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_FIREDAMAGE, 1, damage, CONST_ME_FIREATTACK, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Flame Strike on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [32] = {
    name = "Ice Strike on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLICE)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_ICEDAMAGE, 1, damage, CONST_ME_ICEATTACK, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Ice Strike on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [33] = {
    name = "Ice Strike on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLICE)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_ICEDAMAGE, 1, damage, CONST_ME_ICEATTACK, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Ice Strike on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [34] = {
    name = "Terra Strike on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLEARTH)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_EARTHDAMAGE, 1, damage, CONST_ME_CARNIPHILA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Terra Strike on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [35] = {
    name = "Terra Strike on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLEARTH)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_EARTHDAMAGE, 1, damage, CONST_ME_CARNIPHILA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Terra Strike on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [36] = {
    name = "Death Strike on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_DEATH)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_DEATHDAMAGE, 1, damage, CONST_ME_MORTAREA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Death Strike on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [37] = {
    name = "Death Strike on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_DEATH)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_DEATHDAMAGE, 1, damage, CONST_ME_MORTAREA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Death Strike on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [38] = {
    name = "Divine Missile on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLHOLY)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_HOLYDAMAGE, 1, damage, CONST_ME_HOLYDAMAGE, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Divine Missile on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [39] = {
    name = "Divine Missile on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_SMALLHOLY)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_HOLYDAMAGE, 1, damage, CONST_ME_HOLYDAMAGE, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Divine Missile on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [40] = {
    name = "Energy Strike on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.ATTACK,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_ENERGY)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_ENERGYDAMAGE, 1, damage, CONST_ME_ENERGYAREA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Energy Strike on Attack dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [41] = {
    name = "Energy Strike on Hit",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 2.5,
    execute = function(attacker, target, damage)
      if math.random(100) < 20 then
        attacker:getPosition():sendDistanceEffect(target:getPosition(), CONST_ANI_ENERGY)
        doTargetCombatHealth(attacker:getId(), target, COMBAT_ENERGYDAMAGE, 1, damage, CONST_ME_ENERGYAREA, ORIGIN_CONDITION)
      end
    end,
    format = function(value)
      return "20%% to cast Energy Strike on Hit dealing 1-" .. value .. " damage"
    end,
    itemType = US_ITEM_TYPES.SHIELD + US_ITEM_TYPES.HELMET + US_ITEM_TYPES.LEGS
  },
  [42] = {
    name = "Explosion on Kill",
    minLevel = 20,
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 0.2,
    execute = function(player, value, center, target)
      local damage = math.ceil(target:getMaxHealth() * (value / 100))
      exoriEffect(center, CONST_ME_FIREAREA)
      doAreaCombatHealth(player:getId(), COMBAT_FIREDAMAGE, center, 2, damage, damage, CONST_ME_NONE, ORIGIN_CONDITION)
    end,
    format = function(value)
      return "Explosion on Kill dealing " .. value .. "%% Max HP of a killed monster"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY
  },
  [43] = {
    name = "Health on Kill",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 2,
    execute = function(player, value, center, target)
      player:addHealth(value)
    end,
    format = function(value)
      return "Regenerate " .. value .. " Health on Kill"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    chance = 25
  },
  [44] = {
    name = "Mana on Kill",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 3,
    execute = function(player, value, center, target)
      player:addMana(value)
    end,
    format = function(value)
      return "Regenerate " .. value .. " Mana on Kill"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY + US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    chance = 25
  },
  [45] = {
    name = "Mana Steal",
    combatType = US_TYPES.OFFENSIVE,
    combatDamage = COMBAT_ENERGYDAMAGE + COMBAT_EARTHDAMAGE + COMBAT_FIREDAMAGE + COMBAT_ICEDAMAGE + COMBAT_HOLYDAMAGE + COMBAT_DEATHDAMAGE,
    VALUES_PER_LEVEL = 0.1,
    format = function(value)
      return "Regenerate Mana for " .. value .. "%% of dealt damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_WAND + US_ITEM_TYPES.WEAPON_DISTANCE,
    chance = 10
  },
  [46] = {
    name = "Full HP on Kill",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 0.05,
    execute = function(player, value, center, target)
      if math.random(100) < value then
        player:addHealth(player:getMaxHealth())
      end
    end,
    format = function(value)
      return value .. "%% to regenerate full HP on Kill"
    end,
    itemType = US_ITEM_TYPES.RING,
    minLevel = 20,
    chance = 5
  },
  [47] = {
    name = "Full MP on Kill",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 0.05,
    execute = function(player, value, center, target)
      if math.random(100) < value then
        player:addMana(player:getMaxMana())
      end
    end,
    format = function(value)
      return value .. "%% to regenerate full MP on Kill"
    end,
    itemType = US_ITEM_TYPES.RING,
    minLevel = 20,
    chance = 5
  },
  [48] = {
    name = "Mass Healing on Attack",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.HIT,
    VALUES_PER_LEVEL = 0.2,
    execute = function(attacker, target, damage)
      if math.random(100) < damage then
        local min = (attacker:getLevel() / 5) + (attacker:getMagicLevel() * 4.6) + 100
        local max = (attacker:getLevel() / 5) + (attacker:getMagicLevel() * 9.6) + 125

        doAreaCombatHealth(target:getId(), COMBAT_HEALING, attacker:getPosition(), 6, min, max, CONST_ME_MAGIC_BLUE)
      end
    end,
    format = function(value)
      return value .. "%% to cast Mass Healing on Attack"
    end,
    itemType = US_ITEM_TYPES.WEAPON_WAND,
    minLevel = 10,
    chance = 15
  },
  [49] = {
    name = "Increased Healing",
    VALUES_PER_LEVEL = 0.35,
    format = function(value)
      return value .. "%% more healing from all sources"
    end,
    itemType = US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    minLevel = 25,
    chance = 20
  },
  [50] = {
    name = "Additonal Gold",
    VALUES_PER_LEVEL = 0.5,
    format = function(value)
      return value .. "%% more gold from loot"
    end,
    itemType = US_ITEM_TYPES.BOOTS,
    minLevel = 10,
    chance = 30
  },
  [51] = {
    name = "Double Damage",
    combatType = US_TYPES.OFFENSIVE,
    VALUES_PER_LEVEL = 0.05,
    format = function(value)
      return value .. "%% to deal double damage"
    end,
    itemType = US_ITEM_TYPES.WEAPON_ANY,
    minLevel = 80,
    chance = 5
  },
  [52] = {
    name = "Revive on death",
    VALUES_PER_LEVEL = 0.05,
    format = function(value)
      return value .. "%% to be revived"
    end,
    itemType = US_ITEM_TYPES.BOOTS,
    minLevel = 50,
    chance = 30
  },
  [53] = {
    name = "Damage Buff",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    VALUES_PER_LEVEL = 0.5,
    execute = function(player, value)
      if math.random(100) < 20 then
        local pid = player:getId()
        local buffId = 1
        if not US_BUFFS[pid] then
          US_BUFFS[pid] = {}
        end
        if not US_BUFFS[pid][buffId] then
          US_BUFFS[pid][buffId] = {}
          US_BUFFS[pid][buffId].value = value
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Damage Buff applied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Damage Buff")
        else
          stopEvent(US_BUFFS[pid][buffId].event)
          US_BUFFS[pid][buffId].value = value
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Damage Buff reapplied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Damage Buff")
        end
      end
    end,
    format = function(value)
      return "20%% to get " .. value .. "%% damage buff for 8 sec. on Kill"
    end,
    itemType = US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    minLevel = 30,
    chance = 10
  },
  [54] = {
    name = "Max HP Buff",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    buff = true,
    VALUES_PER_LEVEL = 0.5,
    execute = function(player, value)
      if math.random(100) < 20 then
        local pid = player:getId()
        local buffId = 2
        if not US_BUFFS[pid] then
          US_BUFFS[pid] = {}
        end
        if not US_BUFFS[pid][buffId] then
          US_BUFFS[pid][buffId] = {}
          US_BUFFS[pid][buffId].condition = Condition(CONDITION_ATTRIBUTES)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_STAT_MAXHITPOINTSPERCENT, 100 + value)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_TICKS, 8000)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_SUBID, 3245)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
          player:addCondition(US_BUFFS[pid][buffId].condition)
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Max HP Buff applied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Max HP Buff")
        else
          stopEvent(US_BUFFS[pid][buffId].event)
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Max HP Buff reapplied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Max HP Buff")
          player:removeCondition(US_BUFFS[pid][buffId].condition)
          player:addCondition(US_BUFFS[pid][buffId].condition)
        end
      end
    end,
    format = function(value)
      return "20%% to get " .. value .. "%% Max HP buff for 8 sec. on Kill"
    end,
    itemType = US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    minLevel = 30,
    chance = 10
  },
  [55] = {
    name = "Max MP Buff",
    combatType = US_TYPES.TRIGGER,
    triggerType = US_TRIGGERS.KILL,
    buff = true,
    VALUES_PER_LEVEL = 0.5,
    execute = function(player, value)
      if math.random(100) < 20 then
        local pid = player:getId()
        local buffId = 3
        if not US_BUFFS[pid] then
          US_BUFFS[pid] = {}
        end
        if not US_BUFFS[pid][buffId] then
          US_BUFFS[pid][buffId] = {}
          US_BUFFS[pid][buffId].condition = Condition(CONDITION_ATTRIBUTES)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_STAT_MAXMANAPOINTSPERCENT, 100 + value)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_TICKS, 8000)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_SUBID, 3246)
          US_BUFFS[pid][buffId].condition:setParameter(CONDITION_PARAM_BUFF_SPELL, true)
          player:addCondition(US_BUFFS[pid][buffId].condition)
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Max MP Buff applied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Max MP Buff")
        else
          stopEvent(US_BUFFS[pid][buffId].event)
          player:sendTextMessage(MESSAGE_INFO_DESCR, "Max MP Buff reapplied for 8 seconds!")
          US_BUFFS[pid][buffId].event = addEvent(us_RemoveBuff, 8000, pid, buffId, "Max MP Buff")
          player:removeCondition(US_BUFFS[pid][buffId].condition)
          player:addCondition(US_BUFFS[pid][buffId].condition)
        end
      end
    end,
    format = function(value)
      return "20%% to get " .. value .. "%% Max MP buff for 8 sec. on Kill"
    end,
    itemType = US_ITEM_TYPES.RING + US_ITEM_TYPES.NECKLACE,
    minLevel = 30,
    chance = 10
  }
}

function exoriEffect(center, effect)
  for i = -1, 1 do
    local top = Position(center.x + i, center.y - 1, center.z)
    local middle = Position(center.x + i, center.y, center.z)
    local bottom = Position(center.x + i, center.y + 1, center.z)
    top:sendMagicEffect(effect)
    middle:sendMagicEffect(effect)
    bottom:sendMagicEffect(effect)
  end
end
