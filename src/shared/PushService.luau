local PushService = {}

local gameConfig = require(game.ReplicatedStorage.Shared:WaitForChild("GameConfig"))

function PushService:Push(wheelchairModel, directionVector)
    local primaryPart = wheelchairModel.PrimaryPart 
    if not primaryPart then
        warn("Wheelchair model does not have a PrimaryPart.")
        return
    end

    local pushVelocity = primaryPart:FindFirstChild("PushVelocity") :: LinearVelocity
    if not pushVelocity then 
        warn("หา PushVelocity ไม่เจอใน " .. primaryPart.Name) 
        return 
    end

    -- บังคับให้ LinearVelocity ทำงานและมีแรงมหาศาล
    pushVelocity.Enabled = true
     

    -- คำนวณทิศทาง: -directionVector.Z (เพราะ W มักส่งมาเป็น -1 ใน Input)
    local moveZ = directionVector.Z
    local pushDirection = primaryPart.CFrame.LookVector * -moveZ
    
    local currentVelocity = primaryPart.AssemblyLinearVelocity
    local targetVelocity = pushDirection * gameConfig.MaxSpeed

    local  finalVelocity  =  Vector3.new(targetVelocity.X, primaryPart.AssemblyLinearVelocity.Y, targetVelocity.Z)
   
    -- Debug: ถ้า targetVelocity เป็น (0,0,0) แสดงว่าไม่มีแรงส่งมา
    if targetVelocity.Magnitude < 0.1 then
        print("Target velocity is zero - no input detected")
    end

    local lerpSpeed = 0.1 
    -- ใช้ VectorVelocity สำหรับโหมด Vector
    pushVelocity.VectorVelocity = currentVelocity:Lerp(finalVelocity, lerpSpeed)
end

function PushService:StopPush(wheelchairModel)
    local primaryPart = wheelchairModel.PrimaryPart
    if not primaryPart then return end
    
    local pushVelocity = primaryPart:FindFirstChild("PushVelocity") :: LinearVelocity

    if pushVelocity then
        local currentVelocity = primaryPart.AssemblyLinearVelocity
        -- ค่อยๆ ลดความเร็วจนหยุด (จำลองแรงเฉื่อย)
        pushVelocity.VectorVelocity = currentVelocity:Lerp(Vector3.new(0,0,0), 0.05)
        
        -- ถ้าความเร็วต่ำมากแล้ว ให้ปิดแรงผลักเพื่อให้ฟิสิกส์ธรรมชาติ (Gravity) ทำงาน
        if currentVelocity.Magnitude < 0.5 then
            pushVelocity.VectorVelocity = Vector3.new(0,0,0)
             pushVelocity.Enabled = false -- เปิดบรรทัดนี้ถ้าต้องการให้รถไหลลงเขาตามแรงโน้มถ่วง
        end
    end
end

return PushService