-- Class object

entity = {}
entity.__index = entity

-- Class methods

function entity.new(name, x, y, image, skills, stats, onRender)
	local o = {}
	o.onRender = onRender
	o.name = name
	o.x = x
	o.y = y
	o.image = love.graphics.newImage(image)
	o.skills = skills
	o.menu = o.skills
	o.stats = stats
	setmetatable(o, entity)
	return o
end

function entity:render()
	love.graphics.draw(self.image, self.x, self.y)
	if self.onRender ~= nil then self.onRender() end
end