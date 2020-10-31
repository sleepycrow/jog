local hud = dofile(jog.own_modpath .. "/hud.lua")

jog.players = {}

-- add a player to players on join
minetest.register_on_joinplayer(function(player)
    local playername = player:get_player_name()

    jog.players[playername] = {
        sprinting = false,
        max_stamina = jog.max_stamina,
        stamina = jog.max_stamina
    }

    hud.init(player)
end)

-- remove a player from players on leave
minetest.register_on_leaveplayer(function(player)
    local playername = player:get_player_name()
    jog.players[playername] = nil

    hud.remove(player)
end)

-- replenish stamina on death
minetest.register_on_dieplayer(function(player)
    local playername = player:get_player_name()

    if jog.players[playername] then
        jog.players[playername].stamina = jog.players[playername].max_stamina
    end
end)

-- update all players
minetest.register_globalstep(function(dtime)
    --go through all the players
    for playername, playerinfo in pairs(jog.players) do

        local player = minetest.get_player_by_name(playername)
        if player ~= nil then

            -- set sprinting to false by default
            playerinfo.sprinting = false

            if player:get_player_control()['aux1'] then

                -- if player wants to sprint and has stamina, set sprinting to true and drain stamina
                if playerinfo.stamina > 0 then
                    playerinfo.sprinting = true
                    playerinfo.stamina = playerinfo.stamina - (dtime * jog.use_rate)
                end

            else

                -- if player doesn't want to sprint and doesn't have full stamina, regenerate it
                if playerinfo.stamina < playerinfo.max_stamina then
                    playerinfo.stamina = playerinfo.stamina + (dtime * jog.replenish_rate)
                end

            end

            -- make sure the value of stamina is sensible
            if playerinfo.stamina > playerinfo.max_stamina then
                playerinfo.stamina = playerinfo.max_stamina
            elseif playerinfo.stamina < 0 then
                playerinfo.stamina = 0
            end

            -- update player speed
            if playerinfo.sprinting then
                player:set_physics_override({
                    speed = jog.sprinting_speed,
                    jump = jog.sprinting_jump
                })
            else
                player:set_physics_override({
                    speed = 1.0,
                    jump = 1.0
                })
            end

            -- commit changes to players[]
            jog.players[playername] = playerinfo

            -- update hud
            hud.update(player)

        end

    end
end)
