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
	end
end

function battleSystem.heal(character, base_modifier) 
	base_modifier = math.floor(base_modifier + 0.5)
	character.stats.currentHp = math.min(character.stats.currentHp + base_modifier, maxHpFormula(character))
end

function battleSystem.processAttack(character, target) 
	target.stats.currentHp = target.stats.currentHp - character.stats.strength
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

function get_enemies() 
	zombie = {name = "Zombie", image=res.enemy_zombie, pos={x=10, y=20}}
	zombie.stats = {agility = 2, constitution = 5, endurance = 1, wisdom = 3}

	ghoul = {name = "Ghoul", image=res.enemy_ghoul, pos={x=10, y=64}}
	ghoul.stats = {agility = 3, constitution = 3.5, endurance = 2, wisdom = 1}

	puddle = {name = "Puddle", image=res.enemy_puddle, pos={x=10, y=108}}
	puddle.stats = {agility = 1, constitution = 6, endurance = 1, wisdom = 1}

	return {zombie, ghoul, puddle}
end

battleState = {
	name = "BATTLE",

	init = function(party)
		battleState.entities = {}

		background = {
			image = res.background,
			pos = {x = 0, y = 0}
		}

		table.insert(battleState.entities, background)

		local m_menu = menu_rectangle(0,210, 400, 100)
		table.insert(battleState.entities, m_menu)

		for i, char in ipairs(party) do
			char.pos = { x = 340, y = 32 + (i-1)*42 }

			char.render = function() 
				gfx.print(char.name, 231, 221 + (20*(i-1)))
				local health = maxHpFormula(char)
				gfx.print("\\ " .. char.stats.currentHp .. " / " .. health, 261, 221 + (20*(i-1)))
				gfx.print("~ " .. char.stats.currentMp .. " / " .. maxMp(char), 301, 221 + (20*(i-1)))
				love.graphics.draw(char.image, char.pos.x, char.pos.y)
			end

			table.insert(battleState.entities, char)
		end

		for i, enemy in ipairs(get_enemies()) do
			enemy.render = function() 
				gfx.print(enemy.name, 25, 220 + 15*(i-1))
				if enemy.stats.currentHp == nil then
					enemy.stats.currentHp = maxHpFormula(enemy)
				end
				gfx.drawStatusBar(75,221 + 15*(i-1), 7, 60, maxHpFormula(enemy), enemy.stats.currentHp, {255,0,0}, {255, 255, 255})

				love.graphics.draw(enemy.image, enemy.pos.x, enemy.pos.y)
			end


			table.insert(battleState.entities, enemy)
		end

		local o_menu = menu_rectangle(345,215,50,80)
		table.insert(battleState.entities, o_menu)

		local actors = {}
		for _, char in pairs(party) do
			char.controllable = true
			table.insert(actors, char)
		end

		for _, enemy in pairs(get_enemies()) do
			enemy.controllable = false
			table.insert(actors, enemy)
		end

		q = battleQueueInit(actors)
		table.insert(battleState.entities, q)
	end, 

	scale = function()
		love.graphics.scale(1.6, 1.6)
	end,

	onUpdate = function(dt) 
		-- DO UPDATE STUFF
	end,

	onKeyPress = function(key) 
		-- HANDLE KEY PRESSES
	end
}