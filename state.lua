-- state.lua

--[[
	- This class encapsulates the states used by the game
	- as an abstract object. Instances of state need to have
	- a provided draw() and update() function
	-
]]-- 


require('overworld')
	-- for overworldState

require('mainmenu')
	-- for menuState

require('battle')
	-- for battleState

local function state(name, entities, update)
	local s = {}
	s.name = name
	
	s.draw = function() 
		for depth, entity in ipairs(entities) do
			entity.render()
		end
	end
	
	s.update = update
	return s
end

-- List of states

stateConstants = {}
stateConstants.OVERWORLD = overworldState
stateConstants.BATTLE = battleState
stateConstants.MENU = menuStateo