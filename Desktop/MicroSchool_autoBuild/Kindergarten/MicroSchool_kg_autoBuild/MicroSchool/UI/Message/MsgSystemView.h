//
//  MsgSystemView.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/29.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "GroupChatDetailObject.h"
#import "MixChatDetailObject.h"

@interface MsgSystemView : UIView{
    
    UILabel *msgLabel;
}

- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity;// add 2015.05.29
+(CGFloat)getHeightForGroup:(GroupChatDetailObject*)entity;

- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity;// add 2016.01.09
+(CGFloat)getHeightForMix:(MixChatDetailObject*)entity;
@end
