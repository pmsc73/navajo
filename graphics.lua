gfx = {}

function gfx.drawStatusBar(x, y, height, maxWidth, maxValue, currentValue, color, border)
	local ratio = math.max(0.01, currentValue/maxValue)
	love.graphics.setColor(color)
	love.graphics.rectangle("fill", x+1,y, (maxWidth-2) * ratio, height, 2, 2)
	if border ~= nil then 
		love.graphics.setColor(border)
		love.graphics.rectangle("line", x, y, maxWidth, height, 2, 2)
	end
end