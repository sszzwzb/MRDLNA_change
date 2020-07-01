//
//  FullImageViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 15/6/15.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "FullImageCell.h"

@protocol FullImageViewControllerDelegate<NSObject>//2016.02.02

@optional
-(void)getDeleteIndex:(NSString*)currentIndex;
@end

@interface FullImageViewController : BaseViewController<UIActionSheetDelegate,UIGestureRecognizerDelegate,UICollectionViewDelegate,UICollectionViewDataSource>{
    
    CGFloat maxHeight;
    CGFloat maxWidth;
    id<FullImageViewControllerDelegate> delegate;

}

@property (strong, nonatomic) NSMutableArray *assetsArray;//显示大图的数组 可以放string image ALAsset
@property (assign, nonatomic) NSInteger currentIndex;//当前查看的是第几张图片 从0开始
@property (assign,nonatomic)  BOOL isShowNavigationBar;

@property (strong, nonatomic) NSMutableArray *imageArray;

// health 从身体记录进入
@property (strong, nonatomic) NSString *viewType;

@property (strong, nonatomic) NSString *isFromIphone4s;
//代理
@property (nonatomic, assign) id<FullImageViewControllerDelegate> delegate;//2016.02.02
@property (nonatomic, assign) NSInteger isShowBottomBar;//是否显示底部黑条
@property (nonatomic, assign) NSInteger delOrSave;//右上角显示保存传1 显示删除可不传
@property (nonatomic,assign) NSString *bottomStr;//底部黑条上需要显示的内容
@property (nonatomic,assign) NSString *titleName;//导航栏的title 例如：早餐
@end
