-- Memuat layanan dasar Roblox
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- Membuat ScreenGui untuk Tombol Toggle Remover
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "FlamesHubRemoverToggleGui"
toggleGui.ResetOnSpawn = false

-- Menyimpan GUI di lokasi yang aman
if typeof(get_hui) == "function" then
    toggleGui.Parent = get_hui()
else
    toggleGui.Parent = CoreGui or PlayerGui
end

-- Membuat Tombol Melayang
local toggleButton = Instance.new("TextButton")
toggleButton.Name = "RemoverToggleButton"
toggleButton.Size = UDim2.new(0, 150, 0, 35)
toggleButton.Position = UDim2.new(0, 15, 0.4, 0) -- Posisi di kiri layar
toggleButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Warna Merah (Status Off)
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.Text = "Remover: OFF"
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 15
toggleButton.ZIndex = 999999
toggleButton.Parent = toggleGui

-- Membuat Sudut Tumpul pada Tombol
local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 8)
corner.Parent = toggleButton

-- Menambahkan Fitur Drag (Bisa Digeser)
local userGameSettings = UserSettings():GetService("UserGameSettings")
local isDragging = false
local dragStart, startPos

toggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
        dragStart = input.Position
        startPos = toggleButton.Position
    end
end)

toggleButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local delta = input.Position - dragStart
        toggleButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

-- Logika Penyembunyian / Menampilkan GUI Flames Hub
local isRemoverActive = false

local function setFlamesHubVisibility(visible)
    local targets = {CoreGui, PlayerGui}
    if typeof(get_hui) == "function" then
        table.insert(targets, get_hui())
    end

    for _, parent in ipairs(targets) do
        if parent then
            for _, v in pairs(parent:GetDescendants()) do
                -- Mencari Watermark (PrefixCreditsGui)
                if v:IsA("ScreenGui") and v.Name == "PrefixCreditsGui_LifeTogether" then
                    v.Enabled = visible
                -- Mencari Watermark TextLabel bawaan
                elseif v:IsA("TextLabel") and (v.Text:find("Flames Hub") or v.Text:find("Made By:") or v.Text:find("UUID:")) then
                    local container = v.Parent
                    if container and container:IsA("Frame") then
                        container.Visible = visible
                    else
                        v.Visible = visible
                    end
                -- Mencari Menu UI Utama Flames Hub (Kecuali tombol toggle ini)
                elseif v:IsA("ScreenGui") and v ~= toggleGui then
                    if v.Name:lower():find("flames") or v.Name:lower():find("lifetogether") or v.Name:lower():find("hub") then
                        v.Enabled = visible
                    end
                end
            end
        end
    end
end

-- Aksi Saat Tombol Diklik
toggleButton.MouseButton1Click:Connect(function()
    isRemoverActive = not isRemoverActive

    if isRemoverActive then
        -- REMOVER ON: Sembunyikan Semua GUI Flames Hub & Watermark
        toggleButton.Text = "Remover: ON"
        toggleButton.BackgroundColor3 = Color3.fromRGB(30, 200, 30) -- Warna Hijau
        setFlamesHubVisibility(false)
    else
        -- REMOVER OFF: Tampilkan Kembali Semua GUI
        toggleButton.Text = "Remover: OFF"
        toggleButton.BackgroundColor3 = Color3.fromRGB(200, 30, 30) -- Warna Merah
        setFlamesHubVisibility(true)
    end
end)
