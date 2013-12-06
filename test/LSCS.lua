--这里注意下随机种子要加个
math.randomseed(os.time())

local bIfFirst = true --先手true 后手false
local g_TestTime = 200--测试局数
local bprintdetail = false; --是否开启打印回合细节

--最小 -- 最大回合数设置
--local minR = 5
--local maxR = 15

local minR = 10
local maxR = 0
maxR = minR

local g_Skille = 2 --玩家技能耗点
local g_Att = 0
local g_Energy = 0
--玩家手上残留手牌
local g_tcardLeft = {}


local tCardGroup = {}
local tCardRandom = {}


--打印每回合细节
function PRINTRoundDetail(S)
	if bprintdetail then
		print(S)
	end
end

function InitCardGroup()
	--[[卡组模型
	local tCardGroupCopy = 
	{
		--	--费点 数量
		[1] ={1		,2},
		[2] ={2		,9},
		[3] ={3		,5},
		[4] ={4		,7},
		[5] ={5		,4},
		[6] ={6		,0},
		[7] ={7		,3},
	}
	--]]


	
	local tCardGroupCopy = {}
	--复制卡组
	for i,v in pairs(tCardGroup)do
		local tmp = {}
		for j,k in pairs(v)do
			tmp[j] = k
			
		end
		
		tCardGroupCopy[i] = tmp
	end


	
	tCardRandom = {}
	--先去除空档位
	for i=#tCardGroupCopy ,1,-1  do
		if tCardGroupCopy[i][2] == "0" then
			table.remove(tCardGroupCopy,i)
		end	
	end	
	--
	--打乱顺序
	for i=30 ,1,-1  do
		local index = math.random(1,#tCardGroupCopy)
		local info = tCardGroupCopy[index]
		
		info[2] = info[2] - 1
		local e = info[1]
		table.insert(tCardRandom,e) 
		
		if info[2] <= 0 then
			table.remove(tCardGroupCopy,index)
		end
	end	
	g_tcardLeft = {}
	--[[
	local s = "本局卡组:"
	for i,v in pairs(tCardRandom) do
		s = s..v
	end
	print(s)--]]
end

--用户设置
function UserSetting()
	--输入卡组数量
	for i = 1,7 do
		while(1)do
			local cardgrouptmp = ""
			local cardnum = 0
			for j,v in pairs(tCardGroup)do
				cardnum = cardnum + v[2]
				cardgrouptmp = cardgrouptmp.." "..v[1].."星:"..v[2]
			end
			
			print("   已有卡片数量:"..cardnum.." = ( "..cardgrouptmp.." ) \n输入"..i.."星卡数量:")
			io.flush()
			nNum = io.read("*line")
			tCardGroup[i] = {i,nNum}
			
			cardnum = 0
			for j,v in pairs(tCardGroup)do
				cardnum = cardnum + v[2]
			end
			
			if cardnum > 30 then
				print("总数量不能大于30! cardnum:"..cardnum)
				tCardGroup[i] = {i,0}
			elseif 	i == 7 and cardnum <30 then
				print("总数量不能小于30!")
				tCardGroup[i] = {i,0}
			elseif cardnum == 30 then
				return;
			else
				break
			end
			io.flush()
		end	
	end
end



function PlayerSpell()
	g_Energy = g_Energy - g_Skille
	g_Att = g_Att + g_Skille
	PRINTRoundDetail(printAllCard().." 玩家施放技能 耗点:"..g_Skille)
end


--Replace 将 t中[1]元素与 tparam1的sum比较,取值大的替换t[1]
--如果treturn为空则直接插入
function Replace(t,tparam1)
	if #t == 0 then
		t[1] = tparam1
		return
	end
	
	local sumt1 = 0
	local sumparam = 0
	for i,v in pairs(t[1]) do
		sumt1 = sumt1 + v
	end	

	for i,v in pairs(tparam1) do
		sumparam = sumparam + v
	end
		
	if sumt1 < sumparam then
		t[1] = tparam1
		return
	end	
end					
						
--输入 1能量上限 2卡牌表 , 返回1个最接近E的搭配表
function digui(e,t)
	local treturn = {}
	--[[
	if t == nil then
		return nil
	end--]]
		
	if e == 0 then
		return {999}
	end
	
	if e < 0 then
		return nil
	end
	
	if #t == 0 then	
		return {999}
	end
	
	if #t == 1 and t[1] <= e then
		return {{t[1]},999}
	end	
	
	if #t == 1 and t[1] > e then
		return {999}
	end
	
	for i,v in pairs(t) do
		
		--取出第一个值作为加数
		local eplus = t[i]
		
		local tleft = {}
		--复制剩余t
		for j=i+1,#t do
			table.insert(tleft,t[j])
		end
		
		--一张卡就达到E
		if eplus == e then
			return {{eplus},999} 
		end
		
		local tAllPosible = digui(e-eplus,tleft)  --{{min1,min2,min3},999}  or {999}
		if tAllPosible ~= nil then --{}	
			for x,v in pairs(tAllPosible) do
				local summax = eplus;
				
				--无法细分时
				if 999 == v then				
					Replace(treturn,{eplus})
				else				
					--因为递归只返回最多2个元素表 min表 和999 
					--当发现min表时,不再向tRETURN插入其他元素
					--所以treturn长度最多也是 min表 和999 					
					local tmp = v
					
					--将eplus重新加入表中
					table.insert(tmp,eplus)				
					Replace(treturn,tmp)
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
	return s.." 输出能量:"..g_Att
end

--发牌
function TakeOneCard()
	if #tCardRandom <= 0 then
		PRINTRoundDetail(printAllCard().." 没牌啦!!")
		return
	end
	
	local ecard  = tCardRandom[1];
	table.insert(g_tcardLeft,ecard);
	table.remove(tCardRandom,1);
	
	PRINTRoundDetail(printAllCard().." 抽到"..ecard.."星卡")
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
	PRINTRoundDetail(printAllCard().." 玩家使用卡牌:"..s)
end

--用卡策略	输入能量 返回消耗能量和卡片表(以消耗最多能量为准则)
function Stragy(e)
	if e <= 0 then
		return 0,nil
	end
	
	--复制表
	local tabletmp = {}
	for i,v in pairs(g_tcardLeft) do
		table.insert(tabletmp,v)
	end
	
	
	--找出加起来最接近e的解
	local test = digui(e,g_tcardLeft)
	--test = { {1,3,4},999}
	if test[1] == 999 then
		return 0,nil
	else
		local EmaxSpell = 0
		for i,v in pairs(test[1])do
			EmaxSpell = EmaxSpell + v
		end			
		return EmaxSpell,test[1]
	end	
end


function mainloop(nRound)
--初始化	
g_Att = 0
g_Energy = 0
	
--发3张牌
TakeOneCard();
TakeOneCard();
TakeOneCard();

--玩家比赛中能输出的能量（0耗卡牌暂时不计算）
local E_Fire = 0



for round = 1,nRound do
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
	PRINTRoundDetail(printAllCard().." 第"..round.."回合 ")
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
		g_Att = g_Att + EA	-g_Skille
	--若EA >= EB则 选1 否则选2
	elseif EA >= EB then
		PlayerSpell()
		UseCard(tcardUseA)
		g_Att = g_Att + EA	-g_Skille
	else
		UseCard(tcardUseB)
		g_Att = g_Att + EB		
	end
end
end


local wucha = 0
local minShuchu = 999

while(1)do
	tCardGroup = {}
	UserSetting()

	for nRoundSet = minR,maxR do
		local sum = 0
		for i=1,g_TestTime do
			InitCardGroup()
			mainloop(nRoundSet);
			--print("第"..i.."局共输出能量:"..g_Att)
			sum = sum + g_Att
			
			if g_Att < minShuchu  then
				minShuchu = g_Att
			end
		end
		PINGJUN = sum/g_TestTime
		print("此套卡组在("..nRoundSet.."回合)局中平均输出能量:"..PINGJUN.." 最小输出:"..minShuchu)
	end	
end
--]]5691513








