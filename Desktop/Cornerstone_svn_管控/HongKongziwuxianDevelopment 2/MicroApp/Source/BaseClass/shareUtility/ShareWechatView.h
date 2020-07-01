//
//  ShareWechatView.h
//  MicroApp
//
//  Created by kaiyi on 2018/4/12.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareWechatView : UIView

- (instancetype)initShareTitle:(NSString *)title  //  标题
                   description:(NSString *)description   //  描述
                    thumbImage:(UIImage *)thumbImage //  缩略图
                     detailUrl:(NSString *)detailUrl;

@end

@interface ShareBut : UIButton

@end
