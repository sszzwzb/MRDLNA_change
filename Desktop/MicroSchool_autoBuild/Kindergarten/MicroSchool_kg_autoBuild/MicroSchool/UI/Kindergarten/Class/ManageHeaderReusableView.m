//
//  ManageHeaderReusableView.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ManageHeaderReusableView.h"

@implementation ManageHeaderReusableView

@synthesize delegate;

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)selectAction:(id)sender {
    
    [delegate clickSection:_indexPath];
    
}

@end
