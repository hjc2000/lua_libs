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
	--- 检测完毕后会回到原来的位置
	function Detector.DynamicFrictionDetector.Detecte()
		-- 记录当前位置，检测完毕后要回到此位置
		local position = Servo.Feedback.Position()
		local speed = 100
		Servo.ChangeToSpeedMode()
		Servo.Param.SetBothTorqueLimit(100)
		Servo.SetSpeedAndRun(speed)

		Detector.AccelerationDetector.Reset()

		--- 等待直到电机转起来，达到指定速度，并且加速度为 0，即速度保持稳定。
		--- 计数，至少让加速度检测器检测到 100 个点
		local count = 0
		while true do
			Detector.AccelerationDetector.Detect()
			if (math.abs(Detector.AccelerationDetector.Acceleration()) == 0 and
					Servo.Feedback.Speed() >= speed and
					count > 100) then
				break
			end

			Servo.Timer.Delay(Servo.Timer.Period())
			count = count + 1
		end

		local sample_interval = Servo.Timer.Period() / 1000

		--- 此时的指令转矩就是动摩擦
		--- 将惯性时间常数设定为采样周期的 10 倍
		local inertial_element = Math.InertialElement.New(sample_interval * 10, sample_interval, 0.1)

		-- 采样 100 个点
		for i = 0, 99, 1 do
			Math.InertialElement.Input(inertial_element, Servo.Monitor.CommandTorque())
			Servo.Timer.Delay(Servo.Timer.Period())
		end

		_dynamic_friction_result = Math.InertialElement.CurrentOutput(inertial_element)
		print("检测到动摩擦为：", _dynamic_friction_result)

		-- 检测完毕，回到原位
		if true then
			Servo.ChangeToPositionMode()
			Servo.Param.SetBothTorqueLimit(100)
			Servo.Param.SetSpeedLimit(100)
			Servo.SetAbsolutePositionAndRun(position)

			-- 等待定位结束
			while true do
				if (Servo.EO.PositioningCompletedSignal()) then
					break
				end
			end
		end

		Servo.Stop()
	end

	--- 动摩擦检测结果
	--- @return integer
	function Detector.DynamicFrictionDetector.Result()
		return _dynamic_friction_result
	end
end
