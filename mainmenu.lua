-- mainmenu

require 'character'
require 'graphics'
require 'battle'
require 'menu2'
require 'item'
require 'images'
require 'state'


function itemSubMenu(item)
	local selections = {}

	local useOption = {}
	useOption.name = "USE"
	useOption.action = function()
		if ITEM_DATABASE[item].onUse then 
			ITEM_DATABASE[item].onUse(partyContent)
		end
	end

	if ITEM_DATABASE[item].onUse then 
		table.insert(selections, useOption)
	end

	local equipOption = {}
	equipOption.name = "EQUIP"
	equipOption.action = function() 
		if ITEM_DATABASE[item]["equip"]then 
			karna.equipped.accessory = item
		end
	end

	local cus_selections = {}
	for i, color in ipairs({{255,0,0}, {0,255,0}, {0,0,255}}) do
		local selection = {}
		selection.name = i
		selection.scrolls = true
		local bar = {
			pos = { x = 4, y = 12*(i-1) + 4},
			dim = { w = 100, h = 5 },
			val = 5
		}
		selection.render = function() 
			gfx.drawStatusBar(bar.pos.x, bar.pos.y,
								bar.dim.h, bar.dim.w, 
								10, bar.val, color, {0,0,0})
		end
		selection.handeSideScroll = function(key)
			if key == "left" then bar.val = bar.val - 1 end
			if key == "right" then bar.val = bar.val + 1 end
		end


		table.insert(cus_selections, selection)
	end

	local customOption = new_menu(cus_selections, {4,4}, {3,3}, {0,12})
	customOption.name = "CUSTOMIZE"


	if ITEM_DATABASE[item]["equip"] then table.insert(selections, equipOption) end
	if ITEM_DATABASE[item].customMenu then table.insert(selections, customOption) end
	
	table.insert(selections, "DISCARD")

	local posx = 70
	local posy = 25
	return new_menu(selections, {posx, posy}, {3,3}, {0,12})
end

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
		end,
	}
end

function mr(component) 
	return menu_rectangle(component.pos.x, component.pos.y, component.width, component.height)
end

local menu = {}

partyContent = {karna, alnar, lysh, nez}

partyComp = new(partyContent, 1, 1, 138, 200)

