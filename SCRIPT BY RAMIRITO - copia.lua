local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local X = Material.Load({
	Title = "Ramirito",
	Style = 3,
	SizeX = 200,
	SizeY = 320,
	Theme = "Dark",
	ColorOverrides = {
		MainFrame = Color3.fromRGB(235,235,235)
	}
})

local Y = X.New({
	Title = "Nya"
})

local A = Y.Button({
	Text = "AIMBOT",
	Callback = function()
--// Cache

		local select = select
		local pcall, getgenv, next, Vector2, mathclamp, type, mousemoverel = select(1, pcall, getgenv, next, Vector2.new, math.clamp, type, mousemoverel or (Input and Input.MouseMove))

		--// Preventing Multiple Processes

		pcall(function()
			getgenv().Aimbot.Functions:Exit()
		end)

		--// Environment

		getgenv().Aimbot = {}
		local Environment = getgenv().Aimbot

		--// Services

		local RunService = game:GetService("RunService")
		local UserInputService = game:GetService("UserInputService")
		local TweenService = game:GetService("TweenService")
		local Players = game:GetService("Players")
		local Camera = workspace.CurrentCamera
		local LocalPlayer = Players.LocalPlayer

		--// Variables

		local RequiredDistance, Typing, Running, Animation, ServiceConnections = 2000, false, false, nil, {}

		--// Script Settings

		Environment.Settings = {
			Enabled = true,
			TeamCheck = false,
			AliveCheck = true,
			WallCheck = false, -- Laggy
			Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
			ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
			ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
			TriggerKey = "MouseButton1",
			Toggle = false,
			LockPart = "UpperTorso" -- Body part to lock on
		}

		Environment.FOVSettings = {
			Enabled = true,
			Visible = false,
			Amount = 90,
			Color = Color3.fromRGB(255, 255, 255),
			LockedColor = Color3.fromRGB(255, 70, 70),
			Transparency =0,
			Sides = 60,
			Thickness = 1,
			Filled = false
		}

		Environment.FOVCircle = Drawing.new("Circle")

		--// Functions

		local function CancelLock()
			Environment.Locked = nil
			if Animation then Animation:Cancel() end
			Environment.FOVCircle.Color = Environment.FOVSettings.Color
		end

		local function GetClosestPlayer()
			if not Environment.Locked then
				RequiredDistance = (Environment.FOVSettings.Enabled and Environment.FOVSettings.Amount or 2000)

				for _, v in next, Players:GetPlayers() do
					if v ~= LocalPlayer then
						if v.Character and v.Character:FindFirstChild(Environment.Settings.LockPart) and v.Character:FindFirstChildOfClass("Humanoid") then
							if Environment.Settings.TeamCheck and v.Team == LocalPlayer.Team then continue end
							if Environment.Settings.AliveCheck and v.Character:FindFirstChildOfClass("Humanoid").Health <= 0 then continue end
							if Environment.Settings.WallCheck and #(Camera:GetPartsObscuringTarget({v.Character[Environment.Settings.LockPart].Position}, v.Character:GetDescendants())) > 0 then continue end

							local Vector, OnScreen = Camera:WorldToViewportPoint(v.Character[Environment.Settings.LockPart].Position)
							local Distance = (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Vector.X, Vector.Y)).Magnitude

							if Distance < RequiredDistance and OnScreen then
								RequiredDistance = Distance
								Environment.Locked = v
							end
						end
					end
				end
			elseif (Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2(Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).X, Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position).Y)).Magnitude > RequiredDistance then
				CancelLock()
			end
		end

		--// Typing Check

		ServiceConnections.TypingStartedConnection = UserInputService.TextBoxFocused:Connect(function()
			Typing = true
		end)

		ServiceConnections.TypingEndedConnection = UserInputService.TextBoxFocusReleased:Connect(function()
			Typing = false
		end)

		--// Main

		local function Load()
			ServiceConnections.RenderSteppedConnection = RunService.RenderStepped:Connect(function()
				if Environment.FOVSettings.Enabled and Environment.Settings.Enabled then
					Environment.FOVCircle.Radius = Environment.FOVSettings.Amount
					Environment.FOVCircle.Thickness = Environment.FOVSettings.Thickness
					Environment.FOVCircle.Filled = Environment.FOVSettings.Filled
					Environment.FOVCircle.NumSides = Environment.FOVSettings.Sides
					Environment.FOVCircle.Color = Environment.FOVSettings.Color
					Environment.FOVCircle.Transparency = Environment.FOVSettings.Transparency
					Environment.FOVCircle.Visible = Environment.FOVSettings.Visible
					Environment.FOVCircle.Position = Vector2(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
				else
					Environment.FOVCircle.Visible = false
				end

				if Running and Environment.Settings.Enabled then
					GetClosestPlayer()

					if Environment.Locked then
						if Environment.Settings.ThirdPerson then
							Environment.Settings.ThirdPersonSensitivity = mathclamp(Environment.Settings.ThirdPersonSensitivity, 0.1, 5)

							local Vector = Camera:WorldToViewportPoint(Environment.Locked.Character[Environment.Settings.LockPart].Position)
							mousemoverel((Vector.X - UserInputService:GetMouseLocation().X) * Environment.Settings.ThirdPersonSensitivity, (Vector.Y - UserInputService:GetMouseLocation().Y) * Environment.Settings.ThirdPersonSensitivity)
						else
							if Environment.Settings.Sensitivity > 0 then
								Animation = TweenService:Create(Camera, TweenInfo.new(Environment.Settings.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)})
								Animation:Play()
							else
								Camera.CFrame = CFrame.new(Camera.CFrame.Position, Environment.Locked.Character[Environment.Settings.LockPart].Position)
							end
						end

						Environment.FOVCircle.Color = Environment.FOVSettings.LockedColor

					end
				end
			end)

			ServiceConnections.InputBeganConnection = UserInputService.InputBegan:Connect(function(Input)
				if not Typing then
					pcall(function()
						if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
							if Environment.Settings.Toggle then
								Running = not Running

								if not Running then
									CancelLock()
								end
							else
								Running = true
							end
						end
					end)

					pcall(function()
						if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
							if Environment.Settings.Toggle then
								Running = not Running

								if not Running then
									CancelLock()
								end
							else
								Running = true
							end
						end
					end)
				end
			end)

			ServiceConnections.InputEndedConnection = UserInputService.InputEnded:Connect(function(Input)
				if not Typing then
					if not Environment.Settings.Toggle then
						pcall(function()
							if Input.KeyCode == Enum.KeyCode[Environment.Settings.TriggerKey] then
								Running = false; CancelLock()
							end
						end)

						pcall(function()
							if Input.UserInputType == Enum.UserInputType[Environment.Settings.TriggerKey] then
								Running = false; CancelLock()
							end
						end)
					end
				end
			end)
		end

		--// Functions

		Environment.Functions = {}

		function Environment.Functions:Exit()
			for _, v in next, ServiceConnections do
				v:Disconnect()
			end

			if Environment.FOVCircle.Remove then Environment.FOVCircle:Remove() end

			getgenv().Aimbot.Functions = nil
			getgenv().Aimbot = nil

			Load = nil; GetClosestPlayer = nil; CancelLock = nil
		end

		function Environment.Functions:Restart()
			for _, v in next, ServiceConnections do
				v:Disconnect()
			end

			Load()
		end

		function Environment.Functions:ResetSettings()
			Environment.Settings = {
				Enabled = true,
				TeamCheck = false,
				AliveCheck = true,
				WallCheck = false,
				Sensitivity = 0, -- Animation length (in seconds) before fully locking onto target
				ThirdPerson = false, -- Uses mousemoverel instead of CFrame to support locking in third person (could be choppy)
				ThirdPersonSensitivity = 3, -- Boundary: 0.1 - 5
				TriggerKey = "MouseButton1",
				Toggle = false,
				LockPart = "UpperTorso" -- Body part to lock on
			}

			Environment.FOVSettings = {
				Enabled = false,
				Visible = false,
				Amount = 90,
				Color = Color3.fromRGB(255, 255, 255),
				LockedColor = Color3.fromRGB(255, 70, 70),
				Transparency = 0,
				Sides = 60,
				Thickness = 1,
				Filled = false
			}
		end

		--// Load

		Load()

		end
})

