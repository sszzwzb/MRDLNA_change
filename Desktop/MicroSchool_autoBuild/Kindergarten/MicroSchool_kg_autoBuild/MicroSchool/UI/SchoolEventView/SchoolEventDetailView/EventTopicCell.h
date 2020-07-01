//
//  EventTopicCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 14-1-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"

@interface EventTopicCell : UITableViewCell
{
    // 名字
    UILabel *label_name;
    // 个性签名
    UILabel *label_note;
    
}

@property (nonatomic, retain) UIImageView *imgView_thumb;
@property (nonatomic, retain) UIImageView *imgView_gender;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *note;

@end
