//
//  MRDLNA.m
//  MRDLNA
//
//  Created by MccRee on 2018/5/4.
//

#import "MRDLNA.h"
#import "StopAction.h"

@interface MRDLNA()<CLUPnPServerDelegate, CLUPnPResponseDelegate>

@property(nonatomic,strong) CLUPnPServer *upd;              //MDS服务器
@property(nonatomic,strong) NSMutableArray *dataArray;

@property(nonatomic,strong) CLUPnPRenderer *render;         //MDR渲染器
@property(nonatomic,copy) NSString *volume;
@property(nonatomic,assign) NSInteger seekTime;
@property(nonatomic,assign) BOOL isPlaying;

@property (nonatomic,strong) dispatch_source_t timer;  //  定时器
@property (nonatomic,strong) CLUPnPAVPositionInfo *curPositionInfo;  // 当前时间

@end

@implementation MRDLNA

+ (MRDLNA *)sharedMRDLNAManager{
    static MRDLNA *instance = nil;
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.upd = [CLUPnPServer shareServer];
        self.upd.searchTime = 5;
        self.upd.delegate = self;
        self.dataArray = [NSMutableArray array];
        self.curPositionInfo = [CLUPnPAVPositionInfo new];
    }
    return self;
}

/**
 ** DLNA投屏
 */
- (void)startDLNA{
    [self initCLUPnPRendererAndDlnaPlay];
}
/**
 ** DLNA投屏
 ** 【流程: 停止 ->设置代理 ->设置Url -> 播放】
 */
- (void)startDLNAAfterStop{
    StopAction *action = [[StopAction alloc]initWithDevice:self.device Success:^{
        [self initCLUPnPRendererAndDlnaPlay];
        
    } failure:^{
        [self initCLUPnPRendererAndDlnaPlay];
    }];
    [action executeAction];
}
/**
 初始化CLUPnPRenderer
 */
-(void)initCLUPnPRendererAndDlnaPlay{
    self.render = [[CLUPnPRenderer alloc] initWithModel:self.device];
    self.render.delegate = self;
    [self.render setAVTransportURL:self.playUrl];
}
/**
 退出DLNA
 */
- (void)endDLNA{
    [self.render stop];
}

/**
 播放
 */
- (void)dlnaPlay{
    [self.render play];
}


/**
 暂停
 */
- (void)dlnaPause{
    [self.render pause];
}

/**
 搜设备
 */
- (void)startSearch{
    [self.upd start];
}


/**
 设置音量
 */
- (void)volumeChanged:(NSString *)volume{
    self.volume = volume;
    [self.render setVolumeWith:volume];
}


/**
 播放进度条
 */
- (void)seekChanged:(NSInteger)seek{
    self.seekTime = seek;
    NSString *seekStr = [self timeFormatted:seek];
    [self.render seekToTarget:seekStr Unit:unitREL_TIME];
}


/**
 播放进度单位转换成string
 */
- (NSString *)timeFormatted:(NSInteger)totalSeconds
{
    NSInteger seconds = totalSeconds % 60;
    NSInteger minutes = (totalSeconds / 60) % 60;
    NSInteger hours = totalSeconds / 3600;
    return [NSString stringWithFormat:@"%02ld:%02ld:%02ld",(long)hours, (long)minutes, (long)seconds];
}

/**
 播放切集
 */
- (void)playTheURL:(NSString *)url{
    self.playUrl = url;
    [self.render setAVTransportURL:url];
}

#pragma mark -- 搜索协议CLUPnPDeviceDelegate回调
- (void)upnpSearchChangeWithResults:(NSArray<CLUPnPDevice *> *)devices{
    NSMutableArray *deviceMarr = [NSMutableArray array];
    for (CLUPnPDevice *device in devices) {
        // 只返回匹配到视频播放的设备
        if ([device.uuid containsString:serviceType_AVTransport]) {
            [deviceMarr addObject:device];
        }
    }
    if ([self.delegate respondsToSelector:@selector(searchDLNAResult:)]) {
        [self.delegate searchDLNAResult:[deviceMarr copy]];
    }
    self.dataArray = deviceMarr;
}

