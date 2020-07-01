//
//  HomeworkReadHistory.h
//  MicroSchool
//
//  Created by CheungStephen on 3/5/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Utilities.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

@interface HomeworkReadHistory : UIView

@property (nonatomic, retain) NSMutableArray *elementsArr;

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth radius:(BOOL)isRadius number:(NSString *)num;

@end
