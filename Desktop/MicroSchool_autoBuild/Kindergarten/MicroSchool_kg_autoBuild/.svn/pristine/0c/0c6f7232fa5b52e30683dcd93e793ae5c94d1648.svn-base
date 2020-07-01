//
//  QHCamPlayer.h
//  QHCamSDK
//
//  Created by chengbao on 16/3/3.
//  Copyright © 2016年 qihoo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QHCamPlayerDef.h"


typedef void(^VideoRecordStatusCallBack)(VideoRecordState recordState,  NSString  * _Nonnull saveFilePath);

@protocol QHCamPlayerDelegate <NSObject>

- (void)onGetRelayInfoResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg;
- (void)onOpenPlayResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg;
- (void)onClosePlayResultWithEvent:(VideoPlayEvent)code msg:(nullable NSString*)msg;


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
- (BOOL)onVideoDateSeconds:(long long)mseconds;//当实时播放功能， mseconds代表从1970/1/1时的毫秒数


#pragma mark - 摄像机设置相关回调
//snap screen
- (void)onSnapScreenResult:(nullable UIImage *)image err:(VideoSnapEvent)event;


//close/open player audio
- (void)onAudioStateSwitch:(BOOL)isOn;


//video resolution change callback
- (void)onSwitchVideoResolution:(VedioResolution)nowVr withMsg:(VideoResolutionEvent)resolutionMsg;


//音视频下载速率，单位kbps
- (void)onSpeed:(int)videoSpeed withDownSpeed:(int)audioSpeed;


#pragma mark - 录像相关
- (void)onRecordTime:(long long)recordedSeconds;    //录像时间回调，秒数


@end


@interface QHCamBaseInfo : NSObject

@property(nonnull, nonatomic, copy) NSString *sn;         //摄像机的sn
@property(nonnull, nonatomic, copy) NSString *sn_token;   //用来校验sn

@end


@interface QHCamPlayer : NSObject


@property(nullable, nonatomic, weak) id<QHCamPlayerDelegate> playerDelegate;           //播放器回调
@property(nonnull, nonatomic, strong) QHCamBaseInfo *camInfo;               //当前摄像机信息
@property(nonnull, nonatomic, strong, readonly) UIView *playerHolderView;             //当前摄像机画面所依附的view


//player 当前属性
@property (nonatomic, assign, readonly) BOOL isRecording;
@property (nonatomic, assign, readonly) BOOL currentAudioSwitch;             //YES, player的声音打开  NO， player的声音关闭
@property (nonatomic, assign, readonly) BOOL isTalking;                      //正在语音，其他事件不响应(VC层操作)
@property (nonatomic, assign, readonly) VedioResolution resolutionNo;        //清晰度-高清、流畅、照片

/**
 * 初始化播放器
 *
 * @param camInfo 设置播放器需要播放的摄像头信息
 * @param parentView 播放画面的父view， 播放器画面充满parentView的整个区域, 如果parentView中间变了，变成其他view， 这时需要重新实例化播放器
 *                   但是如果只是parenView的大小变化，只需要调用relayoutPlayerView. @see relayoutPlayerView
 * 
 * @return 返回播放器实例
 */
- (nullable instancetype)initWithCamInfo:(nonnull QHCamBaseInfo *)camInfo parentView:(nonnull UIView *)parentView;


/**
 * 如果parentView的大小变化，请调用下面的函数
 */
- (void)relayoutPlayerView;


/**
 * 开始播放
 */
- (void)start;

/**
 * 开始播放，可以切换新的摄像头
 */
- (void)startWithCameraInfo:(QHCamBaseInfo *)cameraInfo;


/**
 * 停止播放
 */
- (void)stop;


/**
 * 打开／关闭本地播放器的声音
 *
 * @param on YES：打开本地播放器的声音，NO：关闭本地播放器的声音。播放器默认声音是开的
 *
 * 设置的结果将通过QHCamPlayerDelegate:onAudioStateSwitch返回 @seeQHCamPlayerDelegate:onAudioStateSwitch
 */
- (void)setAudioOn:(BOOL)on;


/**
 * 设置观看摄像机的分辨率
 *
 * @param vr 所要设置的分辨率
 */
- (void)setPlayVideoResolution:(VedioResolution)vr;


/**
 * 截屏功能
 *
 * 截屏所得数据将通过QHCamPlayerDelegate:onSnapScreenResult返回 @seeQHCamPlayerDelegate:onSnapScreenResult
 */
- (void)snapPlayerScreen;


/**
 * 开始录像， 本函数必须在调用start()函数后使用, @see - (void)start
 *
 */
- (void)startRecord:(nonnull VideoRecordStatusCallBack)callBack;


/**
 * 结束录像
 */
- (void)stopRecord;


@end
