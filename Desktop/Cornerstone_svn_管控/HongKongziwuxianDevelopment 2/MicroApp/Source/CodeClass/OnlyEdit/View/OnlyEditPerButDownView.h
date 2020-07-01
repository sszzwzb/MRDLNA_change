//
//  OnlyEditPerButDownView.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol OnlyEditPerButDownViewDelegate <NSObject>

-(void)selectButDownViewWithTag:(NSInteger)tag;

@end


NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditPerButDownView : UIView

@property (nonatomic,strong) id <OnlyEditPerButDownViewDelegate> delegate;
@property (nonatomic,assign) NSInteger typeInt;  //  首页0    新建1

@end

NS_ASSUME_NONNULL_END
