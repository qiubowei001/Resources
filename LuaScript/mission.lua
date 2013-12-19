--关卡配置

mission = {};
local p = mission;
local nRound = 0;
local gMission = 1

local gWaveDelay = 0

--[[
tbrickType = 
{
	MONSTER = 	1,
	SWORD  =	2,
	BLOOD  =	3,
	GOLD   =	4,
}
]]
MISSION_TABLE = {}

MISSION_TABLE[1] = {}
MISSION_TABLE[1]["name"] = "ChapterI"
MISSION_TABLE[1]["config"] = 

{
--回合数 --{怪物ID,		怪物概率,	掉落延迟,掉落怪物数,怪物等级 砖块概率}
--[[
{10		,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{1		,	{9},		{100}		,10		, 1			,{6}	,{[tbrickType.MONSTER]=100,[tbrickType.SWORD]=0,[tbrickType.BLOOD]=0,[tbrickType.GOLD]=0}},
{10		,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},


{300	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{9999	,	{1},		{100}		,10		, 1			,{0}	,{[tbrickType.MONSTER]=0,[tbrickType.SWORD]=30,[tbrickType.BLOOD]=30,[tbrickType.GOLD]=40}},

}

--]]

--
{25		,	{1,2,3},	{33,33,34}		,10		, 1			,{1},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{25		,	{1,2,3},	{33,33,34}		,10		, 1			,{2},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{25		,	{1,2,3},	{33,33,34}		,10		, 1			,{3},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{25		,	{1,2,3},	{33,33,34}		,10		, 1			,{4},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1,2,3},	{33,33,34}		,10		, 1			,{5},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1,2,3},	{33,33,34}		,10		, 1			,{6},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1},		{100}			,10		, 1			,{7},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{1		,	{4},		{100}			,10		, 1			,{6},	{[tbrickType.MONSTER]=100,[tbrickType.SWORD]=0,[tbrickType.BLOOD]=0,[tbrickType.GOLD]=0}},--BOSS战
{35		,	{1},		{100}			,10		, 1			,{8},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1},		{100}			,10		, 1			,{9},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1},		{100}			,10		, 1			,{10},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1},		{100}			,10		, 1			,{10},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{35		,	{1},		{100}			,10		, 1			,{10},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{1		,	{4},		{100}			,10		, 1			,{10},	{[tbrickType.MONSTER]=100,[tbrickType.SWORD]=0,[tbrickType.BLOOD]=0,[tbrickType.GOLD]=0}},--BOSS战
{20		,	{1,2,3},	{33,33,34}		,10		, 1			,{10},	{[tbrickType.MONSTER]=20,[tbrickType.SWORD]=27,[tbrickType.BLOOD]=26,[tbrickType.GOLD]=27}},
{9999	,	{},			{}				,10		, 1			,{},	{[tbrickType.MONSTER]=0,[tbrickType.SWORD]=35,[tbrickType.BLOOD]=35,[tbrickType.GOLD]=30}},

}
--]]

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
	
	print("GetRoundInfoTable begin")
	for i,v in pairs(MISSION_TABLE[gMission]["config"]) do
		print("GetRoundInfoTable i:"..i)
		roundBoundMax = roundBoundMin + v[1];
		print("GetRoundInfoTable nRound:roundBoundMax:roundBoundMin:"..nRound.." "..roundBoundMax.." "..roundBoundMin)
		
		if nRound <= roundBoundMax  and nRound > roundBoundMin  then
			return v
		else 
			--在回合外
			roundBoundMin = roundBoundMin + v[1];
		end
	end
	cclog("GetRoundInfoTable fail")
	return nil
end



--初始化MISSION信息
function p.SetMission(nMission)
	gMission = nMission
	
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
end

--返回砖块类型,是否为结束回合
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

--返回怪物ID ,等级
function p.GenerateMonsterId()
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	
	local v = p.GetRoundInfoTable()
	if v==nil then
		return nil
	end	
	
	
	--在回合内产生怪物
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
	
	
	
	return v[2][index],v[6][index]
end

--获取MISSION进度
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




























