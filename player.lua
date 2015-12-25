require "animatedSprite"

Player= {}
Player.__index = Player

function Player:new(animatedSprite)
	local object = {}
	setmetatable(object, Player)
	
	object.x = 160
	object.y = 144
	object.directionX = 0
	object.directionY = 0
	object.speed = 1.0
	object.animation = animatedSprite
	object.Directions = {
		["Down"] = 1,
		["Left"] = 3,
		["Right"] = 7,
		["Up"] = 5
	}
	object.current_direction = "Up"
	object.Mode = {
		["Walk"] = 1,	-- player
		["Push"] = 2,   -- player
		["Dead"] = 3, 	-- player
		["Spawn"] = 1,  -- npc
		["Break"] = 3,  -- npc
		["Move"] = 2,	-- npc
		["Crushed"] = 5	-- npc		
	}
	object.current_mode = "Walk"
	return object
end

function Player:getX() return self.x end

function Player:getY() return self.y end


function Player:update(dt)
	self.x = self.x + (self.directionX * self.speed)
	self.y = self.y + (self.directionY * self.speed)
	self.animation:update(dt)
end

function Player:setDirection(dir)
	self.current_direction = dir
	if self.Directions[self.current_direction] == self.Directions["Up"] and self.x % 16 == 0 then
		self.directionX = 0
		self.directionY = -1
		self.animation:set_animation(self.Directions[self.current_direction], self.Mode[self.current_mode])
	elseif self.Directions[self.current_direction] == self.Directions["Left"] and self.y % 16 == 0 then
		self.directionX = -1
		self.directionY = 0
		self.animation:set_animation(self.Directions[self.current_direction], self.Mode[self.current_mode])
	elseif self.Directions[self.current_direction] == self.Directions["Down"]  and self.x % 16 == 0 then
		self.directionX = 0
		self.directionY = 1
		self.animation:set_animation(self.Directions[self.current_direction], self.Mode[self.current_mode])
	elseif self.Directions[self.current_direction] == self.Directions["Right"] and self.y % 16 == 0 then
		self.directionX = 1
		self.directionY = 0
		self.animation:set_animation(self.Directions[self.current_direction], self.Mode[self.current_mode])
	end	
end

function Player:stop(dt)
	self.x = self.x - (self.directionX * self.speed)
	self.y = self.y - (self.directionY * self.speed)
	self.directionX = 0
	self.directionY = 0
end

function Player:draw()
	self.animation:draw(self.x, self.y)
end
