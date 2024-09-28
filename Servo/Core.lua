if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Core == nil) then
		Servo.Core = {}
	end

	--- 重启伺服
	function Servo.Core.Restart()
		Servo.Param.Set(3, 98, 9999)
	end

	--- 编码器位数
	--- @return integer
	function Servo.Core.EncoderBitCount()
		if (Servo.Param.Get(2, 99) == 0) then
			return 20
		elseif (Servo.Param.Get(2, 99) == 1) then
			return 17
		elseif (Servo.Param.Get(2, 99) == 4) then
			return 20
		elseif (Servo.Param.Get(2, 99) == 5) then
			return 17
		else
			return 17
		end
	end

	--- 脚本中要让电机转一圈，AXIS_MOVEABS 函数的参数要传入多少。
	--- @return number
	function Servo.Core.ScriptOneCirclePosition()
		--- 编码器实际一圈的脉冲数 / 希望的一圈的脉冲数 = 电子齿轮比
		--- 希望的一圈的脉冲数 = 编码器实际一圈的脉冲数 / 电子齿轮比

		local bit_count = Servo.Core.EncoderBitCount()
		local pulse_count = 2 ^ bit_count
		local ratio = Servo.Param.Get(1, 6) / Servo.Param.Get(1, 7)
		return pulse_count / ratio
	end
end
