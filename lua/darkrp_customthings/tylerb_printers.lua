DarkRP.createEntity("Basic Printer", {
    desc = "Prints money. Needs paper and ink to operate.", -- the desc options were a part of my old DarkRP derivative.
	ent = "printer_base",
	model = "models/props_c17/consolebox01a.mdl",
	price = 250,
	max = 5,
	cmd = "buybasicprinter"
})

DarkRP.createEntity("Server Printer", {
    desc = "Prints money. Needs paper and ink to operate.",
	ent = "printer_server",
	model = "models/props_lab/reciever_cart.mdl",
	price = 1000,
	max = 5,
	cmd = "buyserverprinter"
})

DarkRP.createEntity("1 liter of ink", {
    desc = "Use this on a printer to replenish the printer's ink.",
	ent = "printer_ink",
	model = "models/props_junk/metalgascan.mdl",
	price = 25,
	max = 5,
	cmd = "buyink"
})

DarkRP.createEntity("250 sheets of paper", {
    desc = "Use this on a printer to replenish the printer's paper.",
	ent = "printer_paper",
	model = "models/props/cs_office/file_box.mdl",
	price = 10,
	max = 5,
	cmd = "buypaper"
})

DarkRP.createEntity("Replacement Fan", {
    desc = "Use on a printer to fix the printer's fan.",
	ent = "printer_fan",
	model = "models/props/cs_assault/wall_vent.mdl",
	price = 25,
	max = 5,
	cmd = "buyfan"
})