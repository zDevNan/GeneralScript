while wait(8) do
    local player = game.Players.LocalPlayer
    local playerId = player.UserId
    local userDataName = game.Workspace.UserData["User_" .. playerId]

    -- DFT1 Variables
    local AffMelee1 = userDataName.Data.DFT1Melee.Value
    local AffSniper1 = userDataName.Data.DFT1Sniper.Value
    local AffDefense1 = userDataName.Data.DFT1Defense.Value
    local AffSword1 = userDataName.Data.DFT1Sword.Value

    -- Check for DFT1
    if AffSniper1 == 2 and AffSword1 == 2 and AffMelee1 == 2 and AffDefense1 == 2 then
        script.Parent:Destroy()
    end

    local args1 = {
        [1] = "DFT1",
        [2] = false,  -- defense
        [3] = false,  -- melee
        [4] = false,  -- sniper
        [5] = false,  -- sword
        [6] = "Cash"
    }

    if AffDefense1 == 2 then
        args1[2] = 0/0
    end

    if AffMelee1 == 2 then
        args1[3] = 0/0
    end

    if AffSniper1 == 2 then
        args1[4] = 0/0
    end

    if AffSword1 == 2 then
        args1[5] = 0/0
    end

    workspace:WaitForChild("Merchants"):WaitForChild("AffinityMerchant"):WaitForChild("Clickable"):WaitForChild("Retum"):FireServer(unpack(args1))
end
