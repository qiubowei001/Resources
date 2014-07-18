monster = {}
local p = monster
monsterInfo = {
	HP =1,
	ATT =2,	
	BUFFATT = 4,
	MAGIC = 5,
	MAGIC_ROUND =6,
	CD = 7,
	CDMAX = 8,
	LEV = 9,
	HPMAX = 10,
}
local g_hplabeltag =100;
local g_attlabeltag = 101;
local g_CDbar = 102;
local g_attspritetag = 103;

local gblinkactionTag = 90000;

--全局
MONSTER_TYPE = {}

	MONSTER_TYPE[1] = {}
	MONSTER_TYPE[1]["name"] = "Slimegreen"
	MONSTER_TYPE[1]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[1]["HP"] = 24
	MONSTER_TYPE[1]["HPGrow"] = 1
	MONSTER_TYPE[1]["HPadj"] = 3
	MONSTER_TYPE[1]["ATT"] = 2
	--MONSTER_TYPE[1]["ATT"] = 60
	MONSTER_TYPE[1]["ATTGrow"] = 1
	MONSTER_TYPE[1]["ATTadj"] = 3
	MONSTER_TYPE[1]["CD"] = 30
	MONSTER_TYPE[1]["CDGrow"] = -1
	MONSTER_TYPE[1]["PICID"] = 1
	MONSTER_TYPE[1]["ScarePICID"] = 8
	MONSTER_TYPE[1]["desc"]	= ""
	
	MONSTER_TYPE[2] = {}
	MONSTER_TYPE[2]["name"] = "Slimered"
	MONSTER_TYPE[2]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[2]["HP"] = 30
	MONSTER_TYPE[2]["HPGrow"] = 2
	MONSTER_TYPE[2]["HPadj"] = 3
	MONSTER_TYPE[2]["ATT"] = 2
	MONSTER_TYPE[2]["ATTGrow"] = 0.5
	MONSTER_TYPE[2]["ATTadj"] = 3
	MONSTER_TYPE[2]["CD"] = 30
	MONSTER_TYPE[2]["CDGrow"] = -1
	MONSTER_TYPE[2]["PICID"] = 2
	MONSTER_TYPE[2]["ScarePICID"] = 17
	MONSTER_TYPE[2]["desc"]	= ""
	
	MONSTER_TYPE[3] = {}
	MONSTER_TYPE[3]["name"] = "Slimeblue"
	MONSTER_TYPE[3]["MAgic"] = nil--{7} --技能列表
	MONSTER_TYPE[3]["HP"] = 27
	MONSTER_TYPE[3]["HPGrow"] = 1
	MONSTER_TYPE[3]["HPadj"] = 3
	MONSTER_TYPE[3]["ATT"] = 1
	MONSTER_TYPE[3]["ATTGrow"] = 0.7
	MONSTER_TYPE[3]["ATTadj"] = 3
	MONSTER_TYPE[3]["CD"] = 20
	MONSTER_TYPE[3]["CDGrow"] = -1.5
	MONSTER_TYPE[3]["PICID"] = 18
	MONSTER_TYPE[3]["ScarePICID"] = 19
	MONSTER_TYPE[3]["desc"]	= ""
	
	MONSTER_TYPE[4] = {}
	MONSTER_TYPE[4]["name"] = "SlimeKing"
	MONSTER_TYPE[4]["MAgic"] = {1007} --技能列表
	MONSTER_TYPE[4]["MAgicRound"] = {1} 
	MONSTER_TYPE[4]["HP"] = 27
	MONSTER_TYPE[4]["HPGrow"] = 2
	MONSTER_TYPE[4]["HPadj"] = 3
	MONSTER_TYPE[4]["ATT"] = 1
	MONSTER_TYPE[4]["ATTGrow"] = 1
	MONSTER_TYPE[4]["ATTadj"] = 3
	MONSTER_TYPE[4]["CD"] = 30
	MONSTER_TYPE[4]["CDGrow"] = -1
	MONSTER_TYPE[4]["PICID"] = 9
	MONSTER_TYPE[4]["ScarePICID"] = 10
	MONSTER_TYPE[4]["desc"]	= ""
	
	MONSTER_TYPE[5] = {}
	MONSTER_TYPE[5]["name"] = "FireSpider"
	MONSTER_TYPE[5]["MAgic"] = {1008} --技能列表
	MONSTER_TYPE[5]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[5]["HP"] = 27
	MONSTER_TYPE[5]["HPGrow"] = 4
	MONSTER_TYPE[5]["HPadj"] = 3
	MONSTER_TYPE[5]["ATT"] = 1
	MONSTER_TYPE[5]["ATTGrow"] = 1
	MONSTER_TYPE[5]["ATTadj"] = 3
	MONSTER_TYPE[5]["CD"] = 20
	MONSTER_TYPE[5]["CDGrow"] = -1
	MONSTER_TYPE[5]["PICID"] = 11
	MONSTER_TYPE[5]["ScarePICID"] = 12
	MONSTER_TYPE[5]["desc"]	= ""
	
	MONSTER_TYPE[6] = {}
	MONSTER_TYPE[6]["name"] = "littleFireSpider"
	MONSTER_TYPE[6]["MAgic"] = nil
	MONSTER_TYPE[6]["HP"] = 15
	MONSTER_TYPE[6]["HPGrow"] = 4
	MONSTER_TYPE[6]["HPadj"] = 3
	MONSTER_TYPE[6]["ATT"] = 1
	MONSTER_TYPE[6]["ATTGrow"] = 1
	MONSTER_TYPE[6]["ATTadj"] = 3
	MONSTER_TYPE[6]["CD"] = 20
	MONSTER_TYPE[6]["CDGrow"] = -1
	MONSTER_TYPE[6]["PICID"] = 13
	MONSTER_TYPE[6]["ScarePICID"] = 14
	MONSTER_TYPE[6]["desc"]	= ""
	
	MONSTER_TYPE[7] = {}
	MONSTER_TYPE[7]["name"] = "FrozenEye"
	MONSTER_TYPE[7]["MAgic"] = {1009} --技能列表
	MONSTER_TYPE[7]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[7]["HP"] = 25
	MONSTER_TYPE[7]["HPGrow"] = 4
	MONSTER_TYPE[7]["HPadj"] = 3
	MONSTER_TYPE[7]["ATT"] = 1
	MONSTER_TYPE[7]["ATTGrow"] = 1
	MONSTER_TYPE[7]["ATTadj"] = 3
	MONSTER_TYPE[7]["CD"] = 20
	MONSTER_TYPE[7]["CDGrow"] = -1
	MONSTER_TYPE[7]["PICID"] = 1
	MONSTER_TYPE[7]["ScarePICID"] = 8
	MONSTER_TYPE[7]["desc"]	= ""
	
	MONSTER_TYPE[8] = {}
	MONSTER_TYPE[8]["name"] = "FireEye"
	MONSTER_TYPE[8]["MAgic"] = {1010} --技能列表
	MONSTER_TYPE[8]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[8]["HP"] = 25
	MONSTER_TYPE[8]["HPGrow"] = 4
	MONSTER_TYPE[8]["HPadj"] = 3
	MONSTER_TYPE[8]["ATT"] = 1
	MONSTER_TYPE[8]["ATTGrow"] = 1
	MONSTER_TYPE[8]["ATTadj"] = 3
	MONSTER_TYPE[8]["CD"] = 20
	MONSTER_TYPE[8]["CDGrow"] = -1
	MONSTER_TYPE[8]["PICID"] = 1
	MONSTER_TYPE[8]["ScarePICID"] = 8
	MONSTER_TYPE[8]["desc"]	= ""
	
	
	MONSTER_TYPE[9] = {}
	MONSTER_TYPE[9]["name"] = "Bat"
	MONSTER_TYPE[9]["MAgic"] = {1011} --技能列表
	MONSTER_TYPE[9]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[9]["HP"] = 25
	MONSTER_TYPE[9]["HPGrow"] = 4
	MONSTER_TYPE[9]["HPadj"] = 3
	MONSTER_TYPE[9]["ATT"] = 1
	MONSTER_TYPE[9]["ATTGrow"] = 1
	MONSTER_TYPE[9]["ATTadj"] = 3
	MONSTER_TYPE[9]["CD"] = 20
	MONSTER_TYPE[9]["CDGrow"] = -1
	MONSTER_TYPE[9]["PICID"] = 15
	MONSTER_TYPE[9]["ScarePICID"] = 16
	MONSTER_TYPE[9]["desc"]	= ""
	
	MONSTER_TYPE[10] = {}
	MONSTER_TYPE[10]["name"] = "wizard"
	MONSTER_TYPE[10]["MAgic"] = {1012} --技能列表
	MONSTER_TYPE[10]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[10]["HP"] = 25
	MONSTER_TYPE[10]["HPGrow"] = 4
	MONSTER_TYPE[10]["HPadj"] = 3
	MONSTER_TYPE[10]["ATT"] = 1
	MONSTER_TYPE[10]["ATTGrow"] = 1
	MONSTER_TYPE[10]["ATTadj"] = 3
	MONSTER_TYPE[10]["CD"] = 20
	MONSTER_TYPE[10]["CDGrow"] = -1
	MONSTER_TYPE[10]["PICID"] = 26
	MONSTER_TYPE[10]["ScarePICID"] = 26
	MONSTER_TYPE[10]["desc"]	= ""
	
	--屁股星人
	MONSTER_TYPE[11] = {}
	MONSTER_TYPE[11]["name"] = "Asman"
	MONSTER_TYPE[11]["MAgic"] = {1013} --技能列表
	MONSTER_TYPE[11]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[11]["HP"] = 25
	MONSTER_TYPE[11]["HPGrow"] = 4
	MONSTER_TYPE[11]["HPadj"] = 3
	MONSTER_TYPE[11]["ATT"] = 1
	MONSTER_TYPE[11]["ATTGrow"] = 1
	MONSTER_TYPE[11]["ATTadj"] = 3
	MONSTER_TYPE[11]["CD"] = 20
	MONSTER_TYPE[11]["CDGrow"] = -1
	MONSTER_TYPE[11]["PICID"] = 22
	MONSTER_TYPE[11]["ScarePICID"] = 23
	MONSTER_TYPE[11]["desc"]	= "Er..It's an Asman.\nBe careful of its poop"

	--嘲諷兵
	MONSTER_TYPE[12] = {}
	MONSTER_TYPE[12]["name"] = "shield"
	MONSTER_TYPE[12]["MAgic"] = {1014} --技能列表
	MONSTER_TYPE[12]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[12]["HP"] = 50
	MONSTER_TYPE[12]["HPGrow"] = 4
	MONSTER_TYPE[12]["HPadj"] = 3
	MONSTER_TYPE[12]["ATT"] = 1
	MONSTER_TYPE[12]["ATTGrow"] = 1
	MONSTER_TYPE[12]["ATTadj"] = 3
	MONSTER_TYPE[12]["CD"] = 20
	MONSTER_TYPE[12]["CDGrow"] = -1
	MONSTER_TYPE[12]["PICID"] = 24
	MONSTER_TYPE[12]["ScarePICID"] = 25
	MONSTER_TYPE[12]["desc"]	= "Er..It's Ass Man.\nBe careful of its poop"

	--小偷
	MONSTER_TYPE[13] = {}
	MONSTER_TYPE[13]["name"] = "thief"
	MONSTER_TYPE[13]["MAgic"] = {1015} --技能列表
	MONSTER_TYPE[13]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[13]["HP"] = 20
	MONSTER_TYPE[13]["HPGrow"] = 1
	MONSTER_TYPE[13]["HPadj"] = 3
	MONSTER_TYPE[13]["ATT"] = 1
	MONSTER_TYPE[13]["ATTGrow"] = 0.1
	MONSTER_TYPE[13]["ATTadj"] = 1
	MONSTER_TYPE[13]["CD"] = 20
	MONSTER_TYPE[13]["CDGrow"] = -1
	MONSTER_TYPE[13]["PICID"] = 27
	MONSTER_TYPE[13]["ScarePICID"] = 27
	MONSTER_TYPE[13]["desc"]	= "Er..It's Ass Man.\nBe careful of its poop"

	--愤怒者
	MONSTER_TYPE[14] = {}
	MONSTER_TYPE[14]["name"] = "angry"
	MONSTER_TYPE[14]["MAgic"] = {1016} --技能列表
	MONSTER_TYPE[14]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[14]["HP"] = 50
	MONSTER_TYPE[14]["HPGrow"] = 4
	MONSTER_TYPE[14]["HPadj"] = 3
	MONSTER_TYPE[14]["ATT"] = 1
	MONSTER_TYPE[14]["ATTGrow"] = 0.1
	MONSTER_TYPE[14]["ATTadj"] = 1
	MONSTER_TYPE[14]["CD"] = 30
	MONSTER_TYPE[14]["CDGrow"] = -1
	MONSTER_TYPE[14]["PICID"] = 28
	MONSTER_TYPE[14]["ScarePICID"] = 28
	MONSTER_TYPE[14]["desc"]	= "Don't..piss ..me .. off"


	--自爆兵
	MONSTER_TYPE[15] = {}
	MONSTER_TYPE[15]["name"] = "explode"
	MONSTER_TYPE[15]["MAgic"] = {1017} --技能列表
	MONSTER_TYPE[15]["MAgicRound"] = {999} --无限
	MONSTER_TYPE[15]["HP"] = 18
	MONSTER_TYPE[15]["HPGrow"] = 2
	MONSTER_TYPE[15]["HPadj"] = 3
	MONSTER_TYPE[15]["ATT"] = 1
	MONSTER_TYPE[15]["ATTGrow"] = 0.1
	MONSTER_TYPE[15]["ATTadj"] = 1
	MONSTER_TYPE[15]["CD"] = 60
	MONSTER_TYPE[15]["CDGrow"] = -1
	MONSTER_TYPE[15]["PICID"] = 29
	MONSTER_TYPE[15]["ScarePICID"] = 29
	MONSTER_TYPE[15]["desc"]	= "EXPLODE!!!"

	--燃烧能量
	MONSTER_TYPE[16] = {}
	MONSTER_TYPE[16]["name"] = "demon"
	MONSTER_TYPE[16]["MAgic"] = {1018} --技能列表
	MONSTER_TYPE[16]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[16]["HP"] = 25
	MONSTER_TYPE[16]["HPGrow"] = 4
	MONSTER_TYPE[16]["HPadj"] = 3
	MONSTER_TYPE[16]["ATT"] = 1
	MONSTER_TYPE[16]["ATTGrow"] = 1
	MONSTER_TYPE[16]["ATTadj"] = 3
	MONSTER_TYPE[16]["CD"] = 20
	MONSTER_TYPE[16]["CDGrow"] = -1
	MONSTER_TYPE[16]["PICID"] = 1
	MONSTER_TYPE[16]["ScarePICID"] = 1
	MONSTER_TYPE[16]["desc"]	= "burn your energy!"

	--腐蚀装备
	MONSTER_TYPE[17] = {}
	MONSTER_TYPE[17]["name"] = "break"
	MONSTER_TYPE[17]["MAgic"] = {1019} --技能列表
	MONSTER_TYPE[17]["MAgicRound"] = {1} --无限
	MONSTER_TYPE[17]["HP"] = 25
	MONSTER_TYPE[17]["HPGrow"] = 4
	MONSTER_TYPE[17]["HPadj"] = 3
	MONSTER_TYPE[17]["ATT"] = 1
	MONSTER_TYPE[17]["ATTGrow"] = 1
	MONSTER_TYPE[17]["ATTadj"] = 3
	MONSTER_TYPE[17]["CD"] = 20
	MONSTER_TYPE[17]["CDGrow"] = -1
	MONSTER_TYPE[17]["PICID"] = 1
	MONSTER_TYPE[17]["ScarePICID"] = 1
	MONSTER_TYPE[17]["desc"]	= "break equip!"


