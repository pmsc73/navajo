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
	
	--combat stats
	o.colors = {}
	o.stats = {
		str     = 1, frt = 1, con = 1,
		int = 1, wis   = 1, wll   = 1,
		dex 	 = 1, agi   = 1, edr    = 1
	}

	o.damage_modifier = 0
	o.damage_multiplier = 1
	o.defence_modifier = 0
	o.defence_multiplier = 1

	o.pos = {x = ax, y = ay}
	o.map_pos = {x = 130, y = 130}
	setmetatable(o, character)
	return o
end

karna = character.new("Karna", res.karna, 6,  6)
karna.skills = {skill.berserk, skill.defend}

karna.skillTree = {}

-- alnar = character.new("Alnar", res.alnar, 340, 74)
-- alnar.skills = {skill.drain, skill.blast}

-- alnar.skills[1].use = function(enemy) 
-- 	battleSystem.dealDamage(MAGIC, alnar, enemy)
-- 	battleSystem.heal(alnar, alnar.stats.int / enemy.stats.wis)
-- end

-- alnar.skills[2].use = function(enemy)
-- 	battleSystem.dealDamage(MAGIC, alnar, enemy, ELEM_NONE)
-- end

-- alnar.skillTree = {}

-- lysh = character.new("Lysh",   res.lysh, 340, 116)
-- lysh.skills = {skill.shoot, skill.parry}

-- lysh.skills[1].use = function(enemy)
-- 	battleSystem.dealDamage(PHYSICAL, lysh, enemy)
-- end

-- lysh.skillTree = {}

-- nez = character.new("Nez",     res.nez, 340,158)
-- nez.skills = {skill.meditate, skill.nature}

-- nez.skills[1].use = function()
-- 	battleSystem.heal(nez, nez.stats.wis)
-- end

-- nez.skills[2].use = function(enemies)
-- 	for _, enemy in pairs(enemies) do
-- 		battleSystem.dealDamage(MAGIC, nez, enemy, ELEM_NONE)
-- 	end
-- end

-- nez.skillTree = {}

for _, c in pairs({karna}) do
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
	c.stats.totalXp	  = 0
	c.stats.currentAp = 1

	c.stats.chroma = {32, 32, 32}

	c.colors = {{0,0,0}}
	c.color = c.colors[1]
	table.insert(c.skillTree, 
		{
			name="Attune: Red",
			description = "Draw upon the power of Talathir\n violent father to Raejk and Uennys",
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
			name="Attune: Green",
			description = "Draw upon the power of Vyul\n fair judge, and brother to Nezelatl",
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
			name="Attune: Blue",
			description = "Draw upon the power of Mebume\n the mother of all demands respect",
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

	table.insert(c.skillTree, {
		name = "Chromasynthesis",
		description = "Combine the essence of your two\n most used spells",
		cost = 99,
		onacquire = function() 
		end
		}
	)
	c.level = 1
end

function xpForLevel(char, level) 
	return math.floor(level ^ 2)
end

function xpToLevel(char) 
	local xp = 0
	for i = 1, char.level do
		xp = xp ^ (1+(math.log(i, 2.7182818)/i)) + xpForLevel(char, i)
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

	gfx.print("Strength: " .. self.stats.str, 10, 25)
	gfx.print("Fortitude: " .. self.stats.frt, 10, 35)
	gfx.print("Constitution: " .. self.stats.con, 10, 45)

	gfx.print("Dexterity: " .. self.stats.dex, 10, 55)
	gfx.print("Agility: " .. self.stats.agi, 10, 65)
	gfx.print("Endurance: " .. self.stats.edr, 10, 75)
	
	gfx.print("Intelligence: " .. self.stats.int, 10, 85)
	gfx.print("Wisdom: " .. self.stats.wis, 10, 95)
	gfx.print("Willpower: " .. self.stats.wll, 10, 105)

end

function character:render_skills()
	for i, skill in ipairs(self.skills) do
		gfx.print(skill.name, 10, (i-1) *15 +5)
	end
end

function character:levelUp() 
	self.stats.currentAp = self.stats.currentAp + 1
	self.level = self.level + 1
end