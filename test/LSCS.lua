--平均回合数
local bIfFirst = true --先手true 后手false
local g_nRound = 12
local g_Skille = 2 --玩家技能耗点

--玩家手上残留手牌
local g_tcardLeft = {}


					--[[function() 
						if bIfFirst then
							return 3
						else
							return 4
						end
					end --]]

					

					
--卡组模型
local tCardGroup = 
{
	--费点 数量
[1] ={1		,2},
[2] ={2		,9},
[3] ={3		,5},
[4] ={4		,7},
[5] ={5		,4},
[6] ={6		,0},
[7] ={7		,3},
}

--这里注意下随机种子要加个
local tCardRandom = {}

--先去除空档位
for i=#tCardGroup ,1,-1  do
	if tCardGroup[i][2] == 0 then
		table.remove(tCardGroup,i)
	end	
end


--打乱顺序
for i=30 ,1,-1  do
	local index = math.random(1,#tCardGroup)
	local info = tCardGroup[index]
	
	info[2] = info[2] - 1
	local e = info[1]
	table.insert(tCardRandom,e) 
	
	if info[2] <= 0 then
		table.remove(tCardGroup,index)
	end
end



--发牌
function TakeOneCard()
	if #tCardRandom <= 0 then
		print("没牌啦!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
end

--用卡策略	输入能量 返回消耗能量和卡片表(以消耗最多能量为准则)
function Stragy(e)
	--复制表
	local tabletmp = {}
	for i,v in pairs(g_tcardLeft) do
		table.insert(tabletmp,v)
	end
	
	--一次用掉
	for i,v in pairs(g_tcardLeft) do
		if v == e then
			return e,{e}
		end
	end
	
	
	--搭配用
	local ecardtotal = --卡片总需耗能
	--能量大于全部卡加起来
	if ecardtotal <= e then
		return ecardtotal,tabletmp
	else
	--卡片能量总和超越施法能量
		e = 5
		t = {1,3,4,2,7}
		--找出加起来最接近e的解
		--for Cardnum = 1,#t do
			for index,ecard in pairs(t) do
				plus1 = ecard
				for	i = Cardnum,1,-1 do
					t[]
				end			
			end
		--end
		
	end
	
	
end

--发3张牌
TakeOneCard();
TakeOneCard();
TakeOneCard();

--玩家比赛中能输出的能量（0耗卡牌暂时不计算）
local E_Fire = 0
for round = 1,12 do
	--****************************************************--
	--========这里计算的是每回合我可以输出的能量========----
	--========准则是 尽量输出多能量,以防浪费能量点======----
	--****************************************************--
	
	--抽卡一张
	TakeOneCard();

	--本回合获取能量
	local eround = round
	if eround > 10 then
		eround = 10
	end

	--策略选择
	local EA , EB = nil , nil
	local tcardUseA,tcardUseB = nil
	--计算出职业技能配卡耗能 EA
	if eround < EA then
		EA = nil
	else
		local e_left = eround - EA
		
		--返回消耗能量,消耗卡牌表
		local e_card = 0
		e_card,tcardUseA = Stragy(e_left)
		
		EA =  g_Skille + e_card
	end
	
	
	--计算出纯卡耗能 EB
	EB,tcardUseB = Stragy(eround)
	
	
	--若EA >= EB则 选1 否则选2
	if EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
	else
		UseCard(tcardUseB)
	end
end

--]]