function p.GetPicIdFromMonsterId(nMonsterId)
	cclog("GetPicIdFromMonsterId:"..nMonsterId)
	return MONSTER_TYPE[nMonsterId]["PICID"]
end
	
function p.GetScarePicIdFromMonsterId(nMonsterId)
	return MONSTER_TYPE[nMonsterId]["ScarePICID"]	
end
	
	
	
	
function p.AttackCDPlusOne(pbrick)
	pbrick.moninfo[monsterInfo.CD] = pbrick.moninfo[monsterInfo.CD] + 1
	
	--设定进度条
	local nPersent = 100*pbrick.moninfo[monsterInfo.CD]/pbrick.moninfo[monsterInfo.CDMAX]
	BARbg = pbrick.CDBARBG
	
	local BAR = pbrick.CDBAR
	
	if nPersent>100 then
		nPersent = 100
	end	
	
	
	BAR:setPercentage(nPersent);
	
	local mainsprite = brick.GetMainSprite(pbrick)		
	
	--mainsprite:stopActionByTag(gblinkactionTag)
	mainsprite:setVisible(true)
	 
	--90%时闪烁
	if nPersent>= 100 then
		local sprite = pbrick.attackready 
		sprite:setVisible(true)
		BAR:setVisible(false)
		

		--执行释放技能 和攻击
		if pbrick.IfBeStunned == false then
			p.SpellMagic(pbrick,false)	
		end
		p.attack(pbrick);
		
		--执行MAGIC特效
		magiceff.DoMagicEffAfterMonsterAct(pbrick);
		
		--清除过期特效
		magiceff.ClearMonTriggerMagicEff(pbrick)
		
		
	elseif nPersent>=80 then
		if pbrick.IfScaled == false then
			local array = CCArray:create()
			array:addObject(CCScaleTo:create(0.5, 2.5))
			array:addObject(CCScaleTo:create(0.5, 1))
			
			local action = CCSequence:create(array)
			BARbg:runAction(action)
			pbrick.IfScaled = true
		end
	elseif nPersent < 80 then
		BAR:setVisible(true)
		
		local sprite = pbrick.attackready 
		sprite:setVisible(false)
		
		if pbrick.IfScaled == true then
			pbrick.IfScaled = false
		end
	end
	
	--]]
    
