//
//  MomentsDetailTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 14/12/29.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "OHAttributedLabel.h"
#import "NSAttributedString+Attributes.h"

#import "MarkupParser.h"

#import "Utilities.h"

#import "TSAttributedLabel.h"

@protocol MomentsCommentsCellDelegate<NSObject>//add 2015.12.14 新增代理 kate

@optional
-(void)clickComment:(NSDictionary*)dic;
-(void)clickUserName:(NSDictionary*)dic;
-(void)deleteComment:(NSDictionary*)dic;
@end

@interface MomentsDetailTableViewCell : UITableViewCell<TSAttributedLabelDelegate>

- (void)disableLongTouchAction;
- (void)disableTouchAction;

// 内容label
@property (nonatomic, retain) TSAttributedLabel *ohAttributeLabel;
@property (nonatomic, retain) MarkupParser* textParser;

@property (nonatomic, retain) UILongPressGestureRecognizer *longPressRecognizer;

// 每条下方的线
@property (nonatomic, retain) UIImageView *imgView_bottomLime;
@property (retain, nonatomic) UIColor *nameColor;//名字的颜色 add 2015.12.14
//代理
@property (nonatomic, assign) id<MomentsCommentsCellDelegate> delegate;//2015.12.14 kate
@property (nonatomic, assign) NSInteger flag;//暂时为了区分校友圈评论与其他评论,校友圈如果后续修改也有代理回调的话这个值就可以去掉不做区分 2015.12.14 kate
@end