local menuMenu
menuMenu = function()
	local selections = {}
	for _, sel in pairs(partyContent) do
		selection = new_menu({""}, {0,0}, {3,3}, {0,16})
		selection.render = function() 
			sel:render_status()
		end
		selection.name = ""
		table.insert(selections, selection)

	end

	local menu = new_menu(selections, {0,0}, {3,3}, {0, 50})
	local r = menu.render
	menu.render = function() 
		r()
		for i, char in ipairs(partyContent) do
			love.graphics.draw(res.c_wheel, partyComp.pos.x + 40, 3 + partyComp.pos.y + 50 * (i-1))
			gfx.print(#char.colors, partyComp.pos.x + 46, 6 + partyComp.pos.y + 50 *(i-1))
			for n, col in ipairs(char.colors) do
				love.graphics.setColor(col)
				love.graphics.circle("line", partyComp.pos.x + 66 + (14*(n-1)), 10 + partyComp.pos.y + 50 * (i-1), 6)
			end
			gfx.print(char.name, partyComp.pos.x, partyComp.pos.y + 50 * (i-1))
			love.graphics.draw(char.image, partyComp.pos.x,10 + partyComp.pos.y + 50 * (i-1))
			
			local x = partyComp.pos.x + 45
			local y = 10 + partyComp.pos.y + 50 * (i-1)
			
			gfx.print("\\", x-8, y+7)
			gfx.drawStatusBar(x, y + 9, 4, 60, maxHpFormula(char), char.stats.currentHp, {255, 0, 0}, {0,0,0})
			
			gfx.print("~", x-8, y+15)
			gfx.drawStatusBar(x, y + 17, 4, 60, maxMp(char), char.stats.currentMp, {32, 160, 255}, {0,0,0})
			
			gfx.print("|", x-8, y + 23)
			gfx.drawStatusBar(x, y + 25, 4, 60, xpToLevel(char), char.stats.currentXp, {255, 255, 0}, {0,0,0})
		end
	end
	menu.name = "Party"
	return menu
end

local skillsMenu
skillsMenu = function()
	local selections = {}
	for _, sel in pairs(partyContent) do
		selection = new_menu({""}, {0,0}, {3,3}, {0,16})
		selection.render = function() 
			sel:render_skills()
			gfx.print("!!!!!!!!", 10,10)
		end	
		local SKILLS = {}
		for _, SKILL in pairs(sel.skillTree) do
			local s = {
				name = SKILL.name .. "   " .. "? " .. SKILL.cost, 
				action = function()
					SKILL.onacquire()
					sel.stats.currentAp = sel.stats.currentAp - SKILL.cost
				end
			}
			table.insert(SKILLS, s)
		end
			
		selection = new_menu(SKILLS, {0,0}, {3,3}, {0,15})
		selection.name = ""
		table.insert(selections, selection)
	end

	local menu = new_menu(selections, {0,0}, {3,3}, {0, 50})
	local r = menu.render
	menu.render = function()
		r()
		for i, char in ipairs(partyContent) do

			for j, col in ipairs(char.colors) do
				gfx.print(string.format("%d",col[1]) .. string.format(" %d",col[2]) .. string.format(" %d",col[3]),
				 partyComp.pos.x + 60, 5 + partyComp.pos.y + 12 * (j-1) + 50*(i-1)
				)

				love.graphics.setColor(col)
				love.graphics.circle("line", partyComp.pos.x + 50, 8 + partyComp.pos.y + 12 * (j-1) + 50*(i-1), 6)
			end
			

			gfx.print(char.name, partyComp.pos.x,partyComp.pos.y + 50 * (i-1))
			love.graphics.draw(char.image, partyComp.pos.x,10 + partyComp.pos.y + 50 * (i-1))
			
			local x = partyComp.pos.x + 45
			local y = 10 + partyComp.pos.y + 50 * (i-1)
			
			-- gfx.print("\\", x-8, y+3)
			-- gfx.drawStatusBar(x, y + 5, 4, 60, maxHpFormula(char), char.stats.currentHp, {255, 0, 0}, {0,0,0})
			
			-- gfx.print("~", x-8, y+13)
			-- gfx.drawStatusBar(x, y + 15, 4, 60, maxMp(char), char.stats.currentMp, {32, 160, 255}, {0,0,0})
			
			gfx.print("|", x-8, y + 23)
			gfx.drawStatusBar(x, y + 25, 4, 60, xpToLevel(char), char.stats.currentXp, {255, 255, 0}, {0,0,0})
		end
	end
	menu.name = "Skills"
	return menu
end

local itemMenu
itemMenu = function(inventory)
	local selections = {}
	for item, quantity in pairs(inventory) do
		selection = itemSubMenu(item)
		selection.name = item .. "   *" .. quantity
		selection.quantity = quantity
		selection.description = ITEM_DATABASE[item].description
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

local colorsMenu
colorsMenu = function()
	local menu = new_menu({}, {0, 0}, {3,3}, {0,16})
	local r = menu.render
	

	
	-- make some random colors
	local colors = {}
	math.randomseed(os.time())
	
	for i=1,1 do
		local theta = 360
		local r = 100
		local h = 100

		table.insert(colors, {theta, r, h})
		table.insert(colors, {theta + 30, r, h})
		table.insert(colors, {theta + 60, r, h})
		table.insert(colors, {theta + 90, r, h})
		table.insert(colors, {theta + 120, r, h})
		table.insert(colors, {theta + 150, r, h})
		table.insert(colors, {theta + 180, r, h})
		table.insert(colors, {theta + 210, r, h})
		table.insert(colors, {theta + 240, r, h})
		table.insert(colors, {theta + 270, r, h})
		table.insert(colors, {theta + 300, r, h})
		table.insert(colors, {theta + 330, r, h})
		table.insert(colors, {theta + 360, r, h})
		table.insert(colors, {0, 0, 50})
	end
	menu.render = function() 

		love.graphics.setColor(0,0,0)
		love.graphics.rectangle("fill", 0,0, 1000, 1000)

		gfx.print("Color Menu", 3, 3, {255,255,255})
		for i, color in ipairs(colors) do
			for j, c2 in ipairs(colors) do
					gfx.print(string.format("%+1.2f", diff(color, c2)), -15 + 22*j, 13*i, HSV(c2[1], c2[2], c2[3]))
			end
		end
	end

	menu.name = "Colors"
	return menu
end

local storeMenu
storeMenu = function()
	local name
	name = function(title, cost)
		return string.format("%-24s%6s", title, ""..cost)
	end
	local selections = {
		name("Sword <",   10),
		name("Sword >",   10),
		name("Sword ;",   10),
		name("Sword <>",  16),
		name("Sword <;",  16),
		name("Sword >;",  16),
		name("Sword <>;", 21)
	}
	
	local menu = new_menu(selections, {0, 0}, {3,3}, {0,16}, 128)


	menu.name = "Store"
	return menu
end

menuContent = {}
table.insert(menuContent, menuMenu())

table.insert(menuContent, skillsMenu())

table.insert(menuContent, itemMenu({["Sword"] = 1, ["Potion"] = 9, ["Amulet"] = 1, ["Bomb"] = 1}))

table.insert(menuContent, colorsMenu())

table.insert(menuContent, storeMenu())

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
	onUpdate = function(dt) 

		return nil 

	end,
	scale = function() 
		love.graphics.scale(2.0, 2.0)
	end,

	onKeyPress = function(key)

		local next_menu = handleKeyPress(menuComp, key)

		if next_menu.complete then end

		for i, v in ipairs(menuState.entities) do
			if v == menuComp then
				table.remove(menuState.entities, i)
			end
		end
		menuComp = next_menu
		table.insert(menuState.entities, menuComp)
		if key == "escape" then
			changestate()
		end
	end
}