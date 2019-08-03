jog.get_stamina = function(playername)
    if jog.players[playername] then
        return jog.players[playername].stamina
    else
        return nil
    end
end

jog.set_stamina = function(playername, stamina)
    if jog.players[playername] then
        jog.players[playername].stamina = stamina
        return true
    else
        return false
    end
end

jog.get_max_stamina = function(playername)
    if jog.players[playername] then
        return jog.players[playername].max_stamina
    else
        return nil
    end
end

jog.set_max_stamina = function(playername, max_stamina)
    if jog.players[playername] then
        jog.players[playername].max_stamina = max_stamina
        return true
    else
        return false
    end
end
