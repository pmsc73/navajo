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

phys = {}

function phys.handle_movement_input(actor, key, map, npcs)
	local newPos = {x = actor.pos.x, y = actor.pos.y}
	if key == "up" then 
		newPos.y = newPos.y - 1
	end

	if key == "down" then
		newPos.y = newPos.y + 1
	end

	if key == "left" then
		newPos.x = newPos.x - 1
	end

	if key == "right" then
		newPos.x = newPos.x + 1
	end

	if newPos.y + 1 > #map.tiles or 
		newPos.y < 0 or 
		newPos.x < 0 or 
		newPos.x + 1 > #map.tiles[newPos.y+1]  
	then
		return false
	end

	if map.tiles[newPos.y+1][newPos.x+1] > 0 then
		for _, npc in pairs(npcs) do
			if npc.pos.x == newPos.x and npc.pos.y == newPos.y then
				return false
			end
		end

		-- else -- 
		actor.pos.x = newPos.x
		actor.pos.y = newPos.y
		return true
	end

	return false
end