--Replace �� t��[1]Ԫ���� tparam1��sum�Ƚ�,ȡֵ����滻t[1]
--���treturnΪ����ֱ�Ӳ���
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
						
--���� 1�������� 2���Ʊ� , ����1����ӽ�E�Ĵ����
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
		
		--ȡ����һ��ֵ��Ϊ����
		local eplus = t[i]
		
		local tleft = {}
		--����ʣ��t
		for j=i+1,#t do
			table.insert(tleft,t[j])
		end
		
		--һ�ſ��ʹﵽE
		if eplus == e then
			return {{eplus},999} 
		end
		
		local tAllPosible = digui(e-eplus,tleft)  --{{min1,min2,min3},999}  or {999}
		if tAllPosible ~= nil then --{}	
			for x,v in pairs(tAllPosible) do
				local summax = eplus;
				
				--�޷�ϸ��ʱ
				if 999 == v then				
					Replace(treturn,{eplus})
				else				
					--��Ϊ�ݹ�ֻ�������2��Ԫ�ر� min�� ��999 
					--������min��ʱ,������tRETURN��������Ԫ��
					--����treturn�������Ҳ�� min�� ��999 					
					local tmp = v
					
					--��eplus���¼������
					table.insert(tmp,eplus)				
					Replace(treturn,tmp)
				end
				
			end
		end
	end
	--ƨ�ɺ���Ӹ�999
	table.insert(treturn,999)
	
	return treturn
end


e = 9
t = {5,6,5,3,1,3,2}
local g_tcardLeft = digui(e,t)

--��ӡ���г��п���
function printAllCard()
	
	if #g_tcardLeft == 0 then
		return "��"
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
















