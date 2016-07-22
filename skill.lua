-- Class object

skill = {} 
skill.__index = skill

-- Class methods

function skill.new(name,ax,ay, description, image)
	local o = {}
	o.name = name
	o.x = ax
	o.y = ay
	o.description = description
	o.image = love.graphics.newImage(image)
	setmetatable(o, skill)
	return o
end

function skill:render(x, y)
	love.graphics.draw(self.image, x, y)
	if self.name ~= nil then 
		love.graphics.print(self.name, x, y + 20) end
	if self.description ~= nil then
		love.graphics.print(self.description, x, y + 40) end
end