--�ؿ�����

mission = {};
local p = mission;
local nRound = 0;
local nMission = 1


MISSION_TABLE = {}

MISSION_TABLE[1] = {}
MISSION_TABLE[1]["name"] = "����I"
MISSION_TABLE[1]["config"] = 
{
--�غ��� --{����ID,�������}
{3		,	{9},		{100}		 },
{1000		,	{2,4},		{95,5		}},
{20000		,	{4},		{100		}},
}



--ע���غ�����ָ��

function p.GenerateMonsterId()
	nRound = nRound +1;
	local roundBoundMin = 0;
	local roundBoundMax = 0;
	for i,v in pairs(MISSION_TABLE[nMission]["config"]) do
		roundBoundMax = roundBoundMin + v[1];
		if nRound <= roundBoundMax  and nRound > roundBoundMin  then
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
			return v[2][index]		
		else 
			--�ڻغ���
			roundBoundMin = roundBoundMin + v[1];
		end
		
	end
end
