//
//  OutsideReimbursementListTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OutsideReimbursementListModel;

NS_ASSUME_NONNULL_BEGIN

@interface OutsideReimbursementListTableViewCell : UITableViewCell

@property (nonatomic,strong) OutsideReimbursementListModel *model;

-(void)reloadData;
+(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
