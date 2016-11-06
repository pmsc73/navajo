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

karna = character.new("Karna", res.karna, 6,  6)
karna.skills = {skill.berserk, skill.defend}
karna.stats = 
{
	constitution = 5,
	strength = 32,
	endurance = 5,

	agility = 4,
	dexterity = 4,
	luck = 1,

	wisdom = 2,
	intelligence = 2,
	willpower = 1,
}

karna.skillTree = {
	sb_str = {
		name = "Bonus Strength",
		description = "Gain +1 AP",
		cost = 1,
		onacquire = function()
			karna.stats.strength = karna.stats.strength + 1
		end
	}
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

alnar.skillTree = {
	sb_str = {
		name = "Bonus Strength",
		description = "Gain +1 AP",
		cost = 1,
		onacquire = function()
			alnar.stats.strength = alnar.stats.strength + 1
		end
	}

}

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

lysh.skillTree = {
	sb_str = {
		name = "Bonus Strength",
		description = "Gain +1 AP",
		cost = 1,
		onacquire = function()
			lysh.stats.strength = lysh.stats.strength + 1
		end
	}

}

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

nez.skillTree = {
	sb_str = {
		name = "Bonus Strength",
		description = "Gain +1 AP",
		cost = 1,
		onacquire = function()
			nez.stats.strength = nez.stats.strength + 1
		end
	}

}

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
	c.stats.currentAp = 1
	c.colors = {{0x00,0x00,0x00}}
	c.color = c.colors[1]
	table.insert(c.skillTree, 
		{
			name="+ 1 Red",
			description = "Gain a red",
			cost = 1,
			onacquire = function()
				if not c.colors_used then
					c.colors_used = 0

				elseif c.colors_used >= 8 then
					for n, co in ipairs(c.colors) do
						if co == c.color then
							table.remove(c.colors, n)
						end
					end
					local lc = c.color
					table.insert(c.colors, lc)
					table.insert(c.colors, {0x00, 0x00, 0x00})
					c.color = c.colors[#c.colors]
					c.colors_used = 0
				end

				c.color[1] = c.color[1] + 0x80 *  math.pow((1/2),c.colors_used)
				c.colors_used = c.colors_used + 1
			end
		}
	)
	table.insert(c.skillTree, 
		{
			name="+ 1 Green",
			description = "Gain a green",
			cost = 1,
			onacquire = function()
				if not c.colors_used then
					c.colors_used = 0

				elseif c.colors_used >= 8 then
					for n, co in ipairs(c.colors) do
						if co == c.color then
							table.remove(c.colors, n)
						end
					end
					local lc = c.color
					table.insert(c.colors, lc)
					table.insert(c.colors, {0x00, 0x00, 0x00})
					c.color = c.colors[#c.colors]
					c.colors_used = 0
				end
				c.color[2] = c.color[2] + 0x80 *  math.pow((1/2),c.colors_used)
				c.colors_used = c.colors_used + 1
			end
		}
	)
	table.insert(c.skillTree,
		{
			name="+ 1 Blue",
			description = "Gain a blue",
			cost = 1,
			onacquire = function()
				if not c.colors_used then
					c.colors_used = 0
				
				elseif c.colors_used >= 8 then
					for n, co in ipairs(c.colors) do
						if co == c.color then
							table.remove(c.colors, n)
						end
					end
					local lc = c.color
					table.insert(c.colors, lc)
					table.insert(c.colors, {0x00, 0x00, 0x00})
					c.color = c.colors[#c.colors]
					c.colors_used = 0
				end
				c.color[3] = c.color[3] + 0x80 *  math.pow((1/2),c.colors_used)
				c.colors_used = c.colors_used + 1
			end
		}
	)
	c.level = 1
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
	love.graphics.setColor(self.color)
	love.graphics.circle("line", 80, 10, 6)
	gfx.print(string.format("%6d", self.stats.currentXp), 100, 58)
	love.graphics.rectangle("fill", 100, 67, 24, 1)
	gfx.print("|", 90, 64)

	gfx.print("? " .. self.stats.currentAp, 60, 20)

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

function character:render_skills()
	for i, skill in ipairs(self.skills) do
		gfx.print(skill.name, 10, (i-1) *15 +5 )
	end
end

function character:levelUp() 
	self.stats.currentAp = self.stats.currentAp + 1
	self.level = self.level + 1
end