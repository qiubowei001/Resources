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
	
	if t == nil then
		return nil
	end
		
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


e = 9
t = {5,6,5,3,1,3,2}
local g_tcardLeft = digui(e,t)

--打印所有持有卡牌
function printAllCard()
	
	if #g_tcardLeft == 0 then
		return "无"
	end
	for i,v in pairs(g_tcardLeft) do
		local s = ""
		if v ~= 999 then
			for j,k in pairs(v)do
				s = s.." "..k
			end
			print(s)
		end
	end
end

printAllCard()
















