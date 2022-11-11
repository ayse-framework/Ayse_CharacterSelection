AyseCore = exports["Ayse_Core"]:GetCoreObject()

RegisterNetEvent("Ayse_CharacterSelection:newCharacter", function(newCharacter)
    local player = source

    AyseCore.Functions.CreateCharacter(player, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender, newCharacter.cash, newCharacter.bank)
end)

RegisterNetEvent("Ayse_CharacterSelection:editCharacter", function(newCharacter)
    local player = source

    local characters = AyseCore.Functions.GetPlayerCharacters(player)
    if not characters[newCharacter.id] then return end
    
    AyseCore.Functions.UpdateCharacterData(newCharacter.id, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender)

    TriggerClientEvent("Ayse:returnCharacters", player, AyseCore.Functions.GetPlayerCharacters(player))
end)
