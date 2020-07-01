//
//  ChildTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 16/6/17.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ChildTableViewCell.h"

@implementation ChildTableViewCell

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

//管理页 解绑按钮事件
- (IBAction)unBindAction:(id)sender {
    
    
}

@end
