if true then
	if (Calculator == nil) then
		Calculator = {}
	end

	if (Calculator.MaxStaticFrictionCalculator == nil) then
		--- 最大静摩擦计算器。
		Calculator.MaxStaticFrictionCalculator = {}
	end

	--- 构造一个新的最大静摩擦计算器。
	--- @param f_max number 光轴时的最大静摩擦。
	--- @param mu number 摩擦系数。
	function Calculator.MaxStaticFrictionCalculator.New(f_max, mu)
		local context = {}
		context.f_max = f_max
		context.mu = mu
		return context
	end

	--- 计算当前的最大摩擦力。
	--- @param context table
	--- @param weight number 当前施加到轴上的重量或压力。单位：N.
	function Calculator.MaxStaticFrictionCalculator.Calculate(context, weight)
		return context.f_max + context.mu * weight
	end
end
