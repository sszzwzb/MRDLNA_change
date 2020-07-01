//
//  RecordAudio.m
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import "RecordAudio.h"
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "amrFileCodec.h"
#import "TSProgressHUD.h"

@implementation RecordAudio


/*- (void)dealloc {
    [recorder dealloc];
	recorder = nil;
	recordedTmpFile = nil;
    [avPlayer stop];
    [avPlayer release];
    avPlayer = nil;
    [super dealloc];
}*/

-(id)init {
    self = [super init];
    if (self) {
        //Instanciate an instance of the AVAudioSession object.
        //AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        audioSession = [AVAudioSession sharedInstance];
        //Setup the audioSession for playback and record. 
        //We could just use record and then switch it to playback leter, but
        //since we are going to do both lets set it up once.
        //[audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: &error];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error: nil];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AVAudioSessionInterruptionNotification:) name:AVAudioSessionInterruptionNotification object:audioSession];
        
         [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground) name:@"applicationDidEnterBackground" object:nil];
        
        UInt32 audioRouteOverride = kAudioSessionOverrideAudioRoute_Speaker;
        
    //----update 2015.11.27 kate-------------------------------------------------------
//        AudioSessionSetProperty (kAudioSessionProperty_OverrideAudioRoute,
//								 sizeof (audioRouteOverride),
//								 &audioRouteOverride);
        
        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryDefaultToSpeaker,
                                 sizeof (audioRouteOverride),
                                 &audioRouteOverride);// 耳机 扬声器切换
        //--------------------------------------------------------------------------------
        
        //Activate the session
        //[audioSession setActive:YES error: &error];
        //[audioSession setActive:YES error: nil];
        
        //[audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    
    }
    return self;
}

