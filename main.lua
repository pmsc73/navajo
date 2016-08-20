-- main.lua

--[[
	- This file should contain all data that is used by the states,
	- including all party member info, enemy data, etc
]]--

-- REQUIRES

require('overworld')
	-- for stateConstants

require('character')
	-- for party members: karna, alnar, lysh, nez

local current_state = overworldState
local state_changed = true

local party = {karna, alnar, lysh, nez}

--[[
	 Initial, one time load function, to get all resources and things in place
]]--
function love.load()
	
end

function love.keypressed(key, scancode, isrepeat)
	if current_state.onKeyPress ~= nil then
		current_state.onKeyPress(key)
	end
end

-- Update function gets deligated to the state object
function love.update(dt)
	if state_changed then 
		current_state.entities = current_state.init(party)
	end

	current_state.onUpdate(dt)
end

-- Draw function gets deligated to the state object
function love.draw()
	for depth, entity in ipairs(current_state.entities) do
		if entity.render ~= nil then
			entity.render()
		elseif entity.image ~= nil then
			love.graphics.draw(entity.image, entity.pos.x, entity.pos.y)
		end
	end
end