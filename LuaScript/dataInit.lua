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
		tPlayersave.ChapterRecord = 1;		--章节记录
		tPlayersave.MissionRecord = 2;		--关卡记录
		
		tPlayersave.MissionConfigFileId = 0;	--关卡配置工具文件记录
		data(tPlayersave,savepath)
	end
end

--测试用 获取关卡配置工具文件记录
function p.GetMissionConfigFileId()
	local tPlayersave = {}
	data(savepath, tPlayersave)
	return 	tPlayersave.MissionConfigFileId
end


--测试用 存储关卡配置工具文件记录
function p.SetMissionConfigFileId(nId)
	local tPlayersave = {}
	data(savepath, tPlayersave)
	tPlayersave.MissionConfigFileId =nId;
	data(tPlayersave,savepath)
end

--获取玩家进度  返回:章节,关卡
function p.GetPlayerProccessRecord()
	local tPlayersave = {}
	data(savepath, tPlayersave)
	return 	tPlayersave.ChapterRecord ,tPlayersave.MissionRecord
end

--设置玩家进度  章节,关卡
function p.SetPlayerProccessRecord(nChapter,nMission)
	local tPlayersave = {}
	data(savepath, tPlayersave)
	tPlayersave.ChapterRecord =nChapter;		--章节记录
	tPlayersave.MissionRecord =nMission;		--关卡记录	
	data(tPlayersave,savepath)
end










