//
//  SchoolHomeTableViewCell.h
//  MicroSchool
//
//  Created by CheungStephen on 3/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Masonry.h"
#import "UIImageView+WebCache.h"

#import "Utilities.h"

#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

@interface SchoolHomeTableViewCell : UITableViewCell

@property (nonatomic, retain) NSString *cellIndex;

@property (nonatomic, retain) TSTouchImageView *touchedBgImageView;

@property (nonatomic, retain) UIImageView *iconImageView;
@property (nonatomic, retain) UIImageView *thumbImageView;
@property (nonatomic, retain) UIImageView *upLineImageView;
@property (nonatomic, retain) UIImageView *downLineImageView;
@property (nonatomic, retain) UIButton *uploadRecipesButton;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *contentLabel;
@property (retain, nonatomic) UILabel *picsNumberLabel;

@property (retain, nonatomic) NSDictionary *recipesInfo;

@end