- (void)upnpSearchtheEndSearch {
    if ([self.delegate respondsToSelector:@selector(theEndSearch)]) {
        [self.delegate theEndSearch];
    }
}

- (void)upnpGetPositionInfoResponse:(CLUPnPAVPositionInfo *)info{
//    NSLog(@"%f, === %f === %f", info.trackDuration, info.absTime, info.relTime);
    _curPositionInfo = info;
    if ([self.delegate respondsToSelector:@selector(upnpGetPositionInfoResponseTrackDuration:absTime:relTime:)]) {
        [self.delegate upnpGetPositionInfoResponseTrackDuration:info.trackDuration absTime:info.absTime relTime:info.relTime];
    }
}

- (void)upnpSearchErrorWithError:(NSError *)error{
//    NSLog(@"DLNA_Error======>%@", error);
}

#pragma mark - CLUPnPResponseDelegate
- (void)upnpSetAVTransportURIResponse{
    [self.render play];
}

- (void)upnpPlayResponse{
//    NSLog(@"播放");
    if ([self.delegate respondsToSelector:@selector(dlnaStartPlay)]) {
        [self.delegate dlnaStartPlay];
    }
    [self beginTimeForPositionTime];
}

- (void)upnpPauseResponse{
    NSLog(@"暂停");
}

- (void)upnpStopResponse{
    NSLog(@"停止");
    if ([self.delegate respondsToSelector:@selector(dlnaEndPlayGetPositionInfoResponseTrackDuration:absTime:relTime:)]) {
        [self.delegate dlnaEndPlayGetPositionInfoResponseTrackDuration:_curPositionInfo.trackDuration absTime:_curPositionInfo.absTime relTime:_curPositionInfo.relTime];
    }
    [self endTimeForPositionTime];
}

- (void)upnpSeekResponse{
    NSLog(@"跳转完成");
}

- (void)upnpSetVolumeResponse{
//    NSLog(@"设置音量成功");
}

- (void)upnpSetNextAVTransportURIResponse{
//    NSLog(@"设置下一个url成功");
}

- (void)upnpGetVolumeResponse:(NSString *)volume{
//    NSLog(@"音量=%@", volume);
}

- (void)upnpGetTransportInfoResponse:(CLUPnPTransportInfo *)info{
//    NSLog(@"%@ === %@", info.currentTransportState, info.currentTransportStatus);
    if (!([info.currentTransportState isEqualToString:@"PLAYING"] || [info.currentTransportState isEqualToString:@"TRANSITIONING"])) {
        [self.render play];
    }
}

- (void)upnpUndefinedResponse:(NSString *)resXML postXML:(NSString *)postXML{
//    NSLog(@"postXML = %@", postXML);
//    NSLog(@"resXML = %@", resXML);
}

#pragma mark Set&Get
- (void)setSearchTime:(NSInteger)searchTime{
    _searchTime = searchTime;
    self.upd.searchTime = searchTime;
}

#pragma mark - 计时器
-(void)beginTimeForPositionTime
{
    if (_timer == nil) {
        //设置时间间隔 1秒
        uint64_t interval = NSEC_PER_SEC;
        //开启一个专门执行timer的GCD回调队列
        dispatch_queue_t queue = dispatch_queue_create("myqueue", 0);
        //创建timer
        _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
        //配置timer 最后一个参数表示精准度， 0为最精准
        dispatch_source_set_timer(_timer, dispatch_time(DISPATCH_TIME_NOW, 0), interval, 0);
        //设置回调
        dispatch_source_set_event_handler(_timer, ^{
            NSLog(@"计时开始");
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //回调当前投影时间
                [self.render getPositionInfo];
            });
        });
        
        dispatch_resume(_timer);
    }
}

-(void)endTimeForPositionTime
{
    if (_timer) {
        /**  释放  **/
        dispatch_cancel(_timer);
        _timer = nil;
    }
}

@end
