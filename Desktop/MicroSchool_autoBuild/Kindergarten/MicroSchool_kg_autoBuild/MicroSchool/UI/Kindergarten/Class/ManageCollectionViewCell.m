//
//  ManageCollectionViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ManageCollectionViewCell.h"

@implementation ManageCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.checkImg.userInteractionEnabled = YES;
    [self updateCheckImage];

}

- (void)setSelected:(BOOL)selected {
    
    [super setSelected:selected];
    
    [self updateCheckImage];
}

- (void)updateCheckImage {
    
    NSLog(@"self.seleted:%d",self.selected);
    self.checkImg.hidden = !self.selected;
    
}

@end
