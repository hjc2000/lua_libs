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

--- 是否有硬件 EI 被配置为使能信号，有的话返回 true，没有返回 false。
--- @return boolean
function Servo.EI.ThereIsHardwareEIConfiguredAs_EnableSignal()
	if (Servo.Param.Get(3, 1) == 1) then
		return true
	end

	if (Servo.Param.Get(3, 2) == 1) then
		return true
	end

	if (Servo.Param.Get(3, 3) == 1) then
		return true
	end

	if (Servo.Param.Get(3, 4) == 1) then
		return true
	end

	if (Servo.Param.Get(3, 5) == 1) then
		return true
	end

	return false
end
