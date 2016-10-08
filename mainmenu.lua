-- mainmenu

require 'character'
require 'graphics'
require 'battle'
require 'menu2'
require 'item'

function new(cont, posX, posY, w, h) 
	return 
	{
		content = cont,
		width = w, height = h,
		pos = {x = posX, y = posY},

		render = function() 
			love.graphics.setColor(32,32,32)
			love.graphics.rectangle("fill", posX, posY, w, h)
			love.graphics.setColor(255,255,255)
			love.graphics.rectangle("line", posX, posY, w, h)
			for i, sel in ipairs(cont) do
				local str
				if sel.name then 
					str = sel.name
				else 
					str = sel
				end
				
				gfx.print(str, posX, posY + 12*(i-1))
			end
		end,
	}
end

function mr(component) 
	return menu_rectangle(component.pos.x, component.pos.y, component.width, component.height)
end

local menu = {}

partyContent = {karna, alnar, lysh, nez}

partyComp = new(partyContent, 1, 1, 138, 200)
local _render = partyComp.render
partyComp.render = function()
	_render()
	for i, char in ipairs(partyContent) do
		gfx.print(char.name, partyComp.pos.x, partyComp.pos.y + 50 * (i-1))
		love.graphics.draw(char.image, partyComp.pos.x,10 + partyComp.pos.y + 50 * (i-1))
	end
end

local menuMenu
menuMenu = function()
	local selections = {}
	for _, sel in pairs(partyContent) do
		selection = {}
		selection.name = sel.name
		table.insert(selections, sel)

	end

	local menu = new_menu(selections, {0,0}, {3,3}, {0, 50})
	local r = menu.render
	menu.render = function() 
		menu_rectangle(1, 1, 138, 200)
		r()
	end

	menu.name = "Party"
	return menu
end

local itemMenu
itemMenu = function(inventory)
	local selections = {}
	for item, quantity in pairs(inventory) do
		selection = {}
		selection.name = item .. "   *" .. quantity
		selection.quantity = quantity
		selection.description = ITEM_DATABASE[item]
		table.insert(selections, selection)
	end

	local menu = new_menu(selections, {0,0}, {3,3}, {0,16})
	local r = menu.render
	menu.render = function() 
		menu_rectangle(1,1,138,200).render()
		gfx.print(menu.get_selected().description, 10, 170)
		r()
	end

	menu.name = "Item"
	return menu

end


menuContent = {}
table.insert(menuContent, menuMenu())

table.insert(menuContent, "Skills")

table.insert(menuContent, itemMenu({["Potion"] = 9, ["Amulet of Fear"] = 1}))

table.insert(menuContent, "Equipment")

table.insert(menuContent, "Status")

table.insert(menuContent, "Options")

menuComp = new_menu(menuContent, {140, 1}, {3, 3}, {0, 12})

mapContent = {"Pirate Ship"}
mapComp = new(mapContent, 140, 91, 59, 24)

descContent = {"Gold: 199998", "Total XP: 0"}
descComp = new(descContent, 140, 115, 59, 34)

menu.components = {partyComp, menuComp, descComp, mapComp}

menuState = {
	name = "MAINMENU",
	init = function() 
 		menuState.entities = {}
 		table.insert(menuState.entities, partyComp)
 		table.insert(menuState.entities, menuComp)
 		table.insert(menuState.entities, mapComp)
 		table.insert(menuState.entities, descComp)
 	end,
	onUpdate = function(dt) return nil end,
	scale = function() 
		love.graphics.scale(2.0, 2.0)
	end,

	onKeyPress = function(key)
		local next_menu = handleKeyPress(menuComp, key)
		if next_menu.complete then 
			next_menu =  battlemenu.init(party, lysh, get_enemies(), {b_menubox.x, b_menubox.y}, {3, 3}, {0, 12})
		end
		for i, v in ipairs(menuState.entities) do
			if v == menuComp then
				table.remove(menuState.entities, i)
			end
		end
		menuComp = next_menu
		table.insert(menuState.entities, menuComp)
	end
}