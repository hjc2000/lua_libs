--- 静摩擦转矩检测
if true then
	if (StaticFrictionDetector == nil) then
		StaticFrictionDetector = {}
	end

	--- 在速度模式下以指定的转矩限制值转动
	--- @param torque integer 转矩限制值
	local function RunWithTorque(torque)
		Servo.ChangeToSpeedMode()
		Servo.Param.SetBothTorqueLimit(torque)
		Servo.SetSpeedAndRun(100)
	end

	--- 将转矩限制值放开到 100%，然后将速度设置为 0，让伺服快速停下来，停下来后才能进行下一次的静摩擦检测。
	local function Stop()
		Servo.Param.SetBothTorqueLimit(100)
		Servo.Stop()
		while math.abs(Servo.Feedback.Speed()) > 5 do
			-- 等待直到伺服停止
		end
	end


	--- 使用二分法，首先指定转矩限制值的区间左右端点，在区间内寻找静摩擦对应的转矩
	local _detecte_result = 0

	--- 检测一次静摩擦转矩
	--- @return integer
	local function DetecteOnce()
		local left_torque = 0
		local right_torque = 100

		while true do
			local current_torque = (left_torque + right_torque) // 2
			if (left_torque >= right_torque) then
				return current_torque
			end

			RunWithTorque(current_torque)
			Servo.Timer.Delay(1000)

			if (Servo.Feedback.Speed() > 10) then
				-- _current_torque 已经让伺服转起来了，说明大于静摩擦
				right_torque = current_torque - 1
			else
				-- 没让伺服转起来，说明 _current_torque 无法克服静摩擦
				left_torque = current_torque + 1
			end

			Stop()
		end
	end

	--- 执行检测
	function StaticFrictionDetector.Detecte()
		local torque_arr = {}
		for i = 1, 10, 1 do
			torque_arr[i] = DetecteOnce()
		end

		torque_arr = Array.RemoveMinMax(torque_arr)
		_detecte_result = Array.CalculateAverage(torque_arr)
		print("检测结束，静摩擦： ", _detecte_result)
	end

	--- 检测结果
	--- @return integer
	function StaticFrictionDetector.Result()
		return _detecte_result
	end
end
