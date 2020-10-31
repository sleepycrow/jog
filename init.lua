-- jog v1.0
-- a highly-configurable sprint mod with an API
-- by sleepycrow

jog = {}

jog.own_modname = minetest.get_current_modname()
jog.own_modpath = minetest.get_modpath(jog.own_modname)

dofile(jog.own_modpath .. "/settings.lua")
dofile(jog.own_modpath .. "/sprint.lua")
dofile(jog.own_modpath .. "/api.lua")
