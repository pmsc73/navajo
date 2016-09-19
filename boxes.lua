-- this file returns menu portions as entities

function menu_rectangle(x, y, w, h) 
	return {
		x = x,
		y = y,
		w = w,
		h = h,
		render = function() 
			love.graphics.setColor(32,32,32)
			love.graphics.rectangle("fill", x, y, w, h)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", x, y, w, h)
		end
	}
end