//
//  AuthorZoneTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/3/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AuthorZoneTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLineLabel;
@property (strong, nonatomic) IBOutlet UIButton *isFreeBtn;
@property (strong, nonatomic) IBOutlet UILabel *teacherName;
@property (strong, nonatomic) IBOutlet UILabel *specialLabel;
@property (strong, nonatomic) IBOutlet UILabel *teacherNameNoSpecial;
@end
