-- mainmenu

require 'character'
require 'graphics'
require 'battle'
require 'mymenu'

function new(cont, posX, posY, w, h) 
	return 
	{
		content = cont,
		width = w, height = h,
		pos = {x = posX, y = posY}
	}
end

local menu = {}

partyContent = {karna, alnar, lysh, nez}
partyComp = new(partyContent, 1, 1, 138, 148)

menuContent = {"Party", "Skills", "Items", "Equipment", "Status", "Options"}
menuComp = new(menuContent, 140, 1, 59, 90)

mapContent = {"Pirate Ship"}
mapComp = new(mapContent, 140, 91, 59, 24)

descContent = {"Gold: 199998", "Total XP: 0"}
descComp = new(descContent, 140, 115, 59, 34)

menu.components = {partyComp, menuComp, descComp, mapComp}

menuState = {
	name = "MAINMENU",
	draw = function() 
		love.graphics.scale(4.0, 4.0)
		for i, component in ipairs(menu.components) do
			love.graphics.setColor(70,120,200)
			love.graphics.rectangle("fill", component.pos.x, component.pos.y, component.width, component.height)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", component.pos.x, component.pos.y, component.width, component.height)
			for j, sub in ipairs(component.content) do

				local x = component.pos.x
				local y = component.pos.y + 3 + ((j-1)*component.height / table.getn(component.content))
				if sub.name ~= nil then
					gfx.print(sub.name, component.pos.x + 4, y)
					gfx.print("LV " .. sub.level, component.pos.x + 74, y)

					love.graphics.draw(sub.skills[1].image, x + 5, y + 12)

					gfx.print("\\ " .. sub.stats.currentHp .. " / " .. maxHpFormula(sub), x + 28, y + 12)
					gfx.print("~ " ..  sub.stats.currentMp .. " / " .. maxMp(sub),		x + 28, y + 21)
					gfx.print("| " .. sub.stats.currentXp .. " / " .. xpToLevel(sub),		x + 74, y + 12)

					love.graphics.draw(arrow.image, arrow.pos.x, arrow.pos.y)
					-- love.graphics.print("   <    ", x + 120, y)
					-- love.graphics.print("STR: " .. sub.stats.strength, x + 120, y + 14)
					-- love.graphics.print("END: " .. sub.stats.endurance, x + 120, y + 28)
					-- love.graphics.print("CON: " .. sub.stats.constitution, x + 120, y + 42)

					-- love.graphics.print("   ;    ", x + 160, y)
					-- love.graphics.print("DEX: " .. sub.stats.dexterity, x + 160, y + 14)
					-- love.graphics.print("AGI: " .. sub.stats.agility, x + 160, y + 28)
					-- love.graphics.print("LCK: " .. sub.stats.luck, x + 160, y + 42)

					-- love.graphics.print("   >    ", x + 200, y)
					-- love.graphics.print("INT: " .. sub.stats.intelligence, x + 200, y + 14)
					-- love.graphics.print("WIS: " .. sub.stats.wisdom, x + 200, y + 28)
					-- love.graphics.print("WLL: " .. sub.stats.willpower, x + 200, y + 42)



					-- gfx.drawStatusBar(x, y + 14, 5, 120, maxHpFormula(sub), sub.stats.currentHp, {255,0,0}, {255,255,255})
					-- gfx.drawStatusBar(x, y + 21, 5, 120, maxMp(sub), sub.stats.currentMp, {0,0,255}, {255,255,255})
					-- gfx.drawStatusBar(x, y + 28, 5, 120, 1, 1, {0,255,0}, {255,255,255})
				else 
					gfx.print(sub, x + 4, y)
				end
			end
		end
	end	

}