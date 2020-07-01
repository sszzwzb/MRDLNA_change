//
//  SightSilentPlayer.m
//  VideoRecord
//
//  Created by CheungStephen on 4/7/16.
//  Copyright © 2016 guimingsu. All rights reserved.
//

#import "SightSilentPlayer.h"

@implementation SightSilentPlayer

- (void)initParm {
    _imagesAry = [[NSMutableArray alloc] init];
    
    _decode = [[SightDecode alloc] init];
    _decode.delegate = self;
    
    _queueA = [[NSOperationQueue alloc] init];
    _queueA.maxConcurrentOperationCount = 4;

}

- (void)prepareOneForPlayVideoInSilent {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (nil != _videoURL) {
            // 处理耗时操作的代码块...
            [_decode decodeFromVideoURL:_videoURL];
            
        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        
    });
}


- (void)prepareForPlayVideoInSilent:(NSString *)fileName {
    _fileName = fileName;

    _imagesAry = nil;
    _imagesAry = [[NSMutableArray alloc] init];


//    [_imagesAry removeAllObjects];
//    [_imagesAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj) {
//            obj = nil;
//        }
//    }];

    
//    [_decode decodeFromVideoURL:_videoURL];
    
    
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        if (nil != _videoURL) {
            // 处理耗时操作的代码块...
            [_decode decodeFromVideoURL:_videoURL];

        }
        
        //通知主线程刷新
        dispatch_async(dispatch_get_main_queue(), ^{
        });
        
    });

    
    
    
    
    
//    // 以下两行将任务排程到一个后台线程执行。dispatch_get_global_queue会取得一个系统分配的后台任务队列。
//    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_async(queue, ^{
//        
//        // 计算PI值到100万位。和示例1的calcPI:完全一样，唯一区别是现在它在后台线程上执行了。
//        [_decode decodeFromVideoURL:_videoURL];
//        
//        // 计算完成后，因为有UI操作，所以需要切换回主线程。一般原则：
//        // 1. UI操作必须在主线程上完成。2. 耗时的同步网络、同步IO、运算等操作不要在主线程上跑，以避免阻塞
//        // dispatch_get_main_queue()会返回关联到主线程的那个任务队列。
//        dispatch_async(dispatch_get_main_queue(), ^{
//            
////            // 关闭“请等待”提示
////            [self hideWaitingView];
////            
////            // 显示结果
////            [self displayResult:result];		
//        });
//    });
//    
    
    
//
    
    
//    [_operation cancel];
//
//    
//    //2.创建要执行的操作(方式二)
//    _operation = [NSBlockOperation blockOperationWithBlock:^{
//        [_decode decodeFromVideoURL:_videoURL];
//    }];
//    
////    NSBlockOperation *otherOperation = [NSBlockOperation blockOperationWithBlock:^{
////        NSLog(@"下载图片2222: %@", [NSThread currentThread]);
////    }];
//    
//    [_queueA addOperation:_operation];
//    [queue addOperation:otherOperation];
    
    
    
    
    
    
    
    
//    dispatch_queue_t q = dispatch_queue_create("cn.itcast.gcddemo", DISPATCH_QUEUE_SERIAL);
//    
//        dispatch_async(q, ^{
//            SightDecode *decode = [[SightDecode alloc] init];
//            decode.delegate = self;
//            [decode decodeFromVideoURL:_videoURL];
//        });

    
    
    
    
    
    
    
    
//    if (nil != _myThread) {
//        BOOL qqqq = _myThread.finished;
//        
//        NSLog(@"%d", qqqq);
//        if (!qqqq) {
//            [NSThread exit];
//        }
//    }
    
//    _myThread = [[NSThread alloc] initWithTarget:self
//                                                 selector:@selector(doThread)
//                                                   object:nil];
//    [_myThread start];
    
    
    
    
    
    
    
    
    
    
    
    
    
//    SightDecode *decode = [[SightDecode alloc] init];
//    decode.delegate = self;
//    [decode decodeFromVideoURL:_videoURL];
}

- (void)doThread {
    [_decode decodeFromVideoURL:_videoURL];

}

- (void)readyForPlayVideoInSilent {
//    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
//    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
//    animation.duration = 3;
//    animation.values = _imagesAry;
//    animation.repeatCount = MAXFLOAT;
//    [self.layer addAnimation:animation forKey:nil];
    // 确保内存能及时释放掉
//    [_imagesAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if (obj) {
//            obj = nil;
//        }
//    }];

//    __weak SightSilentPlayer *weakView = self;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        weakView.layer.contents = nil;
////        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_videoURL options:nil];
//        
//        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
//        animation.calculationMode = kCAAnimationDiscrete;
//        animation.duration = 4;;
//        animation.repeatCount = HUGE; //循环播放
//        animation.values = _imagesAry; // NSArray of CGImageRefs
//        [weakView.layer addAnimation:animation forKey: @"contents"];
//    });

    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
    animation.calculationMode = kCAAnimationDiscrete;
    animation.duration = 4;
    animation.repeatCount = HUGE;
    // NSArray of CGImageRefs
    animation.values = _imagesAry;
    [self.layer addAnimation:animation forKey: @"contents"];
    
}

