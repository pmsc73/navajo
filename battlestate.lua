-- battlestate.lua

require 'menu2'
require 'battlemenu'
require 'images'
require 'battle'
require 'character'

require 'enemy'
	-- for DB_ENEMY

local enemies_table = {}

function init_enemies()
	enemies_table = {}
	while #enemies_table < 3 do
		for _, e in pairs(DB_ENEMY) do
			if math.random() > 0.4 and #enemies_table <= 3 then
				table.insert(enemies_table, enemy_copy(e))
			end
		end
	end
end
function get_enemies() 
	local e = {}

	for i, n in ipairs(enemies_table) do
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

		b_menu = battlemenu.init(party, karna, get_enemies(), {b_menubox.x, b_menubox.y}, {3, 3}, {0, 12})

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

				love.graphics.draw(enemy.tileset, enemy.quad, 10, 10 + (32*(i-1)))
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
		local n = 0
		q.next = function() 
			if n >= #q.actors then
				n = 0
			end
			n = n+1
			if not q.actors[n].controllable then
				return q.next()
			end
			return q.actors[n]
		end
		table.insert(battleState.entities, q)

		--table.insert(battleState.entities, battle_menu)
	end, 

	scale = function()
		love.graphics.scale(2.0, 2.0)
	end,

	onUpdate = function(dt) 
		local available = false
		for _, e in pairs(get_enemies()) do
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
			next_actor = q.next()
			next_menu =  battlemenu.init(party, next_actor, get_enemies(), {b_menubox.x, b_menubox.y}, {3, 3}, {0, 12})
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
