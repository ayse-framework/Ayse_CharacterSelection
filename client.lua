AyseCore = exports["Ayse_Core"]:GetCoreObject()
local changeAppearence = false
local started = false
local firstSpawn = true

function startChangeAppearence()
    local config = {
        ped = true,
        headBlend = true,
        faceFeatures = true,
        headOverlays = true,
        components = true,
        props = true,
        tattoos = false
    }

    exports["fivem-appearance"]:startPlayerCustomization(function(appearance)
        if appearance then
            local ped = PlayerPedId()
            local clothing = {
                model = GetEntityModel(ped),
                tattoos = exports["fivem-appearance"]:getPedTattoos(ped),
                appearance = exports["fivem-appearance"]:getPedAppearance(ped)
            }
            Wait(4000)
            TriggerServerEvent("Ayse:updateClothes", clothing)
        else
            start(true)
        end
        changeAppearence = false
    end, config)
end

function setCharacterClothes(character)
    if config.enableAppearance then
        if not character.data.clothing or next(character.data.clothing) == nil then
            changeAppearence = true
        else
            changeAppearence = false
            exports["fivem-appearance"]:setPlayerModel(character.data.clothing.model)
            local ped = PlayerPedId()
            exports["fivem-appearance"]:setPedTattoos(ped, character.data.clothing.tattoos)
            exports["fivem-appearance"]:setPedAppearance(ped, character.data.clothing.appearance)
        end
    end
end

function tablelength(table)
    local count = 0
    for _ in pairs(table) do
        count = count + 1
    end
    return count
end

function SetDisplay(bool, typeName, bg, characters)
    local characterAmount = characters
    if not characterAmount then
        characterAmount = AyseCore.Functions.GetCharacters()
    end
    if not bg then
        background = config.backgrounds[math.random(1, #config.backgrounds)]
    end
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = typeName,
        background = background,
        status = bool,
        serverName = AyseCore.Config.serverName,
        characterAmount = tablelength(characterAmount) .. "/" .. AyseCore.Config.characterLimit
    })
    Wait(500)
end

function start(switch)
    TriggerServerEvent("Ayse:GetCharacters")
    if not started then
        TriggerServerEvent("Ayse_CharacterSelection:checkPerms")
        started = true
    end
    if switch then
        local ped = PlayerPedId()
        SwitchOutPlayer(ped, 0, 1)
        FreezeEntityPosition(ped, true)
        SetEntityVisible(ped, false, 0)
    end
end

AddEventHandler("onResourceStart", function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
      return
    end
    Wait(2000)
    start(false)
end)

AddEventHandler("playerSpawned", function()
    start(true)
end)

RegisterNetEvent("Ayse_CharacterSelection:permsChecked", function(allowedRoles)
    SendNUIMessage({
        type = "givePerms",
        deptRoles = json.encode(allowedRoles)
    })
end)

RegisterNetEvent("Ayse:returnCharacters", function(characters)
    local playerCharacters = {}
    for id, characterInfo in pairs(characters) do
        playerCharacters[tostring(id)] = characterInfo
    end
    SendNUIMessage({
        type = "refresh",
        characters = json.encode(playerCharacters)
    })
    SetDisplay(true, "ui", background, characters)
end)

RegisterNUICallback("setMainCharacter", function(data)
    local characters = AyseCore.Functions.GetCharacters()
    local defaultSpawns = config.spawns["DEFAULT"]
    local spawns = {}
    for _, spawn in pairs(defaultSpawns) do
        spawns[#spawns + 1] = spawn
    end
    local job = characters[data.id].job
    local jobSpawns = config.spawns[job]
    if jobSpawns then
        for _, newSpawn in pairs(jobSpawns) do
            spawns[#spawns + 1] = newSpawn
        end
    end
    SendNUIMessage({
        type = "setSpawns",
        spawns = json.encode(spawns),
        id = characters[data.id].id
    })
    Wait(1000)
    TriggerServerEvent("Ayse:setCharacterOnline", data.id)
end)

RegisterNUICallback("newCharacter", function(data)
    if tablelength(AyseCore.Characters) < AyseCore.Config.characterLimit then
        TriggerServerEvent("Ayse_CharacterSelection:newCharacter", {
            firstName = data.firstName,
            lastName = data.lastName,
            dob = data.dateOfBirth,
            gender = data.gender,
            job = data.department
        })
    end
end)

RegisterNUICallback("editCharacter", function(data)
    TriggerServerEvent("Ayse_CharacterSelection:editCharacter", {
        id = data.id,
        firstName = data.firstName,
        lastName = data.lastName,
        dob = data.dateOfBirth,
        gender = data.gender,
        job = data.department
    })
end)

RegisterNUICallback("delCharacter", function(data)
    TriggerServerEvent("Ayse:deleteCharacter", data.character)
end)

RegisterNUICallback("exitGame", function()
    TriggerServerEvent("Ayse:exitGame")
end)

RegisterNUICallback("tpToLocation", function(data)
    local ped = PlayerPedId()
    SetEntityCoords(ped, tonumber(data.x), tonumber(data.y), tonumber(data.z), false, false, false, false)
    FreezeEntityPosition(ped, true)
    SwitchInPlayer(ped)
    Wait(500)
    SetDisplay(false, "ui")
    Wait(500)
    FreezeEntityPosition(ped, false)
    SetEntityVisible(ped, true, 0)
    setCharacterClothes(AyseCore.Functions.GetSelectedCharacter())
    if config.enableAppearance and changeAppearence then
        startChangeAppearence()
    end
    if firstSpawn then
        firstSpawn = false
        SendNUIMessage({
            type = "firstSpawn"
        })
    end
end)

RegisterNUICallback("tpDoNot", function(data)
    local ped = PlayerPedId()
    if firstSpawn then
        local character = AyseCore.Functions.GetCharacters()[data.id]
        if character.lastLocation and next(character.lastLocation) ~= nil then
            SetEntityCoords(ped, character.lastLocation.x, character.lastLocation.y, character.lastLocation.z, false, false, false, false)
            FreezeEntityPosition(ped, true)
        end
        firstSpawn = false
        SendNUIMessage({
            type = "firstSpawn"
        })
    else
        FreezeEntityPosition(ped, true)
    end
    SwitchInPlayer(ped)
    Wait(500)
    SetDisplay(false, "ui")
    Wait(500)
    SetEntityVisible(ped, true, 0)
    FreezeEntityPosition(ped, false)
    Wait(100)
    setCharacterClothes(AyseCore.Functions.GetSelectedCharacter())
    if config.enableAppearance and changeAppearence then
        startChangeAppearence()
    end
end)

RegisterCommand(config.changeCharacterCommand, function()
    TriggerServerEvent("Ayse:GetCharacters")
    local ped = PlayerPedId()
    SwitchOutPlayer(ped, 0, 1)
    Wait(2000)
    FreezeEntityPosition(ped, true)
    SetEntityVisible(ped, false, 0)
	SetDisplay(true, "ui")
end, false)

TriggerEvent("chat:addSuggestion", "/" .. config.changeCharacterCommand, "Switch your framework character.")
