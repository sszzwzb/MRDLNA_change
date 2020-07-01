//
//  SubscribeViewNewsListTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/23.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SubscribeViewNewsListTableViewCell : UITableViewCell
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIImageView *detailImgV;
@property (strong, nonatomic) UIImageView *viewNumImgV;
@property (strong, nonatomic) IBOutlet UILabel *viewNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLineLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;

@end
