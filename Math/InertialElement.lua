function Inject()
	if (Math == nil) then
		Math = {}
	end

	if (Math.InertialElement == nil) then
		Math.InertialElement = {}
	end

	--- 创建一个惯性环节
	--- @param T number 惯性时间常数
	--- @param sample_interval number 采样周期
	--- @param resolution number 分辨率。当前输出离输入差距小于多少时，就直接将输出值赋值为输入，
	--- 避免迟迟不收敛甚至到最后超出浮点精度。
	--- @return {T:number, sample_interval:number, resolution:number, y:number, ky:number, kx:number} 上下文
	function Math.InertialElement.New(T, sample_interval, resolution)
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
	--- @param context {T:number, sample_interval:number, resolution:number, y:number, ky:number, kx:number} 上下文
	--- @param x number 输入值
	--- @return number 输出值
	function Math.InertialElement.Input(context, x)
		context.y = context.ky * context.y + context.kx * x

		if (math.abs(context.y - x) < context.resolution) then
			context.y = x
		end

		return context.y
	end

	--- 获取惯性环节当前输出
	--- @param context {T:number, sample_interval:number, resolution:number, y:number, ky:number, kx:number} 上下文
	--- @return number
	function Math.InertialElement.CurrentOutput(context)
		return context.y
	end
end

Inject()
