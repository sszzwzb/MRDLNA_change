//
//  BaseTableView.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/10.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "BaseTableView.h"

@implementation BaseTableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upTableView];
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self upTableView];
    }
    return self;
}

-(void)upTableView
{
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    if (@available(iOS 11.0, *)) {
        self.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        self.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        self.scrollIndicatorInsets = self.contentInset;
    }
    
    self.estimatedRowHeight = 0;
    self.estimatedSectionHeaderHeight = 0;
    self.estimatedSectionFooterHeight = 0;
    
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
}

@end
