-- this file returns menu portions as entities

function menu_rectangle(x, y, w, h) 
	return {
		render = function() 
			love.graphics.setColor(70,120, 210)
			love.graphics.rectangle("fill", x, y, w, h)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", x, y, w, h)
		end
	}
end