- (NSURL *) stopRecord {
    
    [self resetTimer];
    [self showVoiceHudOrHide:NO];

    NSURL *url =
    [[NSURL alloc]initWithString:recorder.url.absoluteString];
    [recorder stop];
   // [recorder release];
    recorder =nil;
    //return [url autorelease];
    [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    return url;
}

+(NSTimeInterval) getAudioTime:(NSData *) data {
    NSError * error;
    AVAudioPlayer*play = [[AVAudioPlayer alloc] initWithData:data error:&error];
    NSTimeInterval n = [play duration];
    //[play release];
    return n;
}

//0 播放 1 播放完成 2出错
-(void)sendStatus:(int)status {
    
    if ([self.delegate respondsToSelector:@selector(RecordStatus:)]) {
        [self.delegate RecordStatus:status];
    }
    
    if (status!=0) {
        if (avPlayer!=nil) {
            [avPlayer stop];
           // [avPlayer release];
            avPlayer = nil;
        }
    }
}

-(void) stopPlay {
    if (avPlayer!=nil) {
        [self handleNotification:NO];
        
        [avPlayer stop];
        //[avPlayer release];
        avPlayer = nil;
        [self sendStatus:1];
        //通知中断程序中断已经结束，可以恢复播放
        [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
    }
}

-(NSData *)decodeAmr:(NSData *)data{
    if (!data) {
        return data;
    }

    return DecodeAMRToWAVE(data);
}

-(void)play:(NSData*) data{
	//Setup the AVAudioPlayer to play the file that we just recorded.
    //在播放时，只停止
    if (avPlayer!=nil) {
        [self stopPlay];
        return;
    }
    NSLog(@"start decode");
    NSData* o = [self decodeAmr:data];
    NSLog(@"end decode");
    //avPlayer = [[AVAudioPlayer alloc] initWithData:o error:&error];
    avPlayer = [[AVAudioPlayer alloc]initWithData:o error:nil];//update by kate
    avPlayer.delegate = self;
    //    NSInteger aaa = [avPlayer duration];
    //    NSLog(@"%d",aaa);
    
    NSTimeInterval a = avPlayer.duration;
    
    if (a > 0) {
        
        [audioSession setActive:YES error: nil];

        [avPlayer prepareToPlay];
        [avPlayer setVolume:1.0];
        
        if(![avPlayer play]) {
            [self handleNotification:NO];

            [self sendStatus:1];
            
            [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
            
        } else {
            [self handleNotification:YES];

            [self sendStatus:0];
        }
    }else {
          //[[[TSProgressHUD sharedClient] init] doShowFailedHud:@"没有语音文件" descView:nil];
    }
    
}

-(NSInteger) dataDuration:(NSData*) data
{
    //avPlayer = [[AVAudioPlayer alloc] initWithData:data error:&error];
    avPlayer = [[AVAudioPlayer alloc] initWithData:data error:nil];
    avPlayer.delegate = self;
    
    NSInteger dur = [avPlayer duration]+1;
    
    if (dur > 60) {
        dur = 60;
    }
    
    avPlayer = nil;
    return dur;
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag {
    [self sendStatus:1];
    [self handleNotification:NO];
    [audioSession setActive:NO withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:nil];
}

- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error{
    [self sendStatus:2];
}

-(void) startRecord {
    //Begin the recording session.
    //Error handling removed.  Please add to your own code.
    
    //Setup the dictionary object with all the recording settings that this 
    //Recording sessoin will use
    //Its not clear to me which of these are required and which are the bare minimum.
    //This is a good resource: http://www.totodotnet.net/tag/avaudiorecorder/
    //		NSMutableDictionary* recordSetting = [[NSMutableDictionary alloc] init];
    //		[recordSetting setValue :[NSNumber numberWithInt:kAudioFormatAppleIMA4] forKey:AVFormatIDKey];
    //		[recordSetting setValue:[NSNumber numberWithFloat:44100.0] forKey:AVSampleRateKey]; 
    //		[recordSetting setValue:[NSNumber numberWithInt: 2] forKey:AVNumberOfChannelsKey];
    
//    NSDictionary *recordSetting =
//    [[NSDictionary alloc] initWithObjectsAndKeys:
//     
//     [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
//     
//     [NSNumber numberWithInt:kAudioFormatiLBC], AVFormatIDKey,
//     
//     [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
//     
//     [NSNumber numberWithInt:AVAudioQualityMax], AVEncoderAudioQualityKey,
//     
//     nil];
    
        NSDictionary *recordSetting = [NSDictionary dictionaryWithObjectsAndKeys:
                                       [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey, 
                                       //[NSNumber numberWithFloat:44100.0], AVSampleRateKey,
                                       [NSNumber numberWithFloat:8000.00], AVSampleRateKey,
                                       [NSNumber numberWithInt:1], AVNumberOfChannelsKey,
                                       //  [NSData dataWithBytes:&channelLayout length:sizeof(AudioChannelLayout)], AVChannelLayoutKey,
                                       [NSNumber numberWithInt:16], AVLinearPCMBitDepthKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsNonInterleaved,
                                       [NSNumber numberWithBool:NO],AVLinearPCMIsFloatKey,
                                       [NSNumber numberWithBool:NO], AVLinearPCMIsBigEndianKey,
                                       nil];
    
    //Now that we have our settings we are going to instanciate an instance of our recorder instance.
    //Generate a temp file for use by the recording.
    //This sample was one I found online and seems to be a good choice for making a tmp file that
    //will not overwrite an existing one.
    //I know this is a mess of collapsed things into 1 call.  I can break it out if need be.
    
//    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%.0f.%@", [NSDate timeIntervalSinceReferenceDate] * 1000.0, @"caf"]]];
    recordedTmpFile = [NSURL fileURLWithPath:[NSTemporaryDirectory() stringByAppendingPathComponent: [NSString stringWithFormat: @"%@.%@", @"weixiao", @"caf"]]];

    NSLog(@"Using File called: %@",recordedTmpFile);

    
    //Setup the recorder to use this file and record to it.
    //recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:&error];
    recorder = [[ AVAudioRecorder alloc] initWithURL:recordedTmpFile settings:recordSetting error:nil];
    
    NSLog(@"1");
    
    
    recorder.meteringEnabled = YES;

    //Use the recorder to start the recording.
    //Im not sure why we set the delegate to self yet.  
    //Found this in antother example, but Im fuzzy on this still.
    [recorder setDelegate:self];
    //We call this to start the recording process and initialize 
    //the subsstems so that when we actually say "record" it starts right away.
    [recorder prepareToRecord];
        NSLog(@"2");
    //Start the actual Recording
    [recorder record];
        NSLog(@"3");
    
#define WAVE_UPDATE_FREQUENCY   0.05

    [self resetTimer];

    timer_ = [NSTimer scheduledTimerWithTimeInterval:WAVE_UPDATE_FREQUENCY target:self selector:@selector(updateMeters) userInfo:nil repeats:YES];

    [self showVoiceHudOrHide:YES];

    //There is an optional method for doing the recording for a limited time see
    //[recorder recordForDuration:(NSTimeInterval) 10]
}


#pragma mark - Timer Update

- (void)updateMeters {
    if (voiceHud_)
    {
        /*  发送updateMeters消息来刷新平均和峰值功率。
         *  此计数是以对数刻度计量的，-160表示完全安静，
         *  0表示最大输入值
         */
        
        if (recorder) {
            [recorder updateMeters];
        }
        
        float peakPower = [recorder averagePowerForChannel:0];
        double ALPHA = 0.05;
        double peakPowerForChannel = pow(10, (ALPHA * peakPower));
        
        //NSLog(@"asldkfjsldkfj %f",peakPowerForChannel);
        
        [voiceHud_ setProgress:peakPowerForChannel];
    }
}

-(void) resetTimer
{
    if (timer_) {
        [timer_ invalidate];
        timer_ = nil;
    }
}

-(void) showVoiceHudOrHide:(BOOL)yesOrNo{
    
    if (voiceHud_) {
        [voiceHud_ hide];
        voiceHud_ = nil;
    }
    
    if (yesOrNo) {
        
        voiceHud_ = [[LCVoiceHud alloc] init];
        [voiceHud_ show];
        //[voiceHud_ release];
        
    }else{
        
    }
}

//不适用于开启应用之前就插上耳机 用其他方法 2015.11.27
 //---add by Kate 2015.11.16------------------------------------------------------------------------------------------
#pragma mark - 监听听筒or扬声器
- (void) handleNotification:(BOOL)state
{
    [[UIDevice currentDevice] setProximityMonitoringEnabled:state]; //建议在播放之前设置yes，播放结束设置NO，这个功能是开启红外感应
    
    if(state){
        //添加监听
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(sensorStateChange:) name:@"UIDeviceProximityStateDidChangeNotification"
                                                   object:nil];
    }
    else{
        //移除监听
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UIDeviceProximityStateDidChangeNotification" object:nil];
    }
}

//处理监听触发事件
-(void)sensorStateChange:(NSNotificationCenter *)notification
{
    //如果此时手机靠近面部放在耳朵旁，那么声音将通过听筒输出，并将屏幕变暗（省电啊）
    if ([[UIDevice currentDevice] proximityState] == YES)
    {
        NSLog(@"Device is close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    }
    else
    {
        NSLog(@"Device is not close to user");
        [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    }
}

- (void)AVAudioSessionInterruptionNotification:(NSNotification *)notificaiton {
    NSLog(@"%@", notificaiton.userInfo);
    
    AVAudioSessionInterruptionType type = [notificaiton.userInfo[AVAudioSessionInterruptionTypeKey] intValue];
    if (type == AVAudioSessionInterruptionTypeBegan) {
        
        [self stopPlay];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"audioDone"
                                                            object:nil];
    } else {
        [avPlayer play];
    }
}

-(void)applicationDidEnterBackground{
    
    [self stopPlay];
}
//------------------------------------------------------------------------------------------------------------
 

@end
