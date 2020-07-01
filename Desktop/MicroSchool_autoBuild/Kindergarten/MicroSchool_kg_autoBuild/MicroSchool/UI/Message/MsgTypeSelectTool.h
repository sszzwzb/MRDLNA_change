//
//  MsgTypeSelectTool.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <Foundation/Foundation.h>

enum {
	ChatSelectTool_Pic = 0,
    ChatSelectTool_Camera,
	ChatSelectTool_Max
};

@interface MsgTypeSelectTool : UIView
{
	
}

@property(nonatomic, assign) id controller;
@property(nonatomic, retain) UIButton* buttonAlbum;
@property(nonatomic, retain) UIButton* buttonCamera;

- (id)initWithFrame:(CGRect)rect withController:(id)_controller;

@end
