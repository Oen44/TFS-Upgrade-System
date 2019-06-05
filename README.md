#### Table of Contents
* [About](#upgrade-system)
* [New Items](#new-items)
* [Attributes](#attributes)
* [Item Level](#item-level)
* [Unique Items](#unique-items)
* [Installation](#installation)
* [Configuration](#configuration)
* [Developer Notes](#developer-notes)

# Upgrade System

Tibia has flat, dull, boring and not fun items system, time to change it. Expand your server with a lot of possibilities to make grinding more satisfying. No more useless items laying around and being ignored by others, now every item can be powerful. Using special crystals, items can be upgraded with new stats and powerful attributes. New property - Item Level - which determines how powerful given item is. A lot of crystals to upgrade items even further.

#### [YouTube Video](https://www.youtube.com/watch?v=TYrp6CKVtpk)

## New Items

Name | Description | How to obtain
------------ | ------------- | -------------
Upgrade Crystal | Can be used on a piece of equipment for a chance to upgrade it. | Crystal Fossil
Enchantment Crystal | Can be used on a piece of equipment to add random attribute. | Crystal Fossil
Alteration Crystal | Can be used on a piece of equipment to remove last attribute. | Crystal Fossil
Cleansing Crystal | Can be used on a piece of equipment to remove all attributes. | Crystal Fossil
Fortune Crystal | Can be used on a piece of equipment to change value of last attribute. | Crystal Fossil
Faith Crystal | Can be used on a piece of equipment to change values of all attributes. | Crystal Fossil
Mind Crystal | Used to extract all attributes and values and store in that crystal. Can be used again to place these attributes to a new item. Lower item rarity will remove exceeded attributes. | Custom - NPC, Quests etc.
Limitless Crystal | Used to remove Item Level requirement to equip given item. | Custom - NPC, Quests etc.
Mirrored Crystal | Used to make a copy of any item. Copies can't be modified and mirrored again. | Custom - NPC, Quests etc.
Void Crystal | Used to transform item into random Unique type. | Custom - NPC, Quests etc.
Upgrade Catalyst | Prevents item destroy on upgrade. Consumed on item upgrade. | Custom - NPC, Quests etc.
Crystal Fossil | There is unknown crystal inside, try to use crystal extractor. | Randomly drops from monsters
Crystal Extractor | Used to extract rare crystals from crystal fossil. | Custom - NPC, Quests etc.
Scroll of Identification | Can be used on unidentified item to reveal hidden attributes. | Custom - NPC, Quests etc.

## Attributes
* Max HP
* Max MP
* Magic Level
* Melee Skills (all in one)
* Fist Fighting
* Sword Fighting
* Axe Fighting
* Club Fighting
* Distance Fighting
* Shielding
* Mana Shield
* Life Steal
* Experience
* Physical Damage
* Physical Protection
* Energy Damage
* Energy Protection
* Earth Damage
* Earth Protection
* Fire Damage
* Fire Protection
* Ice Damage
* Ice Protection
* Holy Damage
* Holy Protection
* Death Damage
* Death Protection
* Elemental Damage (every element in one except physical)
* Elemental Protection (every element in one except physical)
* Cast Flame Strike on Attack
* Cast Flame Strike on Hit
* Cast Ice Strike on Attack
* Cast Ice Strike on Hit
* Cast Terra Strike on Attack
* Cast Terra Strike on Hit
* Cast Death Strike on Attack
* Cast Death Strike on Hit
* Cast Energy Strike on Attack
* Cast Energy Strike on Hit
* Cast Divine Missile on Attack
* Cast Divine Missile on Hit
* Explosion on Kill
* Regenerate Health on Kill
* Regenerate Mana on Kill
* Mana Steal
* Chance to regenerate full HP on Kill
* Chance to regenerate full MP on Kill
* Chance to cast Mass Healing on Attack
* Increased healing from all sources
* Additional gold from monsters loot
* Chance to deal double damage
* Chance to be revived with 100% HP and MP upon death
* Chance to get Bonus Damage buff on Kill
* Chance to get Bonus Max HP buff on Kill
* Chance to get Bonus Max MP buff on Kill

## Item Level
Item Level (iLvl) is set for every wearable item when dropped by a monster.
Default iLvl is calculated using special algorithm that determines monster level/power based on its Max HP and Experience.
Then additional iLvl value is given based on base item stats (Atk, Def, Armor, Hit Chance). After all of that, additional stats are calculated based on item iLvl.
Upgrading item level increases iLvl in addition to bonus stats and values for bonus attributes are based on iLvl of the item.
Given all of that I have made every item different. If you drop a Giant Sword from a Behemoth and a Giant Sword from a Ferumbras they will be different in stats.
You may ask "What if someone loots Sword from high level monster and a new player gets it? That's unbalanced." but don't be afraid.
If player level is lower than iLvl of given items, they **can't** equip them!

## Unique Items
Items with predefined attributes that can't be altered, only their values can be changed. Unidentified items can become Unique.

## Installation
* Open `data/global.lua`.
* Add somewhere on top
```xml
dofile('data/upgrade_system_core.lua')
```
* Open `data/events/events.xml`.
* Make sure you have enabled
```xml
<event class="Creature" method="onTargetCombat" enabled="1" />

<event class="Player" method="onLook" enabled="1" />
<event class="Player" method="onMoveItem" enabled="1" />
<event class="Player" method="onItemMoved" enabled="1" />
<event class="Player" method="onGainExperience" enabled="1" />
```
* Open `data/events/scripts/player.lua`.
* Find `Player:onLook`.
* Add after `local description = "You see " .. thing:getDescription(distance)`
```xml
description = onItemUpgradeLook(self, thing, position, distance, description)
```
* Find `Player:onMoveItem`.
* Change `return true` from last line to
```xml
return us_onMoveItem(self, item, fromPosition, toPosition)
```
* Find `Player:onItemMoved`.
* Add inside
```xml
onUpgradeMoved(self, item, count, fromPosition, toPosition, fromCylinder, toCylinder)
```
* Find `Player:onGainExperience`.
* Add at the end before `return exp`
```xml
exp = us_onGainExperience(self, source, exp, rawExp)
```
* Open `data/events/scripts/creature.lua`.
* Find `Creature:onTargetCombat`.
* Add somewhere (the best place is after all events, before any event that calculates damage, like DPS Counter)
```xml
target:registerEvent("UpgradeSystemHealth")
target:registerEvent("UpgradeSystemDeath")
```
* Open `data/actions/actions.xml`.
* This is important part, you have to specify items ID for crystals, scroll of identification and crystal extractor. I have created custom items for myself and IDs are one after another so I'm using `fromid` and `toid`. I hope you can handle it.
```xml
<action fromid="26383" toid="26389" script="upgrade_system_actions.lua" /> <!-- Crystals and Scroll -->
<action fromid="26393" toid="26396" script="upgrade_system_actions.lua" /> <!-- Crystals -->
<action itemid="26391" script="upgrade_system_tool.lua" /> <!-- Crystal Extractor -->
```
* Open `data/creaturescripts/creaturescripts.xml`.
* Add
```xml
<event type="login" name="UpgradeSystemLogin" script="upgrade_system_cs.lua" />
<event type="death" name="UpgradeSystemDeath" script="upgrade_system_cs.lua" />
<event type="kill" name="UpgradeSystemKill" script="upgrade_system_cs.lua" />
<event type="healthchange" name="UpgradeSystemHealth" script="upgrade_system_cs.lua" />
<event type="manachange" name="UpgradeSystemMana" script="upgrade_system_cs.lua" />
<event type="preparedeath" name="UpgradeSystemPD" script="upgrade_system_cs.lua" />
```
* Download latest version from [Release Page](https://github.com/Oen44/TFS-Upgrade-System/releases/latest).
* Extract and copy content of the archive into your `data`.

## Configuration
Every configuration is inside `data/upgrade_system_const.lua`.
I have added some comments that should explain each property. There are however few special properties for attributes.

`VALUES_PER_LEVEL` - this indicates max value that can be rolled for given attribute, based on item level. For example if set to **3** then every Item Level adds +3 value, at Item Level 100, max value for this attribute can be 300 (still rolled from 1 to max value).

`minLevel` - this indicates what Item Level is required for this attribute to be rolled. Use it to balance some early and late game attributes.

`chance` - chance in % that this attribute will be rolled. If you want 100% then remove that property or just set to 100.

## Developer Notes
Items from Quests, NPCs or any source other than monster loot won't have Item Level set.
There are functions to help you overcome this issue.
```lua
-- Set Item Level = item_level
-- Calculate additonal iLvl from base stats = true
item:setItemLevel(item_level, true)
```
