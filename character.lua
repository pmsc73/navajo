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
	o.map_pos = {x = 130, y = 130}
	setmetatable(o, character)
	return o
end

karna = character.new("Karna", res.karna, 340,  32)
karna.skills = {skill.berserk, skill.defend}
karna.stats = 
{
	constitution = 5,
	strength = 8,
	endurance = 5,

	agility = 4,
	dexterity = 4,
	luck = 1,

	wisdom = 2,
	intelligence = 2,
	willpower = 1,
}
alnar = character.new("Alnar", res.alnar, 340, 74)
alnar.skills = {skill.drain, skill.blast}
alnar.stats =
{
	constitution = 4,
	strength = 2,
	endurance = 4,

	agility = 5,
	dexterity = 3,
	luck = 2,

	wisdom = 6,
	intelligence = 7,	
	willpower = 10,
}
alnar.skills[1].use = function(enemy) 
	battleSystem.dealDamage(MAGIC, alnar, enemy)
	battleSystem.heal(alnar, alnar.stats.intelligence / enemy.stats.wisdom)
end

alnar.skills[2].use = function(enemy)
	battleSystem.dealDamage(MAGIC, alnar, enemy, ELEM_NONE)
end

lysh = character.new("Lysh",   res.lysh, 340, 116)
lysh.skills = {skill.shoot, skill.parry}
lysh.stats =
{
	constitution = 3,
	strength = 6,
	endurance = 3,

	agility = 8,
	dexterity = 9,
	luck = 4,

	wisdom = 3,
	intelligence = 3,
	willpower = 2	
}
lysh.skills[1].use = function(enemy)
	battleSystem.dealDamage(PHYSICAL, lysh, enemy)
end

nez = character.new("Nez",     res.nez, 340,158)
nez.skills = {skill.meditate, skill.nature}
nez.stats =
{
	constitution = 5,
	strength = 8,
	endurance = 10,

	agility = 6,
	dexterity = 2,
	luck = 0,

	wisdom = 8,
	intelligence = 4,
	willpower = 7
}
nez.skills[1].use = function()
	battleSystem.heal(nez, nez.stats.wisdom)
end

nez.skills[2].use = function(enemies)
	for _, enemy in pairs(enemies) do
		battleSystem.dealDamage(MAGIC, nez, enemy, ELEM_NONE)
	end
end

for _, c in pairs({karna, alnar, lysh, nez}) do
	c.equipped = 
	{
		hand = "",
		head = "",
		accessory = "",
		armor = ""

	}
	c.stats.currentHp = maxHpFormula(c)
	c.stats.currentMp = maxMp(c)
	c.stats.currentXp = 0
	c.level = math.floor(math.random() * 55)
end

function xpForLevel(char, level) 
	return math.floor((level + 100 / 4) * 3 ^ (level / 10))
end

function xpToLevel(char) 
	local xp = 0
	for i = 1, char.level do
		xp = xp + xpForLevel(char, i)
	end
	return xp
end


function character:render_status()
	
	gfx.print(self.name, 10, 10)
	love.graphics.draw(self.image, 100, 10)
	gfx.print(string.format("%6d", self.stats.currentXp), 100, 58)
	love.graphics.rectangle("fill", 100, 67, 24, 1)
	gfx.print("|", 90, 64)
	gfx.print(string.format("%6d", xpToLevel(self)), 100, 68)

	gfx.print(string.format("%s%2d", "Lv.", self.level), 60, 64)

	gfx.print(string.format("HAND: %s", ""..self.equipped.hand), 60, 85)
	gfx.print(string.format("HEAD: %s", ""..self.equipped.head), 60, 95)
	gfx.print(string.format("ACCESSORY: %s", ""..self.equipped.accessory), 60, 105)
	gfx.print(string.format("ARMOR: %s", ""..self.equipped.armor), 60, 115)


	gfx.print("STR: " .. self.stats.strength, 10, 25)
	gfx.print("CON: " .. self.stats.constitution, 10, 35)
	gfx.print("END: " .. self.stats.endurance, 10, 45)

	gfx.print("AGI: " .. self.stats.agility, 10, 55)
	gfx.print("DEX: " .. self.stats.dexterity, 10, 65)
	gfx.print("LCK: " .. self.stats.luck, 10, 75)
	
	gfx.print("WIS: " .. self.stats.wisdom, 10, 85)
	gfx.print("INT: " .. self.stats.intelligence, 10, 95)
	gfx.print("WIL: " .. self.stats.willpower, 10, 105)


end