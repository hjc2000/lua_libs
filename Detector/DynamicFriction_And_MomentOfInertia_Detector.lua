-- 动摩擦和转动惯量检测器
if true then
	if (Detector == nil) then
		Detector = {}
	end

	if (Detector.DynamicFriction_And_MomentOfInertia_Detector == nil) then
		-- 动摩擦和转动惯量检测器
		Detector.DynamicFriction_And_MomentOfInertia_Detector = {}
	end





	-- 结果
	if true then
		local _dynamic_friction_result = 0
		local _moment_of_inertia_result = 0

		--- 执行检测
		function Detector.DynamicFriction_And_MomentOfInertia_Detector.Detecte()
			--- 步骤：
			--- 	* 测量静摩擦，设为 f1。
			--- 	* 得出等会儿要用的正转转矩 f2 = 4 * f1
			--- 	* 得出等会儿要用的反转转矩 f3 = 2 * f1
			---
			--- 	* 转矩控制时的转速限制值设置为 500rpm。
			--- 	* 启动定时器。
			--- 	* 以 f2 转矩正转启动，脚本不断轮询，等转速超过 400rpm 的时候读取定时器的时间，然后计算加速度 1。
			--- 	* 重置定时器。
			---		* 以 -f3 转矩减速，等转速减到小于 0 时，读取定时器的时间，然后计算加速度 2。
			---		* 解方程得出动摩擦转矩和转动惯量。
		end

		--- 动摩擦检测结果
		--- @return integer
		function Detector.DynamicFriction_And_MomentOfInertia_Detector.DynamicFrictionResult()
			return _dynamic_friction_result
		end

		--- 转动惯量检测结果
		--- @return integer
		function Detector.DynamicFriction_And_MomentOfInertia_Detector.MomentOfInertiaResult()
			return _moment_of_inertia_result
		end
	end
end
