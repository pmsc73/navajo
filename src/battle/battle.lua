-- all battle calculations go here

battleSystem = {} 

-- constants
PHYSICAL 	= "PHYSICAL"
MAGIC		= "MAGIC"
ELEM_FIRE	= "FIRE"
ELEM_WATER 	= "WATER"
ELEM_AIR	= "AIR"
ELEM_NONE	= "NON ELEMENTAL"

function battleSystem.dealDamage(t, source, target, element)
	if element == nil then element = ELEM_NONE end
	baseDamage = 0
	baseDefence = 0
	
	if t == PHYSICAL then 
		baseDamage = source.stats.strength
		baseDefence = target.stats.endurance
	elseif t == MAGIC then
		baseDamage = source.stats.intelligence
		baseDefence = target.stats.wisdom
	end
	if target.stats.currentHp == nil then
		target.stats.currentHp = maxHpFormula(target)
	end

	target.stats.currentHp = round(target.stats.currentHp - (baseDamage / baseDefence))

	if target.stats.currentHp <= 0 then
		target.dead = true
	end
end
function battleSystem.heal(character, base_modifier) 
	base_modifier = math.floor(base_modifier + 0.5)
	character.stats.currentHp = math.min(character.stats.currentHp + base_modifier, maxHpFormula(character))
end

function battleSystem.processAttack(character, target) 
	target.stats.currentHp = target.stats.currentHp - character.stats.strength
end

function maxHpFormula(character) 
	return round(character.stats.constitution * 2 + (character.stats.constitution ^ (1/2)))
end

function maxMp(character) 
	return round(character.stats.intelligence * 2 + (character.stats.intelligence ^ (1/2)))
end

function round(number) 
	return math.floor(number + 0.5)
end

battleState = {
	name = "BATTLE",

	draw = function() 

		love.graphics.scale(2.0, 2.0)
		love.graphics.draw(bg, 0,0)

		love.graphics.setColor(70,120,200)
		love.graphics.rectangle("fill", 0, 210, 400, 100)

		love.graphics.setColor(0,0,0)
		for i, char in ipairs(characters) do 
			love.graphics.print(char.name, 231, 221 + (20*(i-1)))
			local health = maxHpFormula(char)
			love.graphics.print("\\ " .. char.stats.currentHp .. " / " .. health, 261, 221 + (20*(i-1)))
			love.graphics.print("~ " .. char.stats.currentMp .. " / " .. maxMp(char), 301, 221 + (20*(i-1)))
		end
		
		love.graphics.setColor(255,255,255)
		love.graphics.rectangle("line",0,210,400, 90)
		love.graphics.rectangle("line",345,215,50,80)
		
		for i, char in ipairs(characters) do 
			love.graphics.print(char.name, 230, 220 + (20*(i-1)))
			local health = maxHpFormula(char)
			love.graphics.print("\\ " .. char.stats.currentHp .. " / " .. health, 260, 220 + (20*(i-1)))
			love.graphics.print("~ " .. char.stats.currentMp .. " / " .. maxMp(char), 300, 220 + (20*(i-1)))
		end

		love.graphics.setColor(0,0,0)
		love.graphics.print("Attack", 351, 221)
		love.graphics.print("Skill", 351, 236)
		love.graphics.print("Magic", 351, 251)
		love.graphics.print("Item", 351, 266)
		love.graphics.print("Escape", 351, 281)

		love.graphics.setColor(255,255,255)
		love.graphics.print("Attack", 350, 220)
		love.graphics.print("Skill", 350, 235)
		love.graphics.print("Magic", 350, 250)
		love.graphics.print("Item", 350, 265)
		love.graphics.print("Escape", 350, 280)
		
		for i, e in ipairs(enemies) do
			love.graphics.setColor(0,0,0)
			love.graphics.print(e.name, 26, 221 + 15*(i-1))
			love.graphics.setColor(255,255,255)
			love.graphics.print(e.name, 25, 220 + 15*(i-1))

			love.graphics.rectangle("line", 75, 221 + 15*(i-1), 60, 7, 2, 2)
			love.graphics.setColor(255,0,0) 
			love.graphics.rectangle("fill", 76, 222 + 15*(i-1), 58*(math.max(0.01,e.stats.currentHp/maxHpFormula(e))), 5, 2, 2)
		end
		love.graphics.setColor(255,255,255)

		for i, v in ipairs(entities) do
			if v.image == nil then
				if v.dim ~= nil then
					love.graphics.setColor(70,120,200)
					love.graphics.rectangle("fill", v.pos.x, v.pos.y, v.dim.w, v.dim.h)
					love.graphics.setColor(255,255,255)
					love.graphics.rectangle("line", v.pos.x, v.pos.y, v.dim.w, v.dim.h)
					for j, l in ipairs(v.selections) do
						love.graphics.print(l.name, v.pos.x + 4, v.pos.y + 4 + (15*(j-1)))
					end
				end
			else 
				love.graphics.draw(v.image, v.pos.x, v.pos.y)
			end
		end
		love.graphics.draw(arrow.image, arrow.pos.x, arrow.pos.y)
		for i, m in ipairs(menuStack) do
			love.graphics.print(m.name .. " / ", 60*(i-1), 200)
		end
	end
}