local B = Y.Button({
	Text = "CAFE",
	Callback = function()

        repeat wait() until game:IsLoaded() 

		getgenv().Fix = true

		getgenv().TeclasWS = {
			["tecla1"] = "M", -- speed +5
			["tecla2"] = "N", -- speed -5
			["tecla3"] = "V" -- toggle  
		}



		-- // servicios
		local MININOS_DOXXEADOS = game:GetService("Players")
		local AUDIOS_LOUD_DE_TRAP = game:GetService("StarterGui") or "son una mierda"

		-- // objetos
		local neonazi = MININOS_DOXXEADOS.LocalPlayer
		local esvastica = neonazi:GetMouse()

		-- // variables
		local lista_de_victimas_de_drizzy = getrenv()._G
		local da_hood_rblxm_REAL = getrawmetatable(game)
		local CP = da_hood_rblxm_REAL.__newindex
		local CP_DE_DRIZZY = da_hood_rblxm_REAL.__index
		local velocidad_de_cum = 29
		local es_pedofilo = true

		-- // funciones para acortar codigo :]
		function anunciar_atentado_terrorista(fecha_del_atentado)
			AUDIOS_LOUD_DE_TRAP:SetCore("SendNotification",{
				Title="Ramirito#4826",
				Text=fecha_del_atentado,
				Icon="rbxthumb://type=Asset&id=1332213374&w=150&h=150"
			})
		end


		getgenv().TECHWAREWALKSPEED_LOADED = true


		wait(1.5)


		anunciar_atentado_terrorista("Welcome"..TeclasWS.tecla3.."")

		-- // conexión
		esvastica.KeyDown:Connect(function(el_impostor)
			if el_impostor:lower() == TeclasWS.tecla1:lower() then
				velocidad_de_cum = velocidad_de_cum + 1
				anunciar_atentado_terrorista(" (speed =   "..tostring(velocidad_de_cum)..")")
			elseif el_impostor:lower() == TeclasWS.tecla2:lower() then
				velocidad_de_cum = velocidad_de_cum - 1
				anunciar_atentado_terrorista(" (speed =  "..tostring(velocidad_de_cum)..")")
			elseif el_impostor:lower() == TeclasWS.tecla3:lower() then
				if es_pedofilo then
					es_pedofilo = false
					anunciar_atentado_terrorista("speed off")
				else
					es_pedofilo = true
					anunciar_atentado_terrorista("speed on")
				end
			end
		end)

		-- // mi parte favorita: metametodos
		setreadonly(da_hood_rblxm_REAL,false)
		da_hood_rblxm_REAL.__index = newcclosure(function(BEST_ON_TOP,IS_GARBAGE)
			local esPedofilo = checkcaller()
			if IS_GARBAGE == "WalkSpeed" and not esPedofilo then
				return lista_de_victimas_de_drizzy.CurrentWS
			end
			return CP_DE_DRIZZY(BEST_ON_TOP,IS_GARBAGE)
		end)
		da_hood_rblxm_REAL.__newindex = newcclosure(function(kaias,ip,logger)
			local unNeonazi = checkcaller()
			if es_pedofilo then
				if ip == "WalkSpeed" and logger ~= 0 and not unNeonazi then
					return CP(kaias,ip,velocidad_de_cum)
				end
			end
			return CP(kaias,ip,logger)
		end)
		setreadonly(da_hood_rblxm_REAL,true)

		repeat wait() until game:IsLoaded()
		local Players = game:service('Players')
		local Player = Players.LocalPlayer

		repeat wait() until Player.Character

		local userInput = game:service('UserInputService')
		local runService = game:service('RunService')

		local Multiplier = -0.22
		local Enabled = false
		local whentheflashnoiq

		userInput.InputBegan:connect(function(Key)
			if Key.KeyCode == Enum.KeyCode.LeftBracket then
				Multiplier = Multiplier + 0.01
				print(Multiplier)
				wait(0.2)
				while userInput:IsKeyDown(Enum.KeyCode.LeftBracket) do
					wait()
					Multiplier = Multiplier + 0.01
					print(Multiplier)
				end
			end

			if Key.KeyCode == Enum.KeyCode.RightBracket then
				Multiplier = Multiplier - 0.01
				print(Multiplier)
				wait(0.2)
				while userInput:IsKeyDown(Enum.KeyCode.RightBracket) do
					wait()
					Multiplier = Multiplier - 0.01
					print(Multiplier)
				end
			end

			if Key.KeyCode == Enum.KeyCode.P then
				Enabled = not Enabled
				if Enabled == true then
					repeat
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + game.Players.LocalPlayer.Character.Humanoid.MoveDirection * Multiplier
						game:GetService("RunService").Stepped:waitn()
					until Enabled == true
				end
			end
		end)

		if Fix == true then
			loadstring(game:HttpGet("https://raw.githubusercontent.com/youtubetutorials123/helo/main/123"))()
		end  

		end
})

