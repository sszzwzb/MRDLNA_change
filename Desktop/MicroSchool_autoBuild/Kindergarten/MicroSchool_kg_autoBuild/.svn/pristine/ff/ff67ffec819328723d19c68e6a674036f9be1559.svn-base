//
//  MsgTextView.h
//  ShenMaPassenger
//
//  Created by kakashi on 14-2-24.
//  Copyright (c) 2014年 enraynet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatDetailObject.h"
#import "OHAttributedLabel.h"
#import "MarkupParser.h"
#import "GroupChatDetailObject.h"// add 2015.05.29
#import "MixChatDetailObject.h"//add 2016.01.19
#import "MLEmojiLabel.h"//add 2015.08.01
#import <MLLabel/MLLinkLabel.h>//add 2015.08.03
#import <MLLabel/NSString+MLExpression.h>
#import <MLLabel/NSAttributedString+MLExpression.h>

@class OHAttributedLabel;

@interface MsgTextView : UIView<OHAttributedLabelDelegate,UIGestureRecognizerDelegate>
{
    //背景pop
    UIImageView *bgView;
    //UILabel *label;
    UIImage *bgViewRcv;
    UIImage *bgViewSend;
    
    OHAttributedLabel *currentLabel;
    MarkupParser* textParser;
    
    CGPoint pt;
    NSTextCheckingResult* activeLink;
    CGPoint touchStartPoint;
    
    MLLink *link;

}

@property(nonatomic, retain) UIImageView *bgView;
@property(nonatomic, retain) UIImage *bgViewRcv;
@property(nonatomic, retain) UIImage *bgViewSend;
@property (nonatomic, retain) NSDictionary *emojiDic;//add by kate
@property(nonatomic,retain) OHAttributedLabel *currentLabel;//add by kate
@property (nonatomic, strong) MLEmojiLabel *emojiLabel;//add 2015.08.01
@property (nonatomic, strong) MLLinkLabel *label;//add 2015.08.03
@property (nonatomic,retain) ChatDetailObject *entity;//add by kate 2015.01.22
@property (nonatomic,retain) GroupChatDetailObject *entityForGroup;//add by kate 2015.06.01
@property (nonatomic, retain) MixChatDetailObject *entityForMix;// add 2016.01.19
@property (nonatomic,retain) NSString *fromName;

- (void)updateWithChatDetailObject:(ChatDetailObject *)entity;
- (void)updateWithChatDetailObjectForGroup:(GroupChatDetailObject *)entity;// add 2015.05.29
- (void)updateWithChatDetailObjectForMix:(MixChatDetailObject *)entity;// add 2016.01.19

- (float)getTextHeight:(ChatDetailObject *)entity;
- (float)getTextHeightForGroup:(GroupChatDetailObject *)entity;// add by kate 2015.05.30
- (float)getTextHeightForMix:(MixChatDetailObject *)entity;


+ (CGSize)heightForEmojiText:(NSString*)emojiText;
@end
