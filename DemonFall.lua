--[[
Este é um comentário de múltiplas linhas.
]]


local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer
local character = player.Character or player.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")
local hrp = character:WaitForChild("HumanoidRootPart")

local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/MetatronXTryHard/Outhers/752c29e5ca827e9d312877715936b2f1a644b49e/UI/RedzLibV5-main/Source.Lua"))()

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Valores Globais

_G.FarmTrinket = false
_G.TweenSpeed = 400
_G.CharacterSpeed = 16

getgenv().Enabled = true
getgenv().Speed = 100
getgenv().StopTween = false
getgenv().executed = false
local autoFarmKaigaku = false
local autoFarmGyutaro = false
local teleportEnabled = false

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- FUNÇÃO PARA VIDA INFINITA

local stopDefinirVidaComoNan = false

local function definirVidaComoNan()
    stopDefinirVidaComoNan = false
    local players = game:GetService("Players")
    local player = players.LocalPlayer
    if player then
        local character = player.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                while not stopDefinirVidaComoNan do
                    humanoid.Health = math.huge / 0 -- Define a saúde do personagem como "nan"
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

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO TP CFrame
function toposTP(targetCFrame)
    hrp.CFrame = targetCFrame
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO FARM TP TRINKETS
local function TrinketFarm()
    while _G.FarmTrinket do
        task.wait()
        local spawnFolder = workspace.Trinkets:GetChildren()
        for _, trinket in pairs(spawnFolder) do
            if not _G.FarmTrinket then break end
            local distance = (trinket.Position - hrp.Position).Magnitude
            
            -- Teletransporte instantâneo
            hrp.CFrame = trinket.CFrame
            
            wait(2.0) -- Ajuste conforme necessário para coletar o trinket
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO PARA MOVER JOGADOR ATÉ KAIGAKU
local function topos(Pos)
    local humanoidRootPart = player.Character.HumanoidRootPart
    local distance = (Pos.Position - humanoidRootPart.Position).Magnitude

    if player.Character.Humanoid.Sit then
        player.Character.Humanoid.Sit = false
    end

    local tweenInfo = TweenInfo.new(distance / _G.TweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = Pos})

    tween:Play()
    tween.Completed:Wait()

    if distance <= 10 then
        tween:Cancel()
        humanoidRootPart.CFrame = Pos
    end

    if getgenv().StopTween then
        tween:Cancel()
        getgenv().Tween = false
    end
end

-- FUNÇÃO DE MATAR KAIGAKU
local function attackKaigaku()
    local args = {
        [1] = "Combat",
        [2] = "Server"
    }
    ReplicatedStorage.Remotes.Async:FireServer(unpack(args))
end

-- FUNÇÃO PARA INICIAR O LOOP DA VARIÁVEL KAIGAKU
local function startAutoFarmKaigaku()
    while autoFarmKaigaku do
        local kaigaku = workspace:FindFirstChild("Kaigaku")
        if kaigaku then
            -- Move até Kaigaku
            topos(kaigaku.HumanoidRootPart.CFrame)
            -- Ataca Kaigaku
            attackKaigaku()
        end
        wait() -- Ajuste o intervalo conforme necessário
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Função para mover jogador até Gyutaro
local function topos(Pos)
    local humanoidRootPart = player.Character.HumanoidRootPart
    local distance = (Pos.Position - humanoidRootPart.Position).Magnitude

    if player.Character.Humanoid.Sit then
        player.Character.Humanoid.Sit = false
    end

    local tweenInfo = TweenInfo.new(distance / _G.TweenSpeed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local tween = TweenService:Create(humanoidRootPart, tweenInfo, {CFrame = Pos})

    tween:Play()
    tween.Completed:Wait()

    if distance <= 10 then
        tween:Cancel()
        humanoidRootPart.CFrame = Pos
    end

    if getgenv().StopTween then
        tween:Cancel()
        getgenv().Tween = false
    end
end

-- Função de atacar Gyutaro
local function attackGyutaro()
    local args = {
        [1] = "Combat",
        [2] = "Server"
    }
    ReplicatedStorage.Remotes.Async:FireServer(unpack(args))
end

-- Função para iniciar o loop da variável Gyutaro
local function startAutoFarmGyutaro()
    while autoFarmGyutaro do
        local gyutaro = workspace:FindFirstChild("Gyutaro")
        if gyutaro then
            -- Move até Gyutaro
            topos(gyutaro.HumanoidRootPart.CFrame)
            -- Ataca Gyutaro
            attackGyutaro()
        end
        wait() -- Ajuste o intervalo conforme necessário
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO SPAMAR TECLA "E"
local function SpamKeyE()
    while teleportEnabled do
        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        wait(0.1) -- Espera 0.1 segundos antes de soltar a tecla "E"
        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game)
        wait(0.1) -- Espera 0.1 segundos antes de pressionar novamente
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO DO NO CLIP
local NoClip = false