local C = Y.Button({
	Text = "ESP",
	Callback = function()

 _G.FriendColor = Color3.fromRGB(0, 0, 255)
_G.EnemyColor = Color3.fromRGB(255, 0, 0)
_G.UseTeamColor = false

--------------------------------------------------------------------------------------------
local Holder = Instance.new("Folder", game.CoreGui)
Holder.Name = "ESP"

local Box = Instance.new("BoxHandleAdornment")
Box.Name = "nilBox"
Box.Size = Vector3.new(1, 2, 1)
Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Box.Transparency = 0
Box.ZIndex = 0
Box.AlwaysOnTop = true
Box.Visible = false
--------------------------------------------------------------------------------------------
local NameTag = Instance.new("BillboardGui")
NameTag.Name = "nilNameTag"
NameTag.Enabled = false
NameTag.Size = UDim2.new(0, 200, 0, 50)
NameTag.AlwaysOnTop = true
NameTag.StudsOffset = Vector3.new(0, 1.8, 0)
local Tag = Instance.new("TextLabel", NameTag)
Tag.Name = "Tag"
Tag.BackgroundTransparency = 1
Tag.Position = UDim2.new(0, -50, 0, 0)
Tag.Size = UDim2.new(0, 300, 0, 20)
Tag.TextSize = 15
Tag.TextColor3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
Tag.TextStrokeColor3 = Color3.new(0 / 255, 0 / 255, 0 / 255)
Tag.TextStrokeTransparency = 0.4
Tag.Text = "nil"
Tag.Font = Enum.Font.SourceSansBold
Tag.TextScaled = false

local LoadCharacter = function(v)
	repeat wait() until v.Character ~= nil
	v.Character:WaitForChild("Humanoid")
	local vHolder = Holder:FindFirstChild(v.DisplayName)
	vHolder:ClearAllChildren()
	local b = Box:Clone()
	b.Name = v.DisplayName .. "Box"
	b.Adornee = v.Character
	b.Parent = vHolder
	local t = NameTag:Clone()
	t.Name = v.DisplayName .. "NameTag"
	t.Enabled = true
	t.Parent = vHolder
	t.Adornee = v.Character:WaitForChild("Head", 5)
	if not t.Adornee then
		return UnloadCharacter(v)
	end
	---------------------------------------------------------------------
	t.Tag.Text = v.DisplayName
	b.Color3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
	t.Tag.TextColor3 = Color3.new(v.TeamColor.r, v.TeamColor.g, v.TeamColor.b)
	local Update
	local UpdateNameTag = function()
		if not pcall(function()
			v.Character.Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
			local maxh = math.floor(v.Character.Humanoid.MaxHealth)
			local h = math.floor(v.Character.Humanoid.Health)
		end) then
			Update:Disconnect()
		end
	end
	UpdateNameTag()
	Update = v.Character.Humanoid.Changed:Connect(UpdateNameTag)
end

local UnloadCharacter = function(v)
	local vHolder = Holder:FindFirstChild(v.DisplayName)
	if vHolder and (vHolder:FindFirstChild(v.DisplayName .. "Box") ~= nil or vHolder:FindFirstChild(v.DisplayName .. "NameTag") ~= nil) then
		vHolder:ClearAllChildren()
	end
end

local LoadPlayer = function(v)
	local vHolder = Instance.new("Folder", Holder)
	vHolder.Name = v.DisplayName
	v.CharacterAdded:Connect(function()
		pcall(LoadCharacter, v)
	end)
	v.CharacterRemoving:Connect(function()
		pcall(UnloadCharacter, v)
	end)
	v.Changed:Connect(function(prop)
		if prop == "TeamColor" then
			UnloadCharacter(v)
			wait()
			LoadCharacter(v)
		end
	end)
	LoadCharacter(v)
end

local UnloadPlayer = function(v)
	UnloadCharacter(v)
	local vHolder = Holder:FindFirstChild(v.DisplayName)
	if vHolder then
		vHolder:Destroy()
	end
end

for i,v in pairs(game:GetService("Players"):GetPlayers()) do
	spawn(function() pcall(LoadPlayer, v) end)
end

game:GetService("Players").PlayerAdded:Connect(function(v)
	pcall(LoadPlayer, v)
end)

game:GetService("Players").PlayerRemoving:Connect(function(v)
	pcall(UnloadPlayer, v)
end)

game:GetService("Players").LocalPlayer.NameDisplayDistance = 0

if _G.Reantheajfdfjdgs then
    return
end

_G.Reantheajfdfjdgs = ":suifayhgvsdghfsfkajewfrhk321rk213kjrgkhj432rj34f67df"

local players = game:GetService("Players")
local plr = players.LocalPlayer

function esp(target, color)
    if target.Character then
        if not target.Character:FindFirstChild("GetReal") then
            local highlight = Instance.new("Highlight")
            highlight.RobloxLocked = true
            highlight.Name = "GetReal"
            highlight.Adornee = target.Character
            highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            highlight.FillColor = color
            highlight.Parent = target.Character
        else
            target.Character.GetReal.FillColor = color
        end
    end
end

		end
})

