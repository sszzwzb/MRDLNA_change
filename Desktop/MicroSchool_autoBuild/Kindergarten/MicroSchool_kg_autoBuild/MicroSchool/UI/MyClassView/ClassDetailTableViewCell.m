//
//  ClassDetailTableViewCell.m
//  MicroSchool
//
//  Created by Kate on 14-12-4.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ClassDetailTableViewCell.h"

@implementation ClassDetailTableViewCell
@synthesize iconImgV,titleLab,descriptionLab,detailLab,noteLabel,commentsV,commentLabel1,commentLabel2,commentLabel3,dateLabel1,dateLabel2,dateLabel3,commnetBtn1,commnetBtn2,commnetBtn3,delegate,lineV1,lineV2,row,subjectTableView,imgViewNew;

// 去公告详情页
- (IBAction)gotoDetail:(id)sender {
    
    UIButton *btn = (UIButton*)sender;
    NSString *index = [NSString stringWithFormat:@"%d",btn.tag];
    [delegate clickComment:index row:row];
}

- (void)awakeFromNib {
    // Initialization code

//    subjectTableView.frame = CGRectMake(70.0, 35.0, subjectTableView.frame.size.width, subjectTableView.frame.size.height);
//    [cell.contentView addSubview:_subjectTableView];

    
    [commnetBtn1 setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
    [commnetBtn2 setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
    [commnetBtn3 setBackgroundImage:[UIImage imageNamed:@"loading_gray.png"] forState:UIControlStateHighlighted];
    
    imgViewNew = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 0, 0)];
    [self.contentView addSubview:imgViewNew];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
