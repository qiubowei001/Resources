--事件触发功能
cclog("GlobalEvent 1")
GlobalEvent = {};
local p = GlobalEvent;


--[[
tGlobalEvent = 
{
	[nEventtype] = {func1,func2,func3 ...}

}
--]]
local tGlobalEvent = {}

--初始化事件触发表
function p.InitEventTable()
	tGlobalEvent = {}
	for i,nEventtype in pairs(GLOBAL_EVENT)do
		tGlobalEvent[nEventtype] = {}
	end
end	

--注册全局事件
function p.RegisterEvent(nEventtype,fFunc)
	table.insert(tGlobalEvent[nEventtype],fFunc)
end

--注销全局事件
function p.unRegisterEvent(nEventtype,fFuncUnregister)
	for i,func in pairs(tGlobalEvent[nEventtype])do
		if fFuncUnregister == func then
			table.remove(tGlobalEvent[nEventtype],i)
			return
		end
	end
end


--触发事件函数
function p.OnEvent(nEventtype)
	local tFunc = tGlobalEvent[nEventtype]
	for i,func in pairs(tFunc)do
		func();
	end
end