-(void)sightDecodeEachFrame:(SightDecode *)sightDecode BufferRef:(CMSampleBufferRef)bufferRef {
#if 9
    
//    UIImage *image = [self imageFromSampleBuffer:&bufferRef];
//    image = [self normalizedImage:image];
//    [_imagesAry addObject:image];
//
//    @synchronized(self)
//    {
//        __weak SightSilentPlayer *weakView = self;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            weakView.layer.contents = image;
//        });
//        
//        
//    }

    
    CGImageRef cgimage = (CGImageRef )[self imageFromSampleBufferRef:bufferRef];
    if (!(__bridge id)(cgimage)) { return; }
    [_imagesAry addObject:((__bridge id)(cgimage))];
    CGImageRelease(cgimage);
    
    
    
    
    
    @synchronized(self)
    {
        __weak SightSilentPlayer *weakView = self;
        dispatch_async(dispatch_get_main_queue(), ^{
            weakView.layer.contents = (__bridge id _Nullable)(cgimage);
        });

        
    }
    
    
    
    
    
    
    
//    UIImage* image = [UIImage imageWithCGImage: cgimage];
//    
//    [_imagesAry addObject:image];

    
//    self.layer.contents = (__bridge id _Nullable)(cgimage);

//    [self.layer addAnimation:animation forKey: @"contents"];

#else
    CGImageRef cgimage = (CGImageRef )[self imageFromSampleBufferRef:bufferRef];

    __weak SightSilentPlayer *weakView = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = (__bridge id _Nullable)(cgimage);
    });
    
    CGImageRelease(cgimage);
#endif
}

-(void)sightDecodeEachFrame:(SightDecode *)sightDecode CGImageRef:(CGImageRef)imageRef {
    __weak SightSilentPlayer *weakView = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = (__bridge id _Nullable)(imageRef);
        [_imagesAry addObject:((__bridge id)(imageRef))];
    });
}

-(void)sightDecodeFinished:(SightDecode *)sightDecode duration:(float)duration {
    __weak SightSilentPlayer *weakView = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = nil;
        
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = duration;
        animation.repeatCount = HUGE; //循环播放
        animation.values = _imagesAry; // NSArray of CGImageRefs
        [weakView.layer addAnimation:animation forKey: @"contents"];
    });

}




-(UIImage*) imageFromSampleBuffer:(CMSampleBufferRef*)sampleBuffer{
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(*sampleBuffer);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    void *basdAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(basdAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    UIImage *image  = [UIImage imageWithCGImage:quartzImage scale:1.0 orientation:UIImageOrientationRight];
    CGImageRelease(quartzImage);
    return (image);
}
- (UIImage *)normalizedImage:(UIImage*)image {
    if (image.imageOrientation == UIImageOrientationUp) return image;
    UIGraphicsBeginImageContextWithOptions(image.size, NO, image.scale);
    [image drawInRect:(CGRect){0, 0, image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
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
    size_t width = 640;
    size_t height = 480;
    
//    size_t width = self.frame.size.width;
//    size_t height = self.frame.size.height;

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
    // 用 Quzetz image 创建一个 UIImage 对象
    // UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // 释放 Quartz image 对象
    //    CGImageRelease(quartzImage);
    
    return quartzImage;
    
}

- (void)sightDecodeFinished:(SightDecode *)decode
{
    NSLog(@"视频解档完成");
#if 0
    int a= 0;
    // 得到媒体的资源
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_videoURL options:nil];
    // 通过动画来播放我们的图片
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"contents"];
    // asset.duration.value/asset.duration.timescale 得到视频的真实时间
    animation.duration = asset.duration.value/asset.duration.timescale;
    animation.values = _imagesAry;
    animation.repeatCount = MAXFLOAT;
    [self.layer addAnimation:animation forKey:nil];
    // 确保内存能及时释放掉
        [_imagesAry enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj) {
                obj = nil;
            }
        }];
#else
    __weak SightSilentPlayer *weakView = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        weakView.layer.contents = nil;
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:_videoURL options:nil];

        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath: @"contents"];
        animation.calculationMode = kCAAnimationDiscrete;
        animation.duration = asset.duration.value/asset.duration.timescale ;//得到视频的真实时间
        animation.repeatCount = HUGE; //循环播放
        animation.values = _imagesAry; // NSArray of CGImageRefs
        [weakView.layer addAnimation:animation forKey: @"contents"];
        
        
//        NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//        NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_imagesAry];
////        NSData *data = [NSMutableData dataWithBytes:(__bridge const void * _Nullable)(_imagesAry) length:sizeof(_imagesAry)];
//
//        [userDefaults setObject:data forKey:_fileName];
//        [userDefaults synchronize];

        
        
    });
#endif
}

@end
