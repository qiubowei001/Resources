brick = {}





local brickWidth = brickInfo.brickWidth ;
local brickHeight = brickInfo.brickHeight;
local winSize = CCDirector:sharedDirector():getWinSize()
local frameWidth = 106
local frameHeight = 96
		


local tbrickTypeInfo = {}
										--SPRITE ID
	tbrickTypeInfo[tbrickType.MONSTER] 	= {1}
	tbrickTypeInfo[tbrickType.SWORD] 	=  {3}
	tbrickTypeInfo[tbrickType.BLOOD] 	=  {7}
	tbrickTypeInfo[tbrickType.GOLD] 	=  {4,5,6}
	tbrickTypeInfo[tbrickType.ENERGY] 	=  {20}
	

local Magicefftag = 4000;	
local choseefftag = 3001;
local deathefftag = 3002;
local MainSpritetag = 3003;
local animationtag = 3004;
brick.ParticleTag = 5000;


function brick.GetPosByBrick(brick)
	local X = brick.TileX
	local Y = brick.TileY
	local positionx = X*brickWidth+brickWidth/2;
	local positiony = Y*brickHeight-brickHeight/2;
	return positionx,positiony
end

function brick.setChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) ~= nil then
		return;
	end	
	
		local texturechose = CCTextureCache:sharedTextureCache():addImage("chooseeffect.png")
        local rect = CCRectMake(0, 0, brickWidth, brickHeight)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth/2, brickHeight/2);		
		pbrick:addChild(spriteeff,3,choseefftag)
		pbrick.chosed = true;
		spriteeff:setOpacity(250)
		
		
		local opacity = CCFadeTo:create(0.4, 115)
		spriteeff:runAction(opacity)
	
end



function brick.setUnChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) == nil then
		return;
	end	
	
	pbrick:removeChildByTag(choseefftag, true)
	pbrick.chosed = false;
end 


function brick.GetMainSprite(pbrick)
		local mainsprite = pbrick:getChildByTag(MainSpritetag)
		tolua.cast(mainsprite, "CCSprite")
		return mainsprite
end

function brick.playAnimation(pbrick,spriteAnimation)
		if  pbrick:getChildByTag(animationtag) ~= nil then
			return;
		end
		--[[
		--隐藏主SPRITE
		local mainsprite = pbrick:getChildByTag(MainSpritetag)
		tolua.cast(mainsprite, "CCSprite")
		mainsprite:setVisible(false)
		--]]
		
		pbrick:addChild(spriteAnimation)
		spriteAnimation:setTag(animationtag)
		spriteAnimation:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
		
		return pbrick;
end



				
function brick.setdeatheffect(pbrick)
		local id = pbrick.monsterId
		if  pbrick:getChildByTag(deathefftag) ~= nil then
			return;
		end

		--隐藏主SPRITE
		local mainsprite = pbrick:getChildByTag(MainSpritetag)
		tolua.cast(mainsprite, "CCSprite")
		mainsprite:setVisible(false)
		

		
		local spritedeath = SpriteManager.creatBrickSprite(monster.GetScarePicIdFromMonsterId(id))
		pbrick:addChild(spritedeath)
		spritedeath:setTag(deathefftag)
		spritedeath:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))

		--增加晃动效果
		local moveaction1 = CCMoveBy:create(0.02, ccp(3,0))
		local moveaction2 = moveaction1:reverse()
		
		local arr = CCArray:create()
		arr:addObject(moveaction1)
		arr:addObject(moveaction2)
		arr:addObject(moveaction2)
		arr:addObject(moveaction1)
		local actionshake = CCRepeatForever:create(CCSequence:create(arr))
	
		--local actionshake = CCRepeatForever:create( CCSequence:createWithTwoActions( moveaction1, moveaction2,moveaction2,moveaction1) )
		spritedeath:runAction(actionshake)
end

function brick.removedeatheff(pbrick)
	--显示主SPRITE
	local mainsprite = pbrick:getChildByTag(MainSpritetag)
	if  mainsprite ~= nil then
		tolua.cast(mainsprite, "CCSprite")
		mainsprite:setVisible(true)
	end
	
	
	if  pbrick:getChildByTag(deathefftag) == nil then
		return;
	end
	pbrick:removeChildByTag(deathefftag, true)
end 




