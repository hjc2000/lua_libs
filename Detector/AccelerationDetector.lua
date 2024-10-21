require("Math.InertialElement")
require("Servo.Monitor")
require("Servo.Feedback")
require("Servo.Timer")

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
	--- @note 当惯性转矩方向与电机指令转矩方向相反时，惯性转矩对电机来说是负载。
	--- 当惯性转矩与电机指令转矩方向相同时，惯性转矩对电机来说时助力。
	--- @return boolean
	function Detector.AccelerationDetector.InertialTorqueIsTheLoad()
		--- 加速度方向与惯性转矩方向相反。所以加速度取相反数，得到的数的符号就与惯性转矩的符号一样。
		--- 将 -Detector.AccelerationDetector.Acceleration() 与指令转矩相乘，得到的如果是负数，
		--- 就说明惯性转矩与指令转矩符号相反，则惯性转矩对电机来说是负载。
		return -Detector.AccelerationDetector.Acceleration() * Servo.Monitor.CommandTorque() < 0
	end

	--- 惯性转矩与电机指令转矩方向相反时，惯性转矩作为电机的负载，惯性转矩与电机指令转矩方向相同时，惯性转矩作为电机的助力。
	---
	--- 本函数用来量化这种负载或助力，量化的方式就是返回据以下规则赋予正负号的加速度大小：
	--- 1. 当惯性转矩为电机负载时返回正数，因为此时是正负载。
	--- 2. 当惯性转矩不是电机负载，反而帮助电机转动时，时返回负数，因为此时是负负载，负负得正，于是是助力。
	--- @return number
	function Detector.AccelerationDetector.AccelerationLoad()
		if (Detector.AccelerationDetector.InertialTorqueIsTheLoad()) then
			return math.abs(Detector.AccelerationDetector.Acceleration())
		else
			return -math.abs(Detector.AccelerationDetector.Acceleration())
		end
	end
end
