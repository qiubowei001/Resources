--这里注意下随机种子要加个
math.randomseed(os.time())

--平均回合数
local bIfFirst = true --先手true 后手false
local g_nRound = 12
local g_Skille = 2 --玩家技能耗点
local g_Att = 0
local g_Energy = 0
--玩家手上残留手牌
local g_tcardLeft = {}


local tCardGroup = {}
local tCardRandom = {}



function InitCardGroup()
	--卡组模型
	local tCardGroup = 
	{
		--[[	--费点 数量
		[1] ={1		,2},
		[2] ={2		,9},
		[3] ={3		,5},
		[4] ={4		,7},
		[5] ={5		,4},
		[6] ={6		,0},
		[7] ={7		,3},
		--]]
		--
		[1] ={1		,8},
		[2] ={2		,7},
		[3] ={3		,5},
		[4] ={4		,3},
		[5] ={5		,3},
		[6] ={6		,3},
		[7] ={7		,1},
		--]]	
	}
	tCardRandom = {}
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
	--[[
	local s = "本局卡组:"
	for i,v in pairs(tCardRandom) do
		s = s..v
	end
	print(s)--]]
end

function PlayerSpell()
	g_Energy = g_Energy - g_Skille
	g_Att = g_Att + g_Skille
	print(printAllCard().." 玩家施放技能 耗点:"..g_Skille)
end


--输入 1能量上限 2卡牌表 , 返回所有可能搭配表
function digui(e,t)
	local treturn = {}
	if t ==nil then
		return nil
	end
		
	if #t == 0 then	
		return {999}
	end
	
	if #t == 1 then
		return {{t[1]},999}
	end
	
	for i,v in pairs(t) do
		
		--取出第一个值作为加数
		local eplus = t[i]
		
		local tleft = {}
		--复制剩余t
		for j=i+1,#t do
			table.insert(tleft,t[j])
		end

		local tAllPosible = digui(e,tleft)
		if tAllPosible ~= nil then --{}	
			for i,v in pairs(tAllPosible) do
				if 999 == v then
					table.insert(treturn,{eplus})
				else					
					local tmp = v
					--将eplus重新加入表中
					table.insert(tmp,eplus)				
					table.insert(treturn,tmp)
				end
			end
		end
	end
	--屁股后面加个999
	table.insert(treturn,999)
	return treturn
end


--打印所有持有卡牌
function printAllCard()
	--local s = "e:"..g_Energy.." 持有卡牌:"
	local s = string.format("e:%d 持有卡牌:",g_Energy)
	if #g_tcardLeft == 0 then
		return "持有卡牌:无"
	end
	for i,v in pairs(g_tcardLeft) do
		s = s.." "..v
	end
	return s
end

--发牌
function TakeOneCard()
	if #tCardRandom <= 0 then
		print(printAllCard().." 没牌啦!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
	table.remove(tCardRandom,1);
	
	print(printAllCard().." 抽到"..ecard.."星卡")
end


--使用卡片
function UseCard(tuseCards)
	if tuseCards == nil then
		return
	end	
	local s = ""
	local sum = 0
	for i = #g_tcardLeft,1,-1 do
		for j,E in pairs(tuseCards) do
			if E == g_tcardLeft[i] then
				s = s.." "..E
				sum = sum + E
				table.remove(g_tcardLeft,i)
				table.remove(tuseCards,j)
			end
		end
	end
	g_Energy = g_Energy - sum
	print(printAllCard().." 玩家使用卡牌:"..s)
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
	
	local sum = 0
	for i,v in pairs(g_tcardLeft) do
		sum = v + sum
	end
	
	--搭配用
	local ecardtotal = sum--卡片总需耗能
	--能量大于全部卡加起来
	if ecardtotal <= e then
		return ecardtotal,tabletmp
	else
	
	
		--卡片能量总和超越施法能量
		--找出加起来最接近e的解
		local test = digui(e,g_tcardLeft)
		--test = { {1,3,4},{2,2,3}, 999}
		--对所有表值校验
		local EmaxSpell = 0
		local tCards = {}
		for i=#test ,1,-1 do
			if test[i] ~= 999 then
				local sum = 0
				for j,k in pairs(test[i])do
					sum = sum + k
				end
				if sum == e then
					return sum,test[i]
				elseif sum < e then
					if EmaxSpell == 0 then
						EmaxSpell = sum
						tCards = test[i]
					end
					
					if EmaxSpell < sum then
						EmaxSpell = sum
						tCards = test[i]
					end
				end		
			end
		end			
	end
	return EmaxSpell,tCards
		
end


function mainloop()
--初始化	
g_Att = 0
g_Energy = 0
	
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
	
	
	--本回合获取能量
	local eround = round
	if eround > 10 then
		eround = 10
	end
	g_Energy = eround
	print(printAllCard().." 第"..round.."回合 ")
	--抽卡一张
	TakeOneCard();

	--策略选择
	local EA , EB = nil , nil
	local tcardUseA,tcardUseB = nil
	
	
	--计算出职业技能配卡耗能 EA
	if eround < g_Skille then
		EA = nil
	else
		local e_left = eround - g_Skille
		
		--返回消耗能量,消耗卡牌表
		local e_card = 0
		e_card,tcardUseA = Stragy(e_left)
		if e_card == nil then
			e_card = 0
		end
		EA =  g_Skille + e_card
	end
	
	--计算出纯卡耗能 EB
	EB,tcardUseB = Stragy(eround)
	if EA == nil and EB== nil then
		
	elseif EA == nil and EB~= nil then
		UseCard(tcardUseB)
		g_Att = g_Att + EB	
	elseif EB == nil and EA~= nil then
		PlayerSpell()
		UseCard(tcardUseA)	
		g_Att = g_Att + EA	
	--若EA >= EB则 选1 否则选2
	elseif EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
		g_Att = g_Att + EA	
	else
		UseCard(tcardUseB)
		g_Att = g_Att + EB		
	end
end
end

for i=1,1 do
	InitCardGroup()
	mainloop();
	print("第"..i.."局共输出能量:"..g_Att)
end

--]]

--print("本局共输出能量:"..g_Att)






