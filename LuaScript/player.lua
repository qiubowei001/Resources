player = {}
local p = player;
playerInfo = {
	HP =1,
	ATT =2,
	GOLD = 3,
	BUFFATT = 4,
	EXP = 5,
	LEVEL = 6,
	HPMAX = 7,
	SKILLID1 = 8,
	SKILLID2 = 9,
	SKILLID3 = 10,
	SKILLID4 = 11,
	
}

--玩家经验配置表
local tPlayerExp = 
{
	[1] = 5,
	[2] = 20,
	[3] = 20,
	[4] = 20,
	[5] = 20,
	[6] = 20,
	[7] = 20,
	[8] = 20,
}

local magic_effect_beforeplayeract = {}
local magic_effect_afterplayeract = {}
local magic_effect_aftermonatt = {}
local magic_effect_aftermonspell = {}



--初始化玩家数据
function p.Initplayer()
	magic_effect_beforeplayeract = {}
	magic_effect_afterplayeract = {}
	magic_effect_aftermonatt = {}
 
	player[playerInfo.HP] = 110;
	player[playerInfo.HPMAX] = 110;
	
	player[playerInfo.ATT] = 3;
	player[playerInfo.GOLD] = 0;
	player[playerInfo.BUFFATT] = 0;
	player[playerInfo.EXP] = 0;
	player[playerInfo.LEVEL] = 1;
	
	
	player[playerInfo.SKILLID1] = 0;
	player[playerInfo.SKILLID2] = 0;
	player[playerInfo.SKILLID3] = 0;
	player[playerInfo.SKILLID4] = 0;
	
	
	
	
	player.AttAdjFuncT = {};
	player.DamageAdjFuncT = {};
	
	player.CriticalChance = 30 --暴击概率
	player.CriticalRate = 2    --暴击比率
	
end

--这个是属性操作
function p.AddHp(nRecovery)
	player[playerInfo.HP] = player[playerInfo.HP] + nRecovery
	
	if player[playerInfo.HP] >= player[playerInfo.HPMAX] then
		player[playerInfo.HP] = player[playerInfo.HPMAX]
	end
end




function p.InitDamageAction(ndamage,pmonster)
	local tDamageAction={
						damage = ndamage,
						attacker = pmonster,
						dodgechance = 0;
					}
	return tDamageAction
end

function p.AddAttAdjFunc(fAttAdjFunc,id)
	player.AttAdjFuncT[id] = fAttAdjFunc
end

function p.RemoveAdjFunc(id)
    player.AttAdjFuncT[id] = nil
end
	
	
function p.AddDamageAdjFunc(fDamageAdjFunc,id)
	player.DamageAdjFuncT[id] = fDamageAdjFunc
end

function p.RemoveDamageAdjFunc(id)
    player.DamageAdjFuncT[id] = nil
end	
	
	
	
--这个是动作
function p.takedamage(ndamage,pmonster)
	local tDamageAction = p.InitDamageAction(ndamage,pmonster)
	for i,func	in pairs(player.DamageAdjFuncT) do
		func(tDamageAction);
	end
	
	
	if tDamageAction.dodgechance ~= 0 then
		if math.random(1,100) <=tDamageAction.dodgechance then
			--被闪避
			return player[playerInfo.HP];
		end
	end
	
	
	player[playerInfo.HP] = player[playerInfo.HP] - tDamageAction.damage;
	return player[playerInfo.HP];
end

function p.drinkBlood(nNum)
	local nRecovery = nNum*2;
	p.AddHp(nRecovery)
	return player[playerInfo.HP];
end

function player.takeGold(nNum)
	player[playerInfo.GOLD] = player[playerInfo.GOLD] + nNum;
	return player[playerInfo.GOLD];
end

--[[
local tPlayerExp = 
{
	[1] = {10}
	[2] = {20}
	[3] = {20}
	[4] = {20}
	[5] = {20}
	[6] = {20}
	[7] = {20}
	[8] = {20}
}
]]
function player.GainEXP()
	player[playerInfo.EXP] = player[playerInfo.EXP] + 1;

	if player[playerInfo.EXP] >= tPlayerExp[player[playerInfo.LEVEL]] then
		--升级
		player[playerInfo.EXP] = player[playerInfo.EXP] - tPlayerExp[player[playerInfo.LEVEL]]
		player[playerInfo.LEVEL] = player[playerInfo.LEVEL]+1
		
		local levlabel = layerMain:getChildByTag(6)
		tolua.cast(levlabel, "CCLabelTTF")
		levlabel:setString("lev:"..player[playerInfo.LEVEL])
		
		
		SkillUpGradeUI.LoadUI();
		
	end
	
	local GOLDlabel = layerMain:getChildByTag(5)
	tolua.cast(GOLDlabel, "CCLabelTTF")
	GOLDlabel:setString("exp:"..player[playerInfo.EXP])
	return player[playerInfo.EXP];
end


function player.GetAttack()
	local att = player[playerInfo.ATT] + player[playerInfo.BUFFATT];
	return  att;
end

function player.AddMagicEff(effinfoT,nPhase)
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		magic_effect_beforeplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		magic_effect_afterplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		magic_effect_aftermonatt[#magic_effect_aftermonatt+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL then
		magic_effect_aftermonspell[#magic_effect_aftermonspell+1] = effinfoT;
	end
end

function player.GetMagicEffTable(nPhase)
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		return magic_effect_beforeplayeract
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		return magic_effect_afterplayeract
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		return magic_effect_aftermonatt
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL then
		return magic_effect_aftermonspell
	end
end


--玩家攻击
--tAttAction{damage攻击力 target对象}
function player.Attack(tAttAction)
	local nDamage = tAttAction.damage
	local target = tAttAction.target
	
	local tAttAction = player.InitAttAction(nDamage,target)
					
	--遍历攻击调整函数
	for k,func in pairs(player.AttAdjFuncT) do
		func(tAttAction)
	end
					
					
	--计算暴击伤害
	if tAttAction.criticalchance >= math.random(0,100) then
		nDamage = nDamage*(tAttAction.criticalrate)
	end
	
	monster.damage(target,nDamage)
	return tAttAction
end

function player.InitAttAction(ndamage,pmonster)
	local tAttAction={
						damage = ndamage,
						target = pmonster,
						criticalrate = player.CriticalRate,
						criticalchance = player.CriticalChance,
					}
	return tAttAction
end