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
--- 主循环中使用定时器需要遵守本属性，将周期设为本属性。
--- @return integer
function Servo.Timer.Period()
	return 10
end
