ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Money Printer Ink"
ENT.Author = "TylerB"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Initialize()
    self:SetModel("models/props_junk/metalgascan.mdl")
    
    self.MaxInk = 1
    self.ProcessTime = 0
    
    if SERVER then
        self:SetInk(self.MaxInk)
        
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    --else
    --    self:FakeModel()
    end
end