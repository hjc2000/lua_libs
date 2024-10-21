if (Array == nil) then
	Array = {}
end

--- 函数：找到并删除最大值和最小值
--- @param t table
--- @return table
function Array.RemoveMinMax(t)
	-- 初始化最大值和最小值
	local max_value = t[1]
	local min_value = t[1]
	local max_index = 1
	local min_index = 1

	-- 遍历数组，找到最大值和最小值及其索引
	for i = 2, #t do
		if t[i] > max_value then
			max_value = t[i]
			max_index = i
		elseif t[i] < min_value then
			min_value = t[i]
			min_index = i
		end
	end

	-- 删除最大值和最小值
	table.remove(t, max_index)
	-- 注意：删除最大值后，最小值的索引可能发生变化
	if max_index < min_index then
		min_index = min_index - 1
	end
	table.remove(t, min_index)

	return t
end

--- 计算数组的平均值
--- @param t table
--- @return integer
function Array.CalculateAverage(t)
	-- 检查数组是否为空
	if #t == 0 then
		return 0 -- 或者抛出错误，取决于你的需求
	end

	-- 初始化总和
	local sum = 0

	-- 遍历数组，累加所有元素
	for i = 1, #t do
		sum = sum + t[i]
	end

	-- 计算平均值
	local average = sum / #t
	average = math.ceil(average)
	return average
end
