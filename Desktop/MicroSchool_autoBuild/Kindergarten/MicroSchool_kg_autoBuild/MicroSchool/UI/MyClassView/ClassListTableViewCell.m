//
//  ClassListTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-9-17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassListTableViewCell.h"

@implementation ClassListTableViewCell
@synthesize headImgView,titleLabel,introductionLabel,isAddedLabel,delegate;

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addClassAction:(id)sender {
    
    [delegate addClass:_currentIndex];
}
@end
