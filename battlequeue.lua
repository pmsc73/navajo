-- Battle queue handler
require 'graphics'


local calculateTurns
calculateTurns = function(n, min)
	return math.floor(math.log(n/min) / math.log(2))
end

queue = {}

function nq(actor)
	table.insert(queue, actor)
end

function battleQueueInit(actors)
	local LRU = {}
	local min_agility = actors[1].stats.agility

	for i, actor in ipairs(actors) do
		if actor.stats.agility < min_agility then
			min_agility = actor.stats.agility
		end
	end
	
	for i, actor in ipairs(actors) do
		LRU[i] = actor
	end
	table.sort(LRU, function(a,b) return a.stats.agility > b.stats.agility end)

	local totalTurns = 0
	local maxTurns = 0
	for i, actor in ipairs(actors) do
		actor.turns = math.max(1, calculateTurns(actor.stats.agility, min_agility))
		maxTurns = math.max(maxTurns, actor.turns)
		totalTurns = totalTurns + actor.turns
	end
	local currentMax = maxTurns
	for i = 1, totalTurns do 
		local foundMax = false
		while((not foundMax) and currentMax > 0) do
			for j = 1, #LRU do
				if LRU[j].turns == currentMax then
					local temp = table.remove(LRU, j)
					temp.turns = temp.turns - 1

					nq(temp) 
					table.insert(LRU, temp)
					foundMax = true
					break
				end
			end
			if (not foundMax) then 
				currentMax = currentMax - 1
			end
		end

	end
	local q = {}
	q.actors = {}
	for _, actor in pairs(queue) do
		table.insert(q.actors, actor)
	end
	return q
end