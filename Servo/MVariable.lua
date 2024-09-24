function Inject()
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.MVariable == nil) then
		--- M 变量
		Servo.MVariable = {}
	end

	--- 获取 M 变量的值
	--- @param index integer
	--- @return boolean
	function Servo.MVariable.Get(index)
		return M(index) ~= 0
	end

	--- 设置 M 变量的值
	--- @param index integer
	--- @param value boolean
	function Servo.MVariable.Set(index, value)
		if (value) then
			M(index, 1)
		else
			M(index, 0)
		end
	end

	--- 检查指定的 M 变量是否有上升沿事件发生
	--- @param index integer
	--- @return boolean
	function Servo.MVariable.HasRisingEdgeEvent(index)
		return M_EVENT(index) == 1
	end

	--- 检查指定的 M 变量是否有下降沿事件发生
	--- @param index integer
	--- @return boolean
	function Servo.MVariable.HasFallenEdgeEvent(index)
		return M_EVENT(index) == -1
	end
end

Inject()
