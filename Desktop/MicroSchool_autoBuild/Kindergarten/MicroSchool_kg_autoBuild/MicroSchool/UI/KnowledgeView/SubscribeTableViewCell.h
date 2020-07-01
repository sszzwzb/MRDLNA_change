//
//  SubscribeTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-2-21.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface SubscribeTableViewCell : UITableViewCell
{
    // 标题
    UILabel *label_title;
    
    // 标题
    UILabel *label_content;

    // 头像
    UIImageView *imgView_head;
    
    // 姓名
    UILabel *label_name;
    
    // 时间
    UILabel *label_time;
    
    // 赞背景图
    UIImageView *imgView_top;
    
    // 赞数量
    UILabel *label_topNum;
}

@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *content;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *time;
@property (copy, nonatomic) NSString *topNum;

@property (nonatomic, retain) UIImageView *imgView_head;
@property (nonatomic, retain) UIImageView *imgView_top;

@property (nonatomic, retain) UIButton *button_collect;

@property (copy, nonatomic) NSString *tid;
@property (copy, nonatomic) NSString *subuid;

@end
