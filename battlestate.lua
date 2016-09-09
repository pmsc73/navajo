-- battlestate.lua

require 'menu2'
require 'battlemenu'
require 'images'
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

		local m_menu = menu_rectangle(0,168, 320, 72)
		local b_menubox = menu_rectangle(m_menu.w - 50, m_menu.y + 3, 45, 65)

		b_menuitems = {"ATTACK", "SKILL", "MAGIC", "ITEM", "ESCAPE"}
		
		b_menu = new_menu(
			b_menuitems, 
			{b_menubox.x, b_menubox.y},
			{3, 3},
			{0, 12}
		)
		handleUpDown(b_menu)

		table.insert(battleState.entities, m_menu)
		table.insert(battleState.entities, b_menubox)
		table.insert(battleState.entities, b_menu)

		for i, char in ipairs(party) do
			char.pos = { x = 272, y = 10 + (i-1)*32 }

			char.render = function() 
				local charline = {x = m_menu.w - 164, y = m_menu.y + 5 + (16*(i-1))}

				gfx.print(char.name, charline.x, charline.y)

				local health = maxHpFormula(char)
				gfx.print("\\ " .. char.stats.currentHp .. " / " .. health, charline.x + 25, charline.y)
				gfx.print("~ " .. char.stats.currentMp .. " / " .. maxMp(char), charline.x + 70, charline.y)
				love.graphics.draw(char.image, char.pos.x, char.pos.y)
			end

			table.insert(battleState.entities, char)
		end

		for i, enemy in ipairs(get_enemies()) do
			enemy.render = function() 
				local charline = {x = m_menu.x + 7, y = m_menu.y + 5 + (16*(i-1))}

				gfx.print(enemy.name, charline.x, charline.y)
				if enemy.stats.currentHp == nil then
					enemy.stats.currentHp = maxHpFormula(enemy)
				end
				gfx.drawStatusBar(charline.x + 35, charline.y, 7, 60, maxHpFormula(enemy), enemy.stats.currentHp, {255,0,0}, {255, 255, 255})

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
		love.graphics.scale(2.0, 2.0)
	end,

	onUpdate = function(dt) 
		-- DO UPDATE STUFF
	end,

	onKeyPress = function(key) 
		handleKeyPress(b_menu, key)
	end
}
