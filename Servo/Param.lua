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

--#region 转矩限制值

--- 正转转矩限制。单位：额定输出转矩的百分比。
--- @return integer
function Servo.Param.ForwardTorqueLimit()
	return SRV_PARA(1, 27)
end

--- 设置正转转矩限制。单位：额定输出转矩的百分比。
--- @param value integer
function Servo.Param.SetForwardTorqueLimit(value)
	SRV_PARA(1, 27, value, 0)
end

--- 反转转矩限制。单位：额定输出转矩的百分比。
--- @return integer
function Servo.Param.ReverseTorqueLimit()
	return SRV_PARA(1, 28)
end

--- 设置反转转矩限制。单位：额定输出转矩的百分比。
--- @param value integer
function Servo.Param.SetReverseTorqueLimit(value)
	SRV_PARA(1, 28, value, 0)
end

--#endregion





--- 伺服旋转一周的指令脉冲数
--- @return integer
function Servo.Param.PulseCountPerCircle()
	return Servo.Param.Get(1, 5)
end

--- 设置伺服旋转一周的指令脉冲数
--- @param value integer
function Servo.Param.SetPulseCountPerCircle(value)
	Servo.Param.Set(1, 5, value)
end

--- 位置控制和速度控制时的最大转速。单位：rpm
--- @return integer
function Servo.Param.MaxSpeedInPositonAndSpeedControlMode()
	return Servo.Param.Get(1, 25)
end

--- 设置位置控制和速度控制时的最大转速。单位：rpm
--- @param value integer
function Servo.Param.SetMaxSpeedInPositonAndSpeedControlMode(value)
	Servo.Param.Set(1, 25, value)
end
