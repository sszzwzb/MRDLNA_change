//
//  ParentBindListTableViewCell.h
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ParentBindListDelegate <NSObject>

-(void)unBind:(NSString*)index;

@end

@interface ParentBindListTableViewCell : UITableViewCell{
    
    id<ParentBindListDelegate> delegte;
}
@property (strong, nonatomic) IBOutlet UIImageView *headImgView;
@property (strong, nonatomic) IBOutlet UILabel *studentNameLabel;
@property (strong, nonatomic) IBOutlet UIButton *bindBtn;
@property (strong, nonatomic) id<ParentBindListDelegate> delegte;
@property(nonatomic,strong)NSString *index;
@end