end	
	
--初始化怪物数据
function p.InitMonster( pBrick,nid,nLev)
		if nLev == nil then
			nLev = 0;
		end
		
		pBrick.monsterId = nid
		
		
		local hp = MONSTER_TYPE[nid]["HP"] + nLev*MONSTER_TYPE[nid]["HPGrow"] + math.random(-MONSTER_TYPE[nid]["HPadj"],MONSTER_TYPE[nid]["HPadj"])
		local att = MONSTER_TYPE[nid]["ATT"] + nLev*MONSTER_TYPE[nid]["ATTGrow"] + math.random(-MONSTER_TYPE[nid]["ATTadj"],MONSTER_TYPE[nid]["ATTadj"])
		local CDMAX = MONSTER_TYPE[nid]["CD"] + nLev*MONSTER_TYPE[nid]["CDGrow"]
		if  hp <= 0 then
			hp = 1
		end
	
		if  att  <= 0 then
			att  = 1
		end
		
		if CDMAX < 5 then
			CDMAX = 5
		end
		
		pBrick.moninfo = 
		{
		
		[monsterInfo.LEV] = nLev,
		
		
		[monsterInfo.HP] = hp,
		[monsterInfo.HPMAX] = hp,
		
		[monsterInfo.ATT] = att,
		[monsterInfo.BUFFATT] = 0,
		[monsterInfo.MAGIC] = MONSTER_TYPE[nid]["MAgic"],
		[monsterInfo.CD] = 0,
		[monsterInfo.CDMAX] = CDMAX,
		
		}
		
		
		
		--攻击CD是否闪烁
		pBrick.IfScaled  = false;
		
		
		--眩晕
		pBrick.IfBeStunned =false;
		
		if pBrick.moninfo[monsterInfo.MAGIC]~= nil then
			pBrick.moninfo[monsterInfo.MAGIC_ROUND] = {}
			for i,v in pairs(MONSTER_TYPE[nid]["MAgicRound"])do
				pBrick.moninfo[monsterInfo.MAGIC_ROUND][i] = v;
			end
		end
		
		
		--冷却进度条
		local CDBarBg = CCMenuItemImage:create("UI/Bar/brickbarbg.png", "UI/Bar/brickbarbg.png")
		CDBarBg:setPosition(brickInfo.brickWidth/2, brickInfo.brickWidth*4/5)
		pBrick:addChild(CDBarBg)
		CDBarBg:setTag(g_CDbar);
		
		
		--攻击准备
		attackready = CCSprite:create("UI/Bar/attackready.png")
		attackready:setPosition(CCPointMake(30, 7))
		CDBarBg:addChild(attackready,1,2)
		attackready:setVisible(false)
		
		CDBar = CCProgressTimer:create(CCSprite:create("UI/Bar/attackcdbar.png"))
		CDBar:setType(kCCProgressTimerTypeBar)
		CDBar:setMidpoint(CCPointMake(0, 0))
		CDBar:setBarChangeRate(CCPointMake(1, 0))
		
		CDBar:setPosition(CCPointMake(30, 7))
		--CDBar:setTag(g_CDbar);
		CDBarBg:addChild(CDBar,1,1)		
		pBrick.CDBARBG = CDBarBg
		pBrick.CDBAR = CDBar
		pBrick.attackready = attackready
		
		
		
		--血条
		local HPBarBg = CCMenuItemImage:create("UI/Bar/brickbarbg.png", "UI/Bar/brickbarbg.png")
		HPBarBg:setPosition(brickInfo.brickWidth/2, brickInfo.brickWidth*7/10)
		pBrick:addChild(HPBarBg)
		HPBarBg:setTag(g_hplabeltag);
		HPBar = CCProgressTimer:create(CCSprite:create("UI/Bar/monsterhpbar.png"))
		HPBar:setType(kCCProgressTimerTypeBar)
		HPBar:setMidpoint(CCPointMake(0, 0))
		HPBar:setBarChangeRate(CCPointMake(1, 0))
		HPBar:setPosition(CCPointMake(30, 7))
		HPBarBg:addChild(HPBar,1,1)		
		pBrick.HPBar = HPBar
		HPBar:setPercentage(100);
		--]]
		
		--[[
		local AttLabel = CCLabelTTF:create(pBrick.moninfo[monsterInfo.ATT], "Arial", 35)
		pBrick:addChild(AttLabel)
		AttLabel:setColor(ccc3(0,0,0))
		AttLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth*2/3)
		AttLabel:setTag(g_attlabeltag);
		--]]
		
		--攻击力表示
		local Attsprite = ValueToPic.GetPicByAttack(pBrick.moninfo[monsterInfo.ATT])
		pBrick:addChild(Attsprite)
		Attsprite:setTag(g_attspritetag);
		
		
		--[[
		local LevLabel = CCLabelTTF:create("LV:"..pBrick.moninfo[monsterInfo.LEV], "Arial", 20)
		pBrick:addChild(LevLabel)
		LevLabel:setColor(ccc3(0,255,0))
		LevLabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth)
		--]]
		
		
		pBrick.AttAdjFuncT = {};
		pBrick.DamageAdjFuncT = {};
		pBrick.DeathActionFuncT = {};
			
			
