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

-- Converts HSV to RGB. (input and output range: 0 - 255)
 
function HSV(h, s, v)
	h = h % 360
    if s <= 0 then return {v,v,v} end
    h, s, v = h/360*6, s/100, v/100
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
    elseif h < 2 then r,g,b = x,c,0
    elseif h < 3 then r,g,b = 0,c,x
    elseif h < 4 then r,g,b = 0,x,c
    elseif h < 5 then r,g,b = x,0,c
    else              r,g,b = c,0,x
    end return {(r+m)*255,(g+m)*255,(b+m)*255}
end

function diff(c1, c2)
	local h1, s1, v1 = c1[1], c1[2], c1[3]
	local h2, s2, v2 = c2[1], c2[2], c2[3]

	local a, d = 1,1
	local hDiff = h2 - h1
	local sQuot = (s1 / s2)
	if hDiff < 0 then
		hDiff = 360 + hDiff
	end
	if hDiff == 180 then
		return 0
	end
	if hDiff > 180 then
		return -diff(c2, c1)
	end

	d = 3/4
	if math.abs(hDiff) > 120 and math.abs(hDiff) < 240 then
		d = 3/2
		hDiff = 180 - hDiff
	end return (sQuot) * math.sin(d * math.rad(hDiff))

end


function phys.handle_movement_input(actor, key, map, npcs)
	local newPos = {x = actor.pos.x, y = actor.pos.y}
	if key == "up" then 
		newPos.y = newPos.y - 1

	elseif key == "down" then
		newPos.y = newPos.y + 1

	elseif key == "left" then
		newPos.x = newPos.x - 1

	elseif key == "right" then
		newPos.x = newPos.x + 1

	else return false end

	if newPos.y + 1 > #map or 
		newPos.y < 0 or 
		newPos.x < 0 or 
		newPos.x + 1 > #map[newPos.y+1] 
	then
		return false
	end

	if map[newPos.y+1][newPos.x+1].tileId > 0 then
		if npcs then
			for _, npc in pairs(npcs) do
				if npc.pos.x == newPos.x and npc.pos.y == newPos.y then
					return false
				end
			end
		end

		-- else -- 
		actor.pos.x = newPos.x
		actor.pos.y = newPos.y
		if math.random() > 0.9 then
			changestate(battleState)
		end
		return true
	end


	return false
end