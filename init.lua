-- jog v1.0
-- a highly-configurable sprint mod with an API
-- by sleepycrow

jog = {}

local own_modname = minetest.get_current_modname()
local own_modpath = minetest.get_modpath(own_modname)

dofile(own_modpath .. "/settings.lua")
dofile(own_modpath .. "/sprint.lua")
dofile(own_modpath .. "/api.lua")
