//
//  MySearchDisplayController.m
//  MicroSchool
//
//  Created by Kate on 16/8/2.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "MySearchDisplayController.h"

@implementation MySearchDisplayController

- (void)setActive:(BOOL)visible animated:(BOOL)animated
{
    [super setActive: visible animated: animated];
    
    [self.searchContentsController.navigationController setNavigationBarHidden: NO animated: NO];
}

@end
