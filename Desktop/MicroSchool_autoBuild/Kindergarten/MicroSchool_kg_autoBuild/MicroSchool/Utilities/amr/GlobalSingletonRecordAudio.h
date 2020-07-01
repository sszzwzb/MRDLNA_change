//
//  RecordAudio.h
//  JuuJuu
//
//  Created by xiaoguang huang on 11-12-19.
//  Copyright (c) 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreAudio/CoreAudioTypes.h>
#import "amrFileCodec.h"

#import "LCVoiceHud.h"

@protocol GlobalSingletonRecordAudioDelegate <NSObject>
//0 播放 1 播放完成 2出错
-(void)GlobalSingletonRecordStatus:(int)status;
@end

@interface GlobalSingletonRecordAudio : NSObject <AVAudioRecorderDelegate,AVAudioPlayerDelegate>
{
    //Variables setup for access in the class:
	NSURL * recordedTmpFile;
	AVAudioRecorder * recorder;
	NSError * error;
    AVAudioPlayer * avPlayer;
    
    // hud
    LCVoiceHud * voiceHud_;
    NSTimer * timer_;

}

+(GlobalSingletonRecordAudio*)sharedGlobalSingleton;

@property (nonatomic,assign)id<GlobalSingletonRecordAudioDelegate> delegate;

- (NSURL *) stopRecord ;
- (void) startRecord;

-(void) play:(NSData*) data;
-(void) stopPlay;

-(NSInteger) dataDuration:(NSData*) data;

+(NSTimeInterval) getAudioTime:(NSData *) data;
@end
