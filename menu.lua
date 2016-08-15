-- menu

menu = {}
menu.__index = menu

function menu.new(name)
	local o = {}
	o.name = name
	o.selections = {}
	o.current = 1
	o.isMenu = true
	o.last = nil
	setmetatable(o, menu)
	return o
end

function menu:next() 
	if self.selections[self.current].isMenu then
		self:nextMenu()
	else
		self.selections[self.current].onSelect()
	end
end

function menu:addSelection(name, selections, onSelect)
	local selection = {}
	selection.name = name
	selection.onSelect = onSelect
	if self.selections == nil then 
		self.selections  = {}
	end
	table.insert(self.selections, selection)
end

function menu:addSubMenu(name)
	local sub = menu.new(name)
end

function menu:nextSelection()
	self.current = self.current + 1
	if self.current > #self.selections then 
		self.current = 1
	end
end

function menu:previousSelection()
	self.current = self.current - 1
	if self.current < 1 then 
		self.current = #self.selections 
	end
end

function menu:previousMenu()
	if self.last ~= nil then 
		self = self.last 
	end
end

function menu:nextMenu()
	if self.selections[self.current].isMenu then 
		self.last = self
		self = self.selections[self.current]
	end
end

function menu:getSelected() 
	return self.selections[self.current]
end

function menu:getIndex() 
	return self.current
end