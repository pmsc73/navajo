
gfx = {}

BG_COLOR = {0,0,0}
FG_COLOR = {255,255,255}

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

function gfx.print(string, x, y, FG, BG)
	local col_fg = FG_COLOR
	if FG then 
		col_fg = FG
	end
	love.graphics.setColor(BG or BG_COLOR)
	love.graphics.print(string, x-1, y)

	love.graphics.setColor(FG or FG_COLOR)
	love.graphics.print(string, x, y)

	love.graphics.setColor(255,255,255)
end

function gfx.create_text_entity(text, x, y, duration, FG, BG)
	local t_ent = {}

	if not duration then
		t_ent.render = function() 
			gfx.print(text, x, y, FG, BG)
		end
		
		return t_ent
	end

	t_ent.duration = duration
	local x_offset = math.random() * 32
	local y_offset = math.random() * 32
	t_ent.render = function()
		gfx.print(text, x + x_offset, y + y_offset + (t_ent.duration), FG, BG)
	end

	table.insert(dur_entities, t_ent)
end
