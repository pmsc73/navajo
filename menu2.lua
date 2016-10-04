-- menu object

function new_menu(selections, pos, padding, spacing)
	local menu = {}
	menu.selections = selections
	menu.selected = 1
	menu.pos = {x = pos[1], y = pos[2]}
	menu.padding = {horizontal = padding[1], vertical = padding[2]}
	menu.spacing = {horizontal = spacing[1], vertical = spacing[2]}
	menu.render = function()
		render(menu) 
	end

	return menu
end


function handleKeyPress(menu, key) 
	if key == "up" and menu.selected - 1 >= 1 then
		menu.selected = menu.selected - 1
	end

	if key == "down" and menu.selected + 1 <= #menu.selections then
		menu.selected = menu.selected + 1
	end

	if key == "return"  then 
		if menu.selections[menu.selected].action then
			menu.selections[menu.selected].action() 
			r = menu
			while (r.previous) do
				r = r.previous
			end
			r.complete = true
			return r
		end
		
		if menu.selections[menu.selected].selections then
			menu.selections[menu.selected].previous = menu
			return menu.selections[menu.selected]
		end
	end

	if key == "backspace" and menu.previous then
		return menu.previous
	end

	return menu
end


function render(menu) 
	for i, item in ipairs(menu.selections) do 
		local x = menu.pos.x + menu.padding.horizontal
		local y = menu.pos.y + menu.padding.vertical + (i-1)*menu.spacing.vertical
		if item.name then
			gfx.print(item.name, x, y)
		else gfx.print(item, x, y)
		end
	end
	-- if menu.previous then 
		love.graphics.draw(res.arrow, menu.pos.x + 34, -1 + menu.pos.y + (menu.selected-1)*menu.spacing.vertical)
	-- end
end