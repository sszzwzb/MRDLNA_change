//
//  KnowledgeCommentTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-3-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "MarkupParser.h"// add by kate
#import "OHAttributedLabel.h"

#import <MLLabel/MLLinkLabel.h> // 2015.09.18
#import <MLLabel/NSString+MLExpression.h>// 2015.09.18
#import <MLLabel/NSAttributedString+MLExpression.h>// 2015.09.18

@interface KnowledgeCommentTableViewCell : UITableViewCell
{
//    // 头像
//    UIImageView *imgView_head;
    
    // 姓名
    UILabel *label_name;
    
    // 时间
//    UILabel *label_time;

    // 评论内容
//    UILabel *label_comment;

    // 学校
    UILabel *label_school;
}

@property (nonatomic, retain) UIButton *btn_thumb;

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *school;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *comment;
@property (copy, nonatomic) NSString *pid;

@property (nonatomic, retain) UIImageView *imgView_head;

@property (nonatomic, retain) UIButton *button_cancelSubscribe;

@property (copy, nonatomic) NSString *subuid;

@property (nonatomic, retain) UIImageView *imgView_line1;

@property (nonatomic, retain) UILabel *label_time;

@property (nonatomic, retain) UILabel *label_comment;

@property(nonatomic,retain) MarkupParser *textParser;// add by kate
//@property (nonatomic, retain) OHAttributedLabel *label;
@property (nonatomic, strong) MLLinkLabel *label;//2015.09.18
-(void)setMLLabelText:(NSString*)attributedStr;// 2015.09.18
+ (CGSize)heightForEmojiText:(NSString*)emojiText;// 2015.09.18

@end
