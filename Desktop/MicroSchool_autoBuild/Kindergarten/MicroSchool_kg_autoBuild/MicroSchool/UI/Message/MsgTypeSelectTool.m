//
//  MsgTypeSelectTool.m
//  ShenMaPassenger
//
//  Created by Kate on 14-2-24.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MsgTypeSelectTool.h"
#import "MsgDetailsViewController.h"
#import "ImageResourceLoader.h"
#import "PublicConstant.h"
#import "GroupChatDetailViewController.h"
#import "MsgDetailsMixViewController.h"

@implementation MsgTypeSelectTool

@synthesize buttonAlbum;
@synthesize buttonCamera;
@synthesize controller;

- (id)initWithFrame:(CGRect)rect withController:(id)_controller
{
	self = [super init];
	
	if (self) {
        //创建背景图片
        UIImageView *BGView = [[UIImageView alloc]initWithFrame:rect];
        BGView.image = [[UIImage imageNamed:@"bg_tools_Select"] stretchableImageWithLeftCapWidth:10 topCapHeight:23];
        BGView.userInteractionEnabled = YES;
        [self addSubview:BGView];
        [BGView release];
        
//		UIImage *_image_pic = [UIImage imageNamed:@"friend/btn_chat_tool_pic"];
//        UIImage *_image_camera = [UIImage imageNamed:@"friend/btn_chat_tool_camera"];
        
        UIImage *_image_pic = [UIImage imageNamed:@"btn_tp_d.png"];
        UIImage *_image_camera = [UIImage imageNamed:@"btn_pz_d.png"];
        
		self.frame = rect;
        self.controller = _controller;
		
		UIButton* button = nil;
		CGRect rect = CGRectZero;
		// 输入法换图
		CGFloat tmpWidth = 0;

		rect = CGRectMake(tmpWidth + 20, 15, 55, 55);
        button = [UIButton buttonWithType:UIButtonTypeCustom];
		self.buttonCamera = button;
		self.buttonCamera.frame = rect;
        self.buttonCamera.backgroundColor = [UIColor clearColor];
		[self.buttonCamera setImage:_image_camera forState:UIControlStateNormal];
		//[self.buttonCamera setImage:_image_camera_p forState:UIControlStateHighlighted];
		[self.buttonCamera addTarget:self action:@selector(DidButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.buttonCamera];
        
        UILabel *labCamera = [[UILabel alloc] initWithFrame:CGRectMake(tmpWidth + 20, 75, 55, 15)];
        labCamera.backgroundColor = [UIColor clearColor];
        labCamera.font = [UIFont fontWithName:@"Helvetica" size:14];
        labCamera.textAlignment = NSTextAlignmentCenter;
        labCamera.text = @"拍照";
        [self addSubview:labCamera];
        [labCamera release];
        
		tmpWidth += rect.size.width;
		rect = CGRectMake(tmpWidth + 20 + 20, 15, 55, 55);
		
		button = [UIButton buttonWithType:UIButtonTypeCustom];
		self.buttonAlbum = button;
		self.buttonAlbum.frame = rect;
        self.buttonAlbum.backgroundColor = [UIColor clearColor];
        [self.buttonAlbum setImage:_image_pic forState:UIControlStateNormal];
		//[self.buttonAlbum setImage:_image_pic_p forState:UIControlStateHighlighted];
		[self.buttonAlbum addTarget:self action:@selector(DidButtonClick:) forControlEvents:UIControlEventTouchUpInside];
		[self addSubview:self.buttonAlbum];
		
        UILabel *labAlbum = [[UILabel alloc] initWithFrame:CGRectMake(tmpWidth + 20 + 20, 75, 55, 15)];
        labAlbum.backgroundColor = [UIColor clearColor];
        labAlbum.font = [UIFont fontWithName:@"Helvetica" size:14];
        labAlbum.textAlignment = NSTextAlignmentCenter;
        labAlbum.text = @"相册";
        [self addSubview:labAlbum];
        [labAlbum release];
        
        self.backgroundColor = COMMON_BACKGROUND_COLOR;
	}
	
	return self;
}

- (void)dealloc
{
	self.buttonAlbum = nil;
	self.buttonCamera = nil;
	
	[super dealloc];
}
	
- (void)OnButtonAction:(int)index
{
    if ([self.controller isKindOfClass:[MsgDetailsViewController class]]) {
			[((MsgDetailsViewController *)self.controller) changeChatTool:index];
    }else if ([self.controller isKindOfClass:[GroupChatDetailViewController class]]){
        
        [((GroupChatDetailViewController *)self.controller) changeChatTool:index];
    }else if ([self.controller isKindOfClass:[MsgDetailsMixViewController class]]){
        
        [((MsgDetailsMixViewController *)self.controller) changeChatTool:index];
    }
}

- (void)DidButtonClick:(id)sender 
{
    int index;
    
	if (sender == self.buttonAlbum) {
		index = ChatSelectTool_Pic;
	} else {
		index = ChatSelectTool_Camera;
	}
	
	[self OnButtonAction:index];
}

@end
