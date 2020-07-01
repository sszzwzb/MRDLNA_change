//
//  ShareWechatUtility.h
//  MicroApp
//
//  Created by kaiyi on 2018/4/12.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "WXApi.h"

typedef NS_ENUM(NSInteger, MyWXScene) {
    MyWXSceneSession = 0,       //  分享用户聊天页
    MyWXSceneTimeline = 1,      //  朋友圈
    MyWXSceneFavorite = 2       //  收藏
};

typedef NS_ENUM(NSInteger, MyWXType) {
    MyWXTypeText,
    MyWXTypeOneImage,
    MyWXTypeAdsHtml,
    MyWXTypeMusic,
};

@interface ShareWechatUtility : NSObject

+(void)shareWeChatScene:(MyWXScene)MyWXScene type:(MyWXType)type
                  title:(NSString *)title  //  标题
            description:(NSString *)description   //  描述
             thumbImage:(UIImage *)thumbImage //  缩略图
              imageData:(NSData *)imageData  //  图片data
              detailUrl:(NSString *)detailUrl;  //  跳转url


@end
