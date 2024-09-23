if (Servo == nil) then
	Servo = {}
end

if (Servo.EI == nil) then
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

--#region 检查硬件 EI 是否有特定信号

--- 检查是否有硬件 EI 被配置为指定的功能代码
--- @param function_code integer
--- @return boolean 有的话返回 true，没有则返回 false.
function Servo.EI.ThereIsHardwareEIConfiguredAs(function_code)
	if (Servo.Param.Get(3, 1) == function_code) then
		return true
	end

	if (Servo.Param.Get(3, 2) == function_code) then
		return true
	end

	if (Servo.Param.Get(3, 3) == function_code) then
		return true
	end

	if (Servo.Param.Get(3, 4) == function_code) then
		return true
	end

	if (Servo.Param.Get(3, 5) == function_code) then
		return true
	end

	return false
end

--- 是否有硬件 EI 被配置为使能信号，有的话返回 true，没有返回 false。
--- @return boolean
function Servo.EI.ThereIsHardwareEIConfiguredAs_EnableSignal()
	return Servo.EI.ThereIsHardwareEIConfiguredAs(1)
end

--- 是否有硬件 EI 被配置为位置预置信号，有的话返回 true，没有返回 false。
--- @return boolean
function Servo.EI.ThereIsHardwareEIConfiguredAs_PresetPositionSignal()
	return Servo.EI.ThereIsHardwareEIConfiguredAs(16)
end

--#endregion
