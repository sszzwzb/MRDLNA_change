//
//  SwitchChildTableViewCell.h
//  MicroSchool
//
//  Created by CheungStephen on 6/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"
#import "Utilities.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface SwitchChildTableViewCell : UITableViewCell

@property (nonatomic, retain) TSTouchImageView *touchedBgImageView;

@property (retain, nonatomic) UILabel *nameLabel;
@property (retain, nonatomic) UILabel *studentIdLabel;
@property (retain, nonatomic) UILabel *studentSchoolLabel;

@property (retain, nonatomic) UILabel *addChildLabel;
@property (nonatomic, retain) UIImageView *addChildImageView;

@property (nonatomic, retain) UIImageView *genderImageView;

@property (nonatomic, retain) UIButton *unbindButton;

@property (retain, nonatomic) NSDictionary *presenceInfo;

@end
