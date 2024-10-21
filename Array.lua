if (Array == nil) then
	Array = {}
end

--- 获取数组元素的个数
--- @param t table
--- @return integer
function Array.Count(t)
	return #t + 1
end

--- 移除数组中指定索引位置的元素
--- @param t table
--- @param index integer
--- @return table
function Array.RemoveAt(t, index)
	if (index < 0 or (index >= Array.Count(t))) then
		print("index 超出范围")
		return t
	end

	if (Array.Count(t) <= 1) then
		return {}
	end

	for i = index, Array.Count(t) - 2, 1 do
		t[i] = t[i + 1]
	end

	-- 将最后一个元素赋值为 nil 从而删除
	t[Array.Count(t) - 1] = nil
	return t
end

--- 找到并删除最大值和最小值
--- @param t table
--- @return table
function Array.RemoveMinMax(t)
	if (Array.Count(t) < 2) then
		return t
	end

	-- 初始化最大值和最小值
	local max_value = t[0]
	local min_value = t[0]
	local max_index = 0
	local min_index = 0

	-- 遍历数组，找到最大值和最小值及其索引
	for i = 1, Array.Count(t) - 1 do
		if t[i] > max_value then
			max_value = t[i]
			max_index = i
		elseif t[i] < min_value then
			min_value = t[i]
			min_index = i
		end
	end

	-- 删除最大值和最小值
	Array.RemoveAt(t, max_index)

	-- 注意：删除最大值后，最小值的索引可能发生变化
	if (min_index > max_index) then
		min_index = min_index - 1
	end

	Array.RemoveAt(t, min_index)
	return t
end

--- 计算数组的平均值
--- @param t table
--- @return integer
function Array.CalculateAverage(t)
	-- 检查数组是否为空
	if (Array.Count(t) == 0) then
		return 0
	end

	-- 初始化总和
	local sum = 0

	-- 遍历数组，累加所有元素
	for i = 0, Array.Count(t) - 1 do
		sum = sum + t[i]
	end

	-- 计算平均值
	local average = sum / Array.Count(t)
	return average
end
