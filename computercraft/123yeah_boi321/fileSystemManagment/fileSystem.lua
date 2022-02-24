if fs.exists("fsmanager.lua") then
	local fsm = require("fsmanager")
else
	print("Hmm.. It seems you do not have the main file. Would you like me to download it?")
	print("Y/N")
	local re = read()
	if re =="y" or re =="yes" or re == "HEK YEA BROTHER" then
		shell.run("wget https://raw.githubusercontent.com/Dead-Knuckle/Minecraft-Computer-Mod-Codes/main/computercraft/123yeah_boi321/fileSystemManagment/fsmanager.lua")
	end
end
local dB,dT,dF,dS =fsm.main(false,"","",0)
term.clear()
while true do
	local dBt,dTt,dFt,dSt = fsm.main(dB,dT,dF,dS)
	dB = dBt
	dT = dTt
	dF = dFt
	dS = dSt
end