end


function p.SetAtt(pmonster)
	local natt = p.GetMonsterAtt(pmonster)
	--[[
	local Attlabel = pmonster:getChildByTag(g_attlabeltag)
	tolua.cast(Attlabel, "CCLabelTTF")
	Attlabel:setString(natt)
	--]]
	
	local Attsprite = pmonster:getChildByTag(g_attspritetag)
	Attsprite:removeFromParentAndCleanup(true);
	local Attsprite = ValueToPic.GetPicByAttack(natt)
	pmonster:addChild(Attsprite)
	Attsprite:setTag(g_attspritetag);
end

--修改怪物属性
function p.AddHp(pmonster,nRecovery)
	pmonster.moninfo[monsterInfo.HP]  = pmonster.moninfo[monsterInfo.HP]  + nRecovery
	
	if pmonster.moninfo[monsterInfo.HP] >= pmonster.moninfo[monsterInfo.HPMAX] then
		pmonster.moninfo[monsterInfo.HP] = pmonster.moninfo[monsterInfo.HPMAX] 
	end
	
	--
	local hpbar = pmonster.HPBar
	local percent = pmonster.moninfo[monsterInfo.HP]/ pmonster.moninfo[monsterInfo.HPMAX]
	hpbar:setPercentage(100*percent);
	--]]
	
	if pmonster.moninfo[monsterInfo.HP] <= 0 then
		Main.destroyBrick(pmonster.TileX,pmonster.TileY)
	end	
