require 'battle'
require 'boxes'
require 'local'

-- battle menu

-- THIS CLASS ENCAPSULATES THE MENU SYSTEM USED FOR THE BATTLE STATE OF THE GAME

--[[ 
	initiates the battle menu for a character.
	this function should be called whenever the
	character who is currently selected changes
]]--

local ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING = {80, 168}, {5,5}, {0,16}
local SKL_MENU_POS, SKL_MENU_PADDING, SKL_MENU_SPACING = {125, 171}, {3,3}, {0,12}
local MAG_MENU_POS, MAG_MENU_PADDING, MAG_MENU_SPACING = {125, 171}, {3,3}, {0,12}
local ITM_MENU_POS, ITM_MENU_PADDING, ITM_MENU_SPACING = {0,0}, {0,0}, {0,0}
local ESC_MENU_POS, ESC_MENU_PADDING, ESC_MENU_SPACING = {0,0}, {0,0}, {0,0}

battlemenu = {}

local target_list = {}


local attackSubMenu
attackSubMenu = function(party, character, enemies)
	local selections = {}
	
	for _, enemy in pairs(enemies) do
		enemy_selection = {}
		enemy_selection.name = ""
		enemy_selection.action = function() 
			battleSystem.processAttack(character, enemy)
		end
		table.insert(selections, enemy_selection)
	end

	local m = new_menu(selections, ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING)
	m.name = "Attack"
	return m
end


local skillSubMenu
skillSubMenu = function(party, character, enemies)


	local selections = {}

	if character.skills then for _, skill in pairs(character.skills) do
		local targets = target_list[skill.targets]
		local targets_selections = {}
		if targets then for _, target in pairs(targets) do
			table.insert(targets_selections, {name = "", action = function() skill.use(target) end})
		end end
		skill_selection = new_menu(targets_selections, ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING)
		skill_selection.name = skill.name

		table.insert(selections, skill_selection)
	end end
	
	local menu = new_menu(selections, SKL_MENU_POS, SKL_MENU_PADDING, SKL_MENU_SPACING)
	local r = menu.render
	local skillbox = menu_rectangle(SKL_MENU_POS[1], SKL_MENU_POS[2], 140, 65)
	menu.render = function() 
		skillbox.render()
		r() 
	end

	menu.name = "Skill"
	return menu
end

local magicSubMenu
magicSubMenu = function(character, enemies)
	local spells = {}
	for _, spell in pairs(character.colors) do
		local targets = enemies
		local selections = {}
		if targets then for _, target in pairs(targets) do
			table.insert(selections, {name="", 
				action = function() battleSystem.dealDamage("MAGIC", character, target, spell) end})
		end end
		spell_selection = new_menu(selections, ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING)
		spell_selection.name = "O"
		table.insert(spells, spell_selection)
	end
	local menu = new_menu(spells, MAG_MENU_POS, MAG_MENU_PADDING, MAG_MENU_SPACING)
	local r = menu.render
	


	local magicbox = menu_rectangle(MAG_MENU_POS[1], MAG_MENU_POS[2], 140, 65)
	menu.render = function()
		magicbox.render()
		r()
	end
	menu.name = "Magic"
	return menu
end

local itemSubMenu
itemSubMenu = function()
	local menu = {name="Item"}

	return menu
end

local escapeSubMenu
escapeSubMenu = function()
	local menu = {name="Escape"}
	menu.action = function() changestate(kitala) end
	return menu
end

function battlemenu.init(party, character, enemies, pos, padding, spacing)
	local selections = {}

	target_list = {
		["SELF"] = {character},
		["ALLY"] = party,
		["SINGLE"] = enemies,
		["AOE"] = {enemies, party}

	}

	table.insert(selections, attackSubMenu(party, character, enemies))
	table.insert(selections, skillSubMenu(party, character, enemies))
	table.insert(selections, magicSubMenu(character, enemies))
	table.insert(selections, itemSubMenu())
	table.insert(selections, escapeSubMenu())

	local battle_menu_instance = new_menu(selections, pos, padding, spacing)
	battle_menu_instance.persists = true
	return battle_menu_instance
end