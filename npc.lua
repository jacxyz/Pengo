require "animatedSprite"


Npc= {}
Npc.__index = Npc

cntr = 0

function Npc:new(animatedSprite)
	local object = {}
	setmetatable(object, Npc)

	object.x = 48
	object.y = 48
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
	object.current_direction = "Down"
	object.Mode = {
		["Walk"] = 1,	-- player
		["Push"] = 2,   -- player
		["Dead"] = 3, 	-- player
		["Spawn"] = 1,  -- npc
		["Break"] = 3,  -- npc
		["Move"] = 2,	-- npc
		["Crushed"] = 5 -- npc
	}
	object.current_mode = "Spawn"
	
	return object
end

function Npc:getX() return self.x end

function Npc:getY() return self.y end

function Npc:update(dt)

--	if self.Mode[self.current_mode] == self.Mode["Stop"] then
--		self:random_direction()
--	end
--	self:move()
	
	self.x = self.x + (self.directionX * self.speed)
	self.y = self.y + (self.directionY * self.speed)
	self.animation:update(dt)

	if self.Mode[self.current_mode] == self.Mode["Spawn"] then
		self.animation:set_animation_frames(6)
		cntr = cntr + 1
		if cntr > 18 then
			cntr = 0
			self.current_mode = "Move"
			self.animation:set_animation_frames(2)
			self.animation:set_sheet_position(self.Directions[self.current_direction], self.Mode[self.current_mode])

		end		
	elseif (self.x % 16 == 0) and (self.y % 16 == 0) then
		self:random_direction()
--		self:move()
	end
end

--[[function Npc:move()
	if self.current_direction == "Up" then self.directionX = 0 self.directionY = -1
	elseif self.current_direction == "Down" then self.directionX = 0 self.directionY = 1
	elseif self.current_direction == "Left" then self.directionX = -1 self.directionY = 0
	elseif self.current_direction == "Right" then self.directionX = 1 self.directionY = 0
	end
end
--]]

function Npc:random_direction()
	local rnd = love.math.random(1,4)
	if rnd == 1 then self.current_direction = "Up"
	elseif rnd == 2 then self.current_direction = "Right"
	elseif rnd == 3 then self.current_direction = "Left"
	elseif rnd == 4 then self.current_direction = "Down"
	end

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

function Npc:set_mode(mode)
	self.current_mode = mode
	self.animation:set_animation_frames(2)
	self.animation:set_sheet_position(self.Directions[self.current_direction], self.Mode[self.current_mode])
end

function Npc:get_mode()
	return self.current_mode
end

function Npc:collided(dt)
	self.x = self.x - (self.directionX * self.speed)
	self.y = self.y - (self.directionY * self.speed)
--	self.current_mode = "Stop"
	self:random_direction()
end

function Npc:draw()
	self.animation:draw(self.x, self.y)
end