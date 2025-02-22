local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
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

-- **Função para teleportar para a ilha do Sam**
local function teleportToSam()
    local character = player.Character
    if character and character:FindFirstChild("HumanoidRootPart") then
        character.HumanoidRootPart.CFrame = CFrame.new(-1283, 218, -1348)
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
    local character = player.Character
    local humanoid = character and character:FindFirstChild("Humanoid")

    if not character or not humanoid then return end

    -- **Coleta todos os "Compass" no inventário**
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Compass" then
            humanoid:EquipTool(item) -- Equipa o item
            task.wait(0.2)
            
            if item.Parent == character then
                item:Activate()
                task.wait(0.1)

                UserInputService:InputBegan({
                    UserInputType = Enum.UserInputType.Keyboard,
                    KeyCode = Enum.KeyCode.Backspace
                }) -- Simula Backspace
                
                task.wait(0.3)
            end
        end
    end
end

-- **Função para reentrar no jogo**
local function rejoinGame()
    TeleportService:Teleport(game.PlaceId, player)
    task.wait(7) -- Tempo para garantir a reconexão
    
    -- **Reexecutar o script automaticamente**
    local scriptUrl = "https://seu-servidor.com/seu-script.lua" -- Troque para a URL real do seu script
    local success, response = pcall(function()
        return game:HttpGet(scriptUrl)
    end)

    if success then
        loadstring(response)()
    else
        warn("Erro ao carregar o script!")
    end
end

-- **Loop otimizado**
task.spawn(function()
    while _G.AutoFarm do
        respawnPlayer()
        updateClothing()
        teleportToSam()
        task.wait(1) -- Espera antes de pegar os Compasses
        claimAllCompasses()
        task.wait(1) -- Espera antes de dropar
        dropAllCompasses()
        task.wait(2) -- Pequena espera para evitar lag
        rejoinGame()
    end
end)
