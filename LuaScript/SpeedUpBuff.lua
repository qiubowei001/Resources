--���ٽ���
SpeedUpBuff = {};
local p = SpeedUpBuff;



local tPrizeType = 
{
GOLD =1,
EXP =2,
}

local tPrizeRandom = 
{
--����  ƽ��ֵ  ����
	[tPrizeType.GOLD] = {50, 1, 3},
	[tPrizeType.EXP]  = {50, 1 ,8},
}

--nBrickCount �´ε�������
--val = (ƽ��ֵ + ����ֵ)x������
function p.GetPrize(nBrickCount)
	local adj = nBrickCount*2
	
	local nrandom = math.random(1,100)
	local ntmp = 0
	for i,v in pairs(tPrizeRandom)do
		ntmp = ntmp + v[1]
		if nrandom < ntmp then
			local val = (v[2] + (math.random(1,v[3])/10))*adj
			
			val = math.floor(val)
			if i == tPrizeType.GOLD then
				player.takeGold(val)
			elseif i == tPrizeType.EXP then
				player.GainEXP(val)
			end
			
			break
		end
	end
end















