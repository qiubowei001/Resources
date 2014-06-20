--dataInit �洢���ݳ�ʼ��
--�ڽ�����Ϸ������ʱ����
dataInit = {}
local  p = dataInit;

local savepath = "save/player1.xml"

--��һ�ν�����Ϸ��ʼ���������
function p.InitPlayerSave()
	--��ȡ����ͼ����Ϣ
	local tPlayersave = {}
	data(savepath, tPlayersave)
	local bIfNil = true	--�Ƿ��ǿ��ļ�
	
	for i,v in pairs(tPlayersave)do
		bIfNil = false --�ǿ�
		break;
	end

	if bIfNil  then
		tPlayersave.lesson = false;--��ҽ̳�
		tPlayersave.music = true;--����
		tPlayersave.sound = true;--��Ч
		tPlayersave.ChapterRecord = 1;		--�½ڼ�¼
		tPlayersave.MissionRecord = 2;		--�ؿ���¼
		
		tPlayersave.MissionConfigFileId = 0;	--�ؿ����ù����ļ���¼
		tPlayersave.Coin = 100;--���ˮ��
		data(tPlayersave,savepath)
	end
end

--������ ��ȡ�ؿ����ù����ļ���¼
function p.GetMissionConfigFileId()
	local tPlayersave = {}
	data(savepath, tPlayersave)
	return 	tPlayersave.MissionConfigFileId
end


--������ �洢�ؿ����ù����ļ���¼
function p.SetMissionConfigFileId(nId)
	local tPlayersave = {}
	data(savepath, tPlayersave)
	tPlayersave.MissionConfigFileId =nId;
	data(tPlayersave,savepath)
end

--��ȡ��ҽ���  ����:�½�,�ؿ�
function p.GetPlayerProccessRecord()
	cclog("qbw99:GetPlayerProccessRecord111")
	local tPlayersave = {}
	cclog("qbw99:GetPlayerProccessRecord2")
	
	data(savepath, tPlayersave)
	cclog("qbw99:GetPlayerProccessRecord3")
	
	cclog("qbw99:GetPlayerProccessRecord3 tPlayersave.ChapterRecord:"..tPlayersave.ChapterRecord)
	cclog("qbw99:GetPlayerProccessRecord3 tPlayersave.MissionRecord:"..tPlayersave.MissionRecord)
	
	
	return 	tPlayersave.ChapterRecord ,tPlayersave.MissionRecord
end

--������ҽ���  �½�,�ؿ�
function p.SetPlayerProccessRecord(nChapter,nMission)
	local tPlayersave = {}
	data(savepath, tPlayersave)
	tPlayersave.ChapterRecord =nChapter;		--�½ڼ�¼
	tPlayersave.MissionRecord =nMission;		--�ؿ���¼	
	data(tPlayersave,savepath)
end


--��ȡ���ˮ��
function p.GetPlayerCoin()
	local tPlayersave = {}
	data(savepath, tPlayersave)	
	return 	tPlayersave.Coin
end

--��ȡ���ˮ��
function p.SetPlayerCoin(nCoin)
	local tPlayersave = {}
	data(savepath, tPlayersave)
	tPlayersave.Coin =nCoin;
	data(tPlayersave,savepath)	
end





