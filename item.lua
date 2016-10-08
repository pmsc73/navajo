-- Item object representation

function new_item(name, description)
	local item = {}
	item.name = name
	item.description = description
	return {[name] = item}
end

ITEM_DATABASE = 
{
	["Potion"] = "Restore health to target",
	["Amulet of Fear"] = "+1% chance to cause FEAR",
	["Salve"] = "Restore mana to target"
}