local function ToggleNoClip(Enabled)
    NoClip = Enabled
    if Enabled then
        RunService.Stepped:Connect(function()
            if NoClip then
                for _, part in pairs(player.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.CanCollide then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        for _, part in pairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = true
            end
        end
        player.Character.Humanoid.WalkSpeed = _G.CharacterSpeed
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- FUNÇÃO PARA MODIFICAR A WALKSPEED

local function bypassWalkSpeed()
    if getgenv().executed then
        print("Walkspeed Already Bypassed - Applying Settings Changes")
        if not getgenv().Enabled then
            return
        end
    else
        getgenv().executed = true
        print("Walkspeed Bypassed")

        local mt = getrawmetatable(game)
        setreadonly(mt, false)

        local oldindex = mt.__index
        mt.__index = newcclosure(function(self, b)
            if b == 'WalkSpeed' then
                return 16
            end
            return oldindex(self, b)
        end)
    end
end

local function startWalkSpeedLoop()
    -- Conectar a função bypassWalkSpeed ao evento CharacterAdded
    Players.LocalPlayer.CharacterAdded:Connect(function(char)
        bypassWalkSpeed()
        char:WaitForChild("Humanoid").WalkSpeed = getgenv().Speed
    end)

    -- Loop para manter a velocidade atualizada
    while getgenv().Enabled and wait() do
        local character = Players.LocalPlayer.Character
        if character then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid.WalkSpeed = getgenv().Speed
            end
        end
    end
end

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- TABS E SESSÕES

local Window = redzlib:MakeWindow({
    Title = "PLUG'S HUB : Demonfall Script",
    SubTitle = "    by @enzokkj",
    SaveFolder = "Teste Folder | redz lib v5.lua"
})

local MainTab1 = Window:MakeTab({"Main Tab", "FARM"})
local ModTab2 = Window:MakeTab({"Player Mod", "MODIFICAÇÕES"})
local MiscTab3 = Window:MakeTab({"Miscellaneous", "DIVERSOS"})
local SkillsTab4 = Window:MakeTab({"Auto Skills", "BREATHING"})
local TeleportTab5 = Window:MakeTab({"Teleports", "Tp Service"})

Window:SelectTab(MainTab1)

local Section1 = MainTab1:AddSection({"Auto Farm"})
local Section2 = ModTab2:AddSection({"Modificações"})
local Section3 = MiscTab3:AddSection({"Diversos"})
local Section4 = SkillsTab4:AddSection({"Auto Skills"})
local Section5 = TeleportTab5:AddSection({"Teleports"})


------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TUDO DA TAB 1
local Tab1Toggle2 = MainTab1:AddToggle({
    Name = "Auto Farm Kaigaku",
    Description = "This will auto <font color='rgb(88, 101, 242)'>kill kaigaku</font> for you.",
    Default = false,
    Callback = function(Value)
        autoFarmKaigaku = Value
        if autoFarmKaigaku then
            spawn(startAutoFarmKaigaku)
        end
    end
})

-- TUDO DA TAB 1
local Tab1Toggle2 = MainTab1:AddToggle({
    Name = "Auto Farm Gyutaro",
    Description = "This will auto <font color='rgb(88, 101, 242)'>kill gyutaro</font> for you.",
    Default = false,
    Callback = function(Value)
        autoFarmGyutaro = Value
        if Value then
            spawn(startAutoFarmGyutaro)
        end
    end
})

local Tab1Toggle2 = MainTab1:AddToggle({
    Name = "Auto Farm Trinket",
    Description = "This will auto farm all <font color='rgb(88, 101, 242)'>trinkets</font> for you.",
    Default = false,
    Callback = function(Value)
        _G.FarmTrinket = Value
        if Value then
            spawn(TrinketFarm)
        end
    end
})

local Tab2Toggle2 = MainTab1:AddToggle({
    Name = "Auto Execute",
    Description = "This will <font color='rgb(88, 101, 242)'>auto execute mobs</font> for you.",
    Default = false,
    Callback = function(Value)
        local args = {
            [1] = "Character",
            [2] = "Execute"
        }
        
        game:GetService("ReplicatedStorage").Remotes.Sync:InvokeServer(unpack(args))
    end
})

local Tab1Toggle3 = MainTab1:AddToggle({
    Name = "Auto Collect",
    Description = "This will collect all <font color='rgb(88, 101, 242)'>trinkets and drops</font> for you.",
    Default = false,
    Callback = function(Value)
        teleportEnabled = Value
        if Value then
            coroutine.wrap(SpamKeyE)()
        end
    end
})

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TUDO DA TAB 2
local Tab2Toggle1 = ModTab2:AddToggle({
    Name = "No Clip",
    Description = "This will activate <font color='rgb(88, 101, 242)'>no clip</font> for you.",
    Default = false,
    Callback= function(Value)
        ToggleNoClip(Value)
    end
})

local Tab2Toggle2 = ModTab2:AddToggle({
    Name = "WalkSpeed Bypass",
    Description = "This will <font color='rgb(88, 101, 242)'>bypass and change</font> your walkspeed",
    Default = false,
    Callback = function(Value)
        getgenv().Enabled = Value
        if Value then
            bypassWalkSpeed()
            spawn(startWalkSpeedLoop)
        end
    end
})

local Slider = ModTab2:AddSlider({
    Name = "Walk Speed",
    Default = 100,
    Min = 0,
    Max = 500,
    Increment = 10,
    ValueName = "WalkSpeed",
    Callback = function(Value)
        getgenv().Speed = Value
    end
})

local Tab2Toggle3 = ModTab2:AddToggle({
    Name = "Auto Breath",
    Description = "This will <font color='rgb(88, 101, 242)'>auto breath</font> for you (press G to normalize).",
    Default = false,
    Callback = function(Value)
        if Value then
            local args = {
                [1] = "Character",
                [2] = "Breath",
                [3] = true
            }
            ReplicatedStorage.Remotes.Async:FireServer(unpack(args))
        end
    end
})

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TUDO DA TAB 3
local Tab3Button1 = MiscTab3:AddButton({
    Name = "Server Hop",
    Description = "This will teleport you to a new game.",
    Callback = function()
        print("Button clicked, teleporting...")
        TeleportService:Teleport(5094651510)
    end
})

local function EquipKatana()
    local args = {
        [1] = "Katana",
        [2] = "EquippedEvents",
        [3] = true,
        [4] = true
    }
    ReplicatedStorage.Remotes.Async:FireServer(unpack(args))
end

local Tab3Toggle0 = MiscTab3:AddToggle({
    Name = "Equip Katana",
    Description = "This will auto-equip the Katana for you.",
    Default = false,
    Callback = function(Value)
        if Value then
            EquipKatana()
        end
    end
})

local Tab3Toggle1 = MiscTab3:AddToggle({
    Name = "God Mode",
    Description = "The power of imortality.",
    Default = false,
    Callback = function(Value)
        if Value then
            definirVidaComoNan()
        else
            stopDefinirVidaComoNanFunction()
        end
    end
})

local Tab3Toggle2 = MiscTab3:AddToggle({
    Name = "Auto Sell Trinkets",
    Description = "This will auto-sell all your trinkets for you.",
    Default = false,
    Callback = function(Value)
        if Value then
            local args = {
                [1] = "Dialogue",
                [2] = "Talk"
            }
            ReplicatedStorage.Remotes.Sync:InvokeServer(unpack(args))

            local args = {
                [1] = "Dialogue",
                [2] = "Answer",
                [3] = Players.LocalPlayer.Character.Answers.Answer,
                [4] = "Merchant"
            }
            ReplicatedStorage.Remotes.Sync:InvokeServer(unpack(args))

            local args = {
                [1] = "Dialogue",
                [2] = "Untalk"
            }
            ReplicatedStorage.Remotes.Sync:InvokeServer(unpack(args))
        end
    end
})

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TUDO DA TAB 4


local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Função genérica para acionar uma habilidade
local function FireSkill(skillName)
    local args = {
        [1] = skillName,
        [2] = "Server"
    }
    ReplicatedStorage.Remotes.Async:FireServer(unpack(args))
end

-- AUTO SKILL 1
local AutoSkill1 = {
    "Third Fang",
    "First Form: Dance of the Butterfly",
    "Second Form: Eight-Layered Mist",
    "First Form: Dark Moon",
    "Dance of the Fire God",
    "First Form: Thunderclap and Flash",
    "First Form: Roar",
    "First Form: Water Surface Slash",
    "First Form: Shivers of First Love",
    "First Form: Winding Serpent",
    "Stone Crush",
    "First Form: Unknowing Fire",
    "First Form: Dust Claw"
}

-- AUTO SKILL 2
local AutoSkill2 = {
    "Fourth Fang",
    "Second Form: Dance of the Dragonfly",
    "Third Form: Scattering Mist Splash",
    "Third Form: Loathsome Moon",
    "Sun Counter",
    "Thunderclap and Flash, Six Fold",
    "Second Form: Bang",
    "Second Form: Water Wheel",
    "Second Form: Love Pangs",
    "Second Form: Venom Fangs",
    "Second Form: Rising Scorching Sun",
    "Second Form: Purifying Wind",
    "Stone Impale"
}

-- AUTO SKILL 3
local AutoSkill3 = {
    "Fifth Fang",
    "Fourth Form: Dance of the Centipede",
    "Fourth Form: Shifting Flow Slash",
    "Fifth Form: Moon Spirit Calamitous Eddy",
    "Flash Dance",
    "Second Form: Rice Spirit",
    "Fourth Form: Chain Explosion",
    "Third Form: Flowing Dance",
    "Third Form: Catlove Shower",
    "Third Form: Coil Choke",
    "Stone Rampage",
    "Third Form: Flame Bend",
    "Third Form: Lotus Tempest"
}

-- AUTO SKILL 4
local AutoSkill4 = {
    "Finishing Fang",
    "Sixth Form: Dance of the Spider",
    "Fifth Form: Sea of Clouds and Haze",
    "Seventh Form: Mirror of Misfortune, Moonlit",
    "Burning Bones, Summer Sun",
    "Third Form: Thunder Swarm",
    "Fifth Form: String Performance",
    "Fourth Form: Striking Tide",
    "Fifth Form: Healthy Life",
    "Fourth Form: Twin-Headed Reptile",
    "Stone Pillar",
    "Fourth Form: Blooming Flame Undulation",
    "Fifth Form: Gale Slash"
}

-- AUTO SKILL 5
local AutoSkill5 = {
    "Seventh Form: Obscuring Clouds",
    "Sixth Form: Judgement Cut",
    "Eighth Form: Moon-Dragon Ringtail",
    "Clear Blue Sky",
    "Fifth Form: Heat Lightning",
    "Sixth Form: Smoke",
    "Sixth Form: Whirlpool",
    "Sixth Form: Rainbow",
    "Fifth Form: Slithering Serpent",
    "Stone Mountain",
    "Sixth Form: Wind Typhoon"
}

-- AUTO SKILL 6
local AutoSkill6 = {
    "Eleventh Form: Dead Calm",
    "Fake Rainbow",
    "Fourteenth Form: Catastrophe",
    "Ninth Form: Rengoku"
}

-- AUTO SKILL 7
local AutoSkill7 = {
    "Beneficent Radiance",
    "Sixteenth Form: Half Moon"
}

-- AUTO SKILL 8
local AutoSkill8 = {
    "Sun Halo Dragon Head Dance"
}

local toggleStates = {
    AutoSkill1 = false,
    AutoSkill2 = false,
    AutoSkill3 = false,
    AutoSkill4 = false,
    AutoSkill5 = false,
    AutoSkill6 = false,
    AutoSkill7 = false,
    AutoSkill8 = false
}

local function loopAutoSkill(skillFunction, skillName)
    while toggleStates[skillName] do
        skillFunction()
        wait(1) -- Intervalo entre as execuções da habilidade
    end
end

-- Funções para acionar as habilidades automaticamente
local function TriggerAutoSkill(autoSkillList, skillName, toggleState)
    toggleStates[skillName] = toggleState
    for i, skill in ipairs(autoSkillList) do
        if toggleState then
            spawn(function()
                loopAutoSkill(function() FireSkill(skill) end, skillName)
            end)
        end
    end
end

-- Definir os toggles para cada grupo de habilidades

local Tab4Toggle1 = SkillsTab4:AddToggle({
    Name = "Auto Skill 1",
    Description = "Auto use Skill 1",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill1, "AutoSkill1", Value)
    end
})

local Tab4Toggle2 = SkillsTab4:AddToggle({
    Name = "Auto Skill 2",
    Description = "Auto use Skill 2",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill2, "AutoSkill2", Value)
    end
})

