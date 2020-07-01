//
//  CameraSetTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 2016/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "CameraSetTableViewCell.h"

@implementation CameraSetTableViewCell
@synthesize checkBtn,checked,delegate,index;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    // Initialization code
    checkBtn.imageView.clipsToBounds = YES;
    checkBtn.imageView.contentMode = UIViewContentModeScaleAspectFill;
    [checkBtn setImage:[UIImage imageNamed:@"rb_gander_d_01.png"] forState:UIControlStateNormal];
    [checkBtn addTarget:self action:@selector(choose:) forControlEvents:UIControlEventTouchUpInside];
  
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)choose:(id)sender{
    
    if (checked == 1)
    {
        [checkBtn setImage:[UIImage imageNamed:@"rb_gander_d_01.png"] forState:UIControlStateNormal];
        checked = 0;
        
    }
    /*else if (checked == 2){
        
        [checkBtn setImage:[UIImage imageNamed:@"rb_gander_ee.png"] forState:UIControlStateNormal];
        self.backgroundView.backgroundColor = [UIColor colorWithRed:223.0/255.0 green:230.0/255.0 blue:250.0/255.0 alpha:1.0];
        
    }*/
    else
    {
        [checkBtn setImage:[UIImage imageNamed:@"checkImg_press.png"] forState:UIControlStateNormal];
        checked = 1;
    }
    [delegate clickCheck:checked row:index];//改变源数据
    
}

@end
