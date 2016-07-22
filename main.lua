require 'entity'
require 'skill'
require 'menu'

function love.load() 
	background = love.graphics.newImage("bg.png")
	love.window.setMode(480,320,{resizable=true})

	entities = {}

	karna = entity.new("Karna", 0, 0, "karna-base.png", {
		skill.new("Berserk",70,0,"Increase offensive stats, lose defence and control", "berserk.png"),
		skill.new("Defend",70,75, "Defend an ally for one turn", "defend.png")
	}, {hp = 10, att = 3, def = 2, spd = 1, mgd = 0, mga = 0})

	alnar = entity.new("Alnar", 0, 42, "alnar-base.png", {
		skill.new("Drain Life",70,0, "Steal health points from target", "resurrect.png"),
		skill.new("Blast",70,75, "Deal non-elemental magic dmage to target", "blast.png") 
	}, {hp = 10, att = 3, def = 2, spd = 1, mgd = 0, mga = 0})

	lysh = entity.new("Lysh", 0, 84, "lysh-base.png", {
		skill.new("Shoot", 70,0,"Deal physical damage and apply effects to target", "shoot.png"),
		skill.new("Parry", 70,75,"Counterattack against an enemy", "parry.png")
	}, {hp = 10, att = 3, def = 2, spd = 1, mgd = 0, mga = 0})

	nez = entity.new("Nez", 0, 126, "nez-base.png", {
		skill.new("Meditate",70,0, "Restore health and increase defence", "meditate.png"),
		skill.new("Nature", 70,75, "Deal non-elemental damage to all targets", "nature.png")
	}, {hp = 10, att = 3, def = 2, spd = 1, mgd = 0, mga = 0})

	arrow = entity.new("Arrow", 36, 0, "arrow.png", {})
 
	current_menu = menu.new({
		menu.new(karna.skills),
		menu.new(alnar.skills),
		menu.new(lysh.skills),
		menu.new(nez.skills)
	})
	selected_index = 1


	enemy = entity.new("Zombie", 230, 200, "zombie.png", {},
		{hp = 10, att = 3, def = 2, spd = 1, mgd = 0, mga = 0}, 
		function() love.graphics.print(enemy.stats.hp, enemy.x, enemy.y) end)

	table.insert(entities, karna)
	table.insert(entities, alnar)
	table.insert(entities, lysh)
	table.insert(entities, nez)
	table.insert(entities, enemy)
	table.insert(entities, arrow)

end

function makeSkill(name, desc, image)
	skill = {}
	skill.name = name
	skill.description = desc
	skill.image = love.graphics.newImage(image)
	return skill
end

function love.keypressed(key, scancode, isrepeat) 
	if key=="return" then
		current_menu = current_meu.selections[selected_index]
		selected_index = 1
	end
	for i, s in ipairs(current_menu) do
		if selected == s then
			i = selected_index
		end
	end

	if key=="down" then
		selected_index = selected_index + 1 
	end
	if key=="up" then
		selected_index = selected_index - 1 
	end


	selected_index = math.max(selected_index, 1)
	selected_index = math.min(#current_menu, selected_index)

end

function love.update(dt)
	selected = current_menu[selected_index]
	if canChange then 
		arrow.y = current_menu[selected_index].y
		arrow.x = current_menu[selected_index].x + 36
	end
end

function love.draw()

	for _,v in pairs(entities) do
		v:render()
	end
	if current_menu ~= nil then
		if current_menu[selected_index] ~= nil then
			for i, v in ipairs(current_menu[selected_index].skills) do
				v:render(100,(i-1)*75)
				-- love.graphics.draw(v.image, 100, i*75)
				-- love.graphics.print(v.name, 100, i*75 + 20)
				-- love.graphics.print(v.description, 100, i*75 + 40)
			end
		end
	end
end
