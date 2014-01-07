--dataInit 存储数据初始化
--在进入游戏主界面时调用
dataInit = {}
local  p = dataInit;


local savepath = "save\\player1.xml"


--第一次进入游戏初始化玩家数据
function p.InitPlayerSave()
	--读取怪物图鉴信息
	local tPlayersave = {}
	data(savepath, tPlayersave)
	local bIfNil = true	--是否是空文件
	
	for i,v in pairs(tPlayersave)do
		bIfNil = false --非空
		break;
	end

	if bIfNil  then
		tPlayersave.lesson = false;--玩家教程
		tPlayersave.music = true;--音乐
		tPlayersave.sound = true;--音效
		data(tPlayersave,savepath)
	end
end