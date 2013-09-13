SpriteManager = {}
local p = SpriteManager;

function p.creatBrickSprite(spriteid)
        local frameWidth = SpriteConfig[spriteid].Width
        local frameHeight = SpriteConfig[spriteid].Height

        -- create dog animate
        local textureDog = CCTextureCache:sharedTextureCache():addImage("brick/"..SpriteConfig[spriteid].Name..".png")
        local rect = CCRectMake(0, 0, frameWidth, frameHeight)
		
		
        local frame0 = CCSpriteFrame:createWithTexture(textureDog, rect)
		
		local animFrames = CCArray:create()
		local sprite = CCSprite:createWithSpriteFrame(frame0)
        sprite.isPaused = false
		
		for y = 0, SpriteConfig[spriteid].FrameNumY-1 do
			for x = 0,SpriteConfig[spriteid].FrameNumX-1 do
			
				local rect = CCRectMake((frameWidth)*x,frameHeight*y ,frameWidth, frameHeight)
				local frame = CCSpriteFrame:createWithTexture(textureDog, rect)
				animFrames:addObject(frame)
			end
		end
		

        local animation = CCAnimation:createWithSpriteFrames(animFrames, 0.02)
        local animate = CCAnimate:create(animation);
        sprite:runAction(CCRepeatForever:create(animate))
		--sprite:setScale(0.8);
		
		local brickWidth = brickInfo.brickWidth ;
		local brickHeight = brickInfo.brickHeight;
		
		sprite:setScaleX(brickWidth/frameWidth);
		sprite:setScaleY(brickHeight/frameHeight);
        return sprite
    end
