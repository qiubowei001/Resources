--�ؿ�����

mission = {};
local p = mission;
local nRound = 0;
local gMission = 1

local gWaveDelay = 0
--���ǵ�һ�� ��һЩ����
--�����������   ============��,��,Ѫ
--����ɱ��
--���﹥��CD����
--���﹥����ȥѪ,Ѫ�����
--��Ѫ��Ѫ
--����ÿ����Ϊ��������
--��������ʼ����ƿ ������ �����ظ����� ============��,��,Ѫ,��
--����� ============��,��,��,Ѫ,��
--������������װ��ʱ ���������װ��	
--�����1��buff����   --��һ��ֻ����2������
-- ���ʹ��BUFF
--�ٴ����� �����һ����ɱ����
-- ���ʹ�õ�ɱ����

MISSION_TABLE = {}
MISSION_TABLE[1] = {}
MISSION_TABLE[1]["name"] = "ChapterI MISSION1"
MISSION_TABLE[1]["BgId"] = 1 --����
MISSION_TABLE[1]["configId"] = 1
MISSION_TABLE[1]["config"] = {}
MISSION_TABLE[1]["StartGold"] = 500



MISSION_TABLE[2] = {}
MISSION_TABLE[2]["name"] = "ChapterIII"
MISSION_TABLE[2]["configId"] = 2
MISSION_TABLE[2]["config"] = {}
MISSION_TABLE[2]["StartGold"] = 500


MISSION_TABLE[3] = {}
MISSION_TABLE[3]["name"] = "ChapterI MISSION3"
MISSION_TABLE[3]["BgId"] = 1 --����
MISSION_TABLE[3]["configId"] = 3
MISSION_TABLE[3]["config"] = {}
MISSION_TABLE[3]["StartGold"] = 500


MISSION_TABLE[4] = {}
MISSION_TABLE[4]["name"] = "ChapterI MISSION3"
MISSION_TABLE[4]["BgId"] = 1 --����
MISSION_TABLE[4]["configId"] = 4
MISSION_TABLE[4]["config"] = {}
MISSION_TABLE[4]["StartGold"] = 500

MISSION_TABLE[5] = {}
MISSION_TABLE[5]["name"] = "ChapterI MISSION3"
MISSION_TABLE[5]["BgId"] = 1 --����
MISSION_TABLE[5]["configId"] = 5
MISSION_TABLE[5]["config"] = {}
MISSION_TABLE[5]["StartGold"] = 500

MISSION_TABLE[6] = {}
MISSION_TABLE[6]["name"] = "ChapterI MISSION3"
MISSION_TABLE[6]["BgId"] = 2 --����
MISSION_TABLE[6]["configId"] = 6
MISSION_TABLE[6]["config"] = {}
MISSION_TABLE[6]["StartGold"] = 500

function p.GetRound()
	return nRound
end
	
--��ȡXML�ؿ�����
function p.LoadMissionData(index)
	--for i,v in pairs(MISSION_TABLE) do
		local savepath = "data/missionConfig/mission"..MISSION_TABLE[index]["configId"] ..".xml"
		local tcache = {}
		data(savepath, tcache)
		MISSION_TABLE[index]["config"] = tcache
	--end
end



--��ȡ�غ���Ϣ��
function p.GetRoundInfoTable()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	print("GetRoundInfoTable begin")
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		print("GetRoundInfoTable i:"..i)
		roundBoundMax = roundBoundMin + v[1];
		print("GetRoundInfoTable nRound:roundBoundMax:roundBoundMin:"..nRound.." "..roundBoundMax.." "..roundBoundMin)
		
		if nRound <= roundBoundMax  and nRound > roundBoundMin  then
			return v
		else 
			--�ڻغ���
			roundBoundMin = roundBoundMin + v[1];
		end
	end
	cclog("GetRoundInfoTable fail")
	return nil
end



--��ʼ��MISSION��Ϣ
function p.SetMission(nMission)
	gMission = nMission
	p.LoadMissionData(nMission)


	nRound = 1;
	local v = p.GetRoundInfoTable()
	gWaveDelay = v[4]
	
	
end

function p.GetMission()
	return gMission;
end

function p.GetMissionDesc()
	return MISSION_TABLE[gMission]["name"]
end

function p.RoundPlusOne()
	nRound = nRound +1;
	cclog("nRound:"..nRound)
end

--����ש������,�Ƿ�Ϊ�����غ�
function p.GenerateBrickType()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	local v = p.GetRoundInfoTable()
	if v==nil then
		return nil
	end	
	
	gWaveDelay = v[4]
	local bEnd = false
	if v[1] == 9999 then
		bEnd = true
		local v = p.GetRoundInfoTable()
	end
	local nrandom = math.random(1,100)
	local tmp =0
	for sType,nRate in pairs(v[7]) do
		tmp = tmp + nRate
		if nrandom <= tmp then
			return sType,bEnd
		end
	end
end

--���ع���ID ,�ȼ�
function p.GenerateMonsterId()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	local v = p.GetRoundInfoTable()
	if v==nil then
		return nil
	end	
	
	
	--�ڻغ��ڲ�������
	local n = math.random(1,100)
	local ntemp = 0
	local index = 0;
	for j,w in pairs(v[3]) do
		ntemp = ntemp + w;
		if n <= ntemp then
			index = j;
			break
		end
	end
	
	local lev = 0;
	--�������ȼ�NIL��ȥV[6][1]
	if v[6][index] == nil then
		lev = v[6][1]
	else
		lev = v[6][index]
	end
	
	return v[2][index],lev
end

--��ȡMISSION����
function p.GetProgress()
	local roundmax = 0;
	
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		if v[1] ~= 9999 then
			roundmax = roundmax + v[1]
		end
	end

	return nRound/roundmax
end

function p.IfFallToFill()
	local n = nRound%5
	if 	n == 0 then
		return true
	else
		return false
	end
end





--�½�����
CHAPTER_TABLE = {}
	CHAPTER_TABLE[1] = {}
	CHAPTER_TABLE[1].tMission = {1,2,3,4,5}
	CHAPTER_TABLE[1].BgId = 1
	
	CHAPTER_TABLE[2] = {}
	CHAPTER_TABLE[2].tMission = {6,7}
	CHAPTER_TABLE[2].BgId = 2
	
function p.GeCHAPTER_TABLEMission(nChapter)
	return CHAPTER_TABLE[nChapter].tMission
end



















