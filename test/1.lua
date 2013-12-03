
g_tcardLeft = {1,3,1,1,5,2}
tuseCards = {2,3,1}
	for i = #g_tcardLeft,1,-1 do
		for j,E in pairs(tuseCards) do
			if E == g_tcardLeft[i] then
				table.remove(g_tcardLeft,i)
				table.remove(tuseCards,j)
			end
		end
	end
	
for i,v in pairs(g_tcardLeft) do	
	print(i.." "..v)	
end