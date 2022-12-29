AyseCore = exports["Ayse_Core"]:GetCoreObject()

function validateDepartment(player, department)
    local departmentExists = config.departments[department]
    if departmentExists then
        local discordUserId = AyseCore.Functions.GetPlayerIdentifierFromType("discord", player):gsub("discord:", "")
        local discordInfo = AyseCore.Functions.GetUserDiscordInfo(discordUserId)

        for _, roleId in pairs(departmentExists) do
            if roleId == 0 or roleId == "0" or (discordInfo and discordInfo.roles[roleId]) then
                return true
            end
        end
    end
    return false
end

RegisterNetEvent("Ayse_CharacterSelection:newCharacter", function(newCharacter)
    local player = source

    local departmentCheck = validateDepartment(player, newCharacter.job)
    if not departmentCheck then return end

    local characterId = NDCore.Functions.CreateCharacter(player, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender, newCharacter.cash, newCharacter.bank)
    AyseCore.Functions.SetPlayerJob(characterId, newCharacter.job, 1)
end)

RegisterNetEvent("Ayse_CharacterSelection:editCharacter", function(newCharacter)
    local player = source

    local characters = AyseCore.Functions.GetPlayerCharacters(player)
    if not characters[newCharacter.id] then return end

    local departmentCheck = validateDepartment(player, newCharacter.job)
    if not departmentCheck then return end

    AyseCore.Functions.UpdateCharacter(newCharacter.id, newCharacter.firstName, newCharacter.lastName, newCharacter.dob, newCharacter.gender)
    AyseCore.Functions.SetPlayerData(newCharacter.id, "job", newCharacter.job, 1)

    TriggerClientEvent("Ayse:returnCharacters", player, AyseCore.Functions.GetPlayerCharacters(player))
end)

RegisterNetEvent("Ayse_CharacterSelection:checkPerms", function()
    local player = source
    local discordUserId = AyseCore.Functions.GetPlayerIdentifierFromType("discord", player):gsub("discord:", "")
    local allowedRoles = {}
    local discordInfo = AyseCore.Functions.GetUserDiscordInfo(discordUserId)

    for dept, roleTable in pairs(config.departments) do
        for _, roleId in pairs(roleTable) do
            if roleId == 0 or roleId == "0" or (discordInfo and discordInfo.roles[roleId]) then
                table.insert(allowedRoles, dept)
            end
        end
    end
    TriggerClientEvent("Ayse_CharacterSelection:permsChecked", player, allowedRoles)
end)

if config.departmentPaychecks then
    CreateThread(function()
        while true do
            Wait(config.paycheckInterval * 60000)
            for player, playerInfo in pairs(AyseCore.Functions.GetPlayers()) do
                local salary = config.departmentSalaries[playerInfo.job]
                if salary then
                    AyseCore.Functions.AddMoney(salary, player, "bank")
                    TriggerClientEvent("chat:addMessage", player, {
                        color = {0, 255, 0},
                        args = {"Salary", "Received $" .. salary .. "."}
                    })
                end
            end
        end
    end)
end
