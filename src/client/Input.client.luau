local UserInputService = game:GetService("UserInputService") :: UserInputService
local replicatedStorage = game:GetService("ReplicatedStorage")
local pushEvant = replicatedStorage.RemoteEvants:WaitForChild("PushEvent") :: RemoteEvent


local ispressingForward = false

UserInputService.InputBegan:Connect(function(Input,grameprocess)
   if grameprocess then return end

   if Input.KeyCode == Enum.KeyCode.W then
       ispressingForward = true
         pushEvant:FireServer("StartPushing")
        
   end
end)


UserInputService.InputEnded:Connect(function(Input,grameprocess)
   if grameprocess then return end
   if Input.KeyCode == Enum.KeyCode.W then
    ispressingForward = false
    pushEvant:FireServer("StopPushing")

   end

end)