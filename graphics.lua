
gfx = {}

local BG_COLOR = {0,0,0}
local FG_COLOR = {255,255,255}

function gfx.drawStatusBar(x, y, height, maxWidth, maxValue, currentValue, color, border)
	local ratio = math.max(0.01, currentValue/maxValue)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", x+1,y, (maxWidth-2) * ratio, height, 2, 2)
	if border ~= nil then 
		love.graphics.setColor(border)
		love.graphics.rectangle("line", x, y, maxWidth, height, 2, 2)
	end

	love.graphics.setColor(255,255,255)
end

function gfx.print(string, x, y)
	love.graphics.setColor(BG_COLOR)
	love.graphics.print(string, x-1, y)

	love.graphics.setColor(FG_COLOR)
	love.graphics.print(string, x, y)
end