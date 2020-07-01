//
//  MemberTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol memberListDelegate

-(void)removeFromClass:(NSString*)userIDIndex;
-(void)gotoSingleInfo:(NSString*)userIDIndex;
@end

@interface MemberTableViewCell : UITableViewCell{
    
    id<memberListDelegate> delegte;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *userTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *classMemberTypeLab;

@property (strong, nonatomic) id<memberListDelegate> delegte;
@property (strong, nonatomic) IBOutlet UIButton *operateBtn;
@property(nonatomic,strong)NSString *index;
@end
