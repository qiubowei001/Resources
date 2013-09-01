monster = {}

monsterInfo = {
	HP =1,
	ATT =2,	
	BUFFATT = 4,
	MAGIC = 5,
	MAGIC_ROUND =6,
}
local g_hplabeltag =100;
local g_attlabeltag = 101;

local MONSTER_TYPE = {}

	MONSTER_TYPE[1] = {}
	MONSTER_TYPE[1]["name"] = "Slimegreen"
	MONSTER_TYPE[1]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[1]["HP"] = 10
	MONSTER_TYPE[1]["HPadj"] = 3
	
	
	
	MONSTER_TYPE[2] = {}
	MONSTER_TYPE[2]["name"] = "Slimered"
	MONSTER_TYPE[2]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[2]["HP"] = 10
	MONSTER_TYPE[2]["HPadj"] = 3
	
	MONSTER_TYPE[3] = {}
	MONSTER_TYPE[3]["name"] = "Slimeblue"
	MONSTER_TYPE[3]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[3]["HP"] = 10
	MONSTER_TYPE[3]["HPadj"] = 3

	
	
	MONSTER_TYPE[4] = {}
	MONSTER_TYPE[4]["name"] = "SlimeKing"
	MONSTER_TYPE[4]["MAgic"] = {1007} --技能列表
	MONSTER_TYPE[4]["MAgicRound"] = {1} 
	MONSTER_TYPE[4]["HP"] = 10
	MONSTER_TYPE[4]["HPadj"] = 3
	
	MONSTER_TYPE[5] = {}
	MONSTER_TYPE[5]["name"] = "FireSpider"
	MONSTER_TYPE[5]["MAgic"] = {1008} --技能列表
	MONSTER_TYPE[5]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[5]["HP"] = 10
	MONSTER_TYPE[5]["HPadj"] = 3

	
	MONSTER_TYPE[6] = {}
	MONSTER_TYPE[6]["name"] = "littleFireSpider"
	MONSTER_TYPE[6]["MAgic"] = nil
	MONSTER_TYPE[6]["HP"] = 10
	MONSTER_TYPE[6]["HPadj"] = 3

	MONSTER_TYPE[7] = {}
	MONSTER_TYPE[7]["name"] = "FrozenEye"
	MONSTER_TYPE[7]["MAgic"] = {1009} --技能列表
	MONSTER_TYPE[7]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[7]["HP"] = 10
	MONSTER_TYPE[7]["HPadj"] = 3
	
	MONSTER_TYPE[8] = {}
	MONSTER_TYPE[8]["name"] = "FireEye"
	MONSTER_TYPE[8]["MAgic"] = {1010} --技能列表
	MONSTER_TYPE[8]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[8]["HP"] = 10
	MONSTER_TYPE[8]["HPadj"] = 3

	MONSTER_TYPE[9] = {}
	MONSTER_TYPE[9]["name"] = "Bat"
	MONSTER_TYPE[9]["MAgic"] = {1011} --技能列表
	MONSTER_TYPE[9]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[9]["HP"] = 10
	MONSTER_TYPE[9]["HPadj"] = 3
	
	MONSTER_TYPE[10] = {}
	MONSTER_TYPE[10]["name"] = "wizard"
	MONSTER_TYPE[10]["MAgic"] = {1012} --技能列表
	MONSTER_TYPE[10]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[10]["HP"] = 10
	MONSTER_TYPE[10]["HPadj"] = 3
	
--初始化怪物数据
function monster.InitMonster( pBrick,nid)
		pBrick.moninfo = 
		{
		[monsterInfo.HP] = MONSTER_TYPE[nid]["HP"] + math.random(-MONSTER_TYPE[nid]["HPadj"],MONSTER_TYPE[nid]["HPadj"]),
		[monsterInfo.ATT] = 1,
		[monsterInfo.BUFFATT] = 0,
		[monsterInfo.MAGIC] = MONSTER_TYPE[nid]["MAgic"],

		}

		if pBrick.moninfo[monsterInfo.MAGIC]~= nil then
			pBrick.moninfo[monsterInfo.MAGIC_ROUND] = {}
			for i,v in pairs(MONSTER_TYPE[nid]["MAgicRound"])do
				pBrick.moninfo[monsterInfo.MAGIC_ROUND][i] = v;
			end
		end
		
		
		
		
		
		
			local hpLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.HP], "Arial", 35)
			pBrick:addChild(hpLabel)
			hpLabel:setColor(ccc3(255,255,0))
			hpLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth/3)
			hpLabel:setTag(g_hplabeltag);
			
			local AttLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.ATT], "Arial", 35)
			pBrick:addChild(AttLabel)
			AttLabel:setColor(ccc3(0,0,0))
			AttLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth*2/3)
			AttLabel:setTag(g_attlabeltag);
			
			
			pBrick.IsSpelled = false;
			
			pBrick.AttAdjFuncT = {};
			pBrick.DamageAdjFuncT = {};
			
			
end

