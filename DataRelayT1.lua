local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")
local player = Players.LocalPlayer

-- **Coordenadas da ilha do Sam**
local samPosition = CFrame.new(-1283, 218, -1348)

-- Função para respawn
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

-- **Função para teleportar para a ilha do Sam**
local function teleportToSam()
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        player.Character.HumanoidRootPart.CFrame = samPosition
    end
end

-- **Função para dropar todos os itens dropáveis do inventário**
local function dropAllItems()
    local backpack = player.Backpack
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    if not humanoid then return end -- Se o humanoid não existir, cancela

    local droppedSomething = false -- Para verificar se dropamos algo

    for _, item in pairs(backpack:GetChildren()) do
        if item:IsA("Tool") and item.CanBeDropped then -- **Verifica se pode ser dropado**
            item.Parent = player.Character -- **Move para a mão do jogador**
            task.wait(0.2) -- Pequeno delay para equipar
            keypress(Enum.KeyCode.Backspace)
            task.wait(0.1)
            keyrelease(Enum.KeyCode.Backspace)
            droppedSomething = true
            task.wait(0.3) -- Tempo extra para garantir o drop
        end
    end

    -- **Se não conseguiu dropar nada, evita loop infinito**
    if not droppedSomething then
        warn("Nenhum item dropável encontrado, seguindo para rejoin...")
    end
end

-- Função para reentrar no servidor
local function rejoin()
    local success, errorMessage = pcall(function()
        TeleportService:Teleport(game.PlaceId, player)
    end)

    if errorMessage and not success then
        warn(errorMessage)
    end
end

-- Executa os passos na ordem correta
local function main()
    task.wait(2) -- Pequeno delay para evitar bugs
    respawn() -- Respawn no jogo
    task.wait(3) -- Espera um pouco para garantir que tudo carregue
    updateClothing() -- **Executa o código de atualização de roupas**
    task.wait(1) 
    
    task.wait(2)
    teleportToSam() -- **Teleporta para a ilha do Sam**
    task.wait(2) 
    dropAllItems() -- **Dropa os itens dropáveis**
    task.wait(2)
    rejoin() -- Reentra no servidor
end

-- Conecta ao evento de respawn
player.CharacterAdded:Connect(function()
    task.wait(1) -- Aguarda o personagem spawnar completamente
    main()
end)

-- Caso o jogador já tenha um personagem carregado, executa imediatamente
if player.Character then
    main()
end
