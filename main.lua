if _G.HVH_LOADED then return end
_G.HVH_LOADED = true

local P = game:GetService("Players")
local R = game:GetService("RunService")
local U = game:GetService("UserInputService")
local C = workspace.CurrentCamera
local L = P.LocalPlayer

local AIM_KEY = Enum.KeyCode.E
local FOV = 150
local SMOOTH = 0.25

local aim = false

local function esp(v)
    if v == L then return end
    v.CharacterAdded:Connect(function(c)
        local h = Instance.new("Highlight", c)
        h.FillColor = Color3.new(1, 0, 0)
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.5
    end)
    if v.Character then
        local h = Instance.new("Highlight", v.Character)
        h.FillColor = Color3.new(1, 0, 0)
        h.OutlineColor = Color3.new(1, 1, 1)
        h.FillTransparency = 0.5
    end
end

for _, v in pairs(P:GetPlayers()) do esp(v) end
P.PlayerAdded:Connect(esp)

U.InputBegan:Connect(function(i, g)
    if not g and i.KeyCode == AIM_KEY then aim = true end
end)
U.InputEnded:Connect(function(i)
    if i.KeyCode == AIM_KEY then aim = false end
end)

R.RenderStepped:Connect(function()
    if not aim then return end
    local t, d = nil, FOV
    local sc = Vector2.new(C.ViewportSize.X / 2, C.ViewportSize.Y / 2)
    for _, v in pairs(P:GetPlayers()) do
        if v ~= L and v.Character then
            local h = v.Character:FindFirstChild("Head")
            local hu = v.Character:FindFirstChild("Humanoid")
            if h and hu and hu.Health > 0 then
                local sp, on = C:WorldToViewportPoint(h.Position)
                if on then
                    local dd = (Vector2.new(sp.X, sp.Y) - sc).Magnitude
                    if dd < d then d = dd; t = h end
                end
            end
        end
    end
    if t then
        local dir = (t.Position - C.CFrame.Position).Unit
        C.CFrame = C.CFrame:Lerp(CFrame.new(C.CFrame.Position, C.CFrame.Position + dir), SMOOTH)
    end
end)
