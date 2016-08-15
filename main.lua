
require 'mymenu'
require 'character'
require 'skill'
require 'images'
require 'battle'
require 'overworld'
require 'battlemenu'
require 'mainmenu'

menuStack = {}

local px,py = 100,100

function love.load()
	bg = res.background
	fn_image = love.graphics.newImage("res/font.png")
	fn_image:setFilter("nearest", "nearest")
	font = love.graphics.newImageFont(fn_image,
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
		"1234567890!@#%^&*()-_=[]{}.?/\\~"
		)
	love.graphics.setFont(font)

	characters = {}
	enemies = {}

	entities = {}
	removable = {}

	arrow = {image=res.arrow, pos={x=380,y=0}}
	table.insert(entities, arrow)

	zombie = {name = "Zombie", image=res.enemy_zombie, pos={x=10, y=20}}
	zombie.stats = {constitution = 5, endurance = 1, wisdom = 3}


	ghoul = {name = "Ghoul", image=res.enemy_ghoul, pos={x=10, y=64}}
	ghoul.stats = {constitution = 3.5, endurance = 2, wisdom = 1}

	puddle = {name = "Puddle", image=res.enemy_puddle, pos={x=10, y=108}}
	puddle.stats = {constitution = 6, endurance = 1, wisdom = 1}

	table.insert(enemies, zombie)
	table.insert(enemies, ghoul)
	table.insert(enemies, puddle)

	for _, e in pairs(enemies) do
		e.stats.currentHp = maxHpFormula(e)
	end

	table.insert(characters, karna)
	table.insert(characters, alnar)
	table.insert(characters, lysh)
	table.insert(characters, nez)

	for _, v in pairs(characters) do
		table.insert(entities, v)
	end

	for _, v in pairs(enemies) do
		table.insert(entities, v)
	end

	b_menu = battlemenu.init(characters, alnar, enemies)

	for k, v in pairs(b_menu.selections) do
		if v.name == "Skill" then
			v.callback = function() openSkillMenu(alnar) end
		end
	end

	menu = menuStack.push(b_menu)
	state = {}
	state.name = "OVERWORLD"
	state.draw = function()
		 draw_world(karna.image, px,py) 
	end
end

function openSkillMenu(char) 
	local ui_skill = {selections = {}}
	for _, v in pairs(char.skills) do
		table.insert(ui_skill.selections, v)
	end
	ui_skill.pos = {x=200, y=215}
	ui_skill.dim = {w=140, h=80}

	table.insert(entities, ui_skill)
	table.insert(removable, ui_skill)
end

function love.keypressed(key, scancode, isrepeat)
	if key=="p" and state.name=="OVERWORLD" then
		state = menuState
	end

	if key=="return" then
		if menu:getSelected().callback ~= nil then 
			menu:getSelected().callback()
		end
		-- Menu option actions happen

		-- Menu sub menu opening happens
		if menu:selectionHasSubMenu() then
			subMenu = menu:getSubMenu()
			menu = menuStack.push(subMenu)
		end

	end

	if key=="backspace" then
		for i, v in ipairs(removable) do
			for j, b in ipairs(entities) do
				if b == v then
					table.remove(entities, j)
				end
			end
			table.remove(removable, i)
		end

		if table.getn(menuStack) > 1 then
			menuStack.pop()
			menu = menuStack.peek()
		end
	end

	if key == "down" then 
		--menu:nextSelection() 
		py = py + 1
	end
	
	if key == "up" then 
		--menu:previousSelection()
		py = py - 1
	end

	if key == "right" then
		px = px + 1
	end

	if key == "left" then
		px = px - 1
	end

end

function love.update(dt)
	local selected = menu:getSelected()
	local ay = menu:getIndex()*(menu.y_increment)
	if menu.arrow_y ~= nil then
		ay = ay + menu.arrow_y
	else ay = ay + 200 end
	arrow.pos = {x = menu.arrow_x, y = ay}

	for i, e in ipairs(enemies) do
		if e.stats.currentHp <= 0 then
			e.dead = true
			menu.needs_init = true
			table.remove(enemies, i)
			for j, _e in ipairs(entities) do
				if _e == e then
					table.remove(entities, j)
				end
			end
		end
	end

	if menu.needs_init then
		menuStack.clear()
		menu = menuStack.push(battlemenu.init(characters, alnar, enemies))
	end
	
end

function love.draw()
	state.draw()
end

function menuStack.clear()
	for i, m in ipairs(menuStack) do
		table.remove(menuStack, i)
	end
end

function menuStack.peek() 
	local m = table.remove(menuStack, table.getn(menuStack))
	table.insert(menuStack, m)
	return m
end

function menuStack.pop() 
	table.remove(menuStack, table.getn(menuStack))
end

function menuStack.push(data)
	table.insert(menuStack, data)
	return data
end

function fpairs(list, criteria) 
	local o = {}
	for _, v in pairs(list) do
		if not v.criteria then
			table.insert(o, v)
		end
	end
	return pairs(o)
end