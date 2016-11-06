-- Local Map States

require 'mapdata'
require 'battle'
require 'character'
require 'images'
require 'state'
require 'mainmenu'

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

local map_state
map_state = function(name, map_file, map_data)
	local s = {}
	s.name = name
	s.entities = {}
	s.tiles = {}
	s.onUpdate = function(dt) return nil end
	local img = map_file
	
	s.init = function(party)

		for _, drawable in pairs(getDrawable(karna, map_data, tiles)) do
			table.insert(s.tiles, drawable)
		end


		for _, tile in pairs(s.tiles) do 
			table.insert(s.entities, tile)
		end
		table.insert(s.entities, {image=img, pos={x=0, y=0}})
		table.insert(s.entities, karna)
		table.insert(s.entities, testNPC)
		table.insert(s.entities, testNPC2)
	end
	
	s.current_dialogue = 1

	local hasMoved = false
	s.onKeyPress = function(key) 
		if key == "return" then
			if hasMoved then s.current_dialogue = 1 end
			if findNearestNPC(karna) ~= nil then
				local npc = findNearestNPC(karna)
				table.insert(s.entities, textEntity(npc.dialogue[s.current_dialogue], npc.pos.x*32 + 40, npc.pos.y*32 + 10 + 12*s.current_dialogue))
				s.current_dialogue = s.current_dialogue + 1
				hasMoved = false
			end
		end
		
		hasMoved = phys.handle_movement_input(karna, key, map_data, npc_entities)

		if key == "p" then
			changestate(menuState)
		end
	end
	s.scale = function()
		love.graphics.scale(1.25, 1.25)
	end
	return s
end

kitala = map_state("KITALA", res.kitala, mapdata.kitala)

function findNearestNPC(char)
	for _, npc in pairs(npc_entities) do
		local distance = math.sqrt( (npc.pos.x - char.pos.x) ^ 2 + (npc.pos.y - char.pos.y) ^ 2)
		if distance <= 1 then
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