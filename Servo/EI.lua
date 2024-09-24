if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.EI == nil) then
		--- 管理 EI 端子
		Servo.EI = {}
	end

	--- 获取 EI
	--- @param ei_index integer EI 索引
	--- @return boolean
	function Servo.EI.Get(ei_index)
		return SRV_EI(ei_index) ~= 0
	end

	--- 设置 EI
	--- @param ei_index integer EI 索引。
	--- @param value boolean
	function Servo.EI.Set(ei_index, value)
		if (value) then
			SRV_EI(ei_index, 1)
		else
			SRV_EI(ei_index, 0)
		end
	end

	--- 让 EI 接收到一个上升沿
	--- @param ei_index integer EI 索引
	function Servo.EI.TriggerRisingEdge(ei_index)
		Servo.EI.Set(ei_index, false)
		Servo.Timer.Delay(5)
		Servo.EI.Set(ei_index, true)
		Servo.Timer.Delay(5)
		Servo.EI.Set(ei_index, false)
	end

	--- 检查哪个硬件 EI 被配置为指定的功能代码
	--- @param function_code integer
	--- @return integer 返回被配置为 function_code 的 EI，如果不存在，返回 -1
	function Servo.EI.WhichHardwareEIConfiguredAs(function_code)
		if (Servo.Param.Get(3, 1) == function_code) then
			return 1
		end

		if (Servo.Param.Get(3, 2) == function_code) then
			return 2
		end

		if (Servo.Param.Get(3, 3) == function_code) then
			return 3
		end

		if (Servo.Param.Get(3, 4) == function_code) then
			return 4
		end

		if (Servo.Param.Get(3, 5) == function_code) then
			return 5
		end

		return -1
	end
end
