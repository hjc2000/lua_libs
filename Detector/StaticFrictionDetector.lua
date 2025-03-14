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

	--- 切换到转矩模式，速度限制 50，以指定的转矩转动。
	--- @param torque integer 转矩限制值
	local function RunWithTorque(torque)
		Servo.ChangeToTorqueMode()
		Servo.Param.SetSpeedLimitInTorqueMode(50)
		Servo.SetTorqueAndRun(torque)
	end

	--- 检测完毕，回到原位。
	--- 每次动作前，记录当前位置，完成后用此函数回到原始位置。
	--- @param origin_position integer 原始位置
	local function ReturnToOriginPosition(origin_position)
		Servo.ChangeToPositionMode()
		Servo.Param.SetBothTorqueLimit(100)
		Servo.Param.SetSpeedLimit(100)
		Servo.SetAbsolutePositionAndRun(origin_position)

		-- 等待定位结束
		while true do
			if (Servo.EO.PositioningCompletedSignal()) then
				break
			end
		end
	end


	--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
	if true then
		--- 设置完速度指令后，要等待多少毫秒的延时之后才开始检测电机速度
		local _delay = 1000

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

		Detector.DynamicFrictionDetector.Detect()
		right_torque = Detector.DynamicFrictionDetector.Result() + 10
		if (right_torque > 100) then
			print("right_torque 超过100，为：", right_torque, "现限幅到100")
			right_torque = 100
		end

		Servo.Stop()

		-- 停止后再稍微等一会儿，等充分停止了
		Servo.Timer.Delay(1000)

		while true do
			-- 记录当前位置，检测完毕后要回到此位置
			local position = Servo.Feedback.Position()

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

			ReturnToOriginPosition(position)
			Servo.Stop()

			-- 停止后再稍微等一会儿，等充分停止了
			Servo.Timer.Delay(1000)
		end

		Servo.Stop()
		return current_torque
	end

	--- 执行检测
	--- 检测完后会回到原位
	function Detector.StaticFrictionDetector.Detect()
		-- 记录当前位置，检测完毕后要回到此位置
		local position = Servo.Feedback.Position()

		local torque_arr = {}
		for i = 0, 3, 1 do
			torque_arr[i] = DetecteOnce()
		end

		torque_arr = Array.RemoveMinMax(torque_arr)
		_detecte_result = Array.CalculateAverage(torque_arr)
		print("检测结束，静摩擦： ", _detecte_result)

		ReturnToOriginPosition(position)
		Servo.Stop()
	end

	--- 检测结果
	--- @return integer
	function Detector.StaticFrictionDetector.Result()
		return _detecte_result
	end
end