end


--伤害ACTION初始化
function p.InitDamageAction( pTarget,ndamage)
	local tDamageAction = {
							defender = pTarget,
							damage = ndamage,
						
							}
	return tDamageAction;
end

--伤害计算
function p.damage( pBrick,nDamage,bcritical)
		local tDamageAction = p.InitDamageAction( pBrick,nDamage);
		
		--在怪物位置播放去血sprite
		if bcritical then
			p.playDamageEff(pBrick,nDamage)
		end			
		
		for i,func in pairs(pBrick.DamageAdjFuncT) do
			func(tDamageAction)
		end
		
		local ndamage =  tDamageAction.damage
		local defender = tDamageAction.defender
		
		if defender ~= nil then 
			defender.moninfo[monsterInfo.HP]  = defender.moninfo[monsterInfo.HP]  - ndamage	
			local hpbar = defender.HPBar
			local percent = defender.moninfo[monsterInfo.HP]/ defender.moninfo[monsterInfo.HPMAX]
			hpbar:setPercentage(100*percent);
	
			--怪物扣血 设置透明
			local mainsprite = brick.GetMainSprite(pBrick)
			mainsprite:setOpacity(50+200*percent)

	
			if defender.moninfo[monsterInfo.HP] <= 0 then
				--執行死亡ACTION
				local tDeathAction = p.InitDeathAction(defender);
				for i,func in pairs(defender.DeathActionFuncT) do
					func(tDeathAction)
				end
				
				--停止闪烁
				local mainsprite = brick.GetMainSprite(pBrick)		
				mainsprite:stopActionByTag(gblinkactionTag)
	
				--玩家獲取經驗
				--local nexp =  (defender.moninfo[monsterInfo.LEV])+1
				local nexp =  1
				player.GainEXP(nexp);

				--玩家获取金币
				local buff =  player[playerInfo.Entity_KILLBUFF ]
				local lev =  pBrick.moninfo[monsterInfo.LEV]
				local nGold =  math.floor(brickInfo.GoldPerLev  * lev * buff)
				player.takeGold(nGold);
				
				
				--执行死亡动画
				if bcritical == nil or bcritical == false then
					p.PlayDeathAnimation(pBrick);
				else
					p.PlayCriticalHitAnimation(pBrick);
				end
				
				
				Main.destroyBrick(defender.TileX,defender.TileY,false)
			end
		end	
