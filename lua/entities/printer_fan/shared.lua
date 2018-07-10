ENT.Type = "anim"
ENT.Base = "base_gmodentity"
ENT.PrintName = "Replacement Fan"
ENT.Author = "TylerB"
ENT.Spawnable = false
ENT.AdminSpawnable = false

function ENT:Initialize()
    self:SetModel("models/props/cs_assault/wall_vent.mdl")

    if SERVER then
        self:PhysicsInit(SOLID_VPHYSICS)
        self:SetSolid(SOLID_VPHYSICS)
        self:SetMoveType(MOVETYPE_VPHYSICS)
        self:SetUseType(SIMPLE_USE)
        self:PhysWake()
    end
end