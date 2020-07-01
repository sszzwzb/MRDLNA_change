//
//  TSImageSelectView.h
//  MicroSchool
//
//  Created by CheungStephen on 15/12/6.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TSTouchImageView.h"
#import "TSTapGestureRecognizer.h"
#import "Utilities.h"

#import "UIImageView+WebCache.h"
#import "Masonry.h"

@class TSImageSelectView;

@protocol TSImageSelectViewSelectDelegate <NSObject>

// 选择图片之后的代理回调
-(void)tsImageSelectViewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic;

// 返回高度
-(void)tsImageSelectView:(TSImageSelectView *)v height:(NSInteger)h;

@end


@interface TSImageSelectView : UIView

@property (nonatomic, assign) id<TSImageSelectViewSelectDelegate> delegate;

@property (nonatomic, retain) NSMutableArray *removeIconArr;
@property (nonatomic, retain) NSMutableArray *allImageArr;
@property (nonatomic, retain) NSMutableArray *allImageNameArr;
@property (nonatomic, retain) NSMutableArray *elementsArr;

@property (nonatomic, retain) NSString *elementsNumberInEachLine;
@property (nonatomic, retain) NSString *totalLines;

@property (nonatomic, retain) NSString *viewHeight;

- (void)initArrays;

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth;
- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth radius:(BOOL)isRadius;
- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth elementHeight:(int)eHeight gapWidth:(int)gWidth;

- (void)setRemoveIconHidden:(BOOL)isHidden;

- (void)removeAllImage;
- (void)removeImageAtIndex:(NSInteger)pos;

@end
