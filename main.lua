function searchNewCommands(res)
    local comandos = {}
    local cmd = getCommandHandlers(res)
    for _, v in ipairs(cmd) do
        if not comandos[getResourceName(res)] then
            comandos[getResourceName(res)] = "/"..v
        else
            comandos[getResourceName(res)] = comandos[getResourceName(res)].."\n/"..v
        end
    end
    if comandos[getResourceName(res)] then
        sendDiscordMessage("Novos Comandos Adicionados:", "**Resource:**\n`"..getResourceName(res).."`\n**Comandos:**\n`"..comandos[getResourceName(res)].."`")
    end
end

function searchCommands()
    sendDiscordMessage("O Anti-Cheat NAC foi Ativo!", "O escaneamento do seu servidor começou.")
    setTimer(function()
        local texto = ""
        local comandos = {}
        local resources = getResources()
        for _, res in ipairs(resources) do
            local cmd = getCommandHandlers(res)
            for _, v in ipairs(cmd) do
                if not comandos[getResourceName(res)] then
                    comandos[getResourceName(res)] = "/"..v
                else
                    comandos[getResourceName(res)] = comandos[getResourceName(res)].."\n/"..v
                end
            end
        end
        for i, v in pairs(comandos) do
            texto = texto.."**Resource:**\n`"..i.."`\n**Comandos:**\n`"..v.."`\n\n"
        end
        sendDiscordMessage("Comandos do Servidor:", texto)
    end, 5000, 1)
end

addEventHandler("onElementDataChange", root,
    function(key, old, new)
        if hasObjectPermissionTo(getThisResource(), "function.fetchRemote", true) then
            if getElementType(source) == "player" then
                local id     = getElementData(source, "ID") or "N/A"
                local nick   = getPlayerName(source)
                local serial = getPlayerSerial(source)

                if key == "money" then
                    if tonumber(old) and tonumber(new) and new > old then
                        local soma = new - old
                        sendDiscordMessage("Alguém Recebeu Dinheiro!", "**"..removeHex(nick).." ("..id..") - "..serial.."**\n`Dinheiro Anterior: "..old.."`\n`Dinheiro Atual: "..new.."`\n`Valor Recebido: "..soma.."`")
                    end
                    
                elseif key == "alpha" then
                    if tonumber(old) and tonumber(new) and new < old then
                        sendDiscordMessage("Alguém Ficou Invisível!", "**"..removeHex(nick).." ("..id..") - "..serial.."**")
                    end

                elseif key == "weapon" then
                    if type(old) == "table" and type(new) == "table" and #new > #old then
                        local texto = ""
                        for i = 1, #new do
                            texto = texto.."\n`"..getWeaponNameFromID(new[i]).."`"
                        end
                        sendDiscordMessage("Alguém Recebeu Armas!", "**"..removeHex(nick).." ("..id..") - "..serial.."**\n**Armas:**"..texto)
                    end
                end
            end
        end
    end
)

addEventHandler("onPlayerCommand", root,
    function(cmd)
        if hasObjectPermissionTo(getThisResource(), "function.fetchRemote", true) then
            local id     = getElementData(source, "ID") or "N/A"
            local nick   = getPlayerName(source)
            local serial = getPlayerSerial(source)
            sendDiscordMessage("Alguém Usou um Comando!", "**"..removeHex(nick).." ("..id..") - "..serial.."**\n`/"..cmd.."`")
        end
    end
)

addEventHandler("onPlayerLogin", root,
    function(_, acc)
        if hasObjectPermissionTo(getThisResource(), "function.fetchRemote", true) then
            setTimer(function(source)
                local id     = getElementData(source, "ID") or "N/A"
                local nick   = getPlayerName(source)
                local serial = getPlayerSerial(source)
                sendDiscordMessage("Alguém Logou-se!", "**"..removeHex(nick).." ("..id..") - "..serial.."**\n`Jogadores: "..#getElementsByType("player").."`")
            end, 2000, 1, source)
        end
    end
)

addEventHandler("onPlayerBan", root,
    function(_, banner)
        local id     = getElementData(source, "ID") or "N/A"
        local nick   = getPlayerName(source)
        local serial = getPlayerSerial(source)
        if banner then
            local id2     = getElementData(banner, "ID") or "N/A"
            local nick2   = getPlayerName(banner)
            local serial2 = getPlayerSerial(banner)

            sendDiscordMessage("Alguém foi Banido!", "**"..removeHex(nick).." ("..id..") - "..serial.." foi banido por "..removeHex(nick2).." ("..id2..") - "..serial2.."**")
        else
            sendDiscordMessage("Alguém foi Banido!", "**"..removeHex(nick).." ("..id..") - "..serial.." foi banido por Console**")
        end
    end
)

addEventHandler("onPlayerChangeNick", root,
    function(old, new)
        local id     = getElementData(source, "ID") or "N/A"
        local nick   = getPlayerName(source)
        local serial = getPlayerSerial(source)
        sendDiscordMessage("Alguém Trocou o Nick!", "**"..removeHex(nick).." ("..id..") - "..serial.."**\n`Nick Antigo: "..removeHex(old).."`\n`Nick Novo: "..removeHex(new).."`")
    end
)

function removeHex(s)
    if type(s) == "string" then
        while (s ~= s:gsub("#%x%x%x%x%x%x", "")) do
            s = s:gsub("#%x%x%x%x%x%x", "")
        end
    end
    return s or false
end