-- mainmenu

require 'character'
require 'graphics'
require 'battle'

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
partyComp = new(partyContent, 1, 1, 398, 225)
mapContent = {"YOU ARE HERE"}
mapComp = new(mapContent, 1, 230, 398, 65)

menu.components = {partyComp, mapComp}

menuState = {
	name = "MAINMENU",
	draw = function() 
	love.graphics.scale(2.0, 2.0)
		for i, component in ipairs(menu.components) do
			love.graphics.setColor(70,120,200)
			love.graphics.rectangle("fill", component.pos.x, component.pos.y, component.width, component.height)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", component.pos.x, component.pos.y, component.width, component.height)
			for j, sub in ipairs(component.content) do
				if sub.name ~= nil then
					local x = component.pos.x
					local y = component.pos.y
					love.graphics.print(sub.name, component.pos.x + 4, y + 4 + 32*(j-1))
					gfx.drawStatusBar(x, y + 14 + 32*(j-1), 5, 120, maxHpFormula(sub), sub.stats.currentHp, {255,0,0}, {255,255,255})
					gfx.drawStatusBar(x, y + 21 + 32*(j-1), 5, 120, maxMp(sub), sub.stats.currentMp, {0,0,255}, {255,255,255})
					gfx.drawStatusBar(x, y + 28 + 32*(j-1), 5, 120, 1, 1, {0,255,0}, {255,255,255})
				else 
					love.graphics.print(sub, component.pos.x + 4, component.pos.y + 4 + 16*j)
				end
			end
		end
	end	

}