require("Detector.AccelerationDetector")
require("Detector.DynamicFrictionDetector")

--- 静摩擦转矩检测
if true then
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.StaticFrictionDetector == nil) then
		Detector.StaticFrictionDetector = {}
	end

	--- 在速度模式下以指定的转矩限制值转动
	--- @param torque integer 转矩限制值
	local function RunWithTorque(torque)
		Servo.ChangeToTorqueMode()
		Servo.Param.SetSpeedLimitInTorqueMode(100)
		Servo.SetTorqueAndRun(torque)
	end





	--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
	if true then
		--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
		local _delay = 500

		--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
		--- @return integer
		function Detector.StaticFrictionDetector.Delay()
			return _delay
		end

		--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
		--- @param value integer
		function Detector.StaticFrictionDetector.SetDelay(value)
			_delay = value
		end
	end




	--- 使用二分法，首先指定转矩限制值的区间左右端点，在区间内寻找静摩擦对应的转矩
	local _detecte_result = 0

	--- 检测一次静摩擦转矩
	--- @return integer
	local function DetecteOnce()
		local left_torque = 0
		local right_torque = 0
		local current_torque = 0

		Detector.DynamicFrictionDetector.Detecte()
		right_torque = Detector.DynamicFrictionDetector.Result() + 10
		Servo.Stop()

		while true do
			Servo.Stop()

			-- 停止后再稍微等一会儿，等充分停止了
			Servo.Timer.Delay(100)

			-- 开始二分法
			current_torque = (left_torque + right_torque) / 2
			RunWithTorque(current_torque)
			Servo.Timer.Delay(Detector.StaticFrictionDetector.Delay())

			if (math.abs(Servo.Feedback.Speed()) > 0) then
				-- _current_torque 已经让伺服转起来了，说明大于静摩擦
				right_torque = current_torque - 0.1
			else
				-- 没让伺服转起来，说明 _current_torque 无法克服静摩擦
				left_torque = current_torque + 0.1
			end

			if (left_torque >= right_torque) then
				break
			end
		end

		Servo.Stop()
		return current_torque
	end

	--- 执行检测
	function Detector.StaticFrictionDetector.Detecte()
		local torque_arr = {}
		for i = 0, 9, 1 do
			torque_arr[i] = DetecteOnce()
		end

		torque_arr = Array.RemoveMinMax(torque_arr)
		_detecte_result = Array.CalculateAverage(torque_arr)
		print("检测结束，静摩擦： ", _detecte_result)
	end

	--- 检测结果
	--- @return integer
	function Detector.StaticFrictionDetector.Result()
		return _detecte_result
	end
end
