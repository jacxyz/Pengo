-- https://rarlindseysmash.com/posts/sprite-love

AnimatedSprite = {}
AnimatedSprite.__index = AnimatedSprite

--[[
startColumn = sprite collection nr in X (number, not pixels) 
startRow = sprite collection nr in Y
--]]
function AnimatedSprite:new(file, width, height, frames, rows, startColumn, startRow)
	local object = {}
	setmetatable(object, AnimatedSprite)

	object.animation_frames = 2
	object.startColumn = startColumn
	object.startRow = startRow
	object.width = width
	object.height = height
	object.frames = frames
	object.rows = rows
	object.sprite_sheet = love.graphics.newImage(file)
	object.sprites = {}
	object.current_frame = 1
	object.current_row = 1
	object.current_animation = 1 		-- x animation start position in sheet
	object.delay = 0.10
	object.delta = 0
	object.animating = true
	object.Directions = {
		["Down"] = 1,
		["Left"] = 3,
		["Up"] = 5,
		["Right"] = 7
	}
	object.Mode = {
		["Walk"] = 1,	-- player
		["Push"] = 2,   -- player
		["Dead"] = 3, 	-- player
		["Spawn"] = 1,  -- npc
		["Break"] = 3,  -- npc
		["Move"] = 2,	-- npc
		["Crushed"] = 5	-- npc		
	}
	return object
end

function AnimatedSprite:load()
	for i = 1, self.rows do
		local y = self.height * (i-1)
		self.sprites[i] = {}
		for j = 1, self.frames do
			local x = self.width * (j-1)
			self.sprites[i][j] = love.graphics.newQuad(x + self.startColumn*self.width, y + self.startRow * self.height, self.width, self.height, self.sprite_sheet:getWidth(), self.sprite_sheet:getHeight())
			end
		end
end

function AnimatedSprite:loadPart()
	
end

function AnimatedSprite:update(dt)
	if self.animating then
		self.delta = self.delta + dt
		if self.delta >= self.delay then
			self.current_frame = (self.current_frame % self.animation_frames) + 1
			self.delta = 0
		end		
	end
end

function AnimatedSprite:set_animation(direction, mode)
	self.current_row = mode
	self.current_animation = direction
end

function AnimatedSprite:set_sheet_position(direction, mode)
	self.current_row = mode
	self.current_animation = direction
end

function AnimatedSprite:set_animation_direction(direction)
	self.animating = true
	self.current_frame = direction
end

function AnimatedSprite:set_animation_frames(nrOfFrames)
	self.animation_frames = nrOfFrames
end

function AnimatedSprite:(x, y)
	love.graphics.draw(self.sprite_sheet, self.sprites[self.current_row][(self.current_animation + self.current_frame) - 1], x, y, 0, 1, 1)	
end

