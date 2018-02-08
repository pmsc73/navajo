require 'images'
require 'skill'
require 'battle'
require 'enemy'
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
	o.cross_damage_modifier = {}
	o.cross_damage_multiplier = {}
	o.cross_defence_modifier = {}
	o.cross_defence_multiplier = {}

	o.pos = {x = ax, y = ay}
	o.map_pos = {x = 130, y = 130}
	setmetatable(o, character)
	return o
end

karna = character.new("Karna", res.karna, 6,  6)
karna.skills = {skill.berserk, skill.defend}

karna.skillTree = {}
karna.tasks = {}

function init_log() 
	local log = {}

	for i, enemy in ipairs(DB_ENEMY) do
		local name = enemy.name
		log[name] = {
			damage = 0,
			kills = 0
		}
		karna.cross_damage_modifier[name] = 0
		karna.cross_damage_multiplier[name] = 1
		karna.tasks[name] = 
		{
			{
				goal = 1,
				current = 0,
				oncomplete = function() 
					karna.cross_damage_multiplier[name] = karna.cross_damage_multiplier[name] * 1.1
				end,
				goalScale = 10,
				rewardScale = 1
			},
			{
				goal = 10,
				current = 0,
				oncomplete = function()
					karna.cross_damage_modifier[name] = karna.cross_damage_modifier[name] + 1
				end,
				goalScale = 5,
				rewardScale = 1
			}
		}
		for i, task in ipairs(karna.tasks[name]) do 

			task.update = function(delta)
				task.current = task.current + delta
				if task.current >= task.goal then
					task.oncomplete()
					if task.goalScale > 0 then
						task.goal = task.goal * task.goalScale
					end
				end
			end
		end

	end
	return log
end

karna.log = init_log()

function logDamage(name, d) 
	local dmg = karna.log[name].damage
	karna.log[name].damage = dmg + d
	karna.tasks[name][2].update(d)

end

function getDamage(name)
	return karna.log[name].damage
end

function logDeath(name)
	if name ~= "Karna" then
		local lkills = karna.log[name].kills
		karna.log[name].kills = lkills + 1
		karna.tasks[name][1].update(1)
	end
end

function getKills(name)
	return karna.log[name].kills
end

function battlelog() 
	return karna.log
end

local attuneSpell
attuneSpell = function(c, spellName, desc, primary_color)
	return {
		name=spellName,
		description = desc,
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

			c.color[primary_color] = c.color[primary_color] + 0x80 *  math.pow((1/2),c.colors_used)
			c.colors_used = c.colors_used + 1
		end
	}
end

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
		attuneSpell(c, "Attune: Red", "Draw upon the power of Talathir\n violent father to Raejk and Uennys", 1)
	)
	table.insert(c.skillTree, 
		attuneSpell(c, "Attune: Green", "Draw upon the power of Vyul\n fair judge, and brother to Nezelatl", 2)
	)
	table.insert(c.skillTree,
		attuneSpell(c, "Attune: Blue", "Draw upon the power of Mebume\n the mother of all demands respect", 3)
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
	love.graphics.draw(self.image, 5, 5)
	love.graphics.setColor(self.color)
	love.graphics.circle("line", 80, 10, 6)
	gfx.print(string.format("%6d", self.stats.currentXp), 10, 58)
	love.graphics.rectangle("fill", 100, 67, 24, 1)
	gfx.print("|", 9, 64)

	gfx.print("? " .. self.stats.currentAp, 10, 20)

	gfx.print(string.format("%6d", xpToLevel(self)), 10, 68)

	gfx.print(string.format("%s%2d", "Lv.", self.level), 10, 64)

	-- gfx.print(string.format("HAND: %s", ""..self.equipped.hand), 60, 85)
	-- gfx.print(string.format("HEAD: %s", ""..self.equipped.head), 60, 95)
	-- gfx.print(string.format("ACCESSORY: %s", ""..self.equipped.accessory), 60, 105)
	-- gfx.print(string.format("ARMOR: %s", ""..self.equipped.armor), 60, 115)

	gfx.print(string.format("%-5s %2d", "STR:", self.stats.str), 40, 25)
	gfx.print(string.format("%-5s %2d", "FRT:", self.stats.frt), 40, 34)
	gfx.print(string.format("%-5s %2d", "CON:", self.stats.con), 40, 43)

	gfx.print(string.format("%-5s %2d", "DEX:", self.stats.dex), 40, 52)
	gfx.print(string.format("%-5s %2d", "AGI:", self.stats.agi), 40, 61)
	gfx.print(string.format("%-5s %2d", "END:", self.stats.edr), 40, 70)
	
	gfx.print(string.format("%-5s %2d", "INT:", self.stats.int), 40, 79)
	gfx.print(string.format("%-5s %2d", "WIS:",  self.stats.wis), 40, 88)
	gfx.print(string.format("%-5s %2d", "WILL:", self.stats.wll), 40, 97)

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