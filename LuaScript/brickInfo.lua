brickInfo = {};
brickInfo.brick_num_X = 6;
brickInfo.brick_num_Y = 6;
brickInfo.brickWidth = 90;
brickInfo.brickHeight = 90;
brickInfo.brickSpeed = 5;
brickInfo.brickRespondArea = 0.7;--ש����Ӧ����0-1

brickInfo.layerMainAdjX = 100;--����ƫ��X



--�������������Կ�������MISSION����
brickInfo.WaveDelay = 5;--ÿ��ש��ĵ�����(1 = 0.1��)
brickInfo.WaveCount = 1;--ÿ��ש�������

brickInfo.PlayerSkillCount = 4;--���������������

--��Ϸ�׶ζ���
GameLogicPhase ={
	BEFORE_PLAYER_ACT = 0,--���ִ��������Ϊǰ
	AFTER_PLAYER_ACT = 1,--���ִ��������Ϊ��
}

--ѡ��ʽ
SELECTMODE = 
{
	NORMAL = 0,
	SINGLE_BRICK = 1,
	LINE = 2,	
}

tbrickType = 
{
	MONSTER = 	1,
	SWORD  =	2,
	BLOOD  =	3,
	GOLD   =	4,
	ENERGY	= 5,
}

tBrickTypeRandom = 
{
	[tbrickType.MONSTER] 	= 17,
	[tbrickType.SWORD] 	 	= 17,
	[tbrickType.BLOOD] 		= 33,
	[tbrickType.GOLD] 		= 33,
	
}
