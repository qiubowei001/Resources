test = {}
local p = test;

function p.creatDog()
        local frameWidth = 87
        local frameHeight = 87

        -- create dog animate
        local textureDog = CCTextureCache:sharedTextureCache():addImage("1.png")
        local rect = CCRectMake(0, 0, frameWidth, frameHeight)
		
		
        local frame0 = CCSpriteFrame:createWithTexture(textureDog, rect)
		
		local animFrames = CCArray:create()
		local spriteDog = CCSprite:createWithSpriteFrame(frame0)
        spriteDog.isPaused = false
		
		for y = 0, 3 do
			for x = 0,4 do
			
				local rect = CCRectMake((frameWidth)*x,frameHeight*y ,frameWidth, frameHeight)
				local frame = CCSpriteFrame:createWithTexture(textureDog, rect)
				animFrames:addObject(frame)
			end
		end
		
		
        
        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.1)
		
        local animate = CCAnimate:create(animation);
        spriteDog:runAction(CCRepeatForever:create(animate))
		--spriteDog:setScale(0.1);
        --CCDirector:sharedDirector():getScheduler():scheduleScriptFunc(tick, 0, false)
		spriteDog:setPosition(200,300);
        return spriteDog
    end
