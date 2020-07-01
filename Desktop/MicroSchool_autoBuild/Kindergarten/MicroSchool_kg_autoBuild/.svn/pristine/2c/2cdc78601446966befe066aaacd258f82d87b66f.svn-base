//
//  GroupChatSettingMemberList.h
//  MicroSchool
//
//  Created by jojo on 15/5/27.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PublicConstant.h"
#import "Utilities.h"

#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"

#import "UIImageView+WebCache.h"

@interface GroupChatSettingMemberList : UIView

@property (nonatomic, retain) NSMutableArray *removeIconArr;
@property (nonatomic, retain) NSMutableArray *allMemberArr;
@property (nonatomic, retain) NSMutableArray *allMemberNameArr;

@property (nonatomic, assign) BOOL hiddenMomentsList;

- (void)setImgAndName:(NSArray *)arr;
- (void)setImgAndName:(NSArray *)arr showRemoveIcon:(BOOL)isShow;

- (void)setRemoveIconHidden:(BOOL)isHidden;

- (void)removeAllMember;
- (void)removeMemberAtIndex:(NSInteger)pos;

@end
