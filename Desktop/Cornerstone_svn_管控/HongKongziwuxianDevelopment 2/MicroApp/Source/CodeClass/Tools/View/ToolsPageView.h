//
//  ToolsPageView.h
//  MicroApp
//
//  Created by kaiyi on 2018/9/19.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ToolsPageViewDelegate <NSObject>

-(void)selectButWithTag:(NSInteger)tag title:(NSString *)title url:(NSString *)url;

@end

@interface ToolsPageView : UIView

@property (nonatomic,strong) id <ToolsPageViewDelegate> delegate;

@end
