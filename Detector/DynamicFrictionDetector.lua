require("Math.InertialElement")

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

		-- 等待直到电机转起来，达到指定速度
		Detector.AccelerationDetector.Reset()

		--- 计数，至少让加速度检测器检测到 100 个点
		local count = 0
		while true do
			Detector.AccelerationDetector.Detect()
			if (math.abs(Detector.AccelerationDetector.Acceleration()) == 0 and
					Servo.Feedback.Speed() >= 100 and
					count > 100) then
				break
			end

			Servo.Timer.Delay(Servo.Timer.Period())
			count = count + 1
		end

		--- 此时的指令转矩就是动摩擦
		--- 将惯性时间常数设定为采样周期的 10 倍
		local inertial_element = Math.InertialElement.New(Servo.Timer.Period() / 1000 * 10,
			Servo.Timer.Period() / 1000,
			0.1)

		-- 采样 100 个点
		for i = 0, 99, 1 do
			Math.InertialElement.Input(inertial_element, Servo.Monitor.CommandTorque())
			Servo.Timer.Delay(Servo.Timer.Period())
		end

		_dynamic_friction_result = Math.InertialElement.CurrentOutput(inertial_element)
		print("检测到动摩擦为：", _dynamic_friction_result)
		Servo.Stop()
	end

	--- 动摩擦检测结果
	--- @return integer
	function Detector.DynamicFrictionDetector.Result()
		return _dynamic_friction_result
	end
end
