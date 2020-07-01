//
//  MsgCenterTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 14/11/13.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"

@interface MsgCenterTableViewCell : UITableViewCell

@property (nonatomic, retain) UILabel *label_subject;
@property (nonatomic, retain) UILabel *label_message;
@property (nonatomic, retain) UILabel *label_dateline;
@property (nonatomic, retain) UILabel *label_result;

@property (nonatomic, retain) UIImageView *imageView_img;
@property (nonatomic, retain) UIImageView *imageView_line;

@end
