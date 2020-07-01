//
//  HomeworkDetailTopCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-6.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface HomeworkDetailTopCell : UITableViewCell
{
    // 标题
    UILabel *label_subject;
    
    UILabel *label_username;
    
    UILabel *label_dateline;
    
    UILabel *label_replynum;
    
    UILabel *label_expectedtime;

    UIImageView *image_time;
    
    UIImageView *image_reply;
    
    UIWebView *webview;
    
}

@property (copy, nonatomic) NSString *subject;
@property (copy, nonatomic) NSString *username;
@property (copy, nonatomic) NSString *dateline;
@property (copy, nonatomic) NSString *replynum;
@property (copy, nonatomic) NSString *expectedtime;

@property (nonatomic, retain) UIImageView *imgView_thumb;

@end
