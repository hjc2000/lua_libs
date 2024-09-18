if (Servo == nil) then
	Servo = {}
end

if (Servo.Feedback == nil) then
	Servo.Feedback = {}
end






--- 反馈速度。有正负。单位：rpm
--- @return number
function Servo.Feedback.Speed()
	return SRV_MON(0)
end

--- 反馈位置。能被位置预置清 0。此外还受参数中设置的 “编码器旋转一圈的脉冲数” 影响。
--- 这个参数设置为多少，旋转一圈本属性就变化多少。
--- @return integer
function Servo.Feedback.Position()
	return SRV_MON(6)
end
