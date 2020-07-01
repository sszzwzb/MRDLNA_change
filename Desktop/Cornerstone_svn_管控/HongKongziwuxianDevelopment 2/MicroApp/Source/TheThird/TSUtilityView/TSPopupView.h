//
//  TSPopupView.h
//  MicroSchool
//
//  Created by CheungStephen on 7/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

//#import "MMPopupItem.h"
#import "TSPopupItem.h"

@interface TSPopupView : NSObject

// singleton
+ (instancetype)sharedClient;

- (void)doShowPopupView:(NSString *)title items:(NSArray *)items;
- (void)doShowPopupView:(NSString *)title items:(NSArray *)items view:(UIView *)view;

@end
