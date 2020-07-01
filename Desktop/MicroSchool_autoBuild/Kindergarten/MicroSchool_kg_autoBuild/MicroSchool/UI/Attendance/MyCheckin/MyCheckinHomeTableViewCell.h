//
//  MyCheckinHomeTableViewCell.h
//  MicroSchool
//
//  Created by CheungStephen on 9/18/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCheckinHomeTableViewCell : UITableViewCell

@property (retain, nonatomic) UIImageView *checkinStatusImageView;
@property (retain, nonatomic) UIImageView *bottomLineImageView;

@property (nonatomic,strong) UIImageView *imgLogo;  //  考勤照片
@property (nonatomic,strong) UIButton *imgLogoBut;  //  考勤图片按键

@property (retain, nonatomic) UILabel *checkinTimeLabel;
@property (retain, nonatomic) UILabel *checkinContentLabel;

@end
