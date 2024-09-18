if (Servo == nil) then
	Servo = {}
end

if (Servo.Timer == nil) then
	Servo.Timer = {}
end






--- 毫秒延时
--- @param milliseconds integer
function Servo.Timer.Delay(milliseconds)
	DELAY(milliseconds)
end
