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
	{3,1,1,0,1,1,1,1,1,1,2,1,1,1,1,0,1,3},
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
	
	return object
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

function Level:load()
	self.sprites = {}
	for i = 1, self.frames do
		local x = self.width * (i-1)
		self.sprites[i] = love.graphics.newQuad(x, 0, self.width, self.height, self.sprite_sheet:getWidth(), self.sprite_sheet:getHeight())
	end
end

function Level:draw()
	for y = 1, #maze do
		for x = 1, #maze[y] do
			love.graphics.draw(self.sprite_sheet, self.sprites[maze[y][x]+1], x*self.width, y*self.height, 0, 1, 1)
		end
	end
end
