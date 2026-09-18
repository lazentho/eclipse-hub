-- Eclipse Hub ESP - Roblox Studio LocalScript
-- Place in StarterPlayer > StarterPlayerScripts.
-- Intended for your own Roblox Studio experience.

local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local settings = {Enabled=true, Boxes=true, Health=true, Hats=true}

local gui = Instance.new("ScreenGui")
gui.Name = "EclipseHub"
gui.ResetOnSpawn = false
gui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local window = Instance.new("Frame")
window.Size = UDim2.fromOffset(310,285)
window.Position = UDim2.new(0,25,.5,-142)
window.BackgroundColor3 = Color3.fromRGB(22,18,35)
window.BorderSizePixel = 0
window.Parent = gui
Instance.new("UICorner",window).CornerRadius = UDim.new(0,10)
local stroke = Instance.new("UIStroke",window)
stroke.Color = Color3.fromRGB(120,75,220)
stroke.Thickness = 1.5

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1,-50,0,42)
title.Position = UDim2.fromOffset(15,0)
title.BackgroundTransparency = 1
title.Text = "ECLIPSE HUB"
title.TextColor3 = Color3.fromRGB(235,225,255)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = window

local function makeButton(parent,text,pos,size)
 local b=Instance.new("TextButton")
 b.Size=size or UDim2.fromOffset(130,32)
 b.Position=pos or UDim2.new()
 b.BackgroundColor3=Color3.fromRGB(45,32,65)
 b.TextColor3=Color3.fromRGB(225,215,245)
 b.Text=text b.Font=Enum.Font.GothamMedium b.TextSize=13 b.Parent=parent
 Instance.new("UICorner",b).CornerRadius=UDim.new(0,7)
 return b
end

local close=makeButton(window,"×",UDim2.new(1,-40,0,5),UDim2.fromOffset(32,32))
local unload=makeButton(window,"Unload",UDim2.new(1,-100,1,-42),UDim2.fromOffset(85,30))
local tabs=Instance.new("Frame",window)
tabs.Size=UDim2.new(1,-30,0,34) tabs.Position=UDim2.fromOffset(15,48) tabs.BackgroundTransparency=1
local content=Instance.new("Frame",window)
content.Size=UDim2.new(1,-30,1,-130) content.Position=UDim2.fromOffset(15,88) content.BackgroundTransparency=1
local espTab=makeButton(tabs,"ESP",UDim2.new(),UDim2.new(.5,-4,1,0))
local settingsTab=makeButton(tabs,"Settings",UDim2.new(.5,4,0,0),UDim2.new(.5,-4,1,0))

local function clearContent() for _,v in ipairs(content:GetChildren()) do v:Destroy() end end
local function toggleRow(label,key,y)
 local row=Instance.new("Frame",content) row.Size=UDim2.new(1,0,0,34) row.Position=UDim2.fromOffset(0,y) row.BackgroundTransparency=1
 local text=Instance.new("TextLabel",row) text.Size=UDim2.new(1,-70,1,0) text.BackgroundTransparency=1 text.Text=label text.TextColor3=Color3.fromRGB(225,215,245) text.Font=Enum.Font.Gotham text.TextSize=14 text.TextXAlignment=Enum.TextXAlignment.Left
 local b=makeButton(row,settings[key] and "ON" or "OFF",UDim2.new(1,-58,0,1),UDim2.fromOffset(58,30))
 local function refresh() b.Text=settings[key] and "ON" or "OFF" b.BackgroundColor3=settings[key] and Color3.fromRGB(91,55,155) or Color3.fromRGB(45,32,65) end
 b.MouseButton1Click:Connect(function() settings[key]=not settings[key] refresh() end) refresh()
end
local function showESP() clearContent() toggleRow("Enable ESP","Enabled",0) toggleRow("Player boxes","Boxes",38) toggleRow("Health lines","Health",76) toggleRow("Chinese hats","Hats",114) end
local function showSettings()
 clearContent()
 local info=Instance.new("TextLabel",content) info.Size=UDim2.new(1,0,1,0) info.BackgroundTransparency=1 info.TextWrapped=true info.Text="Eclipse Hub\n\nRightShift: reopen GUI\nUnload: completely remove ESP and GUI\nStudio-safe local ESP" info.TextColor3=Color3.fromRGB(210,195,235) info.Font=Enum.Font.Gotham info.TextSize=14
