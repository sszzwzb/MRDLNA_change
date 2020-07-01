//
//  FootmarkPicTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FootmarkPicCellDelegate

-(void)gotoFootmarkPicDetail:(NSInteger)index type:(NSString*)type;

@end

@interface FootmarkPicTableViewCell : UITableViewCell{

     id<FootmarkPicCellDelegate> delegte;
    
}


@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *imgNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *tagImgV;
@property (assign, nonatomic) NSInteger index;
@property (strong ,nonatomic) NSString *type;//
@property (strong, nonatomic) id<FootmarkPicCellDelegate> delegte;
@property (strong, nonatomic) IBOutlet UIButton *clickChangeColorBtn;
- (IBAction)gotoPicDetail:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIImageView *videoImgV;//小视频占位 等待小视频通用空间

@end
