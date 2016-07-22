-- Menu Selection

menu = {}
menu.__index = menu

-- Class Methods
function menu.new(selections)
	local o = {}
	o.selections = selections
	o.s_index = 1
	o.selected = o.selections[o.s_index]
	setmetatable(o,menu)
	return o
end

function menu:get_selected() 
	return self.selection[self.s_index]
end
