if (Servo == nil) then
	Servo = {}
end

if (Servo.EO == nil) then
	--- 管理 EO 端子
	Servo.EO = {}
end

--- 获取输出端子的值
--- @param index any
--- @return boolean
function Servo.EO.Get(index)
	return SRV_EOUT(index) ~= 0
end

--- 设置 EO 的值。
--- @param index integer EO 的索引。
--- @param value boolean
function Servo.EO.Set(index, value)
	if (value) then
		SRV_EOUT(index, 1)
	else
		SRV_EOUT(index, 0)
	end
end
