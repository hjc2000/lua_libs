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
