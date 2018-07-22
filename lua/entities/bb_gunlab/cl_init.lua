include("shared.lua")

net.Receive("bb_gunlab", function()
	local lab = net.ReadEntity()
	local gun = net.ReadString()
	local price = net.ReadInt(32)

	window = vgui.Create("DFrame")
	window:SetSize(394, 244)
	window:Center()
	window:SetTitle("Gun Lab")
	window:MakePopup()
	
	window.OldPaint = window.Paint
	window.Paint = function(_, w, h)
		if not IsValid(lab) then window:Close() end
		window:OldPaint(w, h)
	end
	
	local price2 -- because we set it in icon
	
	local icons = vgui.Create("DPanelList", window)
	icons:EnableHorizontal(true)
	icons:EnableVerticalScrollbar(true)
	icons:SetTall(192)
	icons:Dock(TOP)
	
	for k, v in pairs(CustomShipments) do
		local icon = vgui.Create("SpawnIcon", icons)
		icon:SetSize(64, 64)
		icon:SetModel(v.model)
		icon:SetTooltip(v.category.." / "..v.name)
		icons:AddItem(icon)
		
		icons.Paint = function(_, w, h)
			surface.SetDrawColor(Color(80, 80, 80))
			surface.DrawRect(0, 0, w, h)
		end
		
		icon.DoClick = function()
			surface.PlaySound("garrysmod/content_downloaded.wav")
			gun = v.entity
			price = v.pricesep
			price2:SetValue(price)
		end
		
		icon.OldPaint = icon.Paint
		
		icon.Paint = function()
			if gun == v.entity then
				icon.OverlayFade = 255
			end
			
			icon:OldPaint()
		end
	end
	
	icons:InvalidateLayout()
	
	local label = vgui.Create("DLabel", window)
	label:SetPos(8, 225)
	label:SetText("Price for Gun: ")
	label:SizeToContents()
	
	price2 = vgui.Create("DNumSlider", window)
	price2:SetPos(-64, 223)
	price2:SetSize(384, 16)
	price2:SetMin(0)
	price2:SetMax(10000)
	price2:SetValue(price)
	price2:SetDecimals(0)
	price2.OnValueChanged = function()
		price = price2:GetValue()
	end
	
	local submit = vgui.Create("DButton", window)
	submit:SetPos(308, 224)
	submit:SetSize(82, 16)
	submit:SetText("Submit")
	submit.DoClick = function()
		net.Start("bb_gunlab")
			net.WriteEntity(lab)
			net.WriteString(gun)
			net.WriteInt(price, 32)
		net.SendToServer()
		
		window:Close()
	end
end)


function ENT:Initialize() -- spawn
	self:SetModel("models/props_c17/TrapPropeller_Engine.mdl")

	self.PrinterStats = {}
end

function ENT:GetDistance()
	if not LocalPlayer() then return 384 end
	
	return LocalPlayer():GetPos():Distance(self:GetPos())
end

local function drawRect(x, y, w, h)
	surface.SetDrawColor(Color(255, 255, 255)) -- white "trim"
	surface.DrawOutlinedRect(x, y , w, h)
	
	surface.SetDrawColor(Color(200, 200, 200)) -- gray "trim"
	surface.DrawOutlinedRect(x + 1, y + 1, w - 2, h - 2)

	surface.SetDrawColor(Color(80, 80, 80)) -- gray inside
	surface.DrawRect(x + 2, y + 2, w - 4, h - 4)    
end

local matcache = {}

local function drawIcon(icon, x, y, w, h)
	if !matcache[icon] then matcache[icon] = Material(icon) end

	surface.SetDrawColor(Color(255, 255, 255))
	surface.SetMaterial(matcache[icon])
	surface.DrawTexturedRect(x - (w / 2), y - (h / 2), w, h)
end


function ENT:Draw()
	self:DrawModel()
	
	local pos = self:LocalToWorld(Vector(10.2, -10, 15));
	local ang = self:GetAngles()
	
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), 270)
	
	local name = IsValid(self:GetDealer()) and self:GetDealer():Name().."'s" or ""
	
	cam.Start3D2D(pos, ang, 0.3)
		if self:GetDistance() < 512 then
			draw.DrawText(name, "TargetID", 25, 6, (IsValid(self:GetDealer()) and team.GetColor(self:GetDealer():Team()) or Color(0,0,0)), TEXT_ALIGN_CENTER)   
			draw.DrawText("Gun Lab", "TargetID", 25, 20, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(self:GetNWString("name", ""), "TargetIDSmall", 25, 40, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
			draw.DrawText(DarkRP.formatMoney(self:GetNWInt("price", 0)), "TargetIDSmall", 25, 52, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)   
		end
	cam.End3D2D()
end