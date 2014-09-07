include("shared.lua")

function ENT:SpawnEffects()
    self.fan = ClientsideModel("models/props/cs_assault/wall_vent.mdl")
    self.fan:SetPos(self:LocalToWorld(self.FanPos))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(),90)
    self.fan:SetAngles(ang)
    self.fan:SetParent(self)
        
    local mat = Matrix()
    mat:Scale( Vector(0.3,0.4,0.5) )
    self.fan:EnableMatrix( "RenderMultiply", mat )


    self.button = ClientsideModel("models/maxofs2d/button_slider.mdl")
    self.button:SetPos(self:LocalToWorld(self.ButtonPos))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Up(),180)
    ang:RotateAroundAxis(ang:Right(),270)
    self.button:SetAngles(ang)
    self.button:SetParent(self)
    self.button:SetModelScale(1.5,0)
    
    if self.PrinterOC then
        self.button:SetPoseParameter("switch",self.PrinterOC)
    end
end

function ENT:Draw()
    self:DrawModel()
    
    if self:GetPos():Distance(LocalPlayer():GetPos()) > 1024 then return end
    
    local pos = self:LocalToWorld(Vector(13,-7.45,28))
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
        surface.DrawRect(0,0,234,76)
        
        -- paper --
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,2,115,72)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,3,113,70)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,4,111,68)
        
        if paper == 0 then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
            surface.DrawRect(4,4,111,68)
        else
            surface.SetDrawColor(Color(2.55 * (100 - paperpercent),2.55 * (paperpercent),0,255))
            surface.DrawRect(4,4,1.11 * paperpercent,68)
        end

        draw.DrawText("Paper\n"..paper.." sheets", "BudgetLabel", 58, 24, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
       
        -- ink --
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(118,2,114,72)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(119,3,112,70)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(120,4,110,68)
        
        if ink == 0 then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
            surface.DrawRect(120,4,110,68)
        else
            surface.SetDrawColor(Color(2.55 * (100 - inkpercent),2.55 * (inkpercent),0,255))
            surface.DrawRect(120,4,1.1 * inkpercent,68)
        end

        draw.DrawText("Ink\n"..ink.." liters", "BudgetLabel", 175, 24, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)

        
    cam.End3D2D()

    local pos = self:LocalToWorld(Vector(12.95,-2.9,14.8))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    ang:RotateAroundAxis(ang:Right(),270)
        
    local cash = (self.printermoney and "$"..(math.Clamp(self.printermoney,0,self.PrinterMaxMoney)) or "$0")
    
    cam.Start3D2D( pos, ang, 0.18 )
        surface.SetDrawColor(Color(0,0,0,255))
        surface.DrawRect(0,0,80,21)    
        
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,2,76,17)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,3,74,15)

        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,4,72,13)     
        
        draw.DrawText(cash, "BudgetLabel", 5, 3, Color(255, 255, 255, 255),TEXT_ALIGN_LEFT)   
    cam.End3D2D()
    
    local pos = self:LocalToWorld(Vector(-2.84,-10.85,21.3))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    ang:RotateAroundAxis(ang:Right(),0)
            
    cam.Start3D2D( pos, ang, 0.1 )
        surface.SetDrawColor(Color(0,0,0,255))
        surface.DrawRect(0,0,107,58)
        
        -- heat --
        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,2,103,55)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,3,101,53)
 
        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,4,99,51)
        
        if heat >= (self.PrinterHeatMax - 15) then
            if math.Round((math.cos(CurTime()*5)+1)/2) == 0 then
                surface.SetDrawColor(Color(255,0,0,255))
            else
                surface.SetDrawColor(Color(0,0,0,255))            
            end
        else
            surface.SetDrawColor(Color(2.55 * (heatpercent),2.55 * (100 - heatpercent),0,255))
        end
        
        surface.DrawRect(4,4,0.99 * heatpercent,51)
        
        
        draw.DrawText("Temperature\n"..(22 + heat).." Celsius", "BudgetLabel", 53, 14, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
    cam.End3D2D()
        
end
