//
//  SightDecode.m
//  VideoRecord
//
//  Created by CheungStephen on 4/6/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "SightDecode.h"

@implementation SightDecode

- (void)decodeFromVideoURL:(NSURL *)videoURL {
    
    
    
    
    
    
    
    
    
#if 0
    _imageRefAry = [[NSMutableArray alloc] init];
    
#if 9
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    //    [movieAsset ];
    
    NSError *error;
    
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:movieAsset error:&error];
    
    if (nil != reader) {
        NSArray* videoTracks = [movieAsset tracksWithMediaType:AVMediaTypeVideo];
        AVAssetTrack* videoTrack = [videoTracks objectAtIndex:0];
        // 视频播放时，m_pixelFormatType=kCVPixelFormatType_32BGRA
        // 其他用途，如视频压缩，m_pixelFormatType=kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
        
        int m_pixelFormatType;
        m_pixelFormatType = kCVPixelFormatType_32BGRA;
        
        NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                    (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
        AVAssetReaderTrackOutput* videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                                       initWithTrack:videoTrack outputSettings:options];
        [reader addOutput:videoReaderOutput];
        [reader startReading];
        
        
        
        
        AVAssetReaderStatus a = [reader status];
        
        NSError *aaaa = reader.error;
        int bbbb = aaaa.code;
        
        int b= videoTrack.nominalFrameRate;
        NSLog(@"---------start---------- %ld", (long)a);
        
#if 9
        //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
        while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
            // 读取video sample
            CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
            
            
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(sightDecodeEachFrame:BufferRef:)]) {
                [self.delegate sightDecodeEachFrame:self BufferRef:videoBuffer];
            }
            
            //            CGImageRef image = [self imageFromSampleBufferRef:videoBuffer];
            //            if (nil != image) {
            //                [_imageRefAry addObject:(__bridge id _Nonnull)(image)];
            //            }
            
            //            if (image)
            //            {
            //                //                [writerInput appendSampleBuffer: nextBuffer];
            //                //                convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
            //                //NSLog (@"writing");
            //                CGImageRelease(image);
            //            }
            
            
            if (videoBuffer)
            {
                //                [writerInput appendSampleBuffer: nextBuffer];
                //                convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                //NSLog (@"writing");
                CFRelease(videoBuffer);
            }
            
            
            //            [self.delegate sightDecodeEachFrame:self BufferRef:videoBuffer];
            
            //            if (videoBuffer) {
            //
            //                //The caller does not own the returned dataBuffer, and must retain it explicitly if the caller needs to maintain a reference to it.
            //                CFRetain(videoBuffer);//reference +1
            //                CFRelease(videoBuffer);
            //            }
            
            //         CFRelease(videoBuffer);
            
            
            
            
            // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的
            [NSThread sleepForTimeInterval:0.001];
        }
        
        NSLog(@"---------end----------");
        
        [self.delegate sightDecodeFinished:self];
        
    }
    
    [reader cancelReading];
    
    //    });
#else
    // 读取视频每一个buffer转换成CGImageRef
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        CMSampleBufferRef audioSampleBuffer = NULL;
        while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
            CMSampleBufferRef sampleBuffer = [videoReaderOutput copyNextSampleBuffer];
            CGImageRef image = [self imageFromSampleBuffer:sampleBuffer];
            if (self.delegate && [self.delegate respondsToSelector:@selector(sightDecodeEachFrame:CGImageRef:)]) {
                [self.delegate sightDecodeEachFrame:self CGImageRef:image];
            }
            if(sampleBuffer) {
                if(audioSampleBuffer) { // release old buffer.
                    CFRelease(audioSampleBuffer);
                    audioSampleBuffer = nil;
                }
                audioSampleBuffer = sampleBuffer;
            } else {
                break;
            }
            
            // 休眠的间隙刚好是每一帧的间隔
            [NSThread sleepForTimeInterval:CMTimeGetSeconds(videoTrack.minFrameDuration)];
        }
        // decode finish
        float durationInSeconds = CMTimeGetSeconds(movieAsset.duration);
        if (self.delegate && [self.delegate respondsToSelector:@selector(sightDecodeFinished:duration:)]) {
            [self.delegate sightDecodeFinished:self duration:durationInSeconds];
        }
    });
