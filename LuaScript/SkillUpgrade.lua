--����������
SkillUpgrade = {};
local p = SkillUpgrade;


--�������ڵ� MAGICID:��������id  PassiveID:��������ID
p.tSkillNode = 
{
[1] = {MAGICID = 1,PassiveID = nil},
[2] = {MAGICID = 2,PassiveID = nil},
[3] = {MAGICID = 3,PassiveID = nil},
[4] = {MAGICID = 4,PassiveID = nil},

}


--������
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
	--Ѱ����һ�����ܽڵ�,�����������
	for nTreeIndex,v in pairs(p.tSkillTree) do
		if #v == 1 then
			--���Vֻ��һ������,�Ҳ�������Ҽ��������(#v==1)
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
			--V�ж��������� (#v>=2)
			local tmp = v[1]
			local bFound = false
			for nPlayerSkillIndex ,nPlayerSkillId in pairs(tPlayerSkill) do
				--����V �������ͬ��ȡ�¸� ���û����ȡ��һ��
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









