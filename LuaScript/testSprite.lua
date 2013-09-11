test = {}
local p = test;

function p.creatDog()
		local spriteid = 1
        local frameWidth = SpriteConfig[spriteid].Width
        local frameHeight = SpriteConfig[spriteid].Height

        -- create dog animate
        local textureDog = CCTextureCache:sharedTextureCache():addImage(SpriteConfig[spriteid].Name..".png")
        local rect = CCRectMake(0, 0, frameWidth, frameHeight)
		
		
        local frame0 = CCSpriteFrame:createWithTexture(textureDog, rect)
		
		local animFrames = CCArray:create()
		local spriteDog = CCSprite:createWithSpriteFrame(frame0)
        spriteDog.isPaused = false
		
		for y = 0, SpriteConfig[1].FrameNumY-1 do
			for x = 0,SpriteConfig[1].FrameNumX-1 do
			
				local rect = CCRectMake((frameWidth)*x,frameHeight*y ,frameWidth, frameHeight)
				local frame = CCSpriteFrame:createWithTexture(textureDog, rect)
				animFrames:addObject(frame)
			end
		end
		
		
        
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.02)
		
        local animate = CCAnimate:create(animation);
        spriteDog:runAction(CCRepeatForever:create(animate))
		spriteDog:setScale(0.8);
        --CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0, false)
		spriteDog:setPosition(200,200);
        return spriteDog
    end
