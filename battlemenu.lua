require 'battle'

-- battle menu

-- THIS CLASS ENCAPSULATES THE MENU SYSTEM USED FOR THE BATTLE STATE OF THE GAME

--[[ 
	initiates the battle menu for a character.
	this function should be called whenever the
	character who is currently selected changes
]]--

battlemenu = {}
function battlemenu.init(party, character, enemies)
	-- The top level menu
	local menu = {}

	-- First level of menu selections
	local option_attack = attackMenu(character, enemies)
	local option_skill = skillMenu(party, character, enemies)
	local option_magic = {"Magic"}
	local option_item = {"Item"}
	local option_escape = {"Escape"}

	local cb_attack = function(target) 
		battleSystem.processAttack(character, target)
	end

	local cb_skill = function(args)
		args[1].use(args[2])
	end

	local cb_magic = function() return nil end

	local cb_item = function() return nil end

	local cb_escape = function() return love.quit() end

	newSelection(menu, option_attack, nil)
	newSelection(menu, option_skill, nil)
	newSelection(menu, option_magic, nil)
	newSelection(menu, option_item, nil)
	newSelection(menu, option_escape, nil)

	return mymenu.new("Battle", menu, nil, 380, 15);
end

function attackMenu(character, enemies)
	local m = {}

	for _, enemy in pairs(enemies) do
		if not enemy.isDead then
			enemy.callback = function() return nil end
			newSelection(m, enemy, function() battleSystem.processAttack(character, enemy) end)
		end
	end

	return mymenu.new("Attack", m, nil, 140, 15)
end

function skillMenu(party, character, enemies) 
	local menu = {}

	local single_target_list = {}
	local aoe_target_list = {}
	local self_target_list = {}
	local none_target_list = {}

	local target_table = {
		["SINGLE"] = single_target_list,
		["AOE"]	= aoe_target_list,
		["SELF"] = self_target_list,
		["NONE"] = none_target_list
	}

	-- SELF
	table.insert(self_target_list, character)

	-- AOE
	table.insert(aoe_target_list, enemies)
	table.insert(aoe_target_list, party)

	-- SINGLE
	for _, enemy in pairs(enemies) do
		if not enemy.isDead then
			table.insert(single_target_list, enemy)
		end
	end
	for _, member in pairs(party) do 
		table.insert(single_target_list, member)
	end

	-- get them selections otg
	for _, skill in pairs(character.skills) do
		local subMenu = {} 
		for _, selection in pairs(target_table[skill.targets]) do
			newSelection(subMenu, selection, 
				function() return skill.use(selection) end
			)
		end
		subMenu = mymenu.new(skill.name, subMenu, nil, 50,44,-16)
		newSelection(menu, subMenu, nil)
	end

	return mymenu.new("Skill", menu, nil, 320, 15)
end

-- creates new menu selection from a submenu
-- @param parent the parent menu
-- @param sub the selections sub menu, if it exists (should be a table)
-- @param callback a function to call when the selection is finished
function newSelection(parent, sub, callback)
	sub.callback = callback
	table.insert(parent, sub)
end

