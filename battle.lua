require 'images'
require 'boxes'
require 'graphics'
require 'mymenu'
require 'item'
require 'inventory'
require 'battlequeue'
require 'state'

battleSystem = {} 

-- component encoding in enumerated integer values

-- constants
PHYSICAL 	= "PHYSICAL"
MAGIC		= "MAGIC"
ELEM_NONE	= "NON ELEMENTAL"

function battleSystem.dealDamage(t, source, target, element)
	baseDamageMod   = ops.nndv(source.damage_modifier,    0)	
	baseDefenceMod  = ops.nndv(target.defence_modifier,   0)
	baseDamageMult  = ops.nndv(source.damage_multiplier,  1)
	baseDefenceMult = ops.nndv(target.defence_multiplier, 1)

	local tkey = target.name
	if source.name == "Karna" then 
		baseDamageMod   = baseDamageMod   + ops.nndv(source.cross_damage_modifier[tkey],  0)
		baseDamageMult  = baseDamageMult  * ops.nndv(source.cross_damage_modifier[tkey],  1)
		baseDefenceMod  = baseDefenceMod  + ops.nndv(source.cross_defence_modifier[tkey], 0)
		baseDefenceMult = baseDefenceMult * ops.nndv(source.cross_defence_modifier[tkey], 1)
	end
	baseDamage  = (baseDamageMult) * (math.random() + baseDamageMod) 
	baseDefence = (baseDefenceMult) * (math.random() + baseDefenceMod)
	chromaMod = 1

	if element ~= nil then 
		chromaMod = chromaMod + color_diff(toHSV(element), toHSV(target.stats.chroma), true) or 0
		gfx.create_text_entity((2 ^ chromaMod), 150, 50, 50)
	end

	if t == PHYSICAL then 
		damage  = (1 + baseDamage) * source.stats.str
		defence = (1 + baseDefence) * target.stats.frt
	elseif t == MAGIC then 
		damage  = (1 + baseDamage) * source.stats.int
		defence = (1 + baseDamage) * target.stats.wis
	end

	if target.stats.currentHp == nil then 
		target.stats.currentHp = maxHpFormula(target) 
	end

	netDamage = round( (2 ^ chromaMod) * (damage / defence))
	if netDamage ~= netDamage then
		netDamage = 0
	end
	target.stats.currentHp = round(target.stats.currentHp - netDamage)
	if source.name == "Karna" then
		logDamage(target.name, netDamage)
	end
	-- add damage graphic!
	gfx.create_text_entity(netDamage, 150, 50, 25, element)

	if target.stats.currentHp <= 0 then 
		-- on death
		processDeath(target, source)
	end
end

local i = 0
function processDeath(target, source)
	target.dead = true
	target.stats.currentHp = 0
	processExperience(source, target)
	if source.name == "Karna" then
		logDeath(target.name)
	end
	-- add item to inventory?
	local temp_itemdb = ITEM_DATABASE
	local name = target.name .. ":" .. i
	table.insert(temp_itemdb, 
		new_item(name, "!",
		{ 
			["equip"] = true,
			["weapon"] = true
		},
		function(t) t[1].damage_modifier = t[1].damage_modifier + 2 end,
		function() return nil end
		)
	)
	INVENTORY.name=1
	i = i + 1

	ITEM_DATABASE = temp_itemdb
end

function battleSystem.heal(character, base_modifier) 
	base_modifier = math.floor(base_modifier + 0.5)
	character.stats.currentHp = math.min(character.stats.currentHp + base_modifier, maxHpFormula(character))
end

function battleSystem.processAttack(character, target) 
	local r = math.random() * 255
	local b = math.random() * 255
	local g = math.random() * 255
	battleSystem.dealDamage(PHYSICAL, character, target, {r, g, b})
end

function processExperience(source, target)
	if not source.stats.currentXp then return end
	local xp_start = source.stats.currentXp

	local lv_start = source.level
	local xp_post = source.stats.currentXp + target.xp

	while  xp_post >= xpToLevel(source)  do
		source:levelUp()
	end
	source.stats.currentXp = source.stats.currentXp + target.xp
end

function basic_stat(base, multiplier, modifier) 
	return base * multiplier + modifier
end

function radic_stat(base, multiplier, modifier) 
	return base * math.sqrt(multiplier^2 + multiplier*modifier)
end

function maxHpFormula(character) 
	local base = 2
	local modifier = character.stats.frt + character.stats.wis + character.stats.edr
	local multiplier = character.stats.con

	return radic_stat(base, multiplier, modifier)
end

function maxMp(character) 
	local base = 4
	local modifier = character.stats.int + character.stats.dex + character.stats.con
	local multiplier = character.stats.wll

	return radic_stat(base, multiplier, modifier)
end

function maxStamina(character) 
	local base = 1
	local modifier = character.stats.agi + character.stats.str + character.stats.wll
	local multiplier = character.stats.edr

	return radic_stat(base, multiplier, modifier)
end

function hpRegenRate(character) 
	local base = 1/4
	local modifier = math.min(character.stats.str, character.stats.frt, character.stats.con)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function mpRegenRate(character) 
	local base = 1/8
	local modifier = math.min(character.stats.int, character.stats.wis, character.stats.wll)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function spRegenRate(character)
	local base = 1/2
	local modifier = math.min(character.stats.dex, character.stats.agi, character.stats.edr)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function round(number) 
	return math.floor(number + 0.5)
end