--技能升级树
SkillUpgrade = {};
local p = SkillUpgrade;


--技能树节点 MAGICID:主动技能id  PassiveID:被动技能ID
p.tSkillNode = 
{
[1] = {MAGICID = 1,PassiveID = nil} 
[2] = {MAGICID = 2,PassiveID = nil}
[3] = {MAGICID = 3,PassiveID = nil}
[4] = {MAGICID = 4,PassiveID = nil}

}


--技能树
p.tSkillTree = 
{
[1] = {1,4}
[2] = {2}
[3] = {3}
}



function p.GetRandomSkillId()
	local tPlayerSkill = 
	{
	player[playerInfo.SKILLID1],
	player[playerInfo.SKILLID2],
	player[playerInfo.SKILLID3],
	player[playerInfo.SKILLID4],
	}
	
	local tPlayerSkillFilt = {}
	
	for i,v in pairs(tPlayerSkill) do
		if v ~= 0 then
			table.insert(tPlayerSkillFilt,v)
		end
	end
	
	--排序(从小到大)
	table.sort(tPlayerSkillFilt,function(a,b) return a>b end)
	
	
	local tTmp = {}
	for i=1,14 do
		tTmp[i] = i 
	end

	
	local randomSkillInd1 = math.random(1,#tTmp)
	local randomSkill1 = tTmp[randomSkillInd1]
	table.remove(tTmp,randomSkillInd1)
	
	local randomSkillInd2 = math.random(1,#tTmp)
	local randomSkill2 = tTmp[randomSkillInd2]
	table.remove(tTmp,randomSkillInd2)
	
	local randomSkillInd3 = math.random(1,#tTmp)
	local randomSkill3 = tTmp[randomSkillInd3]
	table.remove(tTmp,randomSkillInd3)
	
	return randomSkill1,randomSkill2,randomSkill3
end


















