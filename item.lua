-- Item object representation

function new_item(name, description, flags)
	local item = {}
	item.name = name
	item.description = description
	if flags then
		for k, v in pairs(flags) do
			item[k] = v
		end
	end

	return function(onUse) 
		item.onUse = onUse
		return item
	end
end

local ITEM_DB = 
{
	new_item("Potion", "Restore health to target")(function(target) target[1].stats.currentHp = target[1].stats.currentHp + 1 end),
	new_item("Amulet", "A simple amulet", {["equip"] = true})(nil),
	new_item("Bomb", "Hurt entire party")(
		function(target)  
			for _, char in pairs(target) do 
				char.stats.currentHp = char.stats.currentHp - 3
			end
		end
	)
}

function makeItemDatabase() 
	local database = {}
	for _, item in pairs(ITEM_DB) do
		database[item.name] = item
	end
	return database
end

ITEM_DATABASE = makeItemDatabase()
