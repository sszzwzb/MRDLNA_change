//
//  ClassListTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-9-17.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ClassListTableViewCellDelegate<NSObject>//2016.02.02

@optional
-(void)addClass:(NSInteger)currentIndex;
@end

@interface ClassListTableViewCell : UITableViewCell{
    
    id<ClassListTableViewCellDelegate> delegate;
}



@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *introductionLabel;
@property (strong, nonatomic) IBOutlet UILabel *isAddedLabel;
@property (strong, nonatomic) IBOutlet UIButton *addClassBtn;
@property (strong, nonatomic) id<ClassListTableViewCellDelegate> delegate;
@property (assign, nonatomic) NSInteger currentIndex;

- (IBAction)addClassAction:(id)sender;

@end
