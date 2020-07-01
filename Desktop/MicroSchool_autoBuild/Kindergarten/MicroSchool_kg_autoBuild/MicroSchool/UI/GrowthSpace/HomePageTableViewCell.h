//
//  HomePageTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/10/8.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePageTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *scoreName;
@property (strong, nonatomic) IBOutlet UILabel *totalScore;
@property (strong, nonatomic) IBOutlet UILabel *rank;
@property (strong, nonatomic) UIImageView *isUpImgV;

@end
