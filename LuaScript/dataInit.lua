--dataInit �洢���ݳ�ʼ��
--�ڽ�����Ϸ������ʱ����
dataInit = {}
local  p = dataInit;


local savepath = "save\\player1.xml"


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
	local tPlayersave = {}
	data(savepath, tPlayersave)
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










