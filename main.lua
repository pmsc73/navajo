-- main.lua

--[[
	- This file should contain all data that is used by the states,
	- including all party member info, enemy data, etc
]]--

-- REQUIRES

require('local')

require('overworld')
	-- for overworldState

require('battlestate')
	-- for battleState

require('mainmenu')
	-- for menuState

require('intromenu')
	-- for opening screen

require('character')
	-- for party members: karna, alnar, lysh, nez

require('sound')
	-- for Sound, containing all sound files
	
-- this constant is used for drawing all entities in line with tiles
TILE_SIZE = 32


current_state = intromenu_state
local state_changed = true

dur_entities = {}

onNextUpdate = function() return nil end

local party = {karna}

--[[
	 Initial, one time load function, to get all resources and things in place
]]--
function love.load()
	fn_image = love.graphics.newImage("res/font.png")
	fn_image:setFilter("nearest", "nearest")
	font = love.graphics.newImageFont(fn_image,
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
		"1234567890!@#%^&*()-_=[]{}.?/:\\~|<>;\""
		)
	love.graphics.setFont(font)

	love.window.setMode(640, 480)
end

function love.keypressed(key, scancode, isrepeat)
	if current_state.onKeyPress then
		current_state.onKeyPress(key)
	end
end

function changestate(state) 
	if not state then
		onNextUpdate = function() current_state = previous_state end
	else
		previous_state = current_state
		onNextUpdate = function() current_state = state end
	end
	dur_entities = {}
	state_changed = true
end

-- Update function gets deligated to the state object
function love.update(dt)
	onNextUpdate()
	if state_changed then 
		current_state.init(party)
		-- current_state.queue = current_state.init(party)[2]
		state_changed = false
	end

	current_state.onUpdate(dt)

end

-- Draw function gets deligated to the state object
function love.draw()
	if current_state.scale then current_state.scale() end

	for depth, entity in ipairs(current_state.entities) do
		if entity.render ~= nil then
			entity.render() 
		end 
		if entity.image ~= nil then
			love.graphics.draw(entity.image, (entity.pos.x +7  - karna.pos.x)* TILE_SIZE, (entity.pos.y +5 - karna.pos.y) * TILE_SIZE)
		end
	end

	-- d_ents are HIGHEST depth entities
	for i, d_ent in ipairs(dur_entities) do 
		if d_ent.render ~= nil then
			d_ent.render()
		end

		d_ent.duration = d_ent.duration - 1
		if d_ent.duration <= 0 then
			table.remove(dur_entities, i)
		end
	end

	if current_state.menu ~= nil then
		for _, s in pairs(current_state.menu.selections) do
			gfx.print(s, 100, 100)
		end
	end
end