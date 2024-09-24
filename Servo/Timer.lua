if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Timer == nil) then
		--- 定时器
		Servo.Timer = {}
	end

	--- 毫秒延时
	--- @note 会阻塞脚本执行
	--- @param milliseconds integer
	function Servo.Timer.Delay(milliseconds)
		DELAY(milliseconds)
	end

	--- Servo.Timer.Period() 属性内部变量
	Servo.Timer._millisecond_period = 10

	--- 定时周期。单位：ms
	--- 主循环中使用定时器需要遵守本属性，将周期设为本属性。
	--- @return integer
	function Servo.Timer.Period()
		return Servo.Timer._millisecond_period
	end

	--- 设置定时器时间间隔
	--- @note 设置本属性仅会改变内部的一个变量的值，没有其他副作用。例如：不会将已经启动的定时器的定时周期变更为
	--- 新设置的值。
	--- @note 本函数主要用于在主循环的定时器启动前，设置定时周期 Servo.Timer.Period()，然后启动定时器，
	--- 并遵循 Servo.Timer.Period()。
	---
	--- @param value integer
	function Servo.Timer.SetPeriod(value)
		Servo.Timer._millisecond_period = value
	end
end
