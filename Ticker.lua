if (Ticker == nil) then
	Ticker = {}
end

--- 滴答定时器
--- @param interval integer 你等会儿调用 Ticker.Tick 的时间间隔。例如你 10ms 会调用 1 次，就传入 10
--- @param period integer 定时的周期。每次你调用 Ticker.Tick 后，定时器内部会递增时间，当时间大于等于
--- period 时会发生回调，并将内部计时变量置为 0。
--- @param callback function|nil
--- @return {interval:integer, period:integer, callback:function|nil, tick:integer}
function Ticker.New(interval, period, callback)
	local context = {}
	context.interval = interval
	context.period = period
	context.callback = callback
	context.tick = 0
	return context
end

--- 递增内部时间变量，如果定时时间到，会触发回调。
--- @param context {interval:integer, period:integer, callback:function|nil, tick:integer} 上下文
---
--- @return boolean 定时时间到返回 true，否则返回 false。
--- @note 定时时间到后，因为内部计时变量被置为 0 了，所以当前返回 true，但是后续调用时，除非定时时间到了，否则返回 false。
function Ticker.Tick(context)
	context.tick = context.tick + context.interval
	if (context.tick < context.period) then
		return false
	end

	context.tick = 0
	if (context.callback ~= nil) then
		context.callback()
	end

	return true
end
