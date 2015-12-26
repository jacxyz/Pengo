Block= {}
Block.__index = Block

function Block:new(x, y, ID)
	local object = {}
	setmetatable(object, Block)
	
	object.x = x
	object.y = y
	object.width = 16
	object.height = 16
	object.speed = 2
	object.directionX = 0
	object.directionY = 0
	object.ID = ID
	object.mode = "still"	-- modes: "still" "moving"
	return object
end

function Block:getX() return self.x end
function Block:getY() return self.y end
function Block:get_ID() return self.ID end
function Block:get_mode() return self.mode end

function Block:set_mode(mode) self.mode = mode end
function Block:set_ID(ID) self.ID = ID end

function Block:update(dt)
	self.x = self.x + (self.directionX * self.speed)
	self.y = self.y + (self.directionY * self.speed)
end

function Block:setDirection(x, y)
	self.directionX = x
	self.directionY = y
	self.mode = "moving"
end

function Block:collided(dt)
	self.x = self.x - (self.directionX * self.speed)
	self.y = self.y - (self.directionY * self.speed)
	self:setDirection(0,0)
	self.mode = "still"
end

function Block:draw(sprite_sheet, sprites)
	if self.ID ~= 0 then
		love.graphics.draw(sprite_sheet, sprites[self.ID+1], self.x, self.y, 0, 1, 1)
	end
end