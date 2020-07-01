//
//  SightSilentPlayer.h
//  VideoRecord
//
//  Created by CheungStephen on 4/7/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "SightDecode.h"

@interface SightSilentPlayer : UIView<SightDecodeDelegate>

- (void)prepareForPlayVideoInSilent:(NSString *)fileName;
- (void)readyForPlayVideoInSilent;
- (void)initParm;

@property(nonatomic,retain) NSURL *videoURL;
@property(nonatomic,retain) NSString *fileName;

@property(nonatomic,retain) NSMutableArray *imagesAry;

@property(nonatomic,retain) SightDecode *decode;

@property(nonatomic,retain) NSOperationQueue *queueA;
@property(nonatomic,retain) NSThread* myThread;
@property(nonatomic,retain) NSBlockOperation *operation;

@end
