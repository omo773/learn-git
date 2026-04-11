local replicatedStorage = game:GetService("ReplicatedStorage")
local pushEvant = replicatedStorage.RemoteEvants:WaitForChild("PushEvent") :: RemoteEvent

local pushService = require(replicatedStorage.Shared:WaitForChild("PushService"))

pushEvant.OnServerEvent:Connect(function(player, actionType)
    -- ค้นหาวีลแชร์ที่ผู้เล่นกำลังเข็นอยู่ (สมมติว่าคุณมีระบบเช็กว่าใครเข็นตัวไหนแล้ว)
    local wheelchair = workspace:FindFirstChild("Wheelchair", true) 
    local wheelchair = workspace:FindFirstChild("Wheelchair", true)
    -- ก่อนสั่ง PushService:Push
     wheelchair.PrimaryPart:SetNetworkOwner(nil) -- ให้ Server คุมฟิสิกส์ 100% เพื่อทดสอบ
    if not wheelchair then
        print("หาวีลแชไม่เจอออ")
        return
    end
    
    if actionType == "StartPushing" then
        -- เรียกใช้แรงผลักไปข้างหน้า (Vector3.new(0, 0, 1))
        pushService:Push(wheelchair, Vector3.new(0, 0, 1))
    elseif actionType == "StopPushing" then
        -- หยุดผลัก
        pushService:StopPush(wheelchair)
    end
end)