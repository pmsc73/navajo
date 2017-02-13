require 'images'
require 'boxes'
require 'graphics'
require 'mymenu'

require 'battlequeue'
require 'state'

battleSystem = {} 

-- component encoding in enumerated integer values

-- constants
PHYSICAL 	= "PHYSICAL"
MAGIC		= "MAGIC"
ELEM_NONE	= "NON ELEMENTAL"

function battleSystem.dealDamage(t, source, target, element)
	baseDamageMod   = ops.nndv(source.damage_modifier, 0)
	baseDefenceMod  = ops.nndv(target.defence_modifier, 0)
	baseDamageMult  = ops.nndv(source.damage_multiplier, 1)
	baseDefenceMult = ops.nndv(source.defence_multiplier, 1)


	baseDamage  = baseDamageMult  * (math.random() + baseDamageMod)
	baseDefence = baseDefenceMult * (math.random() + baseDefenceMod)
	chromaMod = 1

	if element ~= nil then 
		chromaMod = chromaMod + color_diff(toHSV(element), toHSV(target.stats.chroma), true) or 0
		gfx.create_text_entity((2 ^ chromaMod), 150, 50, 50)
	end

	if t == PHYSICAL then 
		damage  = (1 + baseDamage) * source.stats.strength
		defence = (1 + baseDefence) * target.stats.fortitude
	elseif t == MAGIC then 
		damage  = (1 + baseDamage) * source.stats.intelligence
		defence = (1 + baseDamage) * target.stats.wisdom
	end

	if target.stats.currentHp == nil then 
		target.stats.currentHp = maxHpFormula(target) 
	end

	netDamage = round( (2 ^ chromaMod) * (damage / defence))
	if netDamage ~= netDamage then
		netDamage = 0
	end
	target.stats.currentHp = round(target.stats.currentHp - netDamage)

	-- add damage graphic!
	gfx.create_text_entity(netDamage, 150, 50, 25, element)

	if target.stats.currentHp <= 0 then 
		target.dead = true
		target.stats.currentHp = 0
		processExperience(source, target)
	end
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
	local modifier = character.stats.fortitude + character.stats.wisdom + character.stats.endurance
	local multiplier = character.stats.constitution

	return radic_stat(base, multiplier, modifier)
end

function maxMp(character) 
	local base = 4
	local modifier = character.stats.intelligence + character.stats.dexterity + character.stats.constitution
	local multiplier = character.stats.willpower

	return radic_stat(base, multiplier, modifier)
end

function maxStamina(character) 
	local base = 1
	local modifier = character.stats.agility + character.stats.strength + character.stats.willpower
	local multiplier = character.stats.endurance

	return radic_stat(base, multiplier, modifier)
end

function hpRegenRate(character) 
	local base = 1/4
	local modifier = math.min(character.stats.strength, character.stats.fortitude, character.stats.constitution)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function mpRegenRate(character) 
	local base = 1/8
	local modifier = math.min(character.stats.intelligence, character.stats.wisdom, character.stats.willpower)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function spRegenRate(character)
	local base = 1/2
	local modifier = math.min(character.stats.dexterity, character.stats.agility, character.stats.endurance)
	local multiplier = 1

	return basic_stat(base, multiplier, modifier)
end

function round(number) 
	return math.floor(number + 0.5)
end