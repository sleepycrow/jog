jog.players = {}

local hudbar_identifier = "stamina"

-- register a hudbar
hb.register_hudbar(hudbar_identifier, 0xFFFFFF, "Stamina",
	{ bar = "stamina_bar.png", icon = "stamina_icon.png" },
	SPRINT_STAMINA, SPRINT_STAMINA, jog.hide_hudbar)

-- add a player to players on join
minetest.register_on_joinplayer(function(player)
    local playername = player:get_player_name()
    
    jog.players[playername] = {
        sprinting = false,
        max_stamina = jog.max_stamina,
        stamina = jog.max_stamina
    }

    hb.init_hudbar(player, hudbar_identifier, jog.players[playername].stamina, jog.players[playername].max_stamina)
end)

-- remove a player from players on leave
minetest.register_on_leaveplayer(function(player)
    local playername = player:get_player_name()
    jog.players[playername] = nil
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

            -- show/hide hudbar
            if jog.hide_hudbar then
                local hudbar_hidden = hb.get_hudbar_state(player, hudbar_identifier)["hidden"]

                if hudbar_hidden then
                    if playerinfo.sprinting or playerinfo.stamina < playerinfo.max_stamina then
                        hb.unhide_hudbar(player, hudbar_identifier)
                    end
                else
                    if playerinfo.stamina >= playerinfo.max_stamina then
                        hb.hide_hudbar(player, hudbar_identifier)
                    end
                end
            end

            -- update hudbar
            hb.change_hudbar(player, hudbar_identifier, math.floor(playerinfo.stamina + 0.5), math.floor(playerinfo.max_stamina + 0.5))

            -- commit changes to players[]
            jog.players[playername] = playerinfo

        end

    end
end)
