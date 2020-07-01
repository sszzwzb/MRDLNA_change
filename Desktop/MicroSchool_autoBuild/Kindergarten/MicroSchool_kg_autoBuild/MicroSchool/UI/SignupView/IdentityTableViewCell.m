//
//  IdentityTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 16/6/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "IdentityTableViewCell.h"

@implementation IdentityTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _baseView.layer.cornerRadius = 3.0;
    _baseView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
