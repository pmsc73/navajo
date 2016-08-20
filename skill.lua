require 'images'

-- Class object

skill = {} 
skill.__index = skill
-- Class methods

function skill.new(name, description, image)
	local o = {}
	o.name = name
	o.description = description
	o.image = love.graphics.newImage(image)
	setmetatable(o, skill)
	return o
end

skill.berserk = 
{
	name = "Berserk",
	description = "Increase offence, lower defence and lose control",
	image = res.berserk,
	targets = "SELF",
	use = function(character) return nil end
}

skill.defend = 
{
	name = "Defend",
	description = "Take all damage directed at an ally for one turn",
	image = res.defend,
	targets = "ALLY" ,
	use = function(ally) return nil end
}

skill.drain = 
{
	name = "Drain",
	description = "Absorb health from target",
	image = res.drain,
	targets = "SINGLE",
	use = function(enemy) return nil end
}

skill.blast = 
{
	name = "Blast",
	description = "Deal non-elemental damage to target",
	image = res.blast,
	targets = "SINGLE", 
	use = function(enemy) return nil end
}

skill.shoot = 
{
	name = "Shoot",
	description = "Deal physical damage to a target, and gain gold", "shoot.png",
	image = res.shoot,
	targets = "SINGLE"
}

skill.parry = 
{
	name = "Parry",
	description = "Counterattack if hit this turn",
	image = res.parry,
	targets = "SELF",
	use = function(enemy) return nil end
}

skill.meditate = 
{
	name = "Meditate",
	description = "Restore health and increase defence",
	image = res.meditate,
	targets = "SELF",
	use = function(character) return nil end
}

skill.nature = 
{
	name = "Nature",
	description = "Deal non-elemental damage to all targets",
	image = res.nature,
	targets = "AOE",
	use = function(targets) return nil end
}