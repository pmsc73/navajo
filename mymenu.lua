-- Menu Selection

mymenu = {}
mymenu.__index = mymenu

-- Class Methods
function mymenu.new(name, selections, callback, ax, ay_offset, ay)
	local o = {}
	o.name = name
	o.selections = selections
	o.s_index = 1
	o.arrow_x = ax
	o.arrow_y = ay
	o.y_increment = ay_offset
	o.callback = callback
	setmetatable(o,mymenu)
	return o
end

function mymenu:selectionHasSubMenu() 
	return self.selections[self.s_index].selections ~= nil
end

function mymenu:getSubMenu() 
	return self.selections[self.s_index]
end

function mymenu:selectionHasAction() 
	return self.selections[self.s_index].callback ~= nil
end

function mymenu:doAction() 
	self.selections[self.s_index].callback()
end

function mymenu:getSelected() 
	return self.selections[self.s_index]
end

function mymenu:nextSelection()
	self.s_index = (self.s_index + 1) % (#self.selections + 1)
	if self.s_index == 0 then self.s_index = 1 end
end

function mymenu:previousSelection()
	self.s_index = (self.s_index - 1) % (#self.selections + 1)
	if self.s_index == 0 then self.s_index = #self.selections end
end

function mymenu:getIndex() 
	if self.s_index == nil then return -1 end
	return self.s_index
end	