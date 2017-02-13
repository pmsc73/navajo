-- intro menu

require('menu2')

require('images')

function newGameOption()
	local handleChoice
	handleChoice = function(key, choices, ind) 
		if key == "left" then  ind = ind -1 end
		if key == "right" then ind = ind + 1 end
		if ind < 1 then ind = #choices - ind end
		if ind > #choices then ind = ind - #choices end
		return ind
	end

	local char_choices = {res.karna, res.alnar, res.lysh, res.nez}
	local class_choices = {res.berserk, res.defend, res.drain, res.blast, res.meditate, res.nature}
	local weap_choices = {res.katana, res.scythe, res.book}
	local char_ind = 1
	local class_ind = 1
	local weap_ind = 1
	local selections = {
		{
			name = "Character: ", 
			s_render = function() 
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("fill", 0,0, 100, 30)
	
				love.graphics.setColor(255,255,255)
				love.graphics.draw(char_choices[char_ind], 5, 5)
			end,
			handleSideScroll = function(key) 
				char_ind = handleChoice(key, char_choices, char_ind)
			end
		},
		{
			name = "Class: ",
			s_render = function() 
				love.graphics.draw(class_choices[class_ind], 48, 10)
			end,
			handleSideScroll = function(key) 
				class_ind = handleChoice(key, class_choices, class_ind)
			end 
		},
		{
			name = "Weapon: ",
			s_render = function()
				love.graphics.draw(weap_choices[weap_ind], 65, 8)
			end,
			handleSideScroll = function(key)
				weap_ind = handleChoice(key, weap_choices, weap_ind)
			end
		}
	}

	local option = new_menu(selections, {0,50}, {3,3}, {0,16})
	option.name = "New Game"
	return option
end

local loadGameOption = {
	name = "Load Game",
}

local quitOption = {
	name = "Quit",
}

local selections = {newGameOption(), loadGameOption, quitOption}
local intromenu = new_menu(selections, {40,60}, {3,3}, {0,16})
intromenu.persists = false
local title = gfx.create_text_entity("Fight Fight\n Money Money", 10, 2, nil, {255,255,0}, {64, 64, 0})

intromenu_state = {
	name = "Intro",
	init = function() 
		intromenu_state.entities = {}
		table.insert(intromenu_state.entities, intromenu)
		table.insert(intromenu_state.entities, title)
	end,

	onUpdate = function(dt) 
		return nil end,

	scale = function() 
		love.graphics.scale(4.0,4.0) end,

	onKeyPress = function(key)
		local next_menu = handleKeyPress(intromenu, key)

		if next_menu.complete then end

		for i,v in ipairs(intromenu_state.entities) do
			if v == intromenu then
				table.remove(intromenu_state.entities, i)
			end
		end

		intromenu = next_menu
		table.insert(intromenu_state.entities, intromenu)
		if key == "escape" then
			love.exit()
		end
	end
}

