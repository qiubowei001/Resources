Goldbrick = {}

local tgoldFenBu = 
{
--¸ÅÂÊ,½ðŽÅ
{20,1},
{19,2},
{15,3},
{13,4},
{12,5},
{9,6},
{6,7},
{3,8},
{2,9},
{1,10},
}


local tgoldrandom = {}
local tmpindmin = 1
local tmpindmax = 1
	
for i,v in pairs(tgoldFenBu) do
	tmpindmax = tmpindmin + v[1] - 1
	
	for j = tmpindmin,tmpindmax  do
		tgoldrandom[j] = v[2];
	end
	tmpindmin = tmpindmax + 1;
end


function Goldbrick.init()
	local GOLD = tgoldrandom[math.random(1,100)];
	return GOLD
end