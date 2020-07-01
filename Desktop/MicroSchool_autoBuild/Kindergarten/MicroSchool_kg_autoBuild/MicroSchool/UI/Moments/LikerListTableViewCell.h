//
//  LikerListTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-12-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface LikerListTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *greenDotImgV;
@property (strong, nonatomic) IBOutlet UIImageView *headImgV;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UIView *lineView;

@end
