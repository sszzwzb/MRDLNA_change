//
//  SetAdminMemberCellTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-10-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setAdminMemberDelegate

-(void)setAdmin:(NSString*)userIDIndex;

@end

@interface SetAdminMemberCellTableViewCell : UITableViewCell
{

    id<setAdminMemberDelegate> delegte;
    
}

@property (strong, nonatomic) id<setAdminMemberDelegate> delegte;
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (strong, nonatomic) IBOutlet UIImageView *ButtonTitleImgV;
@property (strong, nonatomic) IBOutlet UIButton *setAdminBtn;
@property(nonatomic,strong)NSString *index;
@end
