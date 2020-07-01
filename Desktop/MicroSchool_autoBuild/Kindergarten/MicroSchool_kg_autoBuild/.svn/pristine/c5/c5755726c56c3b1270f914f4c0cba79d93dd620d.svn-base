//
//  NewClassPhotoTableViewCell.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/15.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewClassPhotoTableViewCellDelegate

-(void)gotoFootmarkPicDetail:(NSInteger)index type:(NSString*)type;

@end

@interface NewClassPhotoTableViewCell : UITableViewCell{
    
    id<NewClassPhotoTableViewCellDelegate> delegte;

}

@property (strong, nonatomic) IBOutlet UILabel *dayLabel;
@property (strong, nonatomic) IBOutlet UILabel *monthLabel;
@property (strong, nonatomic) IBOutlet UIImageView *imgV;
@property (strong, nonatomic) IBOutlet UILabel *imgNumLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UIView *baseView;

@property (assign, nonatomic) NSInteger index;
@property (strong ,nonatomic) NSString *type;//
@property (strong, nonatomic) id<NewClassPhotoTableViewCellDelegate> delegte;
@property (strong, nonatomic) IBOutlet UIButton *clickChangeColorBtn;
- (IBAction)gotoPicDetail:(id)sender;
@property (strong, nonatomic) IBOutlet UIImageView *videoImgV;//小视频占位 等待小视频通用空间
@end
