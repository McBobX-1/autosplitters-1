// Made by McBobX

state("fceux", "v2.2.3")
{
	byte start : 0x3B1388, 0x00A5;
	byte gooniescount : 0x3B1388, 0x0507;
	byte annie : 0x3B1388, 0x00EC;
}

state("fceux", "v2.6.4")
{
	byte start : 0x3DA4EC, 0x00A5;
	byte gooniescount : 0x3DA4EC, 0x0507;
	byte annie : 0x3DA4EC, 0x00EC;
}


state("nestopia")
{
	// base 0x0000 address of ROM : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x68;
	// Add 0x68 to FCEUX offset to get Nestopia offset
	byte start : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x10D;
	byte gooniescount : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x56F;
	byte annie : "nestopia.exe", 0x1b2bcc, 0, 8, 0xc, 0xc, 0x154;
}

startup
{
	settings.Add("main1", false, "The Goonies II by McBobX");
	settings.Add("main2", false, "Splits each time you rescue a goonie!");
	settings.Add("main3", false, "Supported emulators : FCEUX (2.2.3 and 2.6.4), Netstopia");
}

init
{
	print("--Setting init variables!--");
	refreshRate = 60;
	vars.end = 0;
	if (modules.First().ModuleMemorySize == 0x487000)
        version = "v2.2.3";
    else if (modules.First().ModuleMemorySize == 0x603000)
        version = "v2.6.4";
}

start {
	if (old.start == 0 && current.start == 16) {
		print("--Here we go!");
		vars.end = 0;
		return true;
	}
}

split
{
	if (old.gooniescount < current.gooniescount && current.gooniescount <= 8) {
		print("Saved a goonie! Split now!");
		return true;
	}

	if (current.annie == 21 && vars.end == 0) {
		print("Saved Annie! GG!");
		vars.end = 1;
		return true;
	}
	return;
}

reset
{
	if (current.start == 0) {
		print("Run dead! Reset!");
		return true;
	}
	return;
}