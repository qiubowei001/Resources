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
	tbrickTypeInfo[tbrickType.MONSTER] = {1,"monster"}
	tbrickTypeInfo[tbrickType.SWORD] =   {2,"sword"}
	tbrickTypeInfo[tbrickType.BLOOD] =   {3,"blood"}
	tbrickTypeInfo[tbrickType.GOLD] = 	 {4,"gold"}
	
	
local choseefftag = 1;
local deathefftag = 2;
local Magicefftag = 3000;
		
function brick.setChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) ~= nil then
		return;
	end	
	
		local texturechose = CCTextureCache:sharedTextureCache():addImage("chooseeffect.png")
        local rect = CCRectMake(0, 0, 23, 22)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth, brickHeight);		
		pbrick:addChild(spriteeff)
		spriteeff:setTag(choseefftag)
		pbrick.chosed = true;
end



function brick.setUnChosed(pbrick)
	if  pbrick:getChildByTag(choseefftag) == nil then
		return;
	end	
	
	pbrick:removeChildByTag(choseefftag, true)
	pbrick.chosed = false;
end 

						
function brick.setdeatheffect(pbrick)

		if  pbrick:getChildByTag(deathefftag) ~= nil then
		
			return;
		end
		
		local texturechose = CCTextureCache:sharedTextureCache():addImage("brickeffect/death.png")
        local rect = CCRectMake(0, 0, 106, 96)
        local frame0 = CCSpriteFrame:createWithTexture(texturechose, rect)
        local spriteeff = CCSprite:createWithSpriteFrame(frame0)
		spriteeff:setPosition(brickWidth, brickHeight);		
		pbrick:addChild(spriteeff)
		spriteeff:setTag(deathefftag)
		--pbrick.chosed = true;	
end

function brick.removedeatheff(pbrick)
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
		pbrick:setScaleX((brickWidth)/frameWidth);
		pbrick:setScaleY((brickHeight)/frameHeight);
	
		pbrick.brickSpeed = brickInfo.brickSpeed;
		pbrick.movetoTime = winSize.height/brickInfo.brickSpeed;
		pbrick.chosed = false;		
		
		pbrick.magic_effect_beforeplayeract = {}
		pbrick.magic_effect_afterplayeract = {}
		
		pbrick.magic_effect_aftermonspell = {}				
		pbrick.magic_effect_aftermonatt = {}				
		
end

function brick.creatMonster(monsterid)
		local textureBrick = CCTextureCache:sharedTextureCache():addImage(monster.GetMonsterIconPath(monsterid))		
        local rect = CCRectMake(0, 0, frameWidth, frameHeight)
        local frame0 = CCSpriteFrame:createWithTexture(textureBrick, rect)
        
		local spriteBrick = CCSprite:createWithSpriteFrame(frame0)
		monster.InitMonster(spriteBrick,monsterid);
		brick.init(spriteBrick,tbrickType.MONSTER)
        return spriteBrick;
end



function brick.creatBrick(nType)
        local textureBrick = CCTextureCache:sharedTextureCache():addImage("brick/"..tbrickTypeInfo[nType][2]..".png")	
		local rect = CCRectMake(0, 0, frameWidth, frameHeight)
        local frame0 = CCSpriteFrame:createWithTexture(textureBrick, rect)
        local spriteBrick = CCSprite:createWithSpriteFrame(frame0)
		
		brick.init(spriteBrick,nType)
	    return spriteBrick
end


function brick.creatGoldBrick(nType)
		local num = Goldbrick.init()
		
		local picind = "";
		if num <=3 then
			picind = ""
		elseif num <= 7 then
			picind = "1"
		else
			picind = "2"
		end
		
		
		local textureBrick = CCTextureCache:sharedTextureCache():addImage("brick/"..tbrickTypeInfo[nType][2]..picind..".png")	
		local rect = CCRectMake(0, 0, frameWidth, frameHeight)
        local frame0 = CCSpriteFrame:createWithTexture(textureBrick, rect)
        local spriteBrick = CCSprite:createWithSpriteFrame(frame0)
		
		brick.init(spriteBrick,nType)
		
		--spriteBrick:setTexture(CCTextureCache:sharedTextureCache():addImage("brick/"..tbrickTypeInfo[nType][2]..picind..".png"))
   		spriteBrick.GOLD =  num;
		local goldlabel = CCLabelTTF:create(spriteBrick.GOLD, "Arial", 35)
		spriteBrick:addChild(goldlabel)
		goldlabel:setColor(ccc3(255,255,0))
		goldlabel:setPosition(brickInfo.brickWidth/3, brickInfo.brickWidth/3)

	
        return spriteBrick
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





