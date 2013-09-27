--�������ؼ�
ProgressBar = class("ProgressBar", function()
										return CCSprite:create();
								   end
					)
		
ProgressBar.__index = ProgressBar



local bartag = 99;
local pointertag = 98;

local barheight = 255;
local barwidth = 15;
function ProgressBar:Create()
	local progressbar = ProgressBar.new()
	--progressbar:autorelease()
	
	--����BAR
	local bar = CCSprite:create("UI/Bar/progressbar.png")
	bar:setPosition(CCPointMake(0, barheight/2))
	
	--����BARָ��
	local pointer = CCSprite:create("UI/Bar/pointer.png")
	pointer:setPosition(CCPointMake(barwidth,0))
	
	progressbar:addChild(bar,1,bartag)
	progressbar:addChild(pointer,1,pointertag)
	return progressbar;
end

--���ý���0-1
function ProgressBar:SetProgress(nProgress)
	local pointer = self:getChildByTag(pointertag)
	tolua.cast(pointer, "CCSprite")
	
	local height = (nProgress)*barheight
	pointer:setPosition(CCPointMake(barwidth,height))
end
























