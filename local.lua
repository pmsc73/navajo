-- Local Map States
require 'battle'
require 'character'

require 'state'

local map_state
map_state = function(name, map_file)
	local ents = {}
	local img = love.graphics.newImage(map_file)
	table.insert(ents, {image=img, pos={x=0, y=0}})
	table.insert(ents, karna)
	local s = state(name, ents, function(dt) return nil end)
	return s
end

local thern = map_state("THERN", 'res/test.png')



function localMapState() 
	return thern
end

