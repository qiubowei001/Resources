brickInfo = {};
brickInfo.brick_num_X = 6;
brickInfo.brick_num_Y = 6;
brickInfo.brickWidth = 90;
brickInfo.brickHeight = 90;
brickInfo.brickSpeed = 5;
brickInfo.brickRespondArea = 0.7;--砖块相应区域0-1

brickInfo.layerMainAdjX = 100;--棋盘偏移X



--这俩个参数可以考虑做到MISSION里面
brickInfo.WaveDelay = 5;--每波砖块的掉落间隔(1 = 0.1秒)
brickInfo.WaveCount = 1;--每波砖块的数量

brickInfo.PlayerSkillCount = 4;--玩家主动技能数量

--游戏阶段定义
GameLogicPhase ={
	BEFORE_PLAYER_ACT = 0,--玩家执行消除行为前
	AFTER_PLAYER_ACT = 1,--玩家执行消除行为后
}

--选择方式
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

GLOBAL_EVENT = 
{
	LINK_SUCC 		= 1,--执行一次链接操作
	TAKE_GOLD 		= 2,--吃金币
	TAKE_BLOOD 		= 3,--吃血
	KILL_MONSTER 	= 4,--杀怪
	UPGRADE_EQUIP 	= 5,--升级装备
	USE_BUFF_SKILL 	= 6,--使用buff技能
	USE_ACTIVE_SKILL = 7,--使用点杀技能
	TAKE_ENERGY		= 8,--喝蓝
}
