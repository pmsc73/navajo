-- state.lua

--[[
	- This class encapsulates the states used by the game
	- as an abstract object. Instances of state need to have
	- a provided draw() and update() function
	-
]]-- 

function state(name, entities, update)
	local s = {}
	s.name = name
	s.entities = entities

	s.init = function(party) 
		return entities
	end

	s.onKeyPress = function(key)
		return nil
	end

	s.onUpdate = update
	return s
end