end


--怪物死亡行為初始化
function p.InitDeathAction(dyingMon)
	local tDeathAction = {	
							dyingMon = dyingMon,
						 }
	return tDeathAction
end


--怪物攻击ACTION初始化
function p.InitAttAction( pTarget,ndamage,pmonster)
	local tAttAction = {
							defender = pTarget,
							damage = ndamage,
							attacker = pmonster,
						}
	return tAttAction;
end

--怪物攻击
function p.attack(pmonster)
	local ndamage = 0;		
	--攻击是否CD
	if pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
		
		local tAttAction = p.InitAttAction( player,ndamage,pmonster)
		
		tAttAction.damage = p.GetMonsterAtt(pmonster)
		
		local bSkip = false
		
		--遍历怪物攻击调整函数
		for k,func in pairs(pmonster.AttAdjFuncT) do
			if func(tAttAction) == false then
				--不攻击
				bSkip = true
			end
		end
		
		if bSkip == false then
			--怪物攻击跳跃
			local actionJump = CCJumpBy:create(1.0, ccp(0, 0), 40, 5)
			local mainsprite = brick.GetMainSprite(pmonster)
			--mainsprite:runAction(actionJump);
			pmonster:runAction(actionJump);
			cclog("monsterid:"..pmonster.monsterId.."att:"..pmonster.moninfo[monsterInfo.ATT].." player damage:"..tAttAction.damage)
			player.takedamage(tAttAction.damage,pmonster);	
			pmonster.moninfo[monsterInfo.CD]	= 0;							
		end
	end
	return ndamage;
end



