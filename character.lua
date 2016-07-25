require 'images'
require 'skill'
require 'battle'
-- Character Entity

character = {} 
character.__index = character

-- Constructor
function character.new(name, image, ax, ay) 
	local o = {} 
	o.name = name
	o.image = image
	o.pos = {x = ax, y = ay}
	setmetatable(o, character)
	return o
end

karna = character.new("Karna", res.karna, 0,  0)
karna.skills = {skill.berserk, skill.defend}
karna.stats = 
{
	constitution = 5,
	strength = 8,
	endurance = 5,
	agility = 4,
	wisdom = 2,
	intelligence = 2	
}

alnar = character.new("Alnar", res.alnar, 0, 42)
alnar.skills = {skill.drain, skill.blast}
alnar.stats =
{
	constitution = 4,
	strength = 2,
	endurance = 4,
	agility = 5,
	wisdom = 6,
	intelligence = 7,	
}
alnar.skills[1].use = function(enemy) 
	battleSystem.dealDamage(MAGIC, alnar, enemy)
	battleSystem.heal(alnar, alnar.stats.intelligence / enemy.stats.wisdom)
end

alnar.skills[2].use = function(enemy)
	battleSystem.dealDamage(MAGIC, alnar, enemy, ELEM_NONE)
end

lysh = character.new("Lysh",   res.lysh, 0, 84)
lysh.skills = {skill.shoot, skill.parry}
lysh.stats =
{
	constitution = 3,
	strength = 6,
	endurance = 3,
	agility = 8,
	wisdom = 3,
	intelligence = 3	
}
lysh.skills[1].use = function(enemy)
	battleSystem.dealDamage(PHYSICAL, lysh, enemy)
end

nez = character.new("Nez",     res.nez, 0,126)
nez.skills = {skill.meditate, skill.nature}
nez.stats =
{
	constitution = 5,
	strength = 15,
	endurance = 10,
	agility = 6,
	wisdom = 8,
	intelligence = 4
}
nez.skills[1].use = function()
	battleSystem.heal(nez, nez.stats.wisdom)
end

nez.skills[2].use = function(enemies)
	for _, enemy in pairs(enemies) do
		battleSystem.dealDamage(MAGIC, nez, enemy, ELEM_NONE)
	end
end