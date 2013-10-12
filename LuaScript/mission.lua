--关卡配置

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
--回合数 --{怪物ID,怪物概率,	掉落延迟,掉落怪物数}
{10		,	{9},		{100}		,4, 1},
{10		,	{2,4},		{95,5}		,20, 3},
{30		,	{2,4},		{95,5}		,7, 1},
{1000		,{3,5},		{90,10}		,50, 4},
}

MISSION_TABLE[2] = {}
MISSION_TABLE[2]["name"] = "ChapterII"
MISSION_TABLE[2]["config"] = 
{
--回合数 --{怪物ID,怪物概率}
{3		,	{9},		{100}		 },
{10		,	{2,4},		{95,5		}},
{20		,	{4},		{100		}},
}

MISSION_TABLE[3] = {}
MISSION_TABLE[3]["name"] = "ChapterIII"
MISSION_TABLE[3]["config"] = 
{
--回合数 --{怪物ID,怪物概率}
{10		,	{9},		{100}		 },
{20		,	{2,4},		{95,5		}},
{20		,	{4},		{100		}},
}




--获取回合信息表
function p.GetRoundInfoTable()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		roundBoundMax = roundBoundMin + v[1];
		if nRound <= roundBoundMax  and nRound > roundBoundMin  then
			return v
		else 
			--在回合外
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

--初始化MISSION信息
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

function p.GenerateMonsterId()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	local v = p.GetRoundInfoTable()
	
	--在回合内产生怪物
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
	
	return v[2][index]			
end

--获取MISSION进度
function p.GetProgress()
	local roundmax = 0;
	
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		roundmax = roundmax + v[1]
	end

	return nRound/roundmax
end






























