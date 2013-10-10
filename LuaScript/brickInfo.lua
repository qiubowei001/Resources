brickInfo = {};
brickInfo.brick_num_X = 5;
brickInfo.brick_num_Y = 6;
brickInfo.brickWidth = 100;
brickInfo.brickHeight = 100;
brickInfo.brickSpeed = 5;
brickInfo.brickRespondArea = 0.7;--砖块相应区域0-1

--这俩个参数可以考虑做到MISSION里面
brickInfo.WaveDelay = 100;--每波砖块的掉落间隔(1 = 0.1秒)
brickInfo.WaveCount = 10;--每波砖块的数量


--游戏阶段定义
GameLogicPhase ={
	BEFORE_PLAYER_ACT = 0,--玩家执行消除行为前
	AFTER_PLAYER_ACT = 1,--玩家执行消除行为后
	AFTER_MONSTER_SPELL = 2,--怪物施放技能
	AFTER_MONSTER_ATT =3,--怪物攻击后	
}

--选择方式
SELECTMODE = 
{
	NORMAL = 0,
	SINGLE_BRICK = 1,
	LINE = 2,	
}