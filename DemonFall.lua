-- FUNÇÃO PARA VIDA INFINITA

local stopDefinirVidaComoNan = false

local function definirVidaComoNan()
    stopDefinirVidaComoNan = false
    local player = game:GetService("Players").LocalPlayer
    if player then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                while not stopDefinirVidaComoNan do
                    humanoid.Health = 0/0 -- Define a saúde do personagem como "NaN"
                    wait(0.1) -- Aguarda um curto período antes de atualizar novamente
                end
            else
                warn("Humanoid não encontrado.")
            end
        else
            warn("Personagem não encontrado.")
        end
    else
        warn("Jogador local não encontrado.")
    end
end

local function stopDefinirVidaComoNanFunction()
    stopDefinirVidaComoNan = true
end

-- Iniciar automaticamente
definirVidaComoNan()
