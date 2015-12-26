require "block"

Level= {}
Level.__index = Level

-- 0 = empty
-- 1 = block
-- 2 = diamond
-- 3 = wall

maze = {
	{3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
	{3,1,1,1,1,1,1,0,0,0,0,0,0,0,0,0,0,3},
	{3,0,0,0,0,0,0,0,1,1,1,1,1,1,1,0,1,3},
	{3,0,0,0,2,1,1,1,1,1,1,1,1,1,1,0,1,3},
	{3,0,0,0,1,0,0,0,0,0,0,0,0,0,0,0,1,3},
	{3,1,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3},
	{3,0,1,0,0,0,0,0,0,0,0,0,0,0,0,0,1,3},
	{3,0,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,3},
	{3,0,0,0,0,1,2,1,0,0,0,0,0,0,0,0,0,3},
	{3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3,3},
}

function Level:new(file, width, height, frames)
	local object = {}
	setmetatable(object, Level)
	
	object.sprite_sheet = love.graphics.newImage(file)
	object.width = width
	object.height = height
	object.frames = frames
	object.sprites = {}
	-- create empty 2-dim blocks array
	object.blocks = {}
	for y = 1, #maze do
		object.blocks[y] = {}
		for x = 1, #maze[y] do
			object.blocks[y][x] = {}
		end
	end
	
	return object
end

function Level:load()
	--Load blocks
	self:loadBlocks()
	
	--Load level-sprites
	self.sprites = {}
	for i = 1, self.frames do
		local x = self.width * (i-1)
		self.sprites[i] = love.graphics.newQuad(x, 0, self.width, self.height, self.sprite_sheet:getWidth(), self.sprite_sheet:getHeight())
	end
end

function Level:loadBlocks()
	for y = 1, #maze do
		for x = 1, #maze[y] do
			self.blocks[y][x] = Block:new(x*16, y*16, maze[y][x])
		end
	end
end

function Level:gridPos(x)
	return (x/16)
end


function Level:isColliding(x1, y1, w1, h1)
	for y = 1, #maze do
		for x = 1, #maze[y] do
			if maze[y][x] == 1 or maze[y][x] == 3 then
				if self:CheckCollision(x1, y1, w1, h1, x*16, y*16, 16, 16) then return true end				
			end
		end
	end
end

function Level:CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function Level:push_block(gridX, gridY, direction)
	if direction == "Up" then
		if maze[gridY-1][gridX] == 1 and maze[gridY-2][gridX] == 0 then
			maze[gridY-1][gridX] = 0
			self.blocks[gridY-1][gridX]:setDirection(0, -1)
		end
	elseif direction == "Left" then
		if maze[gridY][gridX-1] == 1 and maze[gridY][gridX-2] == 0 then
			maze[gridY][gridX-1] = 0
			self.blocks[gridY][gridX-1]:setDirection(-1, 0)
		end
	elseif direction == "Right" then
		if maze[gridY][gridX+1] == 1 and maze[gridY][gridX+2] == 0 then
			maze[gridY][gridX+1] = 0
			self.blocks[gridY][gridX+1]:setDirection(1, 0)
		end
	elseif direction == "Down" then
		if maze[gridY+1][gridX] == 1 and maze[gridY+2][gridX] == 0 then
			maze[gridY+1][gridX] = 0
			self.blocks[gridY+1][gridX]:setDirection(0, 1)
		end
	end
end

--[[function Level:draw()
	for y = 1, #maze do
		for x = 1, #maze[y] do
			love.graphics.draw(self.sprite_sheet, self.sprites[maze[y][x]+1], x*self.width, y*self.height, 0, 1, 1)
		end
	end
end
--]]

function Level:update(dt)
	-- update blocks
	for y = 1, #self.blocks do
		for x = 1, #self.blocks[y] do
			self.blocks[y][x]:update(dt)
		end
	end

	--	check block collision against blocks
	for y = 1, #maze do
		for x = 1, #maze[y] do
			if self.blocks[y][x]:get_mode() == "moving" then
				if self:isColliding(self.blocks[y][x]:getX(), self.blocks[y][x]:getY(), 16, 16) then
					self.blocks[y][x]:collided(dt)
					maze[self:gridPos(self.blocks[y][x]:getY())][self:gridPos(self.blocks[y][x]:getX())] = self.blocks[y][x]:get_ID()			--get the new X and Y position from where block collided
					self.blocks[self:gridPos(self.blocks[y][x]:getY())][self:gridPos(self.blocks[y][x]:getX())]:set_ID(self.blocks[y][x]:get_ID())
					self.blocks[y][x]:set_ID(0)
--					self.blocks[self:gridPos(self.blocks[y][x]:getY())][self:gridPos(self.blocks[y][x]:getX())] = self.blocks[y][x]
--					self.blocks[y][x] = Block:new(self.blocks[y][x]:getX(), self.blocks[y][x]:getY(), 0) 
					self:loadBlocks()
				end
			end
		end
	end
	--]]
end

function Level:draw()
	for y = 1, #self.blocks do
		for x = 1, #self.blocks[y] do
			self.blocks[y][x]:draw(self.sprite_sheet, self.sprites)
		end
	end
end

function Level:dump_maze()
print("Maze")
	for y = 1, #maze do
		for x = 1, #maze[y] do
			io.write(maze[y][x])
		end
		io.write("\n")
	end
print("Blocks")
	for y = 1, #self.blocks do
		for x = 1, #self.blocks[y] do
			io.write(self.blocks[y][x]:get_ID())
		end
		io.write"\n"
	end
end

