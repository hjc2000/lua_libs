if (Detector == nil) then
	Detector = {}
end

if (AccelerationDetector == nil) then
	AccelerationDetector = {}
end


require("Math.InertialElement")

--- 执行检测
function Detector.AccelerationDetector.Detect()
	if (Detector.AccelerationDetector._inertial_element == nil) then
		--- 分辨率选择 0.1，避免收敛速度过慢。
		--- 加速度小于 0.1，也就是 10ms 内速度差小于 1rpm，就认为加速度达到 0 了。
		Detector.AccelerationDetector._inertial_element = Math.InertialElement.New(0.05, 0.010, 0.1)
	end

	local current_feedback_speed = Servo.Feedback.Speed()

	-- 速度的增量除以定时周期 Servo.Timer.Period()，得到加速度
	local acceleration = (current_feedback_speed - Detector.AccelerationDetector._last_feedback_speed) /
		Servo.Timer.Period()

	Math.InertialElement.Input(Detector.AccelerationDetector._inertial_element, acceleration)
	Detector.AccelerationDetector._last_feedback_speed = current_feedback_speed
end

--- 加速度。经过了滤波的。
--- @return number
function Detector.AccelerationDetector.Acceleration()
	local acceleration = Math.InertialElement.CurrentOutput(Detector.AccelerationDetector._inertial_element)
	return acceleration
end
