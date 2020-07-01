//
//  OnlyEditCompleteDetailTableViewCell.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditCompleteDetailTableViewCell : UITableViewCell

@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) NSString *imgUrl;
@property (nonatomic,strong) NSString *content;

-(void)reloadData;
+(CGFloat)cellHeight;

@end

NS_ASSUME_NONNULL_END
