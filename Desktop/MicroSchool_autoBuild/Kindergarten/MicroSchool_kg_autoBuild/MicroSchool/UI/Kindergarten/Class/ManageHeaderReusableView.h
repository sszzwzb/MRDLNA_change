//
//  ManageHeaderReusableView.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/11.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ManageHeaderDelegate <NSObject>

@optional

-(void)clickSection:(NSIndexPath*)indexPath;

@end

@interface ManageHeaderReusableView : UICollectionReusableView{
    
    id<ManageHeaderDelegate> delegate;
}

@property (strong, nonatomic) IBOutlet UIButton *checkForHeaderBtn;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) NSIndexPath *indexPath;
@property (strong, nonatomic) id<ManageHeaderDelegate> delegate;
@end
