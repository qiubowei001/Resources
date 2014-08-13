--�¼���������
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

--��ʼ���¼�������
function p.InitEventTable()
	tGlobalEvent = {}
	for i,nEventtype in pairs(GLOBAL_EVENT)do
		tGlobalEvent[nEventtype] = {}
	end
end	

--ע��ȫ���¼�
function p.RegisterEvent(nEventtype,fFunc)
	table.insert(tGlobalEvent[nEventtype],fFunc)
end

--ע��ȫ���¼�
function p.unRegisterEvent(nEventtype,fFuncUnregister)
	for i,func in pairs(tGlobalEvent[nEventtype])do
		if fFuncUnregister == func then
			table.remove(tGlobalEvent[nEventtype],i)
			return
		end
	end
end


--�����¼�����
function p.OnEvent(nEventtype)
	local tFunc = tGlobalEvent[nEventtype]
	for i,func in pairs(tFunc)do
		func();
	end
end