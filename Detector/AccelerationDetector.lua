require("Servo.Timer")
require("Servo.Feedback")
require("Math.InertialElement")

if (true) then
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.AccelerationDetector == nil) then
		Detector.AccelerationDetector = {}
	end

	--- Servo.Timer.Period() 默认值是 10ms，10 / 100 = 0.1 加速度小于 0.1，
	--- 也就是 10ms 内速度差小于 1rpm，就认为加速度达到 0 了。
	local _inertial_element = Math.InertialElement.New(0.05, 0.010, 0.1)
	local _current_feedback_speed = 0
	local _last_feedback_speed = 0

	--- 执行检测
	function Detector.AccelerationDetector.Detect()
		_current_feedback_speed = Servo.Feedback.Speed()

		-- 速度的增量除以定时周期 Servo.Timer.Period()，得到加速度
		local acceleration = (_current_feedback_speed - _last_feedback_speed) / Servo.Timer.Period()
		Math.InertialElement.Input(_inertial_element, acceleration)
		_last_feedback_speed = _current_feedback_speed
	end

	--- 加速度。经过了滤波的。
	--- @return number
	function Detector.AccelerationDetector.Acceleration()
		local acceleration = Math.InertialElement.CurrentOutput(_inertial_element)
		return acceleration
	end

	--- 惯性转矩对于电机来说是负载。
	--- 即电机输出的转矩的绝对值大于匀速时的负载转矩的绝对值，因为此时惯性转矩也作为电机的负载，抵抗
	--- 电机转动，而不是帮助电机转动。这说明惯性转矩与指令转矩反向。
	--- @return boolean
	function Detector.AccelerationDetector.InertialTorqueIsTheLoad()
		--- 加速度的方向与施加到电机轴上的惯性转矩方向相反，所以加速度方向取反就得到惯性转矩方向。
		--- 惯性转矩乘上指令转矩，为负数就说明惯性转矩和指令转矩方向相反，此时惯性转矩作为电机的
		--- 负载，抵抗电机转动。
		return -Detector.AccelerationDetector.Acceleration() * Servo.Monitor.CommandTorque() < 0
	end

	--- 惯性转矩与电机指令转矩方向相反时，惯性转矩作为电机的负载，抵抗电机转动。本函数用来量化这种负载，
	--- 量化的方式就是返回加速度大小。
	--- 只有在惯性转矩为电机负载时才会返回加速度大小，否则返回 0.
	--- @return number
	function Detector.AccelerationDetector.AccelerationLoad()
		if (Detector.AccelerationDetector.InertialTorqueIsTheLoad()) then
			return math.abs(Detector.AccelerationDetector.Acceleration())
		end

		return 0
	end
end
