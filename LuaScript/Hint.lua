--������ʾ
Hint = {}

local p=Hint;

p.tHintType = 
{	
	--ͼƬ·��
	noEnergy = { "UI/font/noEnergy.png"};		--û������
	LowHp = { "UI/font/LowHp.png"};				--û��Ѫ
	LowEnergy = { "UI/font/lowEnergy.png"};		--����̫��
}


local winSize = CCDirector:sharedDirector():getWinSize()

function p.ShowHint(tHintType)
	
	local path = tHintType[1]	
	local sprite = CCSprite:create(path)
	
	sprite:setPosition(CCPointMake(winSize.width *0.5 , winSize.height *0.6))
	
	local scene = Main.GetGameScene();
	scene:addChild(sprite,100)	
	
	--����Ч��
	--ɾ��
	function delete(sender)
		sender:removeFromParentAndCleanup(true);
	end
		
	local arr = CCArray:create()
	
	local scaleact = CCScaleTo:create(0.1, 1.5)
	local scaleact2 = CCScaleTo:create(0.2, 1)
	arr:addObject(scaleact)
	arr:addObject(scaleact2)

	--������ʧ
	local opacity = CCFadeOut:create(2)
	local actionremove = CCCallFuncN:create(delete)

	arr:addObject(opacity)
	arr:addObject(actionremove)
	local  seq = CCSequence:create(arr)	
	sprite:runAction(seq)
end