--每次场景刷新怪物，都会遍历怪物施放技能。怪物数据中 剩余释放次数大于0则释放，并-1, 
--如果是在出生时 则直接执行EFF
function p.SpellMagic(pmonster,IfBorn)
	--第二个参数可以考虑做个判定 
	--不同对象类型做不同输入 
	--现在只做了SINGLE_BRICK输入	
	if pmonster.moninfo[monsterInfo.MAGIC] ~= nil then	
		for i,nid in pairs(pmonster.moninfo[monsterInfo.MAGIC]) do
		
			--攻击是否CD
			--if IfBorn ==true or pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
			if   pmonster.moninfo[monsterInfo.CD]  >= pmonster.moninfo[monsterInfo.CDMAX] then
				local spelltime =  pmonster.moninfo[monsterInfo.MAGIC_ROUND][i];
				
				if spelltime > 0 then
					--本回合还未施放技能
					local tTargetList,tEffList = magic.monsterSpellMagic(nid,pmonster);
					pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]= pmonster.moninfo[monsterInfo.MAGIC_ROUND][i]-1;

					--怪物技能特效是否需要马上触发
					if magic.GetMagicDoeffAfterSpell(nid) ==true then
						--对玩家施法
						if tTargetList == player then
							local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]			
							local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
							efffunc(player,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM],pmonster)
 		 					
							--获取怪物EFFTABLE ROUND --
							tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = tEffList[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1   
						else
							for j,v in pairs(tTargetList) do
								local effT = tEffList[j];
								local effid = magictable[nid][MAGIC_DEF_TABLE.TOTARGET_EFFECT_FUNCID_0]
								local efffunc = MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.EFF_FUNC]
								efffunc(v,MAGIC_EFFtable[effid][MAGIC_EFF_DEF_TABLE.TPARAM])
        
								--获取怪物EFFTABLE ROUND --
								effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] = effT[MAGIC_EFF_DEF_TABLE.LAST_ROUNDS] - 1
							end														
						end	
					end
				end
			end
		end		
	end
end


--获取怪物攻击力
function p.GetMonsterAtt(pmonster)
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

function p.AddAttAdjFunc(pmonster,fAttAdjFunc,id)
	pmonster.AttAdjFuncT[id] = fAttAdjFunc
end

function p.RemoveAdjFunc(pmonster,id)
    pmonster.AttAdjFuncT[id] = nil
end
	

function p.AddDamageAdjFunc(pmonster,fDamageAdjFunc,id)
	pmonster.DamageAdjFuncT[id] = fDamageAdjFunc
end

function p.RemoveDamageAdjFunc(pmonster,id)
    pmonster.DamageAdjFuncT[id] = nil
end	

--怪物死亡後會發生的行為
function p.AddDeathFunc(pmonster,fDeathFunc,id)
	pmonster.DeathActionFuncT[id] = fDeathFunc
end




--获取怪物图标路径
function p.GetMonsterIconPath(nMonsterId)
	
	return "brick/monster/monster"..nMonsterId..".png";
end

--普通死亡 变大 淡化
function p.PlayDeathAnimation(pBrick)
	brick.setUnChosed(pBrick)
	brick.removedeatheff(pBrick)
	
	
	
	local parent = pBrick:getParent()
	--放置到顶层
	parent:reorderChild(pBrick, 50)
 	
	local mainsprite = brick.GetMainSprite(pBrick)
	pBrick:setOpacity(0)

	local array = CCArray:create()
	array:addObject(CCScaleBy:create(1, 1.5))
	array:addObject(CCCallFuncN:create(function(sender)  
											sender:removeFromParentAndCleanup(true);
											end ) )
    local action = CCSequence:create(array)

	local fadeaction  = CCFadeOut:create(1)
	
	
	pBrick:runAction(action)	
	mainsprite:runAction(fadeaction)	
end

function p.PlayCriticalHitAnimation(pBrick)
	brick.setUnChosed(pBrick)
	brick.setdeatheffect(pBrick)
	
	local parent = pBrick:getParent()
	--放置到高層
	parent:reorderChild(pBrick, 50)
 	
	--获取飞行路径
	local tPosition = p.GetFlyPositionBorder(pBrick)
	local arr = CCArray:create()
	local action = CCMoveBy:create(0.5, CCPointMake(0, 50));
	arr:addObject(action)		
		
	local lastx,lasty = 0, 0
	local velocity = 800;
	
	for i,v in pairs(tPosition) do
		if i ~=1 then		
			--计算距离
			local l = (v[1]-lastx)*(v[1]-lastx) + (v[2]-lasty)*(v[2]-lasty)
			local t = math.sqrt(l) / velocity;
			
			local action = CCMoveTo:create(t, CCPointMake(v[1]+100, v[2]));
			arr:addObject(action)
		end
		lastx = v[1];
		lasty = v[2];
	end
	arr:addObject(CCCallFuncN:create(function(sender)  
											sender:removeFromParentAndCleanup(true);
											end ) )
	local  seq = CCSequence:create(arr)
	pBrick:runAction(seq)
	
	local rotatedir = 0
	
	if math.random(1,2) == 1 then
		rotatedir = 360
	else
		rotatedir = -360
	end
	
	local rotate = CCRotateBy:create(0.2, rotatedir)
    local action = CCRepeatForever:create(rotate)
	pBrick:runAction(action)
	
