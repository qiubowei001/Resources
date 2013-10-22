--�ؿ�����

mission = {};
local p = mission;
local nRound = 0;
local gMission = 1

local gWaveCount = 0
local gWaveDelay = 0

MISSION_TABLE = {}

MISSION_TABLE[1] = {}
MISSION_TABLE[1]["name"] = "ChapterI"
MISSION_TABLE[1]["config"] = 
{
--�غ��� --{����ID,		�������,	�����ӳ�,���������,����ȼ�}
--[[
{10		,	{1},		{100}		,30		, 1			,{0}},
{10		,	{1,1},		{95,5}		,30		, 1			,{1,1}},
{30		,	{1,1},		{95,5}		,30		, 1			,{2,1}},
{1000		,{1,1},		{90,10}		,50		, 1			,{3,1}},
--]]

{25		,	{1},		{100}		,15		, 1			,{1}},
{25		,	{1},		{100}		,15		, 1			,{2}},
{25		,	{1},		{100}		,15		, 1			,{3}},
{25		,	{1},		{100}		,15		, 1			,{4}},
{25		,	{1},		{100}		,15		, 1			,{5}},
{25		,	{1},		{100}		,15		, 1			,{6}},
{25		,	{1},		{100}		,15		, 1			,{7}},
{25		,	{1},		{100}		,15		, 1			,{8}},
{25		,	{1},		{100}		,15		, 1			,{9}},
{25		,	{1},		{100}		,15		, 1			,{10}},
{25		,	{1},		{100}		,15		, 1			,{11}},
{25		,	{1},		{100}		,15		, 1			,{12}},


{10		,	{2,4},		{95,5}		,20		, 3			,{1,1}},
{30		,	{2,4},		{95,5}		,7		, 1			,{1,1}},
{1000		,{3,5},		{90,10}		,50		, 4			,{1,1}},
}

MISSION_TABLE[2] = {}
MISSION_TABLE[2]["name"] = "ChapterII"
MISSION_TABLE[2]["config"] = 
{
--�غ��� --{����ID,�������}
{3		,	{9},		{100}		 },
{10		,	{2,4},		{95,5		}},
{20		,	{4},		{100		}},
}

MISSION_TABLE[3] = {}
MISSION_TABLE[3]["name"] = "ChapterIII"
MISSION_TABLE[3]["config"] = 
{
--�غ��� --{����ID,�������}
{10		,	{9},		{100}		 },
{20		,	{2,4},		{95,5		}},
{20		,	{4},		{100		}},
}




--��ȡ�غ���Ϣ��
function p.GetRoundInfoTable()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		roundBoundMax = roundBoundMin + v[1];
		if nRound <= roundBoundMax  and nRound > roundBoundMin  then
			return v
		else 
			--�ڻغ���
			roundBoundMin = roundBoundMin + v[1];
		end
	end
end



function p.GetWaveCount()
	return gWaveCount
end

function p.GetWaveDelay()
	return gWaveDelay
end

--��ʼ��MISSION��Ϣ
function p.SetMission(nMission)
	gMission = nMission
	
	nRound = 1;
	local v = p.GetRoundInfoTable()
	gWaveDelay = v[4]	
	gWaveCount = v[5]
	
end

function p.GetMission()
	return gMission;
end

function p.GetMissionDesc()
	return MISSION_TABLE[gMission]["name"]
end

function p.RoundPlusOne()
	nRound = nRound +1;
end

--���ع���ID ,�ȼ�
function p.GenerateMonsterId()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	local v = p.GetRoundInfoTable()
	
	--�ڻغ��ڲ�������
	local n = math.random(1,100)
	local ntemp = 0
	local index = 0;
	for j,w in pairs(v[3]) do
		ntemp = ntemp + w;
		if n < ntemp then
			index = j;
			break
		end
	end
	
	
	gWaveCount = v[5]
	gWaveDelay = v[4]
	
	return v[2][index],v[6][index]
end

--��ȡMISSION����
function p.GetProgress()
	local roundmax = 0;
	
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		roundmax = roundmax + v[1]
	end

	return nRound/roundmax
end






























