require 'battle'

-- battle menu

-- THIS CLASS ENCAPSULATES THE MENU SYSTEM USED FOR THE BATTLE STATE OF THE GAME

--[[ 
	initiates the battle menu for a character.
	this function should be called whenever the
	character who is currently selected changes
]]--

battlemenu = {}

local ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING = {0,0}, {0,0}, {0,0}
local SKL_MENU_POS, SKL_MENU_PADDING, SKL_MENU_SPACING = {0,0}, {0,0}, {0,0}
local MAG_MENU_POS, MAG_MENU_PADDING, MAG_MENU_SPACING = {0,0}, {0,0}, {0,0}
local ITM_MENU_POS, ITM_MENU_PADDING, ITM_MENU_SPACING = {0,0}, {0,0}, {0,0}
local ESC_MENU_POS, ESC_MENU_PADDING, ESC_MENU_SPACING = {0,0}, {0,0}, {0,0}

local attackSubMenu
attackSubMenu = function(party, character, enemies)
	local selections = {}
	
	for _, enemy in pairs(enemies) do
		if not enemy.isDead then
			local enemy_selection = enemy
			table.insert(selections, {name = enemy.name})
		end
	end

	local m = new_menu(selections, ATT_MENU_POS, ATT_MENU_PADDING, ATT_MENU_SPACING)
	m.name = "Attack"
	return m
end


local skillSubMenu
skillSubMenu = function()
	local menu = {name="Skill"}

	return menu
end

local magicSubMenu
magicSubMenu = function()
	local menu = {name="Magic"}

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

	return menu
end

function battlemenu.init(party, character, enemies)
	local selections = {}

	current_party = party
	current_character = character
	current_enemies = enemies


	table.insert(selections, attackSubMenu(party, character, enemies))
	table.insert(selections, skillSubMenu())
	table.insert(selections, magicSubMenu())
	table.insert(selections, itemSubMenu())
	table.insert(selections, escapeSubMenu())

	return selections
end
