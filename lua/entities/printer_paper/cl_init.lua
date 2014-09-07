include("shared.lua")

function ENT:Draw() 
    --if not IsValid(self.paper) then self:FakeModel() return end
    self:DrawModel()
    
    --local norm = self.paper:GetRight() * -1
    --local dist = norm:Dot(self.paper:GetPos()-(self.paper:GetRight()*45))

    --self.paper:SetRenderClipPlaneEnabled(true)
    --self.paper:SetRenderClipPlane(norm,dist)
    --self.paper:Draw()

    local pos = self:LocalToWorld(Vector(13.2,-7,12.7))
    local ang = self:GetAngles()
    ang:RotateAroundAxis(ang:Forward(),90)
    ang:RotateAroundAxis(ang:Right(),270)

    local sheets = self.printersheets or self.MaxSheets
    local sheetspercent = (sheets / self.MaxSheets)*100
    
    cam.Start3D2D( pos, ang, 0.1 )
        --surface.SetDrawColor(Color(0,0,0,255))
        --surface.DrawRect(0,0,139,127)

        surface.SetDrawColor(Color(255,255,255,255))
        surface.DrawOutlinedRect(2,45,135,40)
        
        surface.SetDrawColor(Color(200,200,200,255))
        surface.DrawOutlinedRect(3,46,133,38)
 
        surface.SetDrawColor(Color(50,50,50,255))
        surface.DrawRect(4,47,131,36)
        
        surface.SetDrawColor(Color(2.55 * (100 - sheetspercent),2.55 * (sheetspercent),0,255))
        
        surface.DrawRect(4,47,1.31 * sheetspercent,36)
                
        draw.DrawText("Paper\n"..sheets.." sheets", "BudgetLabel", 70, 50, Color(255, 255, 255, 255),TEXT_ALIGN_CENTER)
    cam.End3D2D()
end