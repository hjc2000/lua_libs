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
		local speed = SRV_MON(1)
		if (Servo.Param.Get(1, 4) == 1) then
			speed = -speed
		end

		return speed
	end

	--- 伺服那边接收到的，当前的指令转矩。单位：额定输出转矩的百分比。
	--- @return integer
	function Servo.Monitor.CommandTorque()
		local torque = SRV_MON(2)
		if (Servo.Param.Get(1, 4) == 1) then
			torque = -torque
		end

		return torque
	end

	--- 读取伺服端子的模拟输入电压
	--- @return number
	function Servo.Monitor.Vref()
		return SRV_MON(16) / 100
	end
end
