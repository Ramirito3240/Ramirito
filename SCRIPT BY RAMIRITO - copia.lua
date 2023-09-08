local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()

local X = Material.Load({
	Title = "Ramirito",
	Style = 3,
	SizeX = 140,
	SizeY = 290,
	Theme = "Aqua",
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
local fov = 150
local smoothing = 1
local teamCheck = false -- Cambiado para que sea configurable

local RunService = game:GetService("RunService")

local FOVring = Drawing.new("Circle")
FOVring.Visible = false
FOVring.Thickness = 1.5
FOVring.Radius = fov
FOVring.Transparency = 0
FOVring.Color = Color3.fromRGB(255, 128, 128)
FOVring.Position = workspace.CurrentCamera.ViewportSize / 2

local function getClosest(cframe)
    local ray = Ray.new(cframe.Position, cframe.LookVector).Unit

    local target = nil
    local mag = math.huge

    for i, v in pairs(game.Players:GetPlayers()) do
        if v.Character and v.Character:FindFirstChild("Head") and v.Character:FindFirstChild("Humanoid") and v.Character:FindFirstChild("HumanoidRootPart") and v ~= game.Players.LocalPlayer and (v.Team ~= game.Players.LocalPlayer.Team or (not teamCheck)) then
            local direction = (v.Character.Head.Position - ray.Origin).unit
            local angle = math.acos(direction:Dot(ray.Direction))

            if angle <= math.rad(fov) then
                local magBuf = (v.Character.Head.Position - ray:ClosestPoint(v.Character.Head.Position)).Magnitude

                if magBuf < mag then
                    mag = magBuf
                    target = v
                end
            end
        end
    end

    return target
end

local loop

local function onRenderStepped()
    local UserInputService = game:GetService("UserInputService")
    local pressed = UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2)
    local localPlay = game.Players.LocalPlayer.Character
    local cam = workspace.CurrentCamera
    local zz = workspace.CurrentCamera.ViewportSize / 2

    if pressed then
        local Line = Drawing.new("Line")
        local curTar = getClosest(cam.CFrame)
        local ssHeadPoint = cam:WorldToScreenPoint(curTar.Character.Head.Position)
        ssHeadPoint = Vector2.new(ssHeadPoint.X, ssHeadPoint.Y)
        if (ssHeadPoint - zz).Magnitude < fov then
            workspace.CurrentCamera.CFrame = workspace.CurrentCamera.CFrame:Lerp(CFrame.new(cam.CFrame.Position, curTar.Character.Head.Position), smoothing)
        end
    end

    if UserInputService:IsKeyDown(Enum.KeyCode.Delete) then
        loop:Disconnect()
        FOVring:Remove()
    end
end

loop = RunService.RenderStepped:Connect(onRenderStepped)


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



local B = Y.Toggle({
	Text = "ESP",
	Callback = function(Value)
    if Value then
-------------------------------------------------------------------------------------------


------------------------------------------------------------------------------------------------

 _G.FriendColor = Color3.fromRGB(0, 0, 255)
 _G.EnemyColor = Color3.fromRGB(255, 0, 0)
 _G.UseTeamColor = true -- Utiliza los colores de equipo
 
 --------------------------------------------------------------------------------------------
 local Holder = Instance.new("Folder", game.CoreGui)
 Holder.Name = "ESP"
 
 local Box = Instance.new("BoxHandleAdornment")
 Box.Name = "nilBox"
 Box.Size = Vector3.new(1, 2, 1)
 Box.Color3 = Color3.new(100 / 255, 100 / 255, 100 / 255)
 Box.Transparency = 1
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
 
     local nameTagText = Instance.new("TextLabel", t)
     nameTagText.Name = "NameTagText"
     nameTagText.BackgroundTransparency = 1
     nameTagText.Position = UDim2.new(0, 0, 0, 0)
     nameTagText.Size = UDim2.new(1, 0, 0.5, 0) -- Mitad superior para el nombre
     nameTagText.TextSize = 18
     nameTagText.TextColor3 = Color3.new(1, 1, 1)
     nameTagText.Font = Enum.Font.SourceSansBold
     nameTagText.TextStrokeTransparency = 0.4
     nameTagText.Text = v.DisplayName
 
     local healthLabel = Instance.new("TextLabel", t)
     healthLabel.Name = "HealthLabel"
     healthLabel.BackgroundTransparency = 1
     healthLabel.Position = UDim2.new(0, 0, 0.3, 0) -- Mitad inferior para la vida
     healthLabel.Size = UDim2.new(1, 0, 0.5, 0)
     healthLabel.TextSize = 18
     healthLabel.TextColor3 = Color3.new(1, 1, 1)
     healthLabel.Font = Enum.Font.SourceSansBold
     healthLabel.TextStrokeTransparency = 0.4
 
     local function updateNameTag()
         if v.Character and v.Character:FindFirstChild("Humanoid") then
             local maxHealth = math.floor(v.Character.Humanoid.MaxHealth)
             local health = math.floor(v.Character.Humanoid.Health)
             healthLabel.Text = "" .. health .. " / " .. maxHealth
         else
             healthLabel.Text = ""
         end
     end
 
     updateNameTag()
     v.Character:WaitForChild("Humanoid").Changed:Connect(updateNameTag)
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
 
 
    else
        local scriptToRemove = game.CoreGui:FindFirstChild("ESP") -- Cambia "ESP" por el nombre del script que deseas eliminar

        if scriptToRemove then
            scriptToRemove:Remove()
        end   
-----------------------------------------------------------------------------------------

    
    end    
	end,
	Enabled = false
})

local B = Y.Toggle({
	Text = "ITEMS",
	Callback = function(Value)
    if Value then
	-- Encuentra la carpeta "Workspace.Game.Entities.ItemPickup"
    local carpetaItemPickup = workspace:FindFirstChild("Game"):FindFirstChild("Entities"):FindFirstChild("ItemPickup")

    -- Verifica si la carpeta existe
    if carpetaItemPickup then
        -- Itera a través de los objetos en la carpeta
        for _, objeto in pairs(carpetaItemPickup:GetChildren()) do
            if objeto:IsA("Model") then
                -- Crea un BillboardGui
                local billboard = Instance.new("BillboardGui")
                billboard.Parent = objeto
                billboard.AlwaysOnTop = true
                billboard.Name = "ObjBillboard"
                billboard.StudsOffset = Vector3.new(0, 1.8, 0)
                billboard.Size = UDim2.new(0, 100, 0, 40) -- Tamaño del billboard
    
                -- Crea un TextLabel en el BillboardGui para mostrar el nombre
                local label = Instance.new("TextLabel")
                label.Parent = billboard
                label.Text = "obj" -- Cambia "obj" al nombre que desees
                label.Size = UDim2.new(1, 0, 1, 0)
                label.BackgroundTransparency = 1
                label.TextColor3 = Color3.new(0, 1, 00)
                label.TextSize = 10 -- Tamaño del texto
                label.TextStrokeTransparency = 0.4
                label.Font = Enum.Font.SourceSansBold
                label.TextScaled = false
    
                -- Alinea el TextLabel al centro del BillboardGui
                label.Position = UDim2.new(0, 0, 0.5, 0)
                label.AnchorPoint = Vector2.new(0, 0.5)
            end
        end
    else
        print("La carpeta 'Workspace.Game.Entities.ItemPickup' no fue encontrada.")
    end
    else
-- Encuentra la carpeta "Workspace.Game.Entities.ItemPickup"
local carpetaItemPickup = workspace:FindFirstChild("Game"):FindFirstChild("Entities"):FindFirstChild("ItemPickup")

-- Verifica si la carpeta existe
if carpetaItemPickup then
    -- Itera a través de los objetos en la carpeta
    for _, objeto in pairs(carpetaItemPickup:GetChildren()) do
        -- Busca un BillboardGui con el nombre "ObjBillboard" en cada objeto
        local billboard = objeto:FindFirstChild("ObjBillboard")
        if billboard then
            -- Destruye el BillboardGui si se encuentra
            billboard:Destroy()
        end
    end
else
    print("La carpeta 'Workspace.Game.Entities.ItemPickup' no fue encontrada.")
end
end
	end,
	Enabled = false
})