local Tab4Toggle3 = SkillsTab4:AddToggle({
    Name = "Auto Skill 3",
    Description = "Auto use Skill 3",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill3, "AutoSkill3", Value)
    end
})

local Tab4Toggle4 = SkillsTab4:AddToggle({
    Name = "Auto Skill 4",
    Description = "Auto use Skill 4",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill4, "AutoSkill4", Value)
    end
})

local Tab4Toggle5 = SkillsTab4:AddToggle({
    Name = "Auto Skill 5",
    Description = "Auto use Skill 5",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill5, "AutoSkill5", Value)
    end
})

local Tab4Toggle6 = SkillsTab4:AddToggle({
    Name = "Auto Skill 6",
    Description = "Auto use Skill 6",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill6, "AutoSkill6", Value)
    end
})

local Tab4Toggle7 = SkillsTab4:AddToggle({
    Name = "Auto Skill 7",
    Description = "Auto use Skill 7",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill7, "AutoSkill7", Value)
    end
})

local Tab4Toggle8 = SkillsTab4:AddToggle({
    Name = "Auto Skill 8",
    Description = "Auto use Skill 8",
    Default = false,
    Callback = function(Value)
        TriggerAutoSkill(AutoSkill8, "AutoSkill8", Value)
    end
})

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- TUDO DA TAB 5

