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

require('character')
	-- for party members: karna, alnar, lysh, nez

-- this constant is used for drawing all entities in line with tiles
TILE_SIZE = 32


local current_state = battleState
state_changed = true
onNextUpdate = function() return nil end

local party = {karna, alnar, lysh, nez}

--[[
	 Initial, one time load function, to get all resources and things in place
]]--
function love.load()
	fn_image = love.graphics.newImage("res/font.png")
	fn_image:setFilter("nearest", "nearest")
	font = love.graphics.newImageFont(fn_image,
		" abcdefghijklmnopqrstuvwxyz" ..
		"ABCDEFGHIJKLMNOPQRSTUVWXYZ" ..
		"1234567890!@#%^&*()-_=[]{}.?/:\\~|<>;"
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
	onNextUpdate = function() current_state = state end
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
		elseif entity.image ~= nil then
			love.graphics.draw(entity.image, (entity.pos.x +7  - karna.pos.x)* TILE_SIZE, (entity.pos.y +5 - karna.pos.y) * TILE_SIZE)
		end
	end
	if current_state.menu ~= nil then
		for _, s in pairs(current_state.menu.selections) do
			gfx.print(s, 100, 100)
		end
	end
end