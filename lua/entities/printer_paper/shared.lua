ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Paper for Money Printers"
ENT.Author = "TylerB"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Initialize()
    self:SetModel("models/props/cs_office/file_box.mdl")
    
    self.MaxSheets = 250
    self.ProcessTime = 0
    
    if SERVER then
        self:SetSheets(self.MaxSheets)
        
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    --else
    --    self:FakeModel()
    end
end