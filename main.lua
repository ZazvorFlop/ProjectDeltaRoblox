-- ESP Function
local ESP = loadstring(game:HttpGet("https://kiriot22.com/releases/ESP.lua"))()
local library = loadstring(game:HttpGet("https://github.com/GoHamza/AppleLibrary/blob/main/main.lua?raw=true"))()
ESP:Toggle(true)

--Variables
local lplayer = game.Players.LocalPlayer
local mouse = lplayer:GetMouse()
local Current = game.Workspace.CurrentCamera
local enabled = false
local aimbot = true
local aimat = 'Head'
local Track = true


-- Settings
enableAim = false

ESP.Players    = false
ESP.Containers = false
ESP.FaceCamera = true
ESP.BoxSize    = Vector3.new(2.5,2.5,0)
ESP.BoxShift   = CFrame.new(0,0,0)

-- Colors Settings
local notFound = BrickColor.new(235, 52, 216).Color
local itemsColor = {
    ["SmallShippingCrate"] = Color3.fromRGB(255, 255, 255),
    ["SatchelBag"] = Color3.fromRGB(255, 255, 255),
    ["LargeShippingCrate"] = Color3.fromRGB(255, 255, 255),
    ["SportBag"] = Color3.fromRGB(255, 255, 255),
    ["GrenadeCase"] = Color3.fromRGB(255, 255, 255),
    ["SmallMilitaryCrate"] = Color3.fromRGB(255, 122, 155),
    ["MilitaryCrate"] = Color3.fromRGB(255, 122, 155),
    ["LargeMilitaryCrate"] = Color3.fromRGB(255, 122, 155),
    --["Rokakaka"] = Color3.fromRGB(235, 52, 52)
}

-- Get Containers --
local items = game.Workspace.Containers
for i, v in pairs(items:GetChildren()) do
    if v:IsA("Model") then
        local name = v.Name
        local color = itemsColor[name]

        if itemsColor[name] ~= nil then
            color = itemsColor[name]
        end
        
        -- Add ESP
        ESP:Add(v, {
            Name = name,
            Color = color,
            IsEnabled = "Containers"
        })
    end
end

items.ChildAdded:Connect(function(child)
    wait(1)
    if child:IsA("Model") then
        local name = child.ProximityPrompt.ObjectText
        local color = itemsColor[name]
        
        if itemsColor[name] ~= nil then
            color = itemsColor[name]
        end

        -- Add ESP
        ESP:Add(child, {
            Name = name,
            Color = color,
            IsEnabled = "Containers"
        })
    end
end)

--- GUI STUFF ---------------------------------------------------------------
local window = library:init("Pepe Project Delta", true, Enum.KeyCode.RightShift, true)

window:Divider("General")

local ESPTab = window:Section("ESP")

ESPTab:Label("Options...")

ESPTab:Switch("Players", false, function(a)
   ESP.Players = not ESP.Players
end)

ESPTab:Switch("Containers", false, function(a)
   ESP.Containers = not ESP.Containers
end)

local AimbotTab = window:Section("Aimbot")

AimbotTab:Switch("Aimbot", false, function(a)
   enableAim = not enableAim
end)

--AIMBOT
function GetNearestPlayerToMouse()
    local Users = {}
    local lplayer_hold = {}
    local Distances = {}
    for i, v in pairs(game.Players:GetPlayers()) do
        if v ~= lplayer then
            table.insert(Users, v)
        end
    end
    for i, v in pairs(Users) do
        if aimbot == false then
            if v and (v.Character) ~= nil and v.TeamColor ~= lplayer.TeamColor then
                local aim = v.Character:FindFirstChild(aimat)
                if aim ~= nil then
                    local Distance = (aim.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
                    local ray =
                        Ray.new(
                        game.Workspace.CurrentCamera.CoordinateFrame.p,
                        (mouse.Hit.p - Current.CoordinateFrame.p).unit * Distance
                    )
                    local hit, pos = game.Workspace:FindPartOnRay(ray, game.Workspace)
                    local diff = math.floor((pos - aim.Position).magnitude)
                    lplayer_hold[v.Name .. i] = {}
                    lplayer_hold[v.Name .. i].dist = Distance
                    lplayer_hold[v.Name .. i].plr = v
                    lplayer_hold[v.Name .. i].diff = diff
                    table.insert(Distances, diff)
                end
            end
        elseif aimbot == true then
            local aim = v.Character:FindFirstChild(aimat)
            if aim ~= nil then
                local Distance = (aim.Position - game.Workspace.CurrentCamera.CoordinateFrame.p).magnitude
                local ray =
                    Ray.new(
                    game.Workspace.CurrentCamera.CoordinateFrame.p,
                    (mouse.Hit.p - Current.CoordinateFrame.p).unit * Distance
                )
                local hit, pos = game.Workspace:FindPartOnRay(ray, game.Workspace)
                local diff = math.floor((pos - aim.Position).magnitude)
                lplayer_hold[v.Name .. i] = {}
                lplayer_hold[v.Name .. i].dist = Distance
                lplayer_hold[v.Name .. i].plr = v
                lplayer_hold[v.Name .. i].diff = diff
                table.insert(Distances, diff)
            end
        end
    end

    if unpack(Distances) == nil then
        return false
    end

    local L_Distance = math.floor(math.min(unpack(Distances)))
    if L_Distance > 20 then
        return false
    end

    for i, v in pairs(lplayer_hold) do
        if v.diff == L_Distance then
            return v.plr
        end
    end
    return false
end

function Find()
    Clear()
    Track = true
    spawn(
        function()
            while wait() do
                if Track then
                    Clear()
                    for i, v in pairs(game.Players:GetChildren()) do
                        if v.Character and v.Character:FindFirstChild("Head") then
                            if aimbot == false then
                                if v.TeamColor ~= lplayer.TeamColor then
                                    if v.Character:FindFirstChild("Head") then
                                        create(v.Character.Head, true)
                                    end
                                end
                            else
                                if v.Character:FindFirstChild("Head") then
                                    create(v.Character.Head, true)
                                end
                            end
                        end
                    end
                end
            end
            wait(1)
        end
    )
end

game:GetService("RunService").RenderStepped:connect(
    function()
        if enabled then
            local target = GetNearestPlayerToMouse()
            if (target ~= false) then
                local aim = target.Character:FindFirstChild(aimat)
                if aim then
                    Current.CoordinateFrame = CFrame.new(Current.CoordinateFrame.p, aim.CFrame.p)
                end
            else
            end
        end
    end
)

mouse.KeyDown:connect(
    function(key)
        if key == "q" then
            if aimat == "Head" then
                aimat = "Torso"
            elseif aimat == "Torso" then
                aimat = "Head"
            end
        end
    end
)

local inputService = game:GetService('UserInputService')
local runService = game:GetService('RunService')

local clickCn

inputService.InputBegan:Connect(function(io)
    if (io.UserInputType.Name == 'MouseButton2') and enableAim then
        enabled = true
        clickCn = runService.Heartbeat:Connect(mouse1click)
    end
end)

inputService.InputEnded:Connect(function(io)
    if (io.UserInputType.Name == 'MouseButton2') then
        if (clickCn.Connected) then
            enabled = false
            clickCn:Disconnect()
        end
    end
end)


