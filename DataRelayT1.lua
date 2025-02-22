local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer

_G.AutoFarm = true -- Controle global para ativar/desativar o loop

-- **Função para respawn**
local function respawnPlayer()
    repeat task.wait() until player.Character
    task.wait(1) -- Aguarda um segundo após o spawn
end

-- **Função para executar o primeiro código (atualizar roupas)**
local function updateClothing()
    local userData = workspace.UserData["User_" .. player.UserId]
    if userData then
        userData.UpdateClothing_Extras:FireServer("A", "\255", 34)
        player.Character.CharacterTrait.ClothingTrigger:FireServer()
    end
end

-- **Função para teleportar para a ilha Kaizu**
local function teleportToKaizu()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(-1526.023, 365, 10510.021)
    end
end

-- **Função para pegar todos os Compasses**
local function claimAllCompasses()
    local args = {
        [1] = "Claim10"
    }
    workspace.Merchants.QuestMerchant.Clickable.Retum:FireServer(unpack(args))
end

-- **Função para dropar todos os Compasses corretamente**
local function dropAllCompasses()
    local backpack = player.Backpack
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    if not humanoid then return end

    -- **Seleciona e dropa todos os "Compass"**
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Compass" then
            humanoid:EquipTool(item) -- Equipa o item
            task.wait(0.2)
            keypress(0x08) -- Simula apertar Backspace
            task.wait(0.1)
            keyrelease(0x08) -- Solta a tecla
            task.wait(0.3)
        end
    end
end

-- **Função para reentrar no jogo**
local function rejoinGame()
    TeleportService:Teleport(game.PlaceId, player)
    task.wait(7) -- Tempo para garantir a reconexão

    -- **Reexecutar automaticamente com loadstring**
    loadstring(game:HttpGet("https://raw.githubusercontent.com/zDevNan/GeneralScript/refs/heads/main/DataRelayT1.lua"))()
end

-- **Loop otimizado**
task.spawn(function()
    while _G.AutoFarm do
        respawnPlayer()
        updateClothing()
        teleportToKaizu()
        task.wait(1) -- Espera antes de pegar os Compasses
        claimAllCompasses()
        task.wait(1) -- Espera antes de dropar
        dropAllCompasses()
        task.wait(2) -- Pequena espera para evitar lag
        rejoinGame()
    end
end)
