Pet = {}

local p = Pet;

--pet��ʵ���Ǹ��ؼ� ������mainlayer�������������brick
function p.Init()

end

function p.AddPet()
	pbrick = brick.creatMonster(1,2);
	Main.brickSetXY(pbrick,2,0)
end