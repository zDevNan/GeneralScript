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

-- **Função para dropar todos os itens do inventário**
local function dropAllItems()
    local backpack = player.Backpack
    local humanoid = player.Character and player.Character:FindFirstChild("Humanoid")

    if not humanoid then return end -- Se o humanoid não existir, cancela

    while #backpack:GetChildren() > 0 do
        for _, item in pairs(backpack:GetChildren()) do
            if item:IsA("Tool") then
                item.Parent = player.Character -- **Move o item para a mão do jogador**
            end
        end
        
        task.wait(0.2) -- Pequeno delay para garantir que os itens equiparam corretamente
        
        -- **Pressiona e solta Backspace para dropar os itens equipados**
        keypress(Enum.KeyCode.Backspace)
        task.wait(0.1)
        keyrelease(Enum.KeyCode.Backspace)
        
        task.wait(0.5) -- Aguarda antes de tentar pegar mais itens, garantindo que o jogo processou os drops
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
    dropAllItems() -- **Agora dropa absolutamente TUDO da mochila**
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
