--"d:\program files\love\love.exe" "$(CURRENT_DIRECTORY)"
--"d:\program files\love\love.exe" --console "D:\Hans\Dropbox\Programmering\Lua Löve\Pengo"
--"c:\program files\love\love.exe" --console "C:\Users\hans\Dropbox\Programmering\Lua Löve\Pengo"

require "animatedSprite"
require "player"
require "npc"
require "level"

npc = {}


--===== Löve functions =====--
function love.load()
	love.keyboard.setKeyRepeat(true)

	local player_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 4, 0, 0)
	player_animation:load()
	player = Player:new(player_animation)
	
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 4, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 4, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 4, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc[2]:set_mode("Break")
	
	level = Level:new("block.png", 16, 16, 4)
	level:load()
end

function love.update(dt)
	--Update
	player:update(dt)
	for i = 1, #npc do
		npc[i]:update(dt)
	end

	--Maze Collision
	if level:isColliding(player:getX(), player:getY(), 16, 16) then
		player:stop(dt)
	end
	
	for i = 1, #npc do
		if npc[i]:get_mode() ~= "Spawn" and level:isColliding(npc[i]:getX(), npc[i]:getY(), 16, 16) then
			npc[i]:collided(dt)
		end
	end
	
	-- Input
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown("w") then
		player:setDirection("Up")
	elseif love.keyboard.isDown("a") then
		player:setDirection("Left")
	elseif love.keyboard.isDown("s") then
		player:setDirection("Down")
	elseif love.keyboard.isDown("d") then
		player:setDirection("Right")
	end	
end

function love.draw()
	level:draw()
	player:draw()
	for i = 1, #npc do
		npc[i]:draw()
	end
end