local Tab5Button1 = TeleportTab5:AddButton({
    Name = "Kamakura Village",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to Kamakura Village.",
    Callback = function()
        toposTP(CFrame.new(-2145.868896484375, 1161.6719970703125, -1687.411865234375))
    end
})

local Tab5Button2 = TeleportTab5:AddButton({
    Name = "Hayakawa Village",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Hayakawa Village.",
    Callback = function()
        toposTP(CFrame.new(497.5795593261719, 755.1527709960938, -1961.0640869140625))
    end
})

local Tab5Button3 = TeleportTab5:AddButton({
    Name = "Okuyia Village",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Okuyia Village.",
    Callback = function()
        toposTP(CFrame.new(-3306.818359375, 704.1032104492188, -1267.4078369140625))
    end
})

local Tab5Button4 = TeleportTab5:AddButton({
    Name = "Slayer Corps",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Slayer Corps.",
    Callback = function()
        toposTP(CFrame.new(-2381.958251953125, 871.4876098632812, -6297.939453125))
    end
})

local Tab5Button5 = TeleportTab5:AddButton({
    Name = "Final Selection",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Final Selection.",
    Callback = function()
        toposTP(CFrame.new(-5190.49267578125, 792.6189575195312, -3043.970458984375))
    end
})

local Tab5Button6 = TeleportTab5:AddButton({
    Name = "Okuyia Hideout",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Okuyia Hideout.",
    Callback = function()
        toposTP(CFrame.new(-4396.66552734375, 839.512939453125, 539.9063720703125))
    end
})

local Tab5Button7 = TeleportTab5:AddButton({
    Name = "Demon Sanctuary",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Demon Sanctuary.",
    Callback = function()
        toposTP(CFrame.new(2397.5654296875, 1166.50927734375, -7354.82177734375))
    end
})

local Tab5Button8 = TeleportTab5:AddButton({
    Name = "Forest Hideout",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Forest Hideout.",
    Callback = function()
        toposTP(CFrame.new(-733.1015625, 695.7652587890625, -1530.04541015625))
    end
})

local Tab5Button9 = TeleportTab5:AddButton({
    Name = "Entertainment District",
    Description = "This will <font color='rgb(88, 101, 242)'>teleport</font> you to the Entertainment District.",
    Callback = function()
        toposTP(CFrame.new(-5974.6689453125, 744.239013671875, -6237.72314453125))
    end
})
