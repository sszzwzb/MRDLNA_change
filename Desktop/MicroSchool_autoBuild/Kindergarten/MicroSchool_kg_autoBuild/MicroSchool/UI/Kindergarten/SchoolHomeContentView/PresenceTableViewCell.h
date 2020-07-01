//
//  PresenceTableViewCell.h
//  MicroSchool
//
//  Created by CheungStephen on 3/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"
#import "Utilities.h"

#import "Masonry.h"
#import "UIImageView+WebCache.h"

@interface PresenceTableViewCell : UITableViewCell

@property (nonatomic, retain) TSTouchImageView *touchedBgImageView;
@property (nonatomic, retain) UIImageView *thumbImageView;
@property (nonatomic, retain) UIImageView *whiteImageView;

@property (retain, nonatomic) UILabel *titleLabel;
@property (retain, nonatomic) UILabel *dateLabel;

@property (retain, nonatomic) UIView *greenMarkView;

@property (retain, nonatomic) NSDictionary *presenceInfo;

@end
