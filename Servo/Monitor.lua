if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Monitor == nil) then
		Servo.Monitor = {}
	end

	--- 指令转速
	--- @return number
	function Servo.Monitor.CommandSpeed()
		return SRV_MON(1)
	end

	--- 伺服那边接收到的，当前的指令转矩。单位：额定输出转矩的百分比。
	--- @return integer
	function Servo.Monitor.CommandTorque()
		return SRV_MON(2)
	end

	--- 读取伺服端子的模拟输入电压
	--- @return number
	function Servo.Monitor.Vref()
		return SRV_MON(16) / 100
	end
end
