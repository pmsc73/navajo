-- battlestate.lua

require 'menu2'
require 'battlemenu'
require 'images'
require 'battle'
require 'character'

function ec_zombie()
	local zombie = {name = "Zombie", image=res.enemy_zombie, pos={x=10, y=20}}
	zombie.stats = {agility = 2, constitution = 5, endurance = 1, wisdom = 3}
	zombie.xp = 10
	return zombie
end

function ec_ghoul()
	local ghoul = {name = "Ghoul", image=res.enemy_ghoul, pos={x=10, y=64}}
	ghoul.stats = {agility = 3, constitution = 3.5, endurance = 2, wisdom = 1}
	ghoul.xp = 19
	return ghoul
end

function ec_puddle()
	local puddle = {name = "Puddle", image=res.enemy_puddle, pos={x=10, y=108}}
	puddle.stats = {agility = 1, constitution = 6, endurance = 1, wisdom = 1}
	puddle.xp = 20
	return puddle
end

local enemies_table = {}

function init_enemies()
	enemies_table = {}
	for _, e in pairs({ec_zombie(), ec_ghoul(), ec_puddle()}) do
		local instance = e
		table.insert(enemies_table, instance)
	end
end
function get_enemies() 
	local e = {}

	for _, n in pairs(enemies_table) do
		if not n.dead then
			table.insert(e, n)
		end
	end
	
	return e
end

battleState = {
	name = "BATTLE",

	init = function(party)
		battleState.entities = {}
		init_enemies()

		background = {
			image = res.background,
			pos = {x = 0, y = 0}
		}

		table.insert(battleState.entities, background)

		local m_menu = menu_rectangle(0,168, 320, 72)
		b_menubox = menu_rectangle(m_menu.w - 50, m_menu.y + 3, 45, 65)

		enemies = get_enemies()

		b_menu = battlemenu.init(party, karna, enemies, {b_menubox.x, b_menubox.y}, {3, 3}, {0, 12})

		table.insert(battleState.entities, m_menu)
		table.insert(battleState.entities, b_menubox)
		table.insert(battleState.entities, b_menu)

		for i, char in ipairs(party) do
			
			local cEntity = {}
			cEntity.pos = { x = 272, y = 10 + (i-1)*32 }
			cEntity.render = function() 
				local charline = {x = m_menu.w - 164, y = m_menu.y + 5 + (16*(i-1))}

				gfx.print(char.name, charline.x, charline.y)

				local health = maxHpFormula(char)
				gfx.print("\\ " .. char.stats.currentHp .. " / " .. health, charline.x + 25, charline.y)
				gfx.print("| " .. char.stats.currentXp, charline.x + 70, charline.y)
				love.graphics.draw(char.image, cEntity.pos.x, cEntity.pos.y)
			end

			table.insert(battleState.entities, cEntity)
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

		for _, enemy in pairs(enemies) do
			enemy.controllable = false
			table.insert(actors, enemy)
		end

		q = battleQueueInit(actors)
		table.insert(battleState.entities, q)

		--table.insert(battleState.entities, battle_menu)
	end, 

	scale = function()
		love.graphics.scale(2.0, 2.0)
	end,

	onUpdate = function(dt) 
		local available = false
		for _, e in pairs(enemies) do
			if e.dead then
				for i, ent in ipairs(battleState.entities) do
					if ent == e then
						table.remove(battleState.entities, i)
					end
				end
			else available = true end
		end
		if not available then 
			changestate()
		end
	end,

	onKeyPress = function(key)
		local next_menu = handleKeyPress(b_menu, key)
		if next_menu.complete then 
			next_menu =  battlemenu.init(party, lysh, get_enemies(), {b_menubox.x, b_menubox.y}, {3, 3}, {0, 12})
		end
		for i, v in ipairs(battleState.entities) do
			if v == b_menu then
				table.remove(battleState.entities, i)
			end
		end
		b_menu = next_menu
		table.insert(battleState.entities, b_menu)
	end
}
