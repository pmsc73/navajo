-- enemy database file
require 'skill'

local tiles = love.graphics.newImage("res/enemy-tiles.png")

local WIDTH = 33
local HEIGHT = 42

function get_image(ty, tx)
	local x = 1 + (tx*WIDTH)
	local y = 1 + (ty*HEIGHT)
	local image = love.graphics.newQuad(x, y, WIDTH, HEIGHT, tiles:getDimensions())
	return image
end

function new(name, image, POW, MAG, SPD, xp)
	local e = {}
	e.name = name
	e.tileset = tiles
	e.quad = get_image(image[1], image[2])
	e.stats = {
		strength = POW[1],
		endurance = POW[2],
		constitution = POW[3],

		intelligence = MAG[1],
		wisdom = MAG[2],
		willpower = MAG[3],

		agility = SPD[1],
		dexterity = SPD[2],
		luck = SPD[3]
	}
	e.skills = {skill.nature}
	e.xp = xp
	return e
end

DB_ENEMY = 
{
	new("Zombie", 	{2,0}, {1, 1, 5},   {1, 3, 1}, {2, 1, 1}, 10),
	new("Ghoul", 	{2,1}, {1, 2, 3.5}, {1, 1, 1}, {3, 1, 1}, 19),
	new("Puddle", 	{1,0}, {1, 1, 6},   {1, 1, 1}, {1, 1, 1}, 20),
	new("Swamp", 	{1,1}, {1, 3, 7},   {1, 1, 1}, {1, 1, 1}, 30),
	new("Lava", 	{1,2}, {1, 5, 9},   {1, 1, 1}, {1, 1, 1}, 50)
}

function enemy_copy(enemy)
	local copy = {}
	copy.name = enemy.name
	copy.tileset = enemy.tileset
	copy.quad = enemy.quad
	copy.stats = {}
	for k, v in pairs(enemy.stats) do
		copy.stats[k] = v
	end
	copy.xp = enemy.xp
	return copy
end
