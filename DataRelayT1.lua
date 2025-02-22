local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- **Coordenadas da ilha do Sam**
local samPosition = CFrame.new(-1283, 218, -1348)

-- **Função para respawn**
local function respawn()
    local loadFrame = player.PlayerGui:FindFirstChild("Load") and player.PlayerGui.Load.Frame
    if loadFrame and loadFrame.Visible then
        for _, connection in pairs(getconnections(loadFrame.Load.MouseButton1Click)) do
            connection.Function()
        end
    end
end

-- **Executa o primeiro código de atualização de roupa**
local function updateClothing()
    workspace.UserData["User_"..player.UserId].UpdateClothing_Extras:FireServer("A", "\255", 34)
    player.Character.CharacterTrait.ClothingTrigger:FireServer()
end

-- **Função para pegar todos os Compasses**
local function claimCompasses()
    local args = { [1] = "Claim10" }
    workspace.Merchants.QuestMerchant.Clickable.Retum:FireServer(unpack(args))
    warn("Compasses coletados!")
end

-- **Função para teleportar para a ilha do Sam**
local function teleportToSam()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = samPosition
    end
end

-- **Função para dropar todos os itens chamados "Compass"**
local function dropAllCompasses()
    local backpack = player.Backpack
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    if not humanoid then return end -- Se o humanoid não existir, cancela

    local itemsToDrop = {} -- Armazena os itens chamados "Compass"

    -- **Coleta todos os "Compass" no inventário**
    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.Name == "Compass" then
            table.insert(itemsToDrop, item)
        end
    end

    -- **Dropa todos os "Compass"**
    for _, item in ipairs(itemsToDrop) do
        item.Parent = player.Character -- **Move para a mão do jogador**
        task.wait(0.3) -- Pequeno delay para equipar
        keypress(Enum.KeyCode.Backspace)
        task.wait(0.1)
        keyrelease(Enum.KeyCode.Backspace)
        task.wait(0.3) -- Tempo extra para garantir o drop
    end

    warn("Todos os Compass foram dropados.")
end

-- **Função para reentrar no servidor**
local function rejoin()
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)

    if errorMessage and not success then
        warn(errorMessage)
    end
end

-- **Loop infinito para repetir o processo**
while true do
    task.wait(2) -- Pequeno delay para evitar bugs
    respawn() -- Respawn no jogo
    task.wait(3) -- Espera um pouco para garantir que tudo carregue
    updateClothing() -- **Executa o código de atualização de roupas**
    task.wait(1)

    claimCompasses() -- **Pega os Compasses**
    task.wait(2)

    teleportToSam() -- **Teleporta para a ilha do Sam**
    task.wait(2)

    dropAllCompasses() -- **Dropa todos os Compass**
    task.wait(2)

    rejoin() -- **Reentra no servidor**
end
