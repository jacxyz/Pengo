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

	level = Level:new("block.png", 16, 16, 4)
	level:load()
	
	local player_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 4, 0, 0)
	player_animation:load()
	player = Player:new(player_animation)
	
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 5, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 5, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc_animation = AnimatedSprite:new("Pengo_sheet.png", 16, 16, 8, 5, 0, 8)
	npc_animation:load()
	npc[#npc + 1] = Npc:new(npc_animation)
	npc[2]:set_mode("Break")
	


end

function love.update(dt)
	--Update
	player:update(dt)
	for i = 1, #npc do
		npc[i]:update(dt)
	end
	level:update(dt)
	
	--Maze Collision
	if level:isColliding(player:getX(), player:getY(), 16, 16) then
		player:stop(dt)
	end
	
	-- NPC Collision
	for i = 1, #npc do
		-- collision against maze
		if npc[i]:get_mode() ~= "Spawn" and level:isColliding(npc[i]:getX(), npc[i]:getY(), 16, 16) then
			npc[i]:collided(dt)
		end
		-- collision against moving block
		level:is_crushed(npc[i])
	end
	
	-- Input
	if love.keyboard.isDown("escape") then
		love.event.quit()
	end
	if love.keyboard.isDown("m") then
		level:dump_maze()
	end

	if love.keyboard.isDown("w") then
		player:setDirection("Up")
	elseif love.keyboard.isDown("a") then
		player:setDirection("Left")
	elseif love.keyboard.isDown("s") then
		player:setDirection("Down")
	elseif love.keyboard.isDown("d") then
		player:setDirection("Right")
	elseif love.keyboard.isDown(" ") then
		if player:getX() % 16 == 0 and player:getY() % 16 == 0 then
			level:push_block(player:getX()/16, player:getY()/16, player:getDirection())
		end
	end	
end

function love.draw()
	level:draw()
	player:draw()
	for i = 1, #npc do
		npc[i]:draw()
	end
end

