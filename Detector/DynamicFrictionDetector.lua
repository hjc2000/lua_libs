-- 动摩擦和转动惯量检测器
if true then
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.DynamicFrictionDetector == nil) then
		-- 动摩擦和转动惯量检测器
		Detector.DynamicFrictionDetector = {}
	end




	local _dynamic_friction_result = 0

	--- 执行检测
	function Detector.DynamicFrictionDetector.Detecte()
		Servo.ChangeToSpeedMode()
		Servo.Param.SetBothTorqueLimit(100)
		Servo.SetSpeedAndRun(100)

		-- 等待直到电机转起来，接近指定速度
		while true do
			Detector.AccelerationDetector.Detect()
			if (math.abs(Detector.AccelerationDetector.Acceleration()) == 0 and
					Servo.Feedback.Speed() >= 100) then
				break
			end

			Servo.Timer.Delay(Servo.Timer.Period())
		end

		--- 此时的指令转矩就是动摩擦
		--- 设置区间右端点为动摩擦 + 10% 的转矩
		local torque_arr = {}
		for i = 1, 10, 1 do
			torque_arr[i] = Servo.Monitor.CommandTorque()
			Servo.Timer.Delay(100)
		end

		torque_arr = Array.RemoveMinMax(torque_arr)
		_dynamic_friction_result = Array.CalculateAverage(torque_arr)
		print("检测到动摩擦为：", _dynamic_friction_result)
		Servo.Stop()
	end

	--- 动摩擦检测结果
	--- @return integer
	function Detector.DynamicFrictionDetector.Result()
		return _dynamic_friction_result
	end
end
