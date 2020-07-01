//
//  MomentsSharedLink.h
//  MicroSchool
//
//  Created by jojo on 15/4/20.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "UIImageView+WebCache.h"
#import "PublicConstant.h"

@interface MomentsSharedLink : UIView

@property(nonatomic, retain) UIImageView *imgViewBG;

@property(nonatomic, retain) UIImageView *img_default;
@property(nonatomic, retain) UILabel *label_content;
@property(nonatomic, retain) UIImageView *img_snapshot;

@property(nonatomic, retain) NSString *shareUrl;
@property(nonatomic, retain) NSString *shareSnapshot;
@property(nonatomic, retain) NSString *shareContent;

@property(nonatomic, retain) NSString *cellNum;

// 是否显示点击按下的灰色效果
@property(nonatomic, assign) BOOL isShowBgImg;

@end

