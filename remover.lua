-- Cari dan hapus TextLabel yang berisi teks watermark secara otomatis
local function removeWatermark()
    local parent = game:GetService("CoreGui") -- Atau game.Players.LocalPlayer.PlayerGui

    for _, v in pairs(parent:GetDescendants()) do
        if v:IsA("TextLabel") and (v.Text:find("Flames Hub") or v.Text:find("Made By:")) then
            -- Menghapus frame atau background orange di belakangnya
            local container = v.Parent
            if container and container:IsA("Frame") then
                container:Destroy()
            else
                v:Destroy()
            end
        end
    end
end

removeWatermark()
