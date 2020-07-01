//
//  MsgSystemView.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/5/29.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MsgSystemView.h"

@implementation MsgSystemView

- (id)init
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        //--------------------------------------------------------------------------
        msgLabel = [[UILabel alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-200.0)/2.0, 10, 200, 20.0)];
        msgLabel.textColor = [UIColor whiteColor];
        msgLabel.textAlignment = NSTextAlignmentCenter;
        msgLabel.font = [UIFont systemFontOfSize:14.0];
        msgLabel.backgroundColor = [UIColor colorWithRed:204.0/255.0 green:204.0/255.0 blue:204.0/255.0 alpha:204.0/255.0];
        msgLabel.layer.cornerRadius = 5.0;
        msgLabel.layer.masksToBounds = YES;
        msgLabel.text = @"";
        msgLabel.numberOfLines = 0;
        //-------------------------------------------------------------------------
        [self addSubview:msgLabel];
    }
    return self;
}

- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity{
    
    msgLabel.text = entity.msg_content;
    
    NSLog(@"text:%@",msgLabel.text);
    
    //To do: 根据字符串长度重置label的frame
    CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont systemFontOfSize:14.0]  withWidth:200];
    if (contentHeight > 28.0) {
        msgLabel.frame = CGRectMake(msgLabel.frame.origin.x, 0, 200.0, contentHeight);

    }
    
}

// 2016.01.19
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity{
    
    msgLabel.text = entity.msg_content;
    
    NSLog(@"text:%@",msgLabel.text);
    
    //To do: 根据字符串长度重置label的frame
    CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont systemFontOfSize:14.0]  withWidth:200];
    if (contentHeight > 28.0) {
        msgLabel.frame = CGRectMake(msgLabel.frame.origin.x, 0, 200.0, contentHeight);
        
    }
    
}

+(CGFloat)getHeightForGroup:(GroupChatDetailObject*)entity{
    
     CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont systemFontOfSize:14.0]  withWidth:200];
    return contentHeight;
}

+(CGFloat)getHeightForMix:(MixChatDetailObject*)entity{
    
    CGFloat contentHeight = [Utilities heightForText:entity.msg_content withFont:[UIFont systemFontOfSize:14.0]  withWidth:200];
    return contentHeight;
}

@end
