//
//  JKPopMenuView.h
//  
//
//  Created by Bingjie on 14/12/15.
//  Copyright (c) 2015年 Bingjie. All rights reserved.
//

#import "JKPopMenuItem.h"
#import "BaseViewController.h"

typedef void (^JKPopMenuViewSelectBlock)(NSInteger index);

@protocol JKPopMenuViewSelectDelegate <NSObject>
-(void)popMenuViewSelectIndex:(NSInteger)index;
@end

@interface JKPopMenuView : UIView <TSImageSelectViewSelectDelegate>

@property (nonatomic, copy) NSArray *menuItems;

@property (nonatomic, copy) JKPopMenuViewSelectBlock selectBlock;
@property (nonatomic, assign) id<JKPopMenuViewSelectDelegate> delegate;

@property (retain, nonatomic) TSImageSelectView *imageSelectView;

+ (instancetype)menuView;
+ (instancetype)menuViewWithItems:(NSArray*)items;
- (void)show;
- (void)show2;//2016.01.06 add by kate
@end

@interface UIView (Additions)
- (CABasicAnimation *)fadeIn;
- (CABasicAnimation *)fadeOut;

@end
