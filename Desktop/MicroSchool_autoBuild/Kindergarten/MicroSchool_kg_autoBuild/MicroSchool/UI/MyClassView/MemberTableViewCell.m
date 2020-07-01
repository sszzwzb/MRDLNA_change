//
//  MemberTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MemberTableViewCell.h"

@implementation MemberTableViewCell
@synthesize delegte;

- (IBAction)removeAction:(id)sender {
    
    [delegte removeFromClass:_index];
}

- (IBAction)gotoSingleInfo:(id)sender {
    
    [delegte gotoSingleInfo:_index];
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
