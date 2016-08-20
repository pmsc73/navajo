 -- overworld
local mk = require('multikey')
local get, put = mk.get, mk.put

local tiles = love.graphics.newImage("res/tileset.png")
local map = love.image.newImageData("res/map.png")
function generateWorld(img) 
	local w = {}
	
	for j = 0, map:getHeight()-2, 2 do
		local row = {}
		for i = 0, map:getWidth()-2 , 2 do
			local x1,y1 = i, j
			local x2,y2 = x1+1, y1+1
			
			local GREEN = "G"
			local BLUE	= "B"
			local YELLOW= "Y"
			local BLACK = "K"
			
			local t = {}
			put(t,   BLUE,   BLUE,   BLUE,   BLUE,  0)
			put(t,   BLUE,   BLUE,   BLUE,  GREEN,  1)
			put(t,   BLUE,   BLUE,  GREEN,   BLUE,  2)
			put(t,   BLUE,   BLUE,  GREEN,  GREEN,  3)
			put(t,   BLUE,  GREEN,   BLUE,   BLUE,  4)
			put(t,   BLUE,  GREEN,   BLUE,  GREEN,  5)
			put(t,   BLUE,  GREEN,  GREEN,   BLUE,  6)
			put(t,   BLUE,  GREEN,  GREEN,  GREEN,  7)
			put(t,	GREEN, 	 BLUE,	 BLUE, 	 BLUE,  8)
			put(t,  GREEN,   BLUE,   BLUE,  GREEN,  9)
			put(t,  GREEN,   BLUE,  GREEN,   BLUE, 10)
			put(t,  GREEN,   BLUE,  GREEN,  GREEN, 11)
			put(t,  GREEN,  GREEN,   BLUE,   BLUE, 12)
			put(t,  GREEN,  GREEN,   BLUE,  GREEN, 13)
			put(t,  GREEN,  GREEN,  GREEN,   BLUE, 14)
			put(t,  GREEN,  GREEN,  GREEN,  GREEN, 15)
			put(t, YELLOW, YELLOW, YELLOW, YELLOW, 16)
			put(t, 	BLACK,	BLACK,	BLACK,	BLACK, 17)

			local appr = {"K","K","K","K"}

			for i=1, 4 do
				local _x,_y
				if (i>2) then _y = y2 else _y = y1 end
				if ((i%2)==0) then _x = x2 else _x = x1 end
				local r,g,b,a = map:getPixel(_x,_y)

				appr[i] = BLACK
				if g==255 then appr[i] = GREEN end
				if b==255 then appr[i] = BLUE end

			end
			local tile = {
				tileId = get(t, appr[1], appr[2], appr[3], appr[4]),
				onEnter = function() if math.rand() > 0.5 then commenceBattle() end end
			}
			table.insert(row,get(t,appr[1],appr[2],appr[3], appr[4]))
		end
		table.insert(w, row)
	end
	return w
end

local world = generateWorld("res/map.png")

local HEIGHT = 19
local WIDTH = 25
function draw_world(p_image, px, py)
	for i = 1, HEIGHT do
		for j = 1, WIDTH do
			--love.graphics.print(world[i][j], (j-1)*8, (i-1)*8)
			local x = 32*(j-1)
			local y = 32*(i-1)
			local tx,ty
			local pi = py - math.floor(HEIGHT/2) + i
			local pj = px - math.floor(WIDTH/2) + j
			if world[pi][pj] < 10 then
				tx = world[pi][pj] * 32
				ty = 0
			else
				tx = (world[pi][pj] % 10 ) * 32
				ty = 32
			end
			local tile = love.graphics.newQuad(tx, ty, 32, 32, tiles:getDimensions()) 
			love.graphics.draw(tiles, tile, x, y)
		end
	end
	love.graphics.draw(p_image, love.graphics.getWidth() / 2 - 16, love.graphics.getHeight() / 2 - 20)
end

overworldState = {
	name = "Overworld",

	init = function(party) 
		entities = {}
		entities.player = party[1]
		entities.player.map_pos = { x = 32, y = 32 } 

		entities.tiles = {}
		entities.tiles.render = function()
			draw_world(player.image, player.map_pos.x, player.map_pos.y)
		end

		return entities
	end,

	onUpdate = function(dt) 
		-- DO UPDATE STUFF
	end,

	onKeyPress = function(key) 		
		if key == "down" 	then player.map_pos.y = player.map_pos.y + 1 end
		if key == "up"		then player.map_pos.y = player.map_pos.y - 1 end
		if key == "left"	then player.map_pos.x = player.map_pos.x - 1 end
		if key == "right"	then player.map_pos.x = player.map_pos.x + 1 end
		--if key == "return" 	then stateTransition("Menu") end
	end
}