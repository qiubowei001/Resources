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
		data(tPlayersave,savepath)
	end
end