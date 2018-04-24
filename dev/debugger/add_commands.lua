--[[
Adding some commands for debugging :)
]]
--#exclude start
return function(debugger)
	local newCommand = debugger.newCommand

	newCommand("ball", "nn", function(x, y)
		heartbeat:getActiveGameState().ecs:findEntityByTag("Ball").transform:setPosition(heartbeat.Vector2(x, y))
	end)
end
--#exclude end
