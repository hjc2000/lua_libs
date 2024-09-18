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

--- 定时周期。单位：ms
--- @return integer
function Servo.Timer.Period()
	return 10
end
