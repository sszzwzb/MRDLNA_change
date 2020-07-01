//
//  QHCamVodPlayer.h
//  QHCamSDK
//
//  Created by dongzhiqiang on 16/5/9.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QHCamPlayerDef.h"

@protocol QHCamVodPlayerDelegate <NSObject>

-(void)onOpenPlayResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg;
-(void)onClosePlayResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg;

@optional
#pragma mark - 播放状态相关回调
//buffering


- (void)onPlayerStateBuffering;

//buffering timeout
- (void)onPlayerStateBufferingTimeout;

//buffered
- (void)onPlayerStateBuffered;

//play error
- (void)onPlayerStateError;

//play over
- (void)onPlayerStatePlayEnd;

//play progress
- (void)onVideoDateSeconds:(long long)mseconds;//当实时播放功能， mseconds代表从1970/1/1时的毫秒数

@end

@interface QHCamVodPlayInfo : NSObject

@property (nonatomic, copy) NSString* playUrl;          /*<播放视频的url*/
@property (nonatomic, assign) NSUInteger seekto;        /*<播放视频的开始位置，单位毫秒*/
@property (nonatomic, copy) NSString* decryptKey;       /*<播放视频的解密key，非加密的传nil*/
@property (nonatomic, copy) NSString* eventCover;       /*<视频封面图*/
@property (nonatomic, assign) double eventDuration;     /*<视频总长度*/

@end

@interface QHCamVodPlayer : NSObject

@property (nonatomic, weak) id<QHCamVodPlayerDelegate> playerDelegate;
@property (nonnull, nonatomic, strong, readonly) UIView *playerHolderView;             //当前摄像机画面所依附的view

- (id)initWithPlayHolderView:(UIView *)holderView;

/**
 *  获取事件列表接口
 *
 *  @param playInfo 视频信息，详细见类定义说明
 */
- (void)playWithPlayInfo:(QHCamVodPlayInfo*)playInfo;
/**
 * 暂停播放
 */
- (void)pause;

/**
 * 恢复播放，从上次暂停位置开始
 */
- (void)resume;

/**
 * 停止播放
 */
- (void)stop;

@end
