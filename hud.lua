local hud = {}

if minetest.get_modpath("hudbars") ~= nil then

    local hudbar_identifier = "stamina"

    -- register a bar with hudbars
    hb.register_hudbar(hudbar_identifier, 0xFFFFFF, "Stamina",
        { bar = "stamina_bar.png", icon = "stamina_icon_16.png" },
        0, jog.max_stamina, jog.hide_hudbar)

    -- initialize the player's hud
    function hud.init(player)
        local playername = player:get_player_name()
        hb.init_hudbar(player, hudbar_identifier, jog.players[playername].stamina, jog.players[playername].max_stamina)
    end

    -- update the player's hud
    function hud.update(player)
        local playername = player:get_player_name()
        local playerdata = jog.players[playername]

        -- show/hide hudbar
        if jog.hide_hudbar then
            local hudbar_hidden = hb.get_hudbar_state(player, hudbar_identifier)["hidden"]

            if hudbar_hidden then
                if playerdata.sprinting or playerdata.stamina < playerdata.max_stamina then
                    hb.unhide_hudbar(player, hudbar_identifier)
                end
            else
                if playerdata.stamina >= playerdata.max_stamina then
                    hb.hide_hudbar(player, hudbar_identifier)
                end
            end
        end

        -- update hudbar
        hb.change_hudbar(player, hudbar_identifier, math.floor(playerdata.stamina + 0.5), math.floor(playerdata.max_stamina + 0.5))
    end

    -- remove the player's hud (does nothing in hudbars)
    function hud.remove(player)
        return nil
    end

else -- if no hud mod is installed...

    local hud_ids = {}

    local function get_statbar_number(playerdata)
        return (math.floor(playerdata.stamina + 0.5) / math.floor(playerdata.max_stamina + 0.5)) * 20
    end

    -- initialize the player's hud
    function hud.init(player)
        local playername = player:get_player_name()

		local id = player:hud_add({
			hud_elem_type = "statbar",

			position = {x = 0.5, y = 1},
            alignment = {x = -1, y = -1},
            offset = {x = -265, y = (-90 - 24)},
            size = {x=24, y=24},

			text = "stamina_icon_24.png",
			number = get_statbar_number(jog.players[playername])
		})

		hud_ids[playername] = id
    end

    -- update the player's hud
    function hud.update(player)
        local playername = player:get_player_name()
        local playerdata = jog.players[playername]

        -- update/hide hudbar
        if jog.hide_hudbar and not playerdata.sprinting and playerdata.stamina >= playerdata.max_stamina then
            player:hud_change(hud_ids[playername], "number", 0)
        else
            player:hud_change(hud_ids[playername], "number", get_statbar_number(playerdata))
        end
    end

    -- remove the player's hud
    function hud.remove(player)
        local playername = player:get_player_name()
        player:hud_remove(hud_ids[playername])
    end

end

return hud
