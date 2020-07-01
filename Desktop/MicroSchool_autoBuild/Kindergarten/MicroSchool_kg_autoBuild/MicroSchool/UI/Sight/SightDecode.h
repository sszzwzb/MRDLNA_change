//
//  SightDecode.h
//  VideoRecord
//
//  Created by CheungStephen on 4/6/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@class SightDecode;
@protocol SightDecodeDelegate <NSObject>

-(void)sightDecodeEachFrame:(SightDecode *)sightDecode BufferRef:(CMSampleBufferRef)bufferRef;
-(void)sightDecodeFinished:(SightDecode *)sightDecode;

-(void)sightDecodeEachFrame:(SightDecode *)sightDecode CGImageRef:(CGImageRef)imageRef;
-(void)sightDecodeFinished:(SightDecode *)sightDecode duration:(float)duration;

@end

@interface SightDecode : NSObject

@property (nonatomic, weak) id<SightDecodeDelegate> delegate;

- (void)decodeFromVideoURL:(NSURL *)videoURL;
- (void)releaseAry;

@property(nonatomic,assign) NSInteger tag;

@property(nonatomic,retain) NSMutableArray *imageRefAry;
@property(nonatomic,retain) NSString *aaa;


@property(nonatomic,retain) AVAssetReader* reader;
@property(nonatomic,retain) AVAsset *movieAsset;
@property(nonatomic,retain) AVAssetTrack* videoTrack;
@property(nonatomic,retain) AVAssetReaderTrackOutput* videoReaderOutput;

@end