end


local tRusheToFansheFunc = {}
			--左边界
		  tRusheToFansheFunc[1] = function(RVec)
									local FVec = {-RVec[1],RVec[2]};
									return FVec;
								end
			--右边					
		  tRusheToFansheFunc[2] = function(RVec)
									local FVec = {-RVec[1],RVec[2]};
									return FVec;
								end
			--上边					
		  tRusheToFansheFunc[3] = function(RVec)
									local FVec = {RVec[1],-RVec[2]};
									return FVec;
								end								
			--下边					
		  tRusheToFansheFunc[4] = function(RVec)
									local FVec = {RVec[1],-RVec[2]};
									return FVec;
								end								

--获取飞行路径
function p.GetFlyPositionBorder(pBrick)
	--随机第一碰撞点
	local boardW = brickInfo.brick_num_X*brickInfo.brickWidth
	local boardH = brickInfo.brick_num_Y*brickInfo.brickHeight
	local x = 0
	local y = 0
	
	local originx,originy = pBrick:getPosition();
	
	local tPosition = {}
	local nrandomBoard = math.random(1,4)
	if nrandomBoard ==1 then
		--左边界
		x =  0
		y =  math.random(1,boardH-1)
	elseif nrandomBoard ==2 then
		--右边
		x =  boardW
		y =  math.random(1,boardH-1)		
		
	elseif nrandomBoard ==3 then
		--上
		x =  math.random(1,boardW-1)	
		y =  boardH	
		
	else
		--下
		x =  math.random(1,boardW-1)	
		y =  0		
	end
	
	table.insert(tPosition,{originx,originy,nil})
	table.insert(tPosition,{x,y,nrandomBoard})
			
	--设置反射点数
	local nCount = 3
	for i = 1,nCount do 
		local nHitBoard = tPosition[i+1][3]--撞击边界
		--得出入射向量 
		
		local tRusheVec = {tPosition[i+1][1] - tPosition[i][1],tPosition[i+1][2] - tPosition[i][2]}	
		--得出反射向量
		local tFanSheVec = tRusheToFansheFunc[nHitBoard](tRusheVec)
		
		
		local PositionOri = tPosition[i+1]
		
		--根据反射点和反射向量*系数 确定新反射点（系数大于0且最小）
		--特殊情况：垂直和水平入射
		--到达左边	
		K1 = - PositionOri[1]/tFanSheVec[1]
		--右边
		K2 = (boardW - PositionOri[1])/tFanSheVec[1]
		--上
		K3= (boardH- PositionOri[2])/tFanSheVec[2]		
		--下
		
		K4 = - PositionOri[2]/tFanSheVec[2]
		local t = {}
		local K = nil;
		table.insert(t,K1);
		table.insert(t,K2);
		table.insert(t,K3);
		table.insert(t,K4);
		
		
		for i,KTmp in pairs(t) do
			if KTmp > 0  then
				if K == nil or KTmp < K then
					K = KTmp	
					nHitBoard = i
				end
			end
		end	
		
		--得出下一个碰撞点坐标
		if i==nCount then
			K = 1.2*K
		end
		
		xNext = PositionOri[1]+ tFanSheVec[1]*K
		yNext = PositionOri[2]+ tFanSheVec[2]*K
		table.insert(tPosition,{xNext,yNext,nHitBoard})
	end	
	
	
	return tPosition;
end




function p.playDamageEff(pBrick,nDamage)
	local damageSpri =  CCSprite:create("UI/damage.png")
	local posx,posy = brick.GetPosByBrick(pBrick)
	
	nDamage = math.ceil(nDamage)
	damageSpri:setPosition(posx+math.random(-35,35), posy+math.random(-35,35));
	local arr = CCArray:create()
	local ZOrder = 100
	layerMain:addChild(damageSpri,ZOrder)

	--文字
	local Label = CCLabelTTF:create("- "..nDamage, "Arial", 65)
	Label:setPosition(110,80)
	damageSpri:addChild(Label)
	Label:setColor(ccc3(255,255,255))
	
		
	--從小到大出現
	damageSpri:setScale(0.2)
	local scaleact = CCScaleTo:create(0.15, 0.8)
	
	
	--漸漸隱藏
	local fadeoutac  = CCFadeOut:create(1) 
	--删除
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
	local actionremove = CCCallFuncN:create(delete)	
	
	arr:addObject(scaleact)
	arr:addObject(fadeoutac)	
	arr:addObject(actionremove)	
	local  seq = CCSequence:create(arr)		
	damageSpri:runAction(seq)
	
	
	local fadeoutac2  = CCFadeOut:create(1) 
	Label:runAction(fadeoutac2)
	
	--給個隨機角度
	damageSpri:setRotation(math.random(-25,25))		
end












