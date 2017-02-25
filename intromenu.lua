-- intro menu

require('menu2')

require('images')

function newGameOption()
	local stats = {0,0,0, 0,0,0, 0,0,0}
	 __stats = {
	 	str = 0, frt = 0, con = 0, 
	 	int = 0, wis = 0, wll = 0, 
	 	dex = 0, agi = 0, edr = 0
	 }

	

	 char_choices = {res.karna, res.alnar, res.lysh, res.nez}
	local char_c_stat = {
		{2,1,0,0,0,0,0,0,0},
		{0,0,0,2,1,0,0,0,0},
		{0,0,0,0,0,0,2,1,0},
		{0,0,2,0,0,0,0,0,1}
	}
	local class_choices = {res.berserk, res.defend, res.drain, res.blast, res.meditate, res.nature}
	local weap_choices = {res.katana, res.scythe, res.book}
	local weap_c_stat = {
		{1,0,0,0,0,0,0,0,0},
		{0,0,0,0,0,0,1,0,0},
		{0,0,0,1,0,0,0,0,0}
	}

	local chrm_choices = {
		{255,0,0}, 
		{0,255,0}, 
		{0,0,255}, 
		{255,0,255}, 
		{255,255,0}, 
		{0, 255, 255}
	}

	 char_ind = 1
	local class_ind = 1
	local weap_ind = 1
	local chrm_ind = 1
	local handleChoice
	handleChoice = function(key, choices, ind) 
		if key == "left" then  ind = ind -1 end
		if key == "right" then ind = ind + 1 end
		if ind < 1 then ind = #choices - ind end
		if ind > #choices then ind = ind - #choices end

		return ind
	end


	local selections = {
		{
			name = "- Character -", 
			s_render = function() 
				love.graphics.setColor(0,0,0)
				love.graphics.rectangle("fill", 0,0, 100, 30)
	
				love.graphics.setColor(255,255,255)
				love.graphics.draw(char_choices[char_ind], 5, 5)
				for i, v in pairs(stats) do
					stats[i] = 1 + char_c_stat[char_ind][i] + weap_c_stat[weap_ind][i]
				end
				__stats = {
					str = stats[1], frt = stats[2], con = stats[3],
					int = stats[4], wis = stats[5], wll = stats[6],
					dex = stats[7], agi = stats[8], edr = stats[9]
				}
				gfx.print("Strength: " 		.. stats[1], 90, 5)
				gfx.print("Fortitude: " 	.. stats[2], 90, 14)
				gfx.print("Constitution: "  .. stats[3], 90, 23)
				gfx.print("Intelligence: "	.. stats[4], 90, 31)
				gfx.print("Wisdom: "		.. stats[5], 90, 40)
				gfx.print("Willpower: "		.. stats[6], 90, 49)
				gfx.print("Dexterity: "		.. stats[7], 90, 58)
				gfx.print("Agility: "		.. stats[8], 90, 67)
				gfx.print("Endurance: "		.. stats[9], 90, 76)

			end,
			handleSideScroll = function(key) 
				char_ind = handleChoice(key, char_choices, char_ind)
			end
		},
		{
			name = "-    Class   -",
			s_render = function() 
				love.graphics.setColor(chrm_choices[chrm_ind])
				love.graphics.draw(class_choices[class_ind], 48, 10)
			end,
			handleSideScroll = function(key) 
				class_ind = handleChoice(key, class_choices, class_ind)
			end 
		},
		{
			name = "-  Weapon  -",
			s_render = function()
				love.graphics.draw(weap_choices[weap_ind], 65, 8)
			end,

			handleSideScroll = function(key)
				weap_ind = handleChoice(key, weap_choices, weap_ind)
			end
		},
		{
			name = "-  Chroma  -",
			handleSideScroll = function(key)
				chrm_ind = handleChoice(key, chrm_choices, chrm_ind)
			end
		}
	}

	local option = new_menu(selections, {0,50}, {3,3}, {0,16})
	option.name = "New Game"
	local r = option.render
	option.render = function() 
		r()
		gfx.print("[Enter] to begin", 90, 100)
	end
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
		if key == "z" then
			Sound.game_start:play()
			for k, stat in pairs(__stats) do
				karna.stats[k] = __stats[k]
			end
			karna.image = char_choices[char_ind]
			changestate(kitala)
		end
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