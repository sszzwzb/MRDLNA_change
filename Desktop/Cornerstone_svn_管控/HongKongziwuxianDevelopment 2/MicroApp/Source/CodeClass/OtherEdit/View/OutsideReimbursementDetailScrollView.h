//
//  OutsideReimbursementDetailScrollView.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/16.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OutsideReimbursementListModel;



@protocol OutsideReimbursementDetailScrollViewDelegate <NSObject>

-(void)selectButtonForImg:(UIImage *)image;

@end


NS_ASSUME_NONNULL_BEGIN

@interface OutsideReimbursementDetailScrollView : UIScrollView

@property (nonatomic,strong) id <OutsideReimbursementDetailScrollViewDelegate> myDelegate;

@property (nonatomic,strong) OutsideReimbursementListModel *model;

@end

NS_ASSUME_NONNULL_END