#endif
    
    
    
    
#else
    
    
    
    AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
    
    NSError *error;
    AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:movieAsset error:&error];
    
    NSArray *videoTracks = [movieAsset tracksWithMediaType:AVMediaTypeVideo];
    AVAssetTrack *videoTrack =[videoTracks objectAtIndex:0];
    
    int m_pixelFormatType;
    m_pixelFormatType = kCVPixelFormatType_32BGRA;
    // 其他用途，如视频压缩
    //    m_pixelFormatType = kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange;
    
    //    NSMutableDictionary *options = [NSMutableDictionary dictionary];
    //    [options setObject:@(m_pixelFormatType) forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    
    AVAssetReaderTrackOutput *videoReaderOutput = [[AVAssetReaderTrackOutput alloc] initWithTrack:videoTrack outputSettings:options];
    
    [reader addOutput:videoReaderOutput];
    [reader startReading];
    
    // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
    while ([reader status] == AVAssetReaderStatusReading && videoTrack.nominalFrameRate > 0) {
        // 读取 video sample
        CMSampleBufferRef videoBuffer = [videoReaderOutput copyNextSampleBuffer];
        [self.delegate sightDecodeEachFrame:self BufferRef:videoBuffer];
        
        //        CFRelease(videoBuffer);
        
        //        CGImageRef cgimage = (CGImageRef )[self imageFromSampleBufferRef:videoBuffer];
        //        if (!(__bridge id)(cgimage)) { return; }
        //        [_imagesAry addObject:((__bridge id)(cgimage))];
        //        CGImageRelease(cgimage);
        //
        
        //        [self.delegate mMoveDecoder:self onNewVideoFrameReady:videoBuffer];
        
        // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的,这里的 sampleInternal 我设置为0.001秒
        [NSThread sleepForTimeInterval:0.001];
    }
    //    
    // 告诉上层视频解码结束
    [self.delegate sightDecodeFinished:self];
