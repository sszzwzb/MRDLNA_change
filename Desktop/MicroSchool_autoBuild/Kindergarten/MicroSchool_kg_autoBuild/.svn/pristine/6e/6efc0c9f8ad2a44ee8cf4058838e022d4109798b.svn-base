//
//  FootmarkLinkOrTxtTableViewCell.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "FootmarkLinkOrTxtTableViewCell.h"

@implementation FootmarkLinkOrTxtTableViewCell
@synthesize dayLabel,monthLabel,imgV,linkTitleLabel,txtTitleLabel,linkDescribeLabel,baseView,clickChangeColorBtn,index,type,delegte;



- (void)awakeFromNib {
    // Initialization code
    
    baseView.layer.masksToBounds = YES;
    baseView.layer.cornerRadius = 5.0;
    
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"seletStyle.png"] forState:UIControlStateHighlighted];
    [clickChangeColorBtn setBackgroundImage:[UIImage imageNamed:@"dateBg.png"] forState:UIControlStateNormal];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)gotoDetail:(id)sender {
    
    [delegte gotoFootmarkDetail:index type:type];
}

@end
