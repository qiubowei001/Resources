brickInfo = {};
brickInfo.brick_num_X = 5;
brickInfo.brick_num_Y = 6;
brickInfo.brickWidth = 100;
brickInfo.brickHeight = 100;
brickInfo.brickSpeed = 5;
brickInfo.brickRespondArea = 0.7;--ש����Ӧ����0-1

--�������������Կ�������MISSION����
brickInfo.WaveDelay = 100;--ÿ��ש��ĵ�����(1 = 0.1��)
brickInfo.WaveCount = 10;--ÿ��ש�������


--��Ϸ�׶ζ���
GameLogicPhase ={
	BEFORE_PLAYER_ACT = 0,--���ִ��������Ϊǰ
	AFTER_PLAYER_ACT = 1,--���ִ��������Ϊ��
	AFTER_MONSTER_SPELL = 2,--����ʩ�ż���
	AFTER_MONSTER_ATT =3,--���﹥����	
}

--ѡ��ʽ
SELECTMODE = 
{
	NORMAL = 0,
	SINGLE_BRICK = 1,
	LINE = 2,	
}