if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Param == nil) then
		Servo.Param = {}
	end

	--- 获取伺服参数
	--- @param group integer 组索引
	--- @param index integer 参数子索引
	--- @return number 参数值
	function Servo.Param.Get(group, index)
		return SRV_PARA(group, index)
	end

	--- 设置伺服参数
	--- @param group integer 组索引
	--- @param index integer 参数子索引
	--- @param value number 参数值
	--- @param write_to_eerom boolean|nil 是否将参数写入 EEROM。
	--- 传入 nil 或 true 则表示要写入。只有传入 false 时才会不写入。
	function Servo.Param.Set(group, index, value, write_to_eerom)
		if (write_to_eerom == false) then
			SRV_PARA(group, index, value, 0)
		else
			SRV_PARA(group, index, value)
		end
	end

	--- 转矩限制
	if true then
		--- 正转转矩限制。单位：额定输出转矩的百分比。
		--- @return integer
		function Servo.Param.ForwardTorqueLimit()
			return Servo.Param.Get(1, 27)
		end

		--- 设置正转转矩限制。单位：额定输出转矩的百分比。
		--- @param value integer
		function Servo.Param.SetForwardTorqueLimit(value)
			value = math.abs(value)
			value = math.floor(value)
			Servo.Param.Set(1, 27, value, false)
		end

		--- 反转转矩限制。单位：额定输出转矩的百分比。
		--- @return integer
		function Servo.Param.ReverseTorqueLimit()
			return Servo.Param.Get(1, 28)
		end

		--- 设置反转转矩限制。单位：额定输出转矩的百分比。
		--- @param value integer
		function Servo.Param.SetReverseTorqueLimit(value)
			value = math.abs(value)
			value = math.floor(value)
			Servo.Param.Set(1, 28, value, false)
		end

		--- 同时设置正转和反转的转矩限制。单位：额定输出转矩的百分比。
		--- @param value integer
		function Servo.Param.SetBothTorqueLimit(value)
			Servo.Param.SetForwardTorqueLimit(value)
			Servo.Param.SetReverseTorqueLimit(value)
		end
	end

	--- 转速限制
	if true then
		--- 位置控制和速度控制时的最大转速。单位：rpm。
		--- @return number 是浮点数
		function Servo.Param.SpeedLimit()
			return Servo.Param.Get(1, 25) / 100
		end

		--- 设置位置控制和速度控制时的最大转速。单位：rpm。
		--- @param value number 是浮点数
		function Servo.Param.SetSpeedLimit(value)
			value = math.abs(value)
			value = math.floor(value * 100)
			Servo.Param.Set(1, 25, value, false)
		end
	end

	--- 伺服旋转一周的指令脉冲数
	--- @return integer
	function Servo.Param.PulseCountPerCircle()
		return Servo.Param.Get(1, 5)
	end

	--- 设置伺服旋转一周的指令脉冲数
	--- @param value integer
	function Servo.Param.SetPulseCountPerCircle(value)
		value = math.abs(value)
		value = math.floor(value)
		Servo.Param.Set(1, 5, value, false)
	end

	--- 编码器位数
	--- @return integer 返回编码器的位数。例如 17 位或 20 位。
	function Servo.Param.EncoderBitCount()
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
end