function brick.setMagiceffect(pbrick,nEffPicid)
		if  nEffPicid == nil then
			return 
		end
		
		local tag = Magicefftag+nEffPicid
		if  pbrick:getChildByTag(tag) ~= nil then
			return;
		end
		
		local texturechose = CCTextureCache:sharedTextureCache():addImage("brickeffect/brickeff"..nEffPicid..".png")
        local rect = CCRectMake(0, 0, brickWidth, brickHeight)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth/2, brickHeight/2);
		pbrick:addChild(spriteeff)
		spriteeff:setTag(tag)
		--pbrick.chosed = true;	
end

function brick.removeMagiceff(pbrick,nEffPicid)
	if  nEffPicid == nil then
		return 
	end
		
	local tag = Magicefftag+nEffPicid
	if  pbrick:getChildByTag(tag) == nil then
		return;
	end
	pbrick:removeChildByTag(tag, true)
end 



function brick.init(pbrick,nType)

		pbrick.IsAbleLink = true;
		pbrick.nType = nType;
		--pbrick:setScaleX((brickWidth)/frameWidth);
		--pbrick:setScaleY((brickHeight)/frameHeight);
	
		pbrick.brickSpeed = brickInfo.brickSpeed;
		pbrick.movetoTime = winSize.height/brickInfo.brickSpeed;
		pbrick.chosed = false;		
		
		pbrick.magic_effect_aftermonact = {}
		pbrick.magic_effect_afterplayeract = {}		
end

function brick.createParentSprite()
	local spriteParent = CCSprite:create();
	local brickWidth = brickInfo.brickWidth ;
	local brickHeight = brickInfo.brickHeight;
	local rect = CCRectMake(0, 0, brickWidth, brickHeight)
	spriteParent:setTextureRect(rect)
	return spriteParent;
end

function brick.creatMonster(monsterid,nLev)
		local spriteParent = brick.createParentSprite();
		
		local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(monsterid))
		
		
		spriteParent:addChild(spriteBrick)
		spriteBrick:setTag(MainSpritetag)
		spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
   
		monster.InitMonster(spriteParent,monsterid,nLev);
		brick.init(spriteParent,tbrickType.MONSTER)
        return spriteParent;
end



function brick.creatBrick(nType)
		local spriteParent = brick.createParentSprite();
		
		local spriteBrick = SpriteManager.creatBrickSprite(tbrickTypeInfo[nType][1])
		spriteParent:addChild(spriteBrick)
		spriteBrick:setTag(MainSpritetag)
		spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
		
		brick.init(spriteParent,nType)
	    return spriteParent
end


function brick.creatGoldBrick(nType)
		local num = Goldbrick.init()
		
		local picind = 0;
		if num <=3 then
			picind = 4
		elseif num <= 7 then
			picind = 5
		else
			picind = 6
		end
		local spriteParent = brick.createParentSprite();
		
		local spriteBrick = SpriteManager.creatBrickSprite(picind)
		spriteParent:addChild(spriteBrick)
		spriteBrick:setTag(MainSpritetag)
		spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
   
		
		brick.init(spriteParent,nType)
		
		spriteParent.GOLD =  num;
		local goldlabel = CCLabelTTF:create(spriteParent.GOLD, "Arial", 35)
		spriteParent:addChild(goldlabel)
		goldlabel:setColor(ccc3(255,255,0))
		goldlabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth/3)

	
        return spriteParent
end

--bIfPlayerAct   true:玩家执行触发   false:怪物执行触发
function brick.AddMagicEff(effinfoT,pbrick)
	local magic_effect_aftermonact = pbrick.magic_effect_aftermonact
	local magic_effect_afterplayeract= pbrick.magic_effect_afterplayeract
	
	local bIfPlayerAct = effinfoT[MAGIC_EFF_DEF_TABLE.B_IF_TRIGER_AFTER_PLAYER_ACT]
	if bIfPlayerAct then
		magic_effect_afterplayeract[#magic_effect_afterplayeract+1] = effinfoT;
	else
		magic_effect_aftermonact[#magic_effect_aftermonact+1] = effinfoT;
	end
		
	--增加光效
	if effinfoT[MAGIC_EFF_DEF_TABLE.EFF_PIC] ~= "" then
		brick.setMagiceffect(pbrick,effinfoT[MAGIC_EFF_DEF_TABLE.EFF_PIC])
	end
end

--获取玩家行为触发技能特效表
function brick.GetMagicEffTableAfterPlayerAct(pbrick)
	return pbrick.magic_effect_afterplayeract 	
end

--获取怪物行为触发技能特效表
function brick.GetMagicEffTableAfterMonsterAct(pbrick)
	return pbrick.magic_effect_aftermonact 
end



