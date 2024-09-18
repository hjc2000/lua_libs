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