local D = Y.Button({
	Text = "CHAMS",
	Callback = function()

        local RunService = game:GetService("RunService")
		local Players = game:GetService("Players")
		local localPlayer = Players.LocalPlayer

		local function createHighlights()
			-- Clear existing highlights
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer then
					for _, highlight in ipairs(player.Character:GetChildren()) do
						if highlight:IsA("Highlight") then
							highlight:Destroy()
						end
					end
				end
			end

			-- Create highlights for all players
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= localPlayer and player.Character and player.Character:FindFirstChild("Humanoid") then
					local esp = Instance.new("Highlight")
					esp.Name = player.Name
					esp.FillTransparency = 1
					esp.FillColor = Color3.new(1, 0, 0.0156863)
					esp.OutlineColor = player.Character.Humanoid.Health > 0 and Color3.new(0.0666667, 1, 0) or Color3.new(1, 0, 0)
					esp.OutlineTransparency = 0.28
					esp.Parent = player.Character
				end
			end
		end

		-- Run the function initially
		createHighlights()

		-- Connect a function to the Heartbeat event to update the highlights
		local updateDelay = 1 -- Update delay in seconds
		local lastUpdateTime = 0

		RunService.Heartbeat:Connect(function()
			local currentTime = os.clock()
			if currentTime - lastUpdateTime >= updateDelay then
				createHighlights()
				lastUpdateTime = currentTime
			end
		end)  

		end
})
local E = Y.Button({
	Text = "VAULT",
	Callback = function()

local doorbank = game.Workspace.BankRobbery.VaultDoor.Door


	


doorbank.Attachment.ProximityPrompt.HoldDuration = 0



		end
})