#endif
    
    
    
    
#else
    
    
    
    
    @synchronized(self)
    {
        //关键代码;
        if (nil != _movieAsset) {
            [_movieAsset cancelLoading];
            
        }
        
        if (nil != _reader) {
            [_reader cancelReading];
            
        }
        
        _movieAsset = nil;
        _reader = nil;
        _videoReaderOutput = nil;
        _videoTrack = nil;
        
        
        
        
        _imageRefAry = [[NSMutableArray alloc] init];
        
        _movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        
        //    [movieAsset ];
        
        NSError *error;
        
        _reader = [[AVAssetReader alloc] initWithAsset:_movieAsset error:&error];
        
        if ((nil != _reader) && (nil != _movieAsset)) {
            NSArray* videoTracks = [_movieAsset tracksWithMediaType:AVMediaTypeVideo];
            _videoTrack = [videoTracks objectAtIndex:0];
            // 视频播放时，m_pixelFormatType=kCVPixelFormatType_32BGRA
            // 其他用途，如视频压缩，m_pixelFormatType=kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange
            
            int m_pixelFormatType;
            m_pixelFormatType = kCVPixelFormatType_32BGRA;
            
            NSDictionary* options = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:
                                                                        (int)m_pixelFormatType] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
            _videoReaderOutput = [[AVAssetReaderTrackOutput alloc]
                                  initWithTrack:_videoTrack outputSettings:options];
            if (nil != _videoReaderOutput) {
                [_reader addOutput:_videoReaderOutput];
                [_reader startReading];
                
                
                
                
                AVAssetReaderStatus a = [_reader status];
                
                NSError *aaaa = _reader.error;
                int bbbb = aaaa.code;
                
                int b= _videoTrack.nominalFrameRate;
                NSLog(@"---------start---------- %ld", (long)a);
                
                //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                // 要确保nominalFrameRate>0，之前出现过android拍的0帧视频
                while ([_reader status] == AVAssetReaderStatusReading && _videoTrack.nominalFrameRate > 0) {
                    // 读取video sample
                    CMSampleBufferRef videoBuffer = [_videoReaderOutput copyNextSampleBuffer];
                    
                    
                    
                    if (self.delegate && [self.delegate respondsToSelector:@selector(sightDecodeEachFrame:BufferRef:)]) {
                        [self.delegate sightDecodeEachFrame:self BufferRef:videoBuffer];
                    }
                    
                    //            CGImageRef image = [self imageFromSampleBufferRef:videoBuffer];
                    //            if (nil != image) {
                    //                [_imageRefAry addObject:(__bridge id _Nonnull)(image)];
                    //            }
                    
                    //            if (image)
                    //            {
                    //                //                [writerInput appendSampleBuffer: nextBuffer];
                    //                //                convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                    //                //NSLog (@"writing");
                    //                CGImageRelease(image);
                    //            }
                    
                    
                    if (videoBuffer)
                    {
                        //                [writerInput appendSampleBuffer: nextBuffer];
                        //                convertedByteCount += CMSampleBufferGetTotalSampleSize (nextBuffer);
                        //NSLog (@"writing");
                        CFRelease(videoBuffer);
                    }
                    
                    
                    //            [self.delegate sightDecodeEachFrame:self BufferRef:videoBuffer];
                    
                    //            if (videoBuffer) {
                    //
                    //                //The caller does not own the returned dataBuffer, and must retain it explicitly if the caller needs to maintain a reference to it.
                    //                CFRetain(videoBuffer);//reference +1
                    //                CFRelease(videoBuffer);
                    //            }
                    
                    //         CFRelease(videoBuffer);
                    
                    
                    
                    
                    // 根据需要休眠一段时间；比如上层播放视频时每帧之间是有间隔的
                    [NSThread sleepForTimeInterval:0.01];
                }
                
                NSLog(@"---------end----------");
                
                [self.delegate sightDecodeFinished:self];
            }
            
        }
        
        //    [_reader cancelReading];

    }
    
    
    
    
    
    

#endif
}


// AVFoundation 捕捉视频帧，很多时候都需要把某一帧转换成 image
- (CGImageRef)imageFromSampleBufferRef:(CMSampleBufferRef)sampleBufferRef
{
    // 为媒体数据设置一个CMSampleBufferRef
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBufferRef);
    // 锁定 pixel buffer 的基地址
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // 得到 pixel buffer 的基地址
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    // 得到 pixel buffer 的行字节数
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // 得到 pixel buffer 的宽和高
    // 为了可以自定义播放窗口的大小，这里的宽和高用self的
#if 9
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
#else
    size_t width = 480;
    size_t height = 480;
#endif
    
    // 创建一个依赖于设备的 RGB 颜色空间
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // 用抽样缓存的数据创建一个位图格式的图形上下文（graphic context）对象
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    //根据这个位图 context 中的像素创建一个 Quartz image 对象
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // 解锁 pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    
    // 释放 context 和颜色空间
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
//    CFRelease(imageBuffer);

    // 用 Quzetz image 创建一个 UIImage 对象
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放 Quartz image 对象
    //    CGImageRelease(quartzImage);
    
    return quartzImage;
    
}


- (CGImageRef) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer {
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    //Generate image to edit
    unsigned char* pixel = (unsigned char *)CVPixelBufferGetBaseAddress(imageBuffer);
    CGColorSpaceRef colorSpace=CGColorSpaceCreateDeviceRGB();
    CGContextRef context=CGBitmapContextCreate(pixel, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little|kCGImageAlphaPremultipliedFirst);
    CGImageRef image = CGBitmapContextCreateImage(context);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    return image;
}

- (void)releaseAry {
    [_imageRefAry removeAllObjects];
    _imageRefAry = nil;
}

@end
