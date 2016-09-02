-- mapdata
-- used for local maps

mapdata = {}

-- LOCAL MAP DIMENSIONS ARE 16x12

mapdata.kitala = {
	tiles = {
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


local tileData = {
	[0] = {0, 0, 32, 32},
	[1] = {160, 32, 32, 32},
	[2] = {256, 32, 32, 32}
}


-- Turn mapdata into tiles!

local WIDTH, HEIGHT = 10, 10

function getDrawable(mdata, tile_res)
	local toDraw = {}
	for i = 1, #mdata.tiles do
		for j = 1, #mdata.tiles[i] do
			local tile = {}
			local tdata = tileData[mdata.tiles[i][j]]
			local tx, ty, w, h = tdata[1], tdata[2], tdata[3], tdata[4]


			tile.t = love.graphics.newQuad(tx, ty, w, h, tile_res:getDimensions())
			tile.render = function() 
				love.graphics.draw(tile_res, tile.t, (j-1)*32, (i-1)*32)
			end
			table.insert(toDraw, tile)
		end
	end
	return toDraw
end
