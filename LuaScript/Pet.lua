Pet = {}

local p = Pet;

local petlist = {}
--pet其实不是个控件 而是在mainlayer上生成棋盘外的brick
function p.Init()
	Board[1][0] = nil;	
	petlist = {};
end

function p.AddPet()
	pbrick = brick.creatMonster(1,2);
	table.insert(petlist,pbrick);
	Main.RefreshPet()
end

function p.GetPetList()
	return petlist;
end

