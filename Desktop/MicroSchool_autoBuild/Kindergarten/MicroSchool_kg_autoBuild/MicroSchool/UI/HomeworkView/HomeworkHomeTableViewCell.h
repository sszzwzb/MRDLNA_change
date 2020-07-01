//
//  HomeworkHomeTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/11/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HomeworkCellDelegate

-(void)gotoHomeDetail:(NSInteger)index type:(NSString*)type;

@end

@interface HomeworkHomeTableViewCell : UITableViewCell{
    
    id<HomeworkCellDelegate> delegte;
    
}
@property (strong, nonatomic) id<HomeworkCellDelegate> delegte;
@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UILabel *homeNameLabel;
@property (strong, nonatomic)  UILabel *publishNameLabel;
@property (strong, nonatomic)  UIImageView *publishNameImgV;
@property (strong, nonatomic)  UILabel *commentNumLabel;
@property (strong, nonatomic)  UIImageView *commentNumImgV;
@property (strong, nonatomic) UILabel *label_viewnum;//浏览人数
@property (strong, nonatomic) UIImageView *imgView_viewnum;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIImageView *bottomBarImgV;
@property (strong, nonatomic) IBOutlet UIButton *clickChangeColorBtn;
@property (assign, nonatomic) NSInteger index;
@property (strong ,nonatomic) NSString *type;//leftview or rightview
- (IBAction)clickChangeColor:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *answerImgV;//右上角是否有答案图标
@property (strong, nonatomic) IBOutlet UIImageView *finishImgV;//右侧完成状态图标
@property (strong, nonatomic) IBOutlet UIView *totalTimeView;//高度40
@property (strong, nonatomic) IBOutlet UILabel *totalTimeLabel;//总时长
@property (strong, nonatomic)  UIImageView *icon_finishImgV;//对号图标
@property (strong, nonatomic)  UILabel *finishNumLabel;//作业完成人数
@end
