-- Menu Selection

mymenu = {}
mymenu.__index = mymenu

-- Class Methods
function mymenu.new(name, selections)
	local o = {}
	o.name = name
	o.selections = selections
	o.s_index = 1
	setmetatable(o,mymenu)
	return o
end

function mymenu:selectionHasSubMenu() 
	return self.selections[self.s_index].menu ~= nil
end

function mymenu:getSubMenu() 
	return self.selections[self.s_index].menu
end

function mymenu:selectionHasAction() 
	return self.selections[self.s_index].action ~= nil
end

function mymenu:doAction() 
	self.selections[self.s_index].action()
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