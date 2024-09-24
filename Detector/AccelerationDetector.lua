require("Servo.Timer")
require("Servo.Feedback")
require("Math.InertialElement")

function Inject()
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.AccelerationDetector == nil) then
		Detector.AccelerationDetector = {}
	end

	--- Servo.Timer.Period() 默认值是 10ms，10 / 100 = 0.1 加速度小于 0.1，
	--- 也就是 10ms 内速度差小于 1rpm，就认为加速度达到 0 了。
	local _inertial_element = Math.InertialElement.New(0.05, 0.010, 0.1)
	local current_feedback_speed = 0
	local _last_feedback_speed = 0

	--- 执行检测
	function Detector.AccelerationDetector.Detect()
		current_feedback_speed = Servo.Feedback.Speed()

		-- 速度的增量除以定时周期 Servo.Timer.Period()，得到加速度
		local acceleration = (current_feedback_speed - _last_feedback_speed) / Servo.Timer.Period()
		Math.InertialElement.Input(_inertial_element, acceleration)
		_last_feedback_speed = current_feedback_speed
	end

	--- 加速度。经过了滤波的。
	--- @return number
	function Detector.AccelerationDetector.Acceleration()
		local acceleration = Math.InertialElement.CurrentOutput(_inertial_element)
		return acceleration
	end
end

Inject()
