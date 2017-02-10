require 'images'
require 'boxes'
require 'graphics'
require 'mymenu'

require 'battlequeue'


battleSystem = {} 

-- constants
PHYSICAL 	= "PHYSICAL"
MAGIC		= "MAGIC"
ELEM_FIRE	= "FIRE"
ELEM_WATER 	= "WATER"
ELEM_AIR	= "AIR"
ELEM_NONE	= "NON ELEMENTAL"

function battleSystem.dealDamage(t, source, target, element)
	if element == nil then element = ELEM_NONE end
	baseDamage = 0
	baseDefence = 0
	
	if t == PHYSICAL then 
		baseDamage = source.stats.strength
		baseDefence = target.stats.endurance
	elseif t == MAGIC then
		baseDamage = source.stats.intelligence
		baseDefence = target.stats.wisdom
	end
	if target.stats.currentHp == nil then
		target.stats.currentHp = maxHpFormula(target)
	end

	target.stats.currentHp = round(target.stats.currentHp - (baseDamage / baseDefence))

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
	battleSystem.dealDamage(PHYSICAL, character, target)
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

function maxHpFormula(character) 
	return round(character.stats.constitution * 2 + (character.stats.constitution ^ (1/2)))
end

function maxMp(character) 
	return round(character.stats.intelligence * 2 + (character.stats.intelligence ^ (1/2)))
end

function round(number) 
	return math.floor(number + 0.5)
end