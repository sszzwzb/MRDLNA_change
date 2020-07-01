//
//  CameraSetTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 2016/10/24.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CameraSetTableViewCellDelegate<NSObject>

@optional
-(void)clickCheck:(NSInteger)checked row:(NSInteger)index;
@end

@interface CameraSetTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *checkBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (nonatomic,assign)NSInteger index;
@property (nonatomic,assign)NSInteger checked;
@property (nonatomic, assign) id<CameraSetTableViewCellDelegate> delegate;
@end
