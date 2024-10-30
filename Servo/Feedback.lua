if (true) then
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Feedback == nil) then
		Servo.Feedback = {}
	end

	--- 反馈速度。有正负。单位：rpm
	--- @return integer
	function Servo.Feedback.Speed()
		local speed = SRV_MON(0)
		if (Servo.Param.Get(1, 4) == 1) then
			--- 运行方向如果设置为反向，监控数据中读取到的反馈速度并不会自动反向，
			--- 需要脚本取相反数，从而将参考正方向切换到反向。
			speed = -speed
		end

		return speed
	end

	--- 反馈位置。能被位置预置清 0。此外还受参数中设置的 “编码器旋转一圈的脉冲数” 影响。
	--- 这个参数设置为多少，旋转一圈本属性就变化多少。
	---
	--- 当 “编码器旋转一圈的脉冲数” 设置为 0 时，电子齿轮比生效，此时本属性受电子齿轮比影响。
	---
	--- @return integer
	function Servo.Feedback.Position()
		local position = SRV_MON(6)
		if (Servo.Param.Get(1, 4) == 1) then
			position = -position
		end

		return position
	end

	--- 脚本中要让电机转一圈，AXIS_MOVEABS 函数的参数要传入多少。
	--- 或者说电机转一圈后，反馈位置 Servo.Feedback.Position() 会是多少。
	--- @return number
	function Servo.Feedback.OneCirclePosition()
		--- 编码器实际一圈的脉冲数 / 希望的一圈的脉冲数 = 电子齿轮比
		--- 希望的一圈的脉冲数 = 编码器实际一圈的脉冲数 / 电子齿轮比

		local bit_count = Servo.Param.EncoderBitCount()
		local pulse_count = 2 ^ bit_count
		local ratio = Servo.Param.Get(1, 6) / Servo.Param.Get(1, 7)
		return pulse_count / ratio
	end

	--- 当前的绝对圈数
	--- @return number
	function Servo.Feedback.CircleCount()
		return Servo.Feedback.Position() / Servo.Feedback.OneCirclePosition()
	end
end
