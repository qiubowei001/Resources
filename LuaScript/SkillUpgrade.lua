--技能升级树
SkillUpgrade = {};
local p = SkillUpgrade;


--技能树节点 MAGICID:主动技能id  PassiveID:被动技能ID
p.tSkillNode = 
{
[1] = {MAGICID = 1,PassiveID = nil},
[2] = {MAGICID = 2,PassiveID = nil},
[3] = {MAGICID = 3,PassiveID = nil},
[4] = {MAGICID = 4,PassiveID = nil},

}


--技能树
p.tSkillTree = 
--[[
{
[1] = {1,4},
[2] = {2},
[3] = {3},
}
--]]
{
[1] = {1,4,5,6,7},
[2] = {2,8,9,10},
[3] = {3,0},
}



function p.GetRandomSkillId()
	local tPlayerSkill = 
	{
	1,--player[playerInfo.SKILLID1],
	2,--player[playerInfo.SKILLID2],
	0,--player[playerInfo.SKILLID3],
	--player[playerInfo.SKILLID4],
	}
	
	local tRandom = {}
	--寻找下一个技能节点,并插入随机表
	for nTreeIndex,v in pairs(p.tSkillTree) do
		if #v == 1 then
			--如果V只有一个技能,且不属于玩家技能则插入(#v==1)
			local tmp =  v[1]
			for nPlayerSkillIndex ,nPlayerSkillId in pairs(tPlayerSkill) do
				if tmp == nPlayerSkillId then
					tmp = nil
				end
			end
			if tmp ~= nil then
				table.insert(tRandom,tmp)
			end
		else
			--V有多个技能情况 (#v>=2)
			local tmp = v[1]
			local bFound = false
			for nPlayerSkillIndex ,nPlayerSkillId in pairs(tPlayerSkill) do
				--遍历V 如果有相同则取下个 如果没有则取第一个
				for i=1,#v do
					if  nPlayerSkillId == v[i] then
						if i == #v then
							tmp = nil
						else
							tmp = v[i+1]
						end	
						bFound = true
						break
					end
				end
				
				if bFound then
					break
				end
			end	
			
			if tmp ~= nil then
				table.insert(tRandom,tmp)
			end	
		end			
	end
	
	print("tRandom:")
	for i,v in pairs(tRandom) do
		print(v)
	end
	--[[
	
	local randomSkillInd1 = math.random(1,#tTmp)
	local randomSkill1 = tTmp[randomSkillInd1]
	table.remove(tTmp,randomSkillInd1)
	
	local randomSkillInd2 = math.random(1,#tTmp)
	local randomSkill2 = tTmp[randomSkillInd2]
	table.remove(tTmp,randomSkillInd2)
	
	local randomSkillInd3 = math.random(1,#tTmp)
	local randomSkill3 = tTmp[randomSkillInd3]
	table.remove(tTmp,randomSkillInd3)
	
	return randomSkill1,randomSkill2,randomSkill3--]]
end


p.GetRandomSkillId()









