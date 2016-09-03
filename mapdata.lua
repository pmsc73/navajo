-- mapdata
-- used for local maps

mapdata = {}

-- LOCAL MAP DIMENSIONS ARE 16x12

mapdata.kitala = {
	tiles = {
		{1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1},
		{1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 2, 0},
		{1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0},
		{1, 1, 2, 2, 1, 0, 1, 2, 2, 1, 1, 1, 0},
		{1, 1, 2, 2, 1, 0, 1, 2, 2, 1, 2, 2, 2},
		{1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0},
		{2, 2, 2, 2, 1, 0, 1, 0, 0, 1, 2, 2, 2},
		{1, 2, 1, 1, 1, 0, 1, 0, 0, 1, 1, 1, 0},
		{1, 2, 1, 1, 1, 0, 1, 1, 1, 1, 2, 2, 2},
		{1, 2, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0},
		{1, 2, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 0},
		{0, 1},
		{1, 2}
	},
	tileMappings = {{0,0}}
}


local n1 = "-1"
local tileData = {
	n1 = {288, 32, 32, 32},
	[0]  = {0, 0, 32, 32},
	[1]  = {160, 32, 32, 32},
	[2]  = {256, 32, 32, 32}
}


-- Turn mapdata into tiles!

local WIDTH, HEIGHT = 16, 12

function getDrawable(px, py, mdata, tile_res)
	local toDraw = {}
	for i = 1, #mdata.tiles do
		for j = 1, #mdata.tiles[i]do
			local x_index = px - 7
			local y_index = py - 5

			local tile = {}
			local tdata
			if mdata.tiles[y_index + i] and mdata.tiles[y_index + i][x_index + j] then 
				tdata = tileData[mdata.tiles[y_index + i][x_index + j]]
			else
				tdata = tileData.n1
			end
			local tx, ty, w, h = tdata[1], tdata[2], tdata[3], tdata[4]


			tile.t = love.graphics.newQuad(tx, ty, w, h, tile_res:getDimensions())
			tile.render = function() 
				love.graphics.draw(tile_res, tile.t, (j-1 - karna.pos.x)*32, (i-1 - karna.pos.y)*32)
			end
			table.insert(toDraw, tile)
		end
	end
	return toDraw
end
