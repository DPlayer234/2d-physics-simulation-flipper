--[[
Loading the debug module and... stuff.
]]
--#exclude start
miscMod.assert(..., "dev.init")

-- Enabling Debug mode...
local s,r = pcall(require, "dev.debugger")
if not s then print(r) end
--#exclude end
