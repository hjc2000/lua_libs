require("Detector.StaticFrictionDetector")

-- 动摩擦和转动惯量检测器
if true then
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.DynamicFrictionDetector == nil) then
		-- 动摩擦和转动惯量检测器
		Detector.DynamicFrictionDetector = {}
	end





	-- 结果
	if true then
		local _dynamic_friction_result = 0
		local _moment_of_inertia_result = 0

		--- 执行检测
		function Detector.DynamicFrictionDetector.Detecte()
			--- 步骤：
			--- 	* 测量静摩擦，设为 f1。
			--- 	* 得出等会儿要用的正转转矩 f2 = 4 * f1
			--- 	* 得出等会儿要用的反转转矩 f3 = 2 * f1
			---
			--- 	* 转矩控制时的转速限制值设置为 500rpm。
			--- 	* 启动定时器。
			--- 	* 以 f2 转矩正转启动，脚本不断轮询，等转速超过 400rpm 的时候读取定时器的时间，然后计算加速度 1。
			--- 	* 重置定时器。
			---		* 以 -f3 转矩减速，等转速减到小于 0 时，读取定时器的时间，然后计算加速度 2。
			---		* 解方程得出动摩擦转矩和转动惯量。
			Detector.StaticFrictionDetector.Detecte()
			local static_friction = Detector.StaticFrictionDetector.Result()
			local torque_forward = static_friction + 0.4
			local torque_reverse = static_friction + 0.1
			Servo.ChangeToTorqueMode()
			Servo.Param.SetSpeedLimitInTorqueMode(500)
			TIM_START(2, 1)
			Servo.SetTorqueAndRun(torque_forward)
			while (Servo.Feedback.Speed() < Servo.Param.SpeedLimitInTorqueMode()) do
				-- 等待直到速度达到或超过限制值
				TIM_CHECK(2)
			end

			local milliseconds = TIM_VALUE(2)
			print("经过了", milliseconds, "毫秒加速到：", Servo.Feedback.Speed())
			TIM_RESET(2)
		end

		--- 动摩擦检测结果
		--- @return integer
		function Detector.DynamicFrictionDetector.DynamicFrictionResult()
			return _dynamic_friction_result
		end

		--- 转动惯量检测结果
		--- @return integer
		function Detector.DynamicFrictionDetector.MomentOfInertiaResult()
			return _moment_of_inertia_result
		end
	end
end
