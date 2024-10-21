if (true) then
	--- 配置
	if true then
		local function ConfigureEI()
			-- EI9 配置为使能
			Servo.Param.Set(3, 9, 1)

			-- EI10
			-- 正转指令
			Servo.Param.Set(3, 10, 2)

			-- EI11
			-- 定位取消
			Servo.Param.Set(3, 11, 32)

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
			-- 通信转速给定值使能
			Servo.Param.Set(3, 16, 18)
		end

		--- 配置成模式 7
		--- @note 会占用一些通信 EI。
		function Servo.Configure()
			-- 配置成模式 7
			Servo.Param.Set(1, 1, 7)

			-- 定位结束最小 OFF 持续时间
			Servo.Param.Set(1, 34, 20)
			ConfigureEI()

			-- 将通信转速给定值使能 EI 信号设置为 ON，使用通信或脚本来给定转速
			Servo.EI.SetCommunicationSpeedEnable(true)
		end
	end





	--- 模式切换
	--- 所有模式切换函数都会执行以下 2 个步骤：
	--- 	1. 关闭正转 EI 信号
	--- 	2. 取消定位
	if true then
		--- 切换到定位模式
		--- @note 所有模式切换函数都会执行以下 2 个步骤：
		--- 	1. 关闭正转 EI 信号
		--- 	2. 取消定位
		function Servo.ChangeToPositionMode()
			print("切换到定位模式")
			Servo.EI.SetForwardSignal(false)
			Servo.CancelPositioning()

			Servo.EI.Set(12, false)
			Servo.EI.Set(13, false)
		end

		--- 切换到速度控制模式
		--- @note 所有模式切换函数都会执行以下 2 个步骤：
		--- 	1. 关闭正转 EI 信号
		--- 	2. 取消定位
		function Servo.ChangeToSpeedMode()
			print("切换到速度模式")
			Servo.EI.SetForwardSignal(false)
			Servo.CancelPositioning()

			Servo.EI.Set(12, true)
			Servo.EI.Set(13, false)
		end

		--- 切换到转矩控制模式
		--- @note 所有模式切换函数都会执行以下 2 个步骤：
		--- 	1. 关闭正转 EI 信号
		--- 	2. 取消定位
		function Servo.ChangeToTorqueMode()
			print("切换到转矩模式")
			Servo.EI.SetForwardSignal(false)
			Servo.CancelPositioning()

			Servo.EI.Set(12, true)
			Servo.EI.Set(13, true)
		end
	end





	--- 定位、定速运行
	if true then
		--- 设置转速并按此转速运行。
		--- 可以为正负数或 0。设置为正数则正转，负数则反转，0 则停止。
		--- 单位：rpm。
		--- @param value number 浮点数。
		function Servo.SetSpeedAndRun(value)
			-- 要设置的速度如果和当前转速反向了，先断开正转、反转信号。
			if (Servo.Feedback.Speed() * value < 0) then
				Servo.EI.SetForwardSignal(false)
			end

			Servo.Param.SetSpeedLimit(value)
			AXIS_SPEED(value)
			Servo.EI.SetForwardSignal(true)
		end

		--- 设置绝对定位立即数并运行。
		--- @param value integer
		function Servo.SetAbsolutePositionAndRun(value)
			value = math.floor(value)
			local times = 0
			while true do
				AXIS_SPEED(Servo.Param.SpeedLimit())
				AXIS_MOVEABS(value)

				Servo.EI.TriggerRisingEdge(14)
				if (not Servo.EO.PositioningCompletedSignal()) then
					return
				end

				if (Servo.Feedback.Position() == value) then
					return
				end

				times = times + 1
				if (times == 100) then
					print("警告：SetAbsolutePositionAndRun已经循环达到 100 次。")
				end
			end
		end

		--- 设置绝对的圈数并运行
		--- @param value number
		function Servo.SetAbsoluteCircleCountAndRun(value)
			Servo.SetAbsolutePositionAndRun(value * Servo.Feedback.OneCirclePosition())
		end

		--- 设置绝对转矩并运行
		--- @param value number
		function Servo.SetTorqueAndRun(value)
			AXIS_TORQUE(value)
			AXIS_SPEED(Servo.Param.SpeedLimitInTorqueMode())
			Servo.EI.SetForwardSignal(true)
		end

		--- 通过 EI 进行位置预置，设置零点。
		--- @note 因为只有在位置控制模式下才可能进行位置预置，所以会停下伺服，切换到位置
		--- 控制模式，然后通过 EI 进行位置预置，并且还会不断重试，直到反馈位置等于位置预置值。
		function Servo.PresetPosition()
			Servo.ChangeToPositionMode()
			local times = 0
			while true do
				-- 取消定位，直到定位结束信号为 ON
				Servo.CancelPositioning()
				if (Servo.EO.PositioningCompletedSignal()) then
					break
				end

				times = times + 1
				if (times > 100) then
					print("警告：PresetPosition尝试取消定位并等待定位完成信号变成 ON ，循环次数超过 100 次。")
				end
			end

			times = 0
			while true do
				Servo.EI.TriggerRisingEdge(15)
				if (Servo.Feedback.Position() == Servo.Param.Get(2, 19)) then
					break
				end

				times = times + 1
				if (times > 100) then
					print("警告：PresetPosition尝试通过 EI 进行位置预置，并等待反馈位置等于位置预置值 ，循环次数超过 100 次。")
				end
			end
		end

		--- 尝试进行位置预置。
		--- @note 不会取消定位，也不会将伺服停下来后切换到位置模式然后进行位置预置。
		--- @note 这里会检测，如果当前不处于定位完成状态，会直接返回，只有定位完成状态下才会进行位置预置。
		--- @note 本函数进行位置预置时不会重试和确认是否成功。
		function Servo.TryPresetPosition()
			if (not Servo.EO.PositioningCompletedSignal()) then
				-- 还在定位中，直接返回
				print("尝试进行位置预置失败。正在定位中，不能进行进行位置预置。")
				return
			end

			Servo.EI.TriggerRisingEdge(15)
		end

		--- 取消定位
		--- 仅仅触发一次 EI，不会进行重试和确认是否成功。
		function Servo.CancelPositioning()
			Servo.EI.TriggerRisingEdge(11)
		end

		--- 停止转动。
		--- @note 会切换到速度模式，并将速度锁定为 0. 无论原来是什么模式
		--- （定位模式、速度模式、转矩模式）都可以使用。
		function Servo.Stop()
			Servo.ChangeToSpeedMode()
			Servo.SetSpeedAndRun(0)
		end
	end





	--- 使能、禁用
	if true then
		--- 使能伺服
		function Servo.Core.Enable()
			Servo.EI.Set(9, true)
		end

		--- 禁用伺服
		function Servo.Core.Disable()
			Servo.EI.Set(9, false)
		end
	end








	--- EI
	if true then
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

		--- 通信转速给定值使能状态。
		--- @return boolean 返回 true 表示使能通信转速给定值，返回 false 表示不使能。
		function Servo.EI.CommunicationSpeedEnable()
			return Servo.EI.Get(16)
		end

		--- 设置 通信转速给定值使能状态。
		--- @param value boolean 设置 true 表示使能通信转速给定值，设置 false 表示不使能。
		function Servo.EI.SetCommunicationSpeedEnable(value)
			Servo.EI.Set(16, value)
		end
	end






	--- 定位结束（定位完成）信号
	--- @return boolean
	function Servo.EO.PositioningCompletedSignal()
		-- EOUT2 默认的功能代码是 2，即定位完成信号。
		return Servo.EO.Get(2)
	end
end