--修改怪物属性
function monster.AddHp(pmonster,nRecovery)
	pmonster.moninfo[monsterInfo.HP]  = pmonster.moninfo[monsterInfo.HP]  + nRecovery
	local hplabel = pmonster:getChildByTag(g_hplabeltag)
	tolua.cast(hplabel, "CCLabelTTF")
	hplabel:setString(pmonster.moninfo[monsterInfo.HP] )
	
	if pmonster.moninfo[monsterInfo.HP] <= 0 then
		Main.destroyBrick(pmonster.TileX,pmonster.TileY)
	end	
end


--伤害ACTION初始化
function monster.InitDamageAction( pTarget,ndamage)
	local tDamageAction = {
							defender = pTarget,
							damage = ndamage,
						
							}
	return tDamageAction;
end

--伤害计算
function monster.damage( pBrick,nDamage)
		local tDamageAction = monster.InitDamageAction( pBrick,nDamage);
		
		
		for i,func in pairs(pBrick.DamageAdjFuncT) do
			func(tDamageAction)
		end
		
		local ndamage =  tDamageAction.damage
		local defender = tDamageAction.defender
		
		if defender ~= nil then 
			defender.moninfo[monsterInfo.HP]  = defender.moninfo[monsterInfo.HP]  - ndamage
			local hplabel = defender:getChildByTag(g_hplabeltag)
			tolua.cast(hplabel, "CCLabelTTF")
			hplabel:setString(defender.moninfo[monsterInfo.HP] )
		
			if defender.moninfo[monsterInfo.HP] <= 0 then
				Main.destroyBrick(defender.TileX,defender.TileY)
				
				
				--玩家獲取經驗
				player.GainEXP();
			end
		end	
end



--怪物攻击ACTION初始化
function monster.InitAttAction( pTarget,ndamage,pmonster)
	local tAttAction = {
							defender = pTarget,
							damage = ndamage,
							attacker = pmonster,
						}
	return tAttAction;
end

--怪物攻击
function monster.attack()
	local ndamage = 0;
	for i = 1,brickInfo.brick_num_X do
	
		for j = 1,brickInfo.brick_num_Y do
			if Board[i][j] ~= nil then
				if Board[i][j].nType == tbrickType.MONSTER then
					
					
					local tAttAction = monster.InitAttAction( player,ndamage,Board[i][j])
					tAttAction.damage = monster.GetMonsterAtt(Board[i][j])--Board[i][j].moninfo[monsterInfo.ATT];
					
					--遍历怪物攻击调整函数
					for k,func in pairs(Board[i][j].AttAdjFuncT) do
						func(tAttAction)
					end
					
					player.takedamage(tAttAction.damage,Board[i][j]);
				end				
			end
		end
	end
	--cclog(" return ndamage:"..ndamage)
	return ndamage;
	
end



--每次场景刷新怪物，都会遍历怪物施放技能。怪物数据中 剩余释放次数大于0则释放，并-1, 
--如果是在出生时 则直接执行EFF
function monster.SpellMagic(pmonster,IfBorn)
	--第二个参数可以考虑做个判定 
	--不同对象类型做不同输入 
	--现在只做了SINGLE_BRICK输入	
	if pmonster.moninfo[monsterInfo.MAGIC] ~= nil then	
		for i,nid in pairs(pmonster.moninfo[monsterInfo.MAGIC]) do
			local spelltime =  pmonster.moninfo[monsterInfo.MAGIC_ROUND][i];
			
			if spelltime > 0 then
				
				--if pmonster.IsSpelled == false then
					--本回合还未施放技能
					local tTargetList,tEffList = magic.SpellMagic(nid,pmonster);
					pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]= pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]-1;
					pmonster.IsSpelled = true;
					
					--怪物技能特效是否需要马上触发
					if magic.GetMagicDoeffAfterSpell(nid) ==true and IfBorn== true then
						for j,v in pairs(tTargetList) do
							local effT = tEffList[j];
							local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]
							local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
							efffunc(v,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])

							--获取怪物EFFTABLE ROUND --
							effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
						end
					end
				--end
			end
		end		
	end
end


--获取怪物攻击力
function monster.GetMonsterAtt(pmonster)
	local att = pmonster.moninfo[monsterInfo.ATT] + pmonster.moninfo[monsterInfo.BUFFATT] ;
	
	--[[
	for i,func in pairs(pmonster.AttAdjFuncT) do
		att = func(att)
		
		--攻击无效则返回
		if att == false then
			att = 0;
			break
		end
	end--]]
	
	return  att;
end

function monster.AddAttAdjFunc(pmonster,fAttAdjFunc,id)
	pmonster.AttAdjFuncT[id] = fAttAdjFunc
end

function monster.RemoveAdjFunc(pmonster,id)
    pmonster.AttAdjFuncT[id] = nil
end
	
	
function monster.AddDamageAdjFunc(pmonster,fDamageAdjFunc,id)
	pmonster.DamageAdjFuncT[id] = fDamageAdjFunc
end

function monster.RemoveDamageAdjFunc(pmonster,id)
    pmonster.DamageAdjFuncT[id] = nil
end	
	

--获取怪物图标路径
function monster.GetMonsterIconPath(nMonsterId)
	
	return "brick/monster/monster"..nMonsterId..".png";
end