local J = Y.Button({
	Text = "CHAT",
	Callback = function()


local METATABLE = {['Delay'] = 1; ['Spam'] = false; ['Mouse'] = game:GetService('Players').LocalPlayer:GetMouse(); ['LocalPlayer'] = game:GetService('Players').LocalPlayer};

getgenv().CHATVIEW = function()
    local CHATVISIBLE = METATABLE['LocalPlayer'].PlayerGui.Chat.Frame 
    CHATVISIBLE.ChatChannelParentFrame.Visible = true 
    CHATVISIBLE.ChatBarParentFrame.Position = CHATVISIBLE.ChatChannelParentFrame.Position + UDim2.new(UDim.new(), CHATVISIBLE.ChatChannelParentFrame.Size.Y)
end
CHATVIEW()



		end
})

local P = Y.Button({
	Text = "EMOTES",
	Callback = function()

local METATABLE = {['Delay'] = 1; ['Spam'] = false; ['Mouse'] = game:GetService('Players').LocalPlayer:GetMouse(); ['LocalPlayer'] = game:GetService('Players').LocalPlayer};

getgenv().CHATVIEW = function()
    local CHATVISIBLE = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Speed.Holder
    local CHATVISIBLE1 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Sturdy.Holder
    local CHATVISIBLE2 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Griddy.Holder
    local CHATVISIBLE3 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.DefaultDance.Holder
    local CHATVISIBLE4 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Floss.Holder
    local CHATVISIBLE5 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Dance1.Holder
    local CHATVISIBLE6 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Cheer.Holder
    local CHATVISIBLE7 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.HypeDance.Holder
    local CHATVISIBLE8 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Jumpingjacks.Holder
    local CHATVISIBLE9 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Lay.Holder
    local CHATVISIBLE0 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.TPose.Holder
    local CHATVISIBLE01 = METATABLE['LocalPlayer'].PlayerGui.Emotes.Frame.ScrollingFrame.Sit.Holder
    CHATVISIBLE.Locked.Visible = false
    CHATVISIBLE1.Locked.Visible = false
    CHATVISIBLE2.Locked.Visible = false
    CHATVISIBLE3.Locked.Visible = false
    CHATVISIBLE4.Locked.Visible = false
    CHATVISIBLE5.Locked.Visible = false
    CHATVISIBLE6.Locked.Visible = false
    CHATVISIBLE7.Locked.Visible = false
    CHATVISIBLE8.Locked.Visible = false
    CHATVISIBLE9.Locked.Visible = false
    CHATVISIBLE0.Locked.Visible = false
    CHATVISIBLE01.Locked.Visible = false

end
CHATVIEW()



		end
})

local J = Y.Button({
	Text = "PAJA FUERTE",
	Callback = function()

-- Encuentra todos los objetos en la workspace
local workspace = game:GetService("Workspace")
local allObjects = workspace:GetDescendants()

-- Itera a través de los objetos y verifica si son ProximityPrompt
for _, object in pairs(allObjects) do
    if object:IsA("ProximityPrompt") then
        -- Establece HoldDuration en 0 o nil
        object.HoldDuration = nil -- Puedes cambiarlo a nil si lo prefieres
    end
end

		end
})