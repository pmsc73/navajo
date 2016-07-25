-- Image resources
init_flag = false
pres = {

	-- CHARACTER SPRITES
	karna		= love.graphics.newImage("res/img/karna-base.png"),
	alnar		= love.graphics.newImage("res/img/alnar-base.png"),
	lysh		= love.graphics.newImage("res/img/lysh-base.png"),
	nez			= love.graphics.newImage("res/img/nez-base.png"),

	-- SKILL ICONS
	berserk 	= love.graphics.newImage("res/img/berserk.png"),
	defend		= love.graphics.newImage("res/img/defend.png"),
	drain		= love.graphics.newImage("res/img/drain.png"),
	blast		= love.graphics.newImage("res/img/blast.png"),
	shoot		= love.graphics.newImage("res/img/shoot.png"),
	parry		= love.graphics.newImage("res/img/parry.png"),
	meditate	= love.graphics.newImage("res/img/meditate.png"),
	nature		= love.graphics.newImage("res/img/nature.png"),

	-- ENEMY SPRITES
	enemy_zombie= love.graphics.newImage("res/img/zombie.png"),
	enemy_ghoul = love.graphics.newImage("res/img/ghoul.png"),

	-- MISC, MENU STUFF
	arrow		= love.graphics.newImage("res/img/arrow.png")
}
for _, image in pairs(pres) do
	image:setFilter("nearest", "nearest")
end

res = pres