//
//  ShareWechatUtility.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/12.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "ShareWechatUtility.h"

@implementation ShareWechatUtility

+(void)shareWeChatScene:(MyWXScene)MyWXScene type:(MyWXType)type
                  title:(NSString *)title  //  标题
            description:(NSString *)description   //  描述
             thumbImage:(UIImage *)thumbImage //  缩略图
              imageData:(NSData *)imageData  //  图片data
              detailUrl:(NSString *)detailUrl  //  跳转url
{
    
    if (type == MyWXTypeText) {
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = YES;
        req.scene = MyWXScene;
        req.text = title;
        
        [WXApi sendReq:req];
    }
    
    if (type == MyWXTypeOneImage) {
        WXMediaMessage *message = [WXMediaMessage message];
        
        [message setThumbImage:thumbImage];  //  缩略图
        
        WXImageObject *imgObject = [WXImageObject object];
//        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"res2" ofType:@"jpg"];
//        imgObject.imageData = [NSData dataWithContentsOfFile:filePath];
        imgObject.imageData = imageData;
        message.mediaObject = imgObject;
        
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = MyWXScene;
        req.message = message;
        
        
        [WXApi sendReq:req];
    }
    
    if (type == MyWXTypeAdsHtml) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        
        [message setThumbImage:thumbImage];  //  缩略图
        
        WXWebpageObject *webObject = [WXWebpageObject object];
        webObject.webpageUrl = [NSString stringWithFormat:@"%@",detailUrl];
        message.mediaObject = webObject;
        
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = MyWXScene;
        req.message = message;
        
        
        [WXApi sendReq:req];
    }
    
    if (type == MyWXTypeMusic) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = title;
        message.description = description;
        
        [message setThumbImage:thumbImage];  //  缩略图
        
        WXMusicObject *musicObject = [WXMusicObject object];
        musicObject.musicUrl = [NSString stringWithFormat:@"%@",detailUrl];
        musicObject.musicLowBandUrl = musicObject.musicUrl;
        
        NSString *filePath = [[NSBundle mainBundle]pathForResource:@"di" ofType:@"aif"];
        musicObject.musicDataUrl = filePath;  //  长度不能超过10K  所以这个功能是废的
        musicObject.musicLowBandDataUrl = musicObject.musicDataUrl;
        message.mediaObject = musicObject;
        
        
        SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
        req.bText = NO;
        req.scene = MyWXScene;
        req.message = message;
        
        
        [WXApi sendReq:req];
    }
}

@end
