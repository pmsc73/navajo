-- Local Map States

require 'mapdata'
require 'battle'
require 'character'
require 'images'
require 'state'

local tiles = love.graphics.newImage("res/tileset.png")

local NPC_dialogues = {
	{"I've got the best cabbages"},
	{"Would you like a cabbage?"},
	{"Get away from my cabbages"}
}

local testNPC = {
	pos = {x = 6, y = 0},
	image = res.enemy_zombie,
	dialogue = NPC_dialogues
}

local testNPC2 = {
	pos = {x = 2, y = 2},
	image = res.enemy_puddle,
	dialogue = {"Puddles don't talk!"}
}

local npc_entities = {testNPC, testNPC2}

for _, npc in pairs(npc_entities) do
	npc.render = function() 
		love.graphics.draw(npc.image, npc.pos.x*32, npc.pos.y*32)
	end
end

local map_state
map_state = function(name, map_file, map_data)
	local s = {}
	s.name = name
	s.entities = {}
	s.onUpdate = function(dt) return nil end
	local img = map_file

	s.init = function(party)

		karna.pos.x = 0
		karna.pos.y = 0


		for _, drawable in pairs(getDrawable(map_data, tiles)) do
			table.insert(s.entities, drawable)
		end

		table.insert(s.entities, {image=img, pos={x=0, y=0}})
		table.insert(s.entities, karna)
		table.insert(s.entities, testNPC)
		table.insert(s.entities, testNPC2)
	end
	
	s.current_dialogue = 1

	local hasMoved = false
	s.onKeyPress = function(key) 
		local x,y = karna.pos.x, karna.pos.y
		if key == "return" then
			if hasMoved then s.current_dialogue = 1 end
			if findNearestNPC(karna) ~= nil then
				local npc = findNearestNPC(karna)
				table.insert(s.entities, textEntity(npc.dialogue[s.current_dialogue], 64, 64 + 12*s.current_dialogue))
				s.current_dialogue = s.current_dialogue + 1
				hasMoved = false
			end
		end
		if key == "up" then karna.pos.y = karna.pos.y - 32 end
		if key == "down" then karna.pos.y = karna.pos.y + 32 end
		if key == "left" then karna.pos.x = karna.pos.x - 32 end
		if key == "right" then karna.pos.x = karna.pos.x + 32 end

		if x ~= karna.pos.x or y ~= karna.pos.y then
			hasMoved = true
		end

	end
	return s
end

local kitala = map_state("KITALA", res.kitala, mapdata.kitala)

function findNearestNPC(char)
	for _, npc in pairs(npc_entities) do
		local distance = math.sqrt((npc.pos.x - char.pos.x) ^ 2 + (npc.pos.y - char.pos.y) ^ 2)
		if distance <= 40 then
			return npc
		end
	end
end

function textEntity(text, x, y)
	return {render = function() gfx.print(text, x, y) end}
end

function localMapState() 
	return kitala
end

