//
//  CertificationTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/23.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CertificationTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *headImgV;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@end
