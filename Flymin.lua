local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")
local Mouse = Player:GetMouse()
local UserInputService = game:GetService("UserInputService")

local Flying = false
local Speed = 50 -- You can change the flight speed here

-- Function to start/stop flying
local function ToggleFly()
	Flying = not Flying
	
	if Flying then
		-- Setup Physics for flying
		local BodyVelocity = Instance.new("BodyVelocity")
		BodyVelocity.Name = "FlightVelocity"
		BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
		BodyVelocity.Velocity = Vector3.new(0, 0, 0)
		BodyVelocity.Parent = RootPart
		
		local BodyGyro = Instance.new("BodyGyro")
		BodyGyro.Name = "FlightGyro"
		BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
		BodyGyro.CFrame = RootPart.CFrame
		BodyGyro.Parent = RootPart
		
		Humanoid.PlatformStand = true -- Disable falling animation
		
		-- Flying Loop
		task.spawn(function()
			while Flying do
				local Camera = workspace.CurrentCamera
				local Direction = Vector3.new(0, 0, 0)
				
				-- Check Key Inputs for Movement
				if UserInputService:IsKeyDown(Enum.KeyCode.W) then
					Direction = Direction + Camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.S) then
					Direction = Direction - Camera.CFrame.LookVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.A) then
					Direction = Direction - Camera.CFrame.RightVector
				end
				if UserInputService:IsKeyDown(Enum.KeyCode.D) then
					Direction = Direction + Camera.CFrame.RightVector
				end
				
				BodyVelocity.Velocity = Direction * Speed
				BodyGyro.CFrame = Camera.CFrame
				task.wait()
			end
		end)
	else
		-- Cleanup when stopping
		if RootPart:FindFirstChild("FlightVelocity") then
			RootPart.FlightVelocity:Destroy()
		end
		if RootPart:FindFirstChild("FlightGyro") then
			RootPart.FlightGyro:Destroy()
		end
		Humanoid.PlatformStand = false
	end
end

-- Keybind to toggle fly (Press 'E' to fly)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.E then
		ToggleFly()
	end
end)
