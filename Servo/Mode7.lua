if (Servo == nil) then
	Servo = {}
end

if (Servo.Mode7 == nil) then
	Servo.Mode7 = {}
end

if (Servo.Core == nil) then
	Servo.Core = {}
end

if (Servo.EI == nil) then
	Servo.EI = {}
end

--- 配置成模式 7
--- @note 会占用一些通信 EI。
function Servo.Mode7.Config()
	--- 将 EI 9 配置为使能信号
	local function ConfigEI()
		if (Servo.Param.Get(3, 1) == 1) then
			-- 默认状态下，EI1 是伺服使能，想要让 EI9 是伺服使能，需要释放 EI1
			Servo.Param.Set(3, 1, 0)
		end

		-- EI9 配置为使能
		Servo.Param.Set(3, 9, 1)

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

	-- 配置成模式 7
	Servo.Param.Set(1, 1, 7)
	ConfigEI()
end

--- 使能伺服
function Servo.Core.Enable()
	Servo.EI.Set(9, true)
end

--- 禁用伺服
function Servo.Core.Disable()
	Servo.EI.Set(9, false)
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
