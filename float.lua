local MENU_NAME = "🤔 Float? MELHOR AINDA! 😈"
local CREDIT_TEXT = "feito por OlhadinhaSo"

local MAIN_COLOR = Color3.fromRGB(18,18,18)
local BUTTON_COLOR = Color3.fromRGB(38,38,38)
local ACCENT_COLOR = Color3.fromRGB(255,90,90)
local TEXT_COLOR = Color3.fromRGB(255,255,255)

local MAX_SPEED = 26
local ACCEL = 2
local SLOW_DIST = 8

local player = game.Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
local hrp = char:WaitForChild("HumanoidRootPart")
local runService = game:GetService("RunService")

local savedCFrame
local flying = false
local currentSpeed = 0
local connection

local gui = Instance.new("ScreenGui", player.PlayerGui)
gui.Name = "FloatMenu"

local main = Instance.new("Frame", gui)
main.Size = UDim2.new(0, 260, 0, 210)
main.Position = UDim2.new(0, 25, 0.35, 0)
main.BackgroundColor3 = MAIN_COLOR
main.BorderSizePixel = 0
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

local stroke = Instance.new("UIStroke", main)
stroke.Color = ACCENT_COLOR
stroke.Thickness = 1
stroke.Transparency = 0.4

local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1, -10, 0, 38)
title.Position = UDim2.new(0, 5, 0, 6)
title.Text = MENU_NAME
title.Font = Enum.Font.GothamBold
title.TextColor3 = ACCENT_COLOR
title.TextScaled = true
title.BackgroundTransparency = 1

local function createButton(text, y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.new(0, 220, 0, 42)
	b.Position = UDim2.new(0, 20, 0, y)
	b.Text = text
	b.Font = Enum.Font.Gotham
	b.TextScaled = true
	b.TextColor3 = TEXT_COLOR
	b.BackgroundColor3 = BUTTON_COLOR
	Instance.new("UICorner", b).CornerRadius = UDim.new(0, 12)

	b.MouseEnter:Connect(function()
		b.BackgroundColor3 = BUTTON_COLOR:Lerp(ACCENT_COLOR, 0.15)
	end)
	b.MouseLeave:Connect(function()
		b.BackgroundColor3 = BUTTON_COLOR
	end)

	return b
end

local saveBtn = createButton("SALVAR POSIÇÃO", 50)
local flyBtn = createButton("IR VOANDO ATÉ POSIÇÃO", 96)

local credit = Instance.new("TextLabel", main)
credit.Size = UDim2.new(1, -40, 0, 26)
credit.Position = UDim2.new(0, 20, 0, 145)
credit.Text = CREDIT_TEXT
credit.Font = Enum.Font.GothamBold
credit.TextSize = 16
credit.TextColor3 = ACCENT_COLOR
credit.BackgroundTransparency = 1
credit.TextXAlignment = Enum.TextXAlignment.Center

local msg = Instance.new("TextLabel", main)
msg.Size = UDim2.new(1, -20, 0, 24)
msg.Position = UDim2.new(0, 10, 0, 170)
msg.BackgroundTransparency = 1
msg.TextColor3 = ACCENT_COLOR
msg.Font = Enum.Font.Gotham
msg.TextScaled = true
msg.Text = ""

local function showMsg(t)
	msg.Text = t
	task.delay(2, function()
		msg.Text = ""
	end)
end

saveBtn.MouseButton1Click:Connect(function()
	savedCFrame = hrp.CFrame
	showMsg("posição salva")
end)

flyBtn.MouseButton1Click:Connect(function()
	if flying then return end
	if not savedCFrame then
		showMsg("você não salvou a posição")
		return
	end

	flying = true
	currentSpeed = 0

	connection = runService.RenderStepped:Connect(function()
		local diff = savedCFrame.Position - hrp.Position
		local dist = diff.Magnitude

		if dist < 0.6 then
			hrp.Velocity = Vector3.zero
			hrp.CFrame = CFrame.new(savedCFrame.Position)
			connection:Disconnect()
			flying = false
			return
		end

		currentSpeed = math.min(currentSpeed + ACCEL, MAX_SPEED)

		if dist < SLOW_DIST then
			currentSpeed = math.clamp(dist * 2, 6, MAX_SPEED)
		end

		hrp.Velocity = diff.Unit * currentSpeed
	end)
end)
