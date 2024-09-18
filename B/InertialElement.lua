InertialElement = {}

--- 创建一个惯性环节
--- @param T number 惯性时间常数
--- @param sample_interval number 采样周期
--- @param resolution number 分辨率。当前输出离输入差距小于多少时，就直接将输出值赋值为输入，
--- 避免迟迟不收敛甚至到最后超出浮点精度。
--- @return table 上下文
function InertialElement.New(T, sample_interval, resolution)
	local context = {}
	context.T = T
	context.sample_interval = sample_interval
	context.resolution = math.abs(resolution)

	context.y = 0
	context.ky = context.T / (context.T + context.sample_interval)
	context.kx = context.sample_interval / (context.T + context.sample_interval)
	return context
end

--- 输入一个值并获取输出。
--- @param context table 上下文
--- @param x number 输入值
--- @return number 输出值
function InertialElement.Input(context, x)
	context.y = context.ky * context.y + context.kx * x

	if (math.abs(context.y - x) < context.resolution) then
		context.y = x
	end

	return context.y
end

--- 获取惯性环节当前输出
--- @param context any
--- @return number
function InertialElement.CurrentOutput(context)
	return context.y
end

-- local _inertial_element = InertialElement.New(0.05, 0.010, 0.001)

-- for i = 0, 100 do
-- 	InertialElement.Input(_inertial_element, 5)
-- 	print(InertialElement.CurrentOutput(_inertial_element))
-- end

return InertialElement
