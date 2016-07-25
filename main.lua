
require 'mymenu'
require 'character'
require 'skill'
require 'images'
require 'battle'

menuStack = {}


function love.load()

	fn_image = love.graphics.newImage("res/font.png")
	fn_image:setFilter("nearest", "nearest")
	font = love.graphics.newImageFont(fn_image,
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
		"1234567890!@#%^&*()-_=[]{}.?"
	)
	love.graphics.setFont(font)

	characters = {}
	enemies = {}
	entities = {}

	arrow = {image=res.arrow, pos={x=0,y=0}}
	table.insert(entities, arrow)

	zombie = {name = "Zombie", image=res.enemy_zombie, pos={x=125, y=200}}
	zombie.stats = {currentHp = 10, endurance = 1, wisdom = 3}


	ghoul = {name = "Ghoul", image=res.enemy_ghoul, pos={x=175, y=200}}
	ghoul.stats = {currentHp = 7, endurance = 2, wisdom = 1}

	table.insert(enemies, zombie)
	table.insert(enemies, ghoul)

	table.insert(characters, karna)
	table.insert(characters, alnar)
	table.insert(characters, lysh)
	table.insert(characters, nez)

	for _, v in pairs(characters) do
		table.insert(entities, v)
		for i, s in ipairs(v.skills) do
			s.pos = {x=125, y=60*(i-1)}
			local t_menu = {}


			if s.targets == "SELF" then
				-- target only self
				local _target = {}
				_target.pos = v.pos
				_target.action = function() s.use(v) end
				table.insert(t_menu, _target)
			end

			if s.targets == "SINGLE" then
				-- target a single enemy
				for _, enemy in pairs(enemies) do
					local _target = {}
					_target.pos = enemy.pos
					_target.action = function() s.use(enemy) end
					table.insert(t_menu, _target)
				end
			end
			if s.targets == "ALLY" then 
				for _, ally in pairs(characters) do
					local _target = {} 
					_target.pos = ally.pos
					_target.action = function() s.use(ally) end
					table.insert(t_menu, _target)
				end
			end
			if s.targets == "AOE" then
				local _target = {}
				_target.pos = enemies[1].pos
				_target.action = function() s.use(enemies) end
				table.insert(t_menu, _target) 

				local _target2 = {}
				_target2.pos = karna.pos
				_target2.action = function() s.use(characters) end
				table.insert(t_menu, _target2)
			end
			s.menu = mymenu.new(s.name, t_menu)
		end
		v.menu = mymenu.new(v.name, v.skills)
	end

	for _, v in pairs(enemies) do
		table.insert(entities, v)
	end

	charmenu = mymenu.new("Party", characters)
	menu = menuStack.push(charmenu)

end

function love.keypressed(key, scancode, isrepeat)
	if key=="return" then

		-- Menu option actions happen
		if menu:selectionHasAction() then
			menuStack.peek():doAction()
			menuStack.pop()
			menuStack.pop()
			menu = menuStack.peek()
		end
		-- Menu sub menu opening happens
		if menu:selectionHasSubMenu() then
			menu = menuStack.push(menu:getSubMenu())
		end
	end

	if key=="backspace" then
		if table.getn(menuStack) > 1 then
			menuStack.pop()
			menu = menuStack.peek()
		end
	end

	if key == "down" then 
		menu:nextSelection() 
	end
	
	if key == "up" then 
		menu:previousSelection()
	end

end

function love.update(dt)
	local selected = menu:getSelected()
	arrow.pos = {x = selected.pos.x + 42, y = selected.pos.y}
end

function love.draw()
	love.graphics.scale(2.4,2.4)
	for i, m in ipairs(menuStack) do
		love.graphics.print(m.name .. ">", 60*(i-1), 400)
	end

	for i, v in ipairs(entities) do
		love.graphics.draw(v.image, v.pos.x, v.pos.y)

		if v.stats ~= nil then 
			if v.stats.currentHp == nil then 
				v.stats.currentHp = maxHpFormula(v)
			end
			love.graphics.print(v.stats.currentHp, v.pos.x+30, v.pos.y)
		end
	end

	for i, skill in ipairs(charmenu:getSelected().skills) do
		love.graphics.draw(skill.image, 110, 60*(i-1) + 5)
		love.graphics.print(skill.name, 110, 60*(i-1) + 25)
		love.graphics.print(skill.description, 110, 60*(i-1) + 45)
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