-- battlestate.lua

require 'battlemenu'
require 'battle'

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

		local battle_menu = battlemenu.init(party, party[1], get_enemies())
		table.insert(battleState.entities, battle_menu)
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
