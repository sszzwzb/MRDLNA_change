//
//  SetAdminMemberCellTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-10-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetAdminMemberCellTableViewCell.h"

@implementation SetAdminMemberCellTableViewCell
@synthesize delegte;

- (void)awakeFromNib {
    // Initialization code
}

- (IBAction)setAdminAction:(id)sender {
    
    [delegte setAdmin:_index];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
