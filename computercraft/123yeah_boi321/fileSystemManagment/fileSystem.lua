local fsm = require("fsmanager")
local dB,dT,dF,dS =fsm.main(false,"","",0)
term.clear
while true do
	local dBt,dTt,dFt,dSt = fsm.main(dB,dT,dF,dS)
	dB = dBt
	dT = dTt
	dF = dFt
	dS = dSt
end
