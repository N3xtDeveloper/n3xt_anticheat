setTimer(function()
    local money = getElementData(localPlayer, "money")
    if money then
        if money ~= getPlayerMoney() then
            setElementData(localPlayer, "money", getPlayerMoney())
        end
    end

    local alpha = getElementData(localPlayer, "alpha")
    if alpha then
        if alpha ~= getElementAlpha(localPlayer) then
            setElementData(localPlayer, "alpha", getElementAlpha(localPlayer))
        end
    end

    local armas  = getPedWeapons(localPlayer)
    local armas2 = getElementData(localPlayer, "weapon")
    if armas2 then
        if #armas > #armas2 then
            setElementData(localPlayer, "weapon", armas)
        end
    end
end, 5000, 0)

function getPedWeapons(ped)
	local playerWeapons = {}
	if ped and isElement(ped) and getElementType(ped) == "ped" or getElementType(ped) == "player" then
		for i = 2, 9 do
			local wep = getPedWeapon(ped, i)
			if wep and wep ~= 0 then
				table.insert(playerWeapons, wep)
			end
		end
	else
		return false
	end
	return playerWeapons
end

setElementData(localPlayer, "money", getPlayerMoney(localPlayer))
setElementData(localPlayer, "alpha", getElementAlpha(localPlayer))
setElementData(localPlayer, "weapon", getPedWeapons(localPlayer))