-- enemy database file
require 'skill'

local tiles = love.graphics.newImage("res/enemy-tiles.png")

local enemy_stats_modifier = 0
local enemy_stats_multiplier = 1

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
		str = POW[1],
		frt = POW[2],
		con = POW[3],

		int = MAG[1],
		wis = MAG[2],
		wll = MAG[3],

		dex = SPD[1],
		agi = SPD[2],
		edr = SPD[3]
	}
	e.skills = {skill.nature}
	e.xp = xp
	return e
end

DB_ENEMY = 
{
	new("Zombie", 	{2,0}, {10, 1, 5},   {1, 3, 1}, {2, 1, 1}, 10),
	new("Ghoul", 	{2,1}, {10, 2, 3.5}, {1, 1, 1}, {3, 1, 1}, 19),
	
	new("Puddle", 	{1,0}, {10, 1, 6},   {1, 1, 1}, {1, 1, 1}, 20),
	new("Swamp", 	{1,1}, {10, 3, 7},   {1, 1, 1}, {1, 1, 1}, 30),
	new("Lava", 	{1,2}, {10, 5, 9},   {1, 1, 1}, {1, 1, 1}, 50),
	
	new("Thug",		{0,0}, {1,1,1}, {1,1,1}, {1,1,1}, 1),
	new("Pirate",	{0,1}, {2,2,2}, {2,2,2}, {2,2,2}, 2),
	new("Rebel", 	{0,2}, {6,6,6}, {6,6,6}, {6,6,6}, 666666)
}
function update_modifiers()
	enemy_stats_modifier = enemy_stats_modifier + 1
	enemy_stats_mulitplier = enemy_stats_multiplier * (1.01)
end

function enemy_copy(enemy)
	local copy = {}
	copy.name = enemy.name
	copy.tileset = enemy.tileset
	copy.quad = enemy.quad

	copy.damage_modifier = 0
	copy.damage_multiplier = 1
	copy.defence_modifier = 0
	copy.defence_multiplier = 1
	copy.stats = {}
	for k, v in pairs(enemy.stats) do

		copy.stats[k] = math.floor((v + enemy_stats_modifier) * (enemy_stats_multiplier))
	end
	copy.stats["chroma"] = {math.random()*255, math.random()*255, math.random()*255} 
	copy.xp = enemy.xp
	return copy
end
