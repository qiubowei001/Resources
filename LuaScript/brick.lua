brick = {}





local brickWidth = brickInfo.brickWidth ;
local brickHeight = brickInfo.brickHeight;
local winSize = CCDirector:sharedDirector():getWinSize()
local frameWidth = 106
local frameHeight = 96
		
tbrickType = 
{
	MONSTER = 	1,
	SWORD  =	2,
	BLOOD  =	3,
	GOLD   =	4,
}

local tbrickTypeInfo = {}
										--SPRITE ID
	tbrickTypeInfo[tbrickType.MONSTER] = {1}
	tbrickTypeInfo[tbrickType.SWORD] =   {3}
	tbrickTypeInfo[tbrickType.BLOOD] =   {7}
	tbrickTypeInfo[tbrickType.GOLD] = 	 {4,5,6}
	
	
local choseefftag = 3001;
local deathefftag = 3002;
local Magicefftag = 3000;
local MainSpritetag = 3003;

function brick.setChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) ~= nil then
		return;
	end	
	
		local texturechose = CCTextureCache:sharedTextureCache():addImage("chooseeffect.png")
        local rect = CCRectMake(0, 0, 100, 100)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth/2, brickHeight/2);		
		pbrick:addChild(spriteeff,3,choseefftag)
		pbrick.chosed = true;
		spriteeff:setOpacity(250)
		
		
		--local tintblue = CCTintBy:create(1, -255, -255, 0)
		--local tintblue_back = tintblue:reverse()
		--local blue = CCRepeatForever:create( CCSequence:createWithTwoActions( tintblue, tintblue_back) )
		local opacity = CCFadeTo:create(0.4, 115)
		spriteeff:runAction(opacity)
		--spriteeff:runAction(tintblue)
end



function brick.setUnChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) == nil then
		return;
	end	
	
	pbrick:removeChildByTag(choseefftag, true)
	pbrick.chosed = false;
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
        local rect = CCRectMake(0, 0, 106, 96)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth, brickHeight);		
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
		
		pbrick.magic_effect_beforeplayeract = {}
		pbrick.magic_effect_afterplayeract = {}
		
		pbrick.magic_effect_aftermonspell = {}				
		pbrick.magic_effect_aftermonatt = {}				
		
end

function brick.createParentSprite()
	local spriteParent = CCSprite:create();
	local brickWidth = brickInfo.brickWidth ;
	local brickHeight = brickInfo.brickHeight;
	local rect = CCRectMake(0, 0, brickWidth, brickHeight)
	spriteParent:setTextureRect(rect)
	return spriteParent;
end

function brick.creatMonster(monsterid)
		local spriteParent = brick.createParentSprite();
		
		local spriteBrick = SpriteManager.creatBrickSprite(monster.GetPicIdFromMonsterId(monsterid))
		spriteParent:addChild(spriteBrick)
		spriteBrick:setTag(MainSpritetag)
		spriteBrick:setPosition(CCPointMake(brickWidth/2 , brickHeight/2))
   
		monster.InitMonster(spriteParent,monsterid);
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

function brick.AddMagicEff(effinfoT,nPhase,pbrick)
		local magic_effect_beforeplayeract = pbrick.magic_effect_beforeplayeract
		local  magic_effect_afterplayeract= pbrick.magic_effect_afterplayeract
		local magic_effect_aftermonatt= pbrick.magic_effect_aftermonatt
		local magic_effect_aftermonspell= pbrick.magic_effect_aftermonspell
		
		
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		magic_effect_beforeplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		magic_effect_afterplayeract[#magic_effect_beforeplayeract+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		magic_effect_aftermonatt[#magic_effect_aftermonatt+1] = effinfoT;
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL  then
		magic_effect_aftermonspell[#magic_effect_aftermonspell+1] = effinfoT;
	end
	
		
	--增加光效
	if effinfoT[MAGIC_EFF_DEF_TABLE.EFF_PIC] ~= "" then
		brick.setMagiceffect(pbrick,effinfoT[MAGIC_EFF_DEF_TABLE.EFF_PIC])
	end
	
end


function brick.GetMagicEffTable(nPhase,pbrick)
	if nPhase == GameLogicPhase.BEFORE_PLAYER_ACT then
		return pbrick.magic_effect_beforeplayeract
	elseif nPhase == GameLogicPhase.AFTER_PLAYER_ACT then
		return pbrick.magic_effect_afterplayeract
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_ATT then
		return pbrick.magic_effect_aftermonatt
	elseif nPhase == GameLogicPhase.AFTER_MONSTER_SPELL  then
		return pbrick.magic_effect_aftermonspell
	end
end