end
espTab.MouseButton1Click:Connect(showESP) settingsTab.MouseButton1Click:Connect(showSettings)
close.MouseButton1Click:Connect(function() gui.Enabled=false end)

local dragging=false local dragStart startPosition
window.InputBegan:Connect(function(input)
 if input.UserInputType==Enum.UserInputType.MouseButton1 then dragging=true dragStart=input.Position startPosition=window.Position input.Changed:Connect(function() if input.UserInputState==Enum.UserInputState.End then dragging=false end end) end
end)
UIS.InputChanged:Connect(function(input)
 if dragging and input.UserInputType==Enum.UserInputType.MouseMovement then local d=input.Position-dragStart window.Position=UDim2.new(startPosition.X.Scale,startPosition.X.Offset+d.X,startPosition.Y.Scale,startPosition.Y.Offset+d.Y) end
end)
UIS.InputBegan:Connect(function(input,processed) if not processed and input.KeyCode==Enum.KeyCode.RightShift then gui.Enabled=not gui.Enabled end end)

local drawings={}
local function removePlayer(p) if drawings[p] then for _,v in pairs(drawings[p]) do v:Destroy() end drawings[p]=nil end end
local function createVisual(p)
 if p==LocalPlayer then return end
 local folder=Instance.new("Folder",gui) folder.Name=p.Name.."_ESP"
 local box=Instance.new("Frame",folder) box.BackgroundTransparency=1 box.BorderSizePixel=0
 local outline=Instance.new("UIStroke",box) outline.Color=Color3.fromRGB(180,100,255) outline.Thickness=1
 local health=Instance.new("Frame",folder) health.BackgroundColor3=Color3.fromRGB(90,255,130) health.BorderSizePixel=0
 local hat=Instance.new("TextLabel",folder) hat.BackgroundTransparency=1 hat.Text="▼" hat.TextColor3=Color3.fromRGB(245,190,70) hat.Font=Enum.Font.GothamBold hat.TextSize=26
 drawings[p]={folder=folder,box=box,health=health,hat=hat}
end
for _,p in ipairs(Players:GetPlayers()) do createVisual(p) end
Players.PlayerAdded:Connect(createVisual) Players.PlayerRemoving:Connect(removePlayer)

local renderConnection=RunService.RenderStepped:Connect(function()
 local camera=workspace.CurrentCamera
 for p,o in pairs(drawings) do
  local c=p.Character local h=c and c:FindFirstChildOfClass("Humanoid") local root=c and c:FindFirstChild("HumanoidRootPart") local head=c and c:FindFirstChild("Head")
  local visible=settings.Enabled and c and h and root and h.Health>0
  if not visible then o.box.Visible=false o.health.Visible=false o.hat.Visible=false continue end
  local pos,onScreen=camera:WorldToViewportPoint(root.Position) local hp=camera:WorldToViewportPoint(head and head.Position or root.Position+Vector3.new(0,3,0))
  if not onScreen then o.box.Visible=false o.health.Visible=false o.hat.Visible=false continue end
  local height=math.abs(pos.Y-hp.Y)*2.2 local width=height*.55 local x=pos.X-width/2 local y=pos.Y-height/2
  o.box.Visible=settings.Boxes o.box.Position=UDim2.fromOffset(x,y) o.box.Size=UDim2.fromOffset(width,height)
  o.health.Visible=settings.Health o.health.AnchorPoint=Vector2.new(0,1) o.health.Position=UDim2.fromOffset(x-5,y+height) o.health.Size=UDim2.fromOffset(2,height*math.clamp(h.Health/math.max(h.MaxHealth,1),0,1))
  o.hat.Visible=settings.Hats o.hat.Position=UDim2.fromOffset(pos.X-13,y-28) o.hat.Size=UDim2.fromOffset(26,26)
 end
end)

local unloaded=false
unload.MouseButton1Click:Connect(function()
 if unloaded then return end
 unloaded=true
 if renderConnection then renderConnection:Disconnect() end
 for p in pairs(drawings) do removePlayer(p) end
 gui:Destroy()
end)
showESP()