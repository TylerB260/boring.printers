print("test, moneyprinter stuff")

e2function normal entity:isPrinter()
	if not IsValid(this) then return 0 end
	
	return (this.PrinterStats and this.PrinterStats.heat) and 1 or 0
end

e2function normal entity:printerGetStat(string stat)
	if not IsValid(this) then return 0 end
	if this.GetStat then return this:GetStat(string.lower(stat)) end
end

e2function normal entity:printerGetStatMax(string stat)
	if not IsValid(this) then return 0 end
	if this.GetStatMax then return this:GetStatMax(string.lower(stat)) end
end

e2function normal entity:printerGetRate(string stat)
	if not IsValid(this) then return 0 end
	if this.GetRate then return this:GetRate(string.lower(stat)) end
end

e2function vector entity:printerGetFanPos()
	if not IsValid(this) then return Vector() end
	if this.GetFanPos then return this:GetFanPos() end
end

e2function vector entity:printerGetFanSize()
	if not IsValid(this) then return Vector() end
	if this.GetFanSize then return this:GetFanSize() end
end

e2function vector entity:printerGetButtonPos()
	if not IsValid(this) then return Vector() end
	if this.GetButtonPos then return this:GetButtonPos() end
end

e2function vector entity:printerGetFanSize()
	if not IsValid(this) then return Vector() end
	if this.GetButtonSize then return this:GetButtonSize() end
end