-- menu object

function new_menu(selections, pos, padding, spacing)
	local menu = {}
	menu.selections = selections
	menu.selected = 1
	menu.pos = {x = pos[1], y = pos[2]}
	menu.padding = {horizontal = padding[1], vertical = padding[2]}
	menu.spacing = {horizontal = spacing[1], vertical = spacing[2]}
	menu.render = function() render(menu) end

	return menu
end


function handleUpDown(menu)
	menu.is_handlesUpDown = true
end

function handleLeftRight(menu)
	menu.is_handleLeftRight = true
end

function handleKeyPress(menu,key) 
	if key == "up" and menu.selected - 1 >= 1 then
		menu.selected = menu.selected - 1
	end

	if key == "down" and menu.selected + 1 <= #menu.selections then
		menu.selected = menu.selected + 1
	end
end


function render(menu) 
	for i, item in ipairs(menu.selections) do 
		local x = menu.pos.x + menu.padding.horizontal
		local y = menu.pos.y + menu.padding.vertical + (i-1)*menu.spacing.vertical
		gfx.print(item, x, y)

	end
	love.graphics.draw(res.arrow, menu.pos.x + 34, menu.pos.y + (menu.selected-1)*menu.spacing.vertical)
end