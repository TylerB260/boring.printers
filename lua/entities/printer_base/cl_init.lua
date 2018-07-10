include("shared.lua")

net.Receive("printer_update",function()
    local ent = net.ReadEntity()
    local op = net.ReadString()
    local val = net.ReadFloat()
    
    --print("Update: "..op.." operation on "..(ent:EntIndex()).." ID: "..val)
    
	if ent.fan then
		ent.fan:SetColor(ent:GetNWBool("BrokenFan", false) and Color(20, 20, 20) or Color(255, 255, 255))
	end
	
    ent["printer"..op] = math.Round(val,2)
end)

net.Receive("printer_switch",function()
    local ent = net.ReadEntity()
    local val = net.ReadFloat()
    
    if IsValid(ent.button) then ent.PrinterOC = val ent.button:SetPoseParameter("switch",val) end
end)

function ENT:SpawnEffects()
    self.fan = ClientsideModel("models/props/cs_assault/wall_vent.mdl")
    self.fan:SetPos(self:LocalToWorld(self.FanPos))
    self.fan:SetAngles(self:GetAngles())
    self.fan:SetParent(self)
        
    local mat = Matrix()
    mat:Scale( Vector(0.1,0.2,0.15) )
    self.fan:EnableMatrix( "RenderMultiply", mat )


    self.button = ClientsideModel("models/maxofs2d/button_slider.mdl")
    self.button:SetPos(self:LocalToWorld(self.ButtonPos))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Right(),270)
    self.button:SetAngles(ang)
    self.button:SetParent(self)
    self.button:SetModelScale(0.6,0)
    
    if self.PrinterOC then
        self.button:SetPoseParameter("switch",self.PrinterOC)
    end
end

function ENT:Think()
    if not IsValid(self.button) or not IsValid(self.fan) then
        self:SpawnEffects()
    end
    
    local posnot = self.button:GetPos():Distance(self:LocalToWorld(self.ButtonPos)) > 1 or self.fan:GetPos():Distance(self:LocalToWorld(self.FanPos)) > 1 

    if posnot then
        self.button:Remove()
        self.fan:Remove()
        self:SpawnEffects()
    end
    
    if IsValid(self:GetNWEntity("steam")) then
        if LocalPlayer():GetPos():Distance(self:GetPos()) > 1024 then
            self:GetNWEntity("steam"):SetKeyValue("renderamt", 0)
        else
            self:GetNWEntity("steam"):SetKeyValue("renderamt", ((self.printerheat or 0) / self.PrinterHeatMax)*64)
        end
    end
end

