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
