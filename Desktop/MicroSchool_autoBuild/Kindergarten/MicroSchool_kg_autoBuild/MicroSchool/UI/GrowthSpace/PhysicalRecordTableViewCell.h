//
//  PhysicalRecordTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/26.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhysicalRecordTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftEyeLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightEyeLabel;
@property (strong, nonatomic) IBOutlet UILabel *noDataLabel;
@property (strong, nonatomic) IBOutlet UILabel *heightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *weightTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *visionTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *leftEyeTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *rightEyeTitleLabel;

@end