function ENT:Draw()
    self:DrawModel()
    
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 1024 then return end
    
    local pos = self:LocalToWorld(Vector(16.2,-14.45,10.2))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    ang:RotateAroundAxis(ang:Right(),270)
    
    local heat = self.printerheat or 0
    local paper = self.printerpaper or 0
    local ink = self.printerink or 0
    
    
    local heatpercent = math.Clamp((heat / self.PrinterHeatMax)*100,0,100)
    local paperpercent = math.Clamp((paper / self.PrinterPaperMax)*100,0,100)
    local inkpercent = math.Clamp((ink / self.PrinterInkMax)*100,0,100)
    
    cam.Start3D2D( pos, ang, 0.1 )
        surface.SetDrawColor(Color(0,0,0,255))
        surface.DrawRect(0,0,220,95)
        
        -- heat --
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,2,181,40)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,3,179,38)
 
        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,4,177,36)
        
        if heat >= (self.PrinterHeatMax - 15) then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
        else
            surface.SetDrawColor(Color(2.55 * (heatpercent),2.55 * (100 - heatpercent),0,255))
        end
        
        surface.DrawRect(4,4,1.77 * heatpercent,36)
        
        draw.DrawText("Temperature\n"..(22 + heat).." Celsius", "BudgetLabel", 90, 6, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
        
        -- paper --
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,53,89,40)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,54,87,38)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,55,85,36)
        
        if paper == 0 then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
            surface.DrawRect(4,55,85,36)
        else
            surface.SetDrawColor(Color(2.55 * (100 - paperpercent),2.55 * (paperpercent),0,255))
            surface.DrawRect(4,55,0.85 * paperpercent,36)
        end

        draw.DrawText("Paper\n"..paper.." sheets", "BudgetLabel", 46.5, 58, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
       
        -- ink --
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(93,53,89,40)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(94,54,87,38)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(95,55,85,36)
        
        if ink == 0 then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
            surface.DrawRect(95,55,85,36)
        else
            surface.SetDrawColor(Color(2.55 * (100 - inkpercent),2.55 * (inkpercent),0,255))
            surface.DrawRect(95,55,0.85 * inkpercent,36)
        end

        draw.DrawText("Ink\n"..ink.." liters", "BudgetLabel", 138, 58, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
        
        -------------------------------------
        -------------------------------------
        -------------------------------------
        
        local warned = false
        
        if paper == 0 and not warned then
            local x,y = 184, 95
            
            surface.SetDrawColor(Color(0,0,0,250))
            surface.DrawRect(0,0,x,y)

            surface.SetMaterial(self.PaperIcon)
            surface.SetDrawColor(Color(255,255,255))
            surface.DrawTexturedRect((x/2) - 8, (y/3) - 8, 16, 16)
            
            draw.DrawText("This printer requires\npaper to operate.", "BudgetLabel", x/2, y/2, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
            
            warned = true
        end

        if ink == 0 and not warned then
            local x,y = 184, 95
            
            surface.SetDrawColor(Color(0,0,0,250))
            surface.DrawRect(0,0,x,y)

            surface.SetMaterial(self.InkIcon)
            surface.SetDrawColor(Color(255,255,255))
            surface.DrawTexturedRect((x/2) - 8, (y/3) - 8, 16, 16)
            
            draw.DrawText("This printer requires\nink to operate.", "BudgetLabel", x/2, y/2, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
            
            warned = true
        end

        if self:GetNWBool("BrokenFan",false) and not warned then
            local x,y = 184, 95
            
            surface.SetDrawColor(Color(0,0,0,250))
            surface.DrawRect(0,0,x,y)

            surface.SetMaterial(self.FanIcon)
            surface.SetDrawColor(Color(255,255,255))
            surface.DrawTexturedRect((x/2) - 8, (y/3) - 8, 16, 16)
            
            draw.DrawText("This printer needs a new\nfan to cool properly.", "BudgetLabel", x/2, y/2, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
            
            warned = true
        end

        if not self:GetNWBool("PrinterEnabled",false) and not warned then
            local x,y = 184, 95
            
            surface.SetDrawColor(Color(0,0,0,250))
            surface.DrawRect(0,0,x,y)

            surface.SetMaterial(self.GoodIcon)
            surface.SetDrawColor(Color(255,255,255))
            surface.DrawTexturedRect((x/2) - 8, (y/3) - 8, 16, 16)
            
            draw.DrawText("Use the slider to the\nright to start printing.", "BudgetLabel", x/2, y/2, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
            
            warned = true
        end
                
        -------------------------------------
        -------------------------------------
        -------------------------------------
        
    cam.End3D2D()

    local pos = self:LocalToWorld(Vector(16.7,8.55,9.35))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    ang:RotateAroundAxis(ang:Right(),270)
        
    local cash = (self.printermoney and "$"..(math.Clamp(self.printermoney,0,self.PrinterMaxMoney)) or "$0")
    
    cam.Start3D2D( pos, ang, 0.1 )
        surface.SetDrawColor(Color(0,0,0,255))
        surface.DrawRect(0,0,65,21)    
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,2,61,17)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,3,59,15)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,4,57,13)     
        
        draw.DrawText(cash, "BudgetLabel", 5, 3, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)   
    cam.End3D2D()
end