function Inject()
	if (Servo == nil) then
		Servo = {}
	end

	if (Servo.Core == nil) then
		Servo.Core = {}
	end

	--- 重启伺服
	function Servo.Core.Restart()
		Servo.Param.Set(3, 98, 9999)
	end
end

Inject()
