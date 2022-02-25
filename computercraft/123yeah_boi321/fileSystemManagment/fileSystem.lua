if shell.resolveProgram("fsmanager") then
	shell.run("wget https://raw.githubusercontent.com/Dead-Knuckle/Minecraft-Computer-Mod-Codes/main/computercraft/123yeah_boi321/fileSystemManagment/fsmanager.lua temp.lua")
	local tempFile = fs.open("temp.lua", "r")
	local temp = tempFile.readAll()
	tempFile.close()
	local fsmanResolved = shell.resolveProgram("fsmanager")
	local fsmanFile = fs.open(fsmanResolved, "r")
	local fsman = fsmanFile.readAll()
	fsmanFile.close()
	if fsman ~= temp then
		print("It seems that fsmanager may need an update. Would you like to install?")
		print("Y/N")
		local re = read()
		if string.lower(re) == "y" or string.lower(re) == "yes" or string.lower(re) == "update" or string.upper(re) == "HEC YEA BROTHER" then
			fs.delete(fsmanResolved)
			fs.move("temp.lua",fsmanResolved)
		end
	else
		fs.delete("temp.lua")
	end
	term.clear()
else
	print("Hmm.. It seems you do not have the main file. Would you like me to download it?")
	print("Y/N")
	local re = read()
	if string.lower(re) == "y" or string.lower(re) == "yes" or string.upper(re) == "HEK YEA BROTHER" then
		shell.run("wget https://raw.githubusercontent.com/Dead-Knuckle/Minecraft-Computer-Mod-Codes/main/computercraft/123yeah_boi321/fileSystemManagment/fsmanager.lua")
	else
		return
	end
end
local fsm = require(string.gsub(shell.resolveProgram("fsmanager"),".lua",""))
local dB,dT,dF,dS =fsm.main(false,"","",0)
term.clear()
while true do
	local dBt,dTt,dFt,dSt = fsm.main(dB,dT,dF,dS)
	dB = dBt
	dT = dTt
	dF = dFt
	dS = dSt
end
