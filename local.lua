-- Local Map States
require 'battle'
require 'character'
require 'images'
require 'state'

local map_state
map_state = function(name, map_file)
	local s = {}
	s.name = name
	s.onUpdate = function(dt) return nil end
	local img = map_file

	s.init = function(party) return { {{image=img, pos={x=0, y=0}}, karna} }  end
	return s
end

local thern = map_state("THERN", res.thern)



function localMapState() 
	return thern
end

