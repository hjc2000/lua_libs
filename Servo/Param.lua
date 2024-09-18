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
function Servo.Param.Set(group, index, value)
	SRV_PARA(group, index, value)
end
