-- menu object

function new_menu(selections, pos, padding, spacing, a_offset)
	local menu = {}
	menu.selections = selections
	menu.selected = 1
	menu.pos = {x = pos[1], y = pos[2]}
	menu.padding = {horizontal = padding[1], vertical = padding[2]}
	menu.spacing = {horizontal = spacing[1], vertical = spacing[2]}
	menu.render = function()
		render(menu) 
	end

	menu.get_selected = function() 
		return menu.selections[menu.selected]
	end

	if a_offset == nil then
		menu.arrow_offset = 34
	else
		menu.arrow_offset = a_offset
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
		if menu.get_selected().action then
			menu.get_selected().action() 
			r = menu
			while (r.previous) do
				r = r.previous
			end
			r.complete = true
			return r
		end
		
		if menu.get_selected().selections then
			menu.get_selected().previous = menu
			return menu.get_selected()
		end
	end

	if key == "backspace" and menu.previous then
		return menu.previous
	end

	if menu.get_selected().scrolls then
		if key == "left" or key == "right" then
			menu.get_selected().handleSideScroll(key)
		end
	end
	return menu
end

function render(menu, current)
	if current == nil then
		current = true
	end
	if menu.previous and menu.previous.persists then
		render(menu.previous, false)
	end
	for i, item in ipairs(menu.selections) do 
		local x = menu.pos.x + menu.padding.horizontal
		local y = menu.pos.y + menu.padding.vertical + (i-1)*menu.spacing.vertical
		if item.s_render then
			item.s_render()
		end 
		if item.name then
			gfx.print(item.name, x, y)
		else gfx.print(item, x, y)

		end
	end
	if current == true then 
		love.graphics.draw(res.arrow, menu.pos.x + menu.arrow_offset, -1 + menu.pos.y + (menu.selected-1)*menu.spacing.vertical)
	end
end
