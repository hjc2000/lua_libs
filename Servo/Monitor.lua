if (Servo == nil) then
	Servo = {}
end

if (Servo.Monitor == nil) then
	Servo.Monitor = {}
end

--- 伺服那边接收到的，当前的指令转矩。单位：额定输出转矩的百分比。
--- @return integer
function Servo.Monitor.CommandTorque()
	return SRV_MON(2)
end
