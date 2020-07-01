//
//  RecordSightStartButton.h
//  VideoRecord
//
//  Created by CheungStephen on 4/12/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecordSightStartButton : UIView

- (void)disappearAnimation;
- (void)appearAnimation;

@property (nonatomic,strong) CAShapeLayer *circleLayer;
@property (nonatomic,strong) UILabel *label;

@end
