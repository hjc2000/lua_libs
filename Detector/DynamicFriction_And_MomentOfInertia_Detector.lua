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
