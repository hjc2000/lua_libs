if (Servo == nil) then
	Servo = {}
end

if (Servo.Mode7 == nil) then
	Servo.Mode7 = {}
end

--- 配置成模式 7
--- @note 会占用一些通信 EI。
function Servo.Mode7.Config()
	--- 将 EI 9 配置为使能信号
	local function ConfigEI()
		if (not Servo.EI.ThereIsHardwareEIConfiguredAs_EnableSignal()) then
			-- EI9 配置为使能
			Servo.Param.Set(3, 9, 1)
		else
			print("有硬件 EI 被配置为使能信号，无法将 EI9 配置为使能信号")
		end

		-- EI10
		-- 正转指令
		Servo.Param.Set(3, 10, 2)

		-- EI11
		-- 反转指令
		Servo.Param.Set(3, 11, 3)

		-- EI12
		-- 控制模式切换
		-- OFF 是位置控制。ON 后可通过 EI13 进一步选择速度控制和转矩控制。
		Servo.Param.Set(3, 12, 36)

		-- EI13
		-- 转矩控制、速度控制切换
		-- EI12 为 ON 后，EI13 为 OFF 则是速度控制，为 ON 则是转矩控制。
		Servo.Param.Set(3, 13, 38)

		-- EI14
		-- 定位数据启动
		Servo.Param.Set(3, 14, 4)

		-- EI15
		-- 位置预置
		Servo.Param.Set(3, 15, 16)

		-- EI16
		-- 定位取消
		Servo.Param.Set(3, 16, 32)
	end

	-- 向其他模块注入一些函数
	local function Inject()
		if (Servo.Core == nil) then
			Servo.Core = {}
		end

		if (Servo.EI == nil) then
			Servo.EI = {}
		end

		if (Servo.EO == nil) then
			Servo.EO = {}
		end


		--- 使能伺服
		function Servo.Core.Enable()
			if (not Servo.EI.ThereIsHardwareEIConfiguredAs_EnableSignal()) then
				-- 没有硬件 EI 被配置为使能时才有效
				Servo.EI.Set(9, true)
			else
				print("有硬件 EI 被配置为使能信号，无法将 EI9 配置为使能信号，因此无法使能伺服。")
			end
		end

		--- 禁用伺服
		function Servo.Core.Disable()
			if (not Servo.EI.ThereIsHardwareEIConfiguredAs_EnableSignal()) then
				-- 没有硬件 EI 被配置为使能时才有效
				Servo.EI.Set(9, false)
			else
				print("有硬件 EI 被配置为使能信号，无法将 EI9 配置为使能信号，因此无法禁用伺服。")
			end
		end

		--- 获取 EI 正转信号的值
		--- @return boolean
		function Servo.EI.ForwardSignal()
			return Servo.EI.Get(10)
		end

		--- 设置 EI 正转信号的值
		--- @param value boolean
		function Servo.EI.SetForwardSignal(value)
			Servo.EI.Set(10, value)
		end

		--- 获取 EI 反转信号的值
		--- @return boolean
		function Servo.EI.ReverseSignal()
			return Servo.EI.Get(11)
		end

		--- 设置 EI 反转信号的值
		--- @param value boolean
		function Servo.EI.SetReverseSignal(value)
			Servo.EI.Set(11, value)
		end

		--- 定位结束（定位完成）信号
		--- @return boolean
		function Servo.EO.PositioningCompletedSignal()
			-- EOUT2 默认的功能代码是 2，即定位完成信号。
			return Servo.EO.Get(2)
		end
	end

	-- 配置成模式 7
	Servo.Param.Set(1, 1, 7)
	ConfigEI()
	Inject()
end

--- 切换到定位模式
function Servo.Mode7.ChangeToPositionMode()
	Servo.EI.SetForwardSignal(false)
	Servo.EI.SetReverseSignal(false)
	Servo.Mode7.CancelPositioning()

	Servo.EI.Set(12, false)
end

--- 切换到速度控制模式
function Servo.Mode7.ChangeToSpeedMode()
	Servo.EI.SetForwardSignal(false)
	Servo.EI.SetReverseSignal(false)
	Servo.Mode7.CancelPositioning()

	Servo.EI.Set(12, true)
	Servo.EI.Set(13, false)
end

--- 切换到转矩控制模式
function Servo.Mode7.ChangeToTorqueMode()
	Servo.EI.SetForwardSignal(false)
	Servo.EI.SetReverseSignal(false)
	Servo.Mode7.CancelPositioning()

	Servo.EI.Set(12, true)
	Servo.EI.Set(13, true)
end

--- 设置转速并按此转速运行。
--- 可以为正负数或 0。设置为正数则正转，负数则反转，0 则停止。
--- 单位：rpm。
--- @param value number 浮点数。
function Servo.Mode7.SetSpeedAndRun(value)
	-- 要设置的速度如果和当前转速反向了，先断开正转、反转信号。
	if (Servo.Feedback.Speed() * value < 0) then
		Servo.EI.SetForwardSignal(false)
		Servo.EI.SetReverseSignal(false)
	end

	Servo.Param.SetSpeedLimit(value)
	AXIS_SPEED(value)

	if (value > 0) then
		-- 正转
		Servo.EI.SetForwardSignal(true)
		Servo.EI.SetReverseSignal(false)
	elseif (value < 0) then
		-- 反转
		Servo.EI.SetForwardSignal(false)
		Servo.EI.SetReverseSignal(true)
	end
end

--- 设置绝对定位立即数并运行。
--- @param value integer
function Servo.Mode7.SetAbsolutePositionAndRun(value)
	AXIS_MOVEABS(value)
	Servo.EI.TriggerRisingEdge(14)
end

--- 通过 EI 进行位置预置，设置零点
function Servo.Mode7.PresetPosition()
	Servo.EI.TriggerRisingEdge(15)
end

--- 取消定位
function Servo.Mode7.CancelPositioning()
	Servo.EI.TriggerRisingEdge(16)
end

--- 停止转动，将速度锁定为 0. 无论原来是什么模式（定位模式、速度模式、转矩模式）都可以使用。
function Servo.Mode7.Stop()
	Servo.Mode7.ChangeToSpeedMode()
	Servo.Mode7.SetSpeedAndRun(0)
end
