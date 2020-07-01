//
//  LCVoiceHud.m
//  LCVoiceHud
//
//  Created by 郭历成 on 13-6-21.
//  Contact titm@tom.com
//  Copyright (c) 2013年 Wuxiantai Developer Team.(http://www.wuxiantai.com) All rights reserved.
//

#import "LCVoiceHud.h"
#import <QuartzCore/QuartzCore.h>
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

#pragma mark - <DEFINES>

#define _DEVICE_WINDOW ((UIView*)[UIApplication sharedApplication].keyWindow)
#define _DEVICE_HEIGHT ([UIScreen mainScreen].bounds.size.height-20.0f)
#define _DEVICE_WIDTH  ([UIScreen mainScreen].bounds.size.width)

//#define _IMAGE_UNDER       [UIImage imageNamed:@"Hud/black_bg_ip5.png"]
#define _IMAGE_UNDER       [UIImage imageNamed:@"amr/bg_platform_voicerecord.png"]

//#define _IMAGE_MIC_NORMAL  [UIImage imageNamed:@"Hud/mic_normal_358x358.png"]
#define _IMAGE_MIC_NORMAL  [UIImage imageNamed:@"amr/icon_mic_nor.png"]


#define _IMAGE_MIC_TALKING [UIImage imageNamed:@"Hud/mic_talk_358x358.png"]

//#define _IMAGE_MIC_WAVE [UIImage imageNamed:@"Hud/wave70x117.png"]
#define _IMAGE_MIC_WAVE [UIImage imageNamed:@"amr/icon_mic_7level.png"]
#define _IMAGE_UNDER       [UIImage imageNamed:@"amr/bg_platform_voicerecord.png"]


#pragma mark - <CLASS> - UIVewFrame

@interface UIView (UIViewFrame)

-(float)width;
-(float)height;

@end

@implementation UIView (UIViewFrame)

-(float)width{
    return self.frame.size.width;
}

-(float)height{
    return self.frame.size.height;
}

@end

#pragma mark - <CLASS> - UIImageGrayscale

@interface UIImage (Grayscale)

- (UIImage *) partialImageWithPercentage:(float)percentage
                                vertical:(BOOL)vertical
                           grayscaleRest:(BOOL)grayscaleRest;

@end

@implementation UIImage (Grayscale)

//http://stackoverflow.com/questions/1298867/convert-image-to-grayscale
- (UIImage *) partialImageWithPercentage:(float)percentage vertical:(BOOL)vertical grayscaleRest:(BOOL)grayscaleRest {
    const int ALPHA = 0;
    const int RED = 1;
    const int GREEN = 2;
    const int BLUE = 3;
    
    // Create image rectangle with current image width/height
    CGRect imageRect = CGRectMake(0, 0, self.size.width * self.scale, self.size.height * self.scale);
    
    int width = imageRect.size.width;
    int height = imageRect.size.height;
    
    // the pixels will be painted to this array
    uint32_t *pixels = (uint32_t *) malloc(width * height * sizeof(uint32_t));
    
    // clear the pixels so any transparency is preserved
    memset(pixels, 0, width * height * sizeof(uint32_t));
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // create a context with RGBA pixels
    CGContextRef context = CGBitmapContextCreate(pixels, width, height, 8, width * sizeof(uint32_t), colorSpace,
                                                 kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedLast);
    
    // paint the bitmap to our context which will fill in the pixels array
    CGContextDrawImage(context, CGRectMake(0, 0, width, height), [self CGImage]);
    
    int x_origin = vertical ? 0 : width * percentage;
    int y_to = vertical ? height * (1.f -percentage) : height;
    
    for(int y = 0; y < y_to; y++) {
        for(int x = x_origin; x < width; x++) {
            uint8_t *rgbaPixel = (uint8_t *) &pixels[y * width + x];
            
            if (grayscaleRest) {
                // convert to grayscale using recommended method: http://en.wikipedia.org/wiki/Grayscale#Converting_color_to_grayscale
                uint32_t gray = 0.3 * rgbaPixel[RED] + 0.59 * rgbaPixel[GREEN] + 0.11 * rgbaPixel[BLUE];
                
                // set the pixels to gray
                rgbaPixel[RED] = gray;
                rgbaPixel[GREEN] = gray;
                rgbaPixel[BLUE] = gray;
            }
            else {
                rgbaPixel[ALPHA] = 0;
                rgbaPixel[RED] = 0;
                rgbaPixel[GREEN] = 0;
                rgbaPixel[BLUE] = 0;
            }
        }
    }
    
    // create a new CGImageRef from our context with the modified pixels
    CGImageRef image = CGBitmapContextCreateImage(context);
    
    // we're done with the context, color space, and pixels
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    free(pixels);
    
    // make a new UIImage to return
    UIImage *resultUIImage = [UIImage imageWithCGImage:image
                                                 scale:self.scale
                                           orientation:UIImageOrientationUp];
    
    // we're done with image now too
    CGImageRelease(image);
    
    return resultUIImage;
}

@end

#pragma mark - <CLASS> - LCPorgressImageView

@interface LCPorgressImageView : UIImageView {
    
    UIImage * _originalImage;
    
    BOOL      _internalUpdating;
}

@property (nonatomic) float progress;
@property (nonatomic) BOOL  hasGrayscaleBackground;

@property (nonatomic, getter = isVerticalProgress) BOOL verticalProgress;

@end

@interface LCPorgressImageView ()

@property(nonatomic,retain) UIImage * originalImage;

- (void)commonInit;
- (void)updateDrawing;

@end

@implementation LCPorgressImageView

@synthesize progress               = _progress;
@synthesize hasGrayscaleBackground = _hasGrayscaleBackground;
@synthesize verticalProgress       = _verticalProgress;

- (void)dealloc
{
    [_originalImage release];
    
    [super dealloc];
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self commonInit];
    }
    return self;
    
}

- (void)commonInit{
    
    _progress = 0.f;
    _hasGrayscaleBackground = YES;
    _verticalProgress = YES;
    _originalImage = self.image;
    
}

#pragma mark - Custom Accessor

- (void)setImage:(UIImage *)image{
    
    [super setImage:image];
    
    if (!_internalUpdating) {
        self.originalImage = image;
        [self updateDrawing];
    }
    
    _internalUpdating = NO;
}

- (void)setProgress:(float)progress{
    
    _progress = MIN(MAX(0.f, progress), 1.f);
    [self updateDrawing];
    
}

- (void)setHasGrayscaleBackground:(BOOL)hasGrayscaleBackground{
    
    _hasGrayscaleBackground = hasGrayscaleBackground;
    [self updateDrawing];
    
}

- (void)setVerticalProgress:(BOOL)verticalProgress{
    
    _verticalProgress = verticalProgress;
    [self updateDrawing];
    
}

#pragma mark - drawing

- (void)updateDrawing{
    
    _internalUpdating = YES;
    self.image = [_originalImage partialImageWithPercentage:_progress vertical:_verticalProgress grayscaleRest:_hasGrayscaleBackground];
    
}

@end

#pragma mark - <CLASS> - LCVoice HUD

@interface LCVoiceHud ()
{
    UIImageView         * _talkingImageView;
    LCPorgressImageView * _dynamicProgress;
}

@end

@implementation LCVoiceHud

- (id)init
{
    self = [super initWithFrame:_DEVICE_WINDOW.bounds];
    
    if (self) {

        self.backgroundColor = [UIColor clearColor];
        self.progress = 0.f;
        self.alpha = 0;
        
        [self createMainUI];
    }
    return self;
}

#pragma mark - View Create

-(void) createMainUI{
    
    CGRect frame1 = CGRectMake((_DEVICE_WIDTH - 200)/2, (_DEVICE_HEIGHT - 200)/2+10, 200, 200);
    CGRect frame2 = CGRectMake((_DEVICE_WIDTH - 61)/2, (_DEVICE_HEIGHT - 101)/2-30, 51, 91);
    CGRect frame3 = CGRectMake(124/2-50/2, 124/2-93.5/2, 139, 139);
    CGRect frame4 = CGRectMake(0, 0, 25, 58.5);

    UIImageView * backBlackImageView = [[UIImageView alloc] initWithFrame:frame1];
    backBlackImageView.image = _IMAGE_UNDER;
    [self addSubview:backBlackImageView];
    [backBlackImageView release];
    
    UIImageView * micNormalImageView = [[UIImageView alloc] initWithImage:_IMAGE_MIC_NORMAL];
    micNormalImageView.frame = frame2;
    micNormalImageView.center = self.center;
    [self addSubview:micNormalImageView];
    [micNormalImageView release];
    
    countDownLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 210, WIDTH, 30)];
    countDownLabel.textAlignment = NSTextAlignmentCenter;
    countDownLabel.lineBreakMode = NSLineBreakByWordWrapping;
    countDownLabel.font = [UIFont systemFontOfSize:19.0f];
    countDownLabel.textColor = [UIColor greenColor];
    countDownLabel.backgroundColor = [UIColor clearColor];
    countDownLabel.hidden = YES;
    [self addSubview:countDownLabel];

   
    UILabel *recordingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 320, WIDTH, 30)];
    recordingLabel.textAlignment = NSTextAlignmentCenter;
    recordingLabel.lineBreakMode = NSLineBreakByWordWrapping;
    recordingLabel.font = [UIFont systemFontOfSize:19.0f];
    recordingLabel.textColor = [UIColor whiteColor];
    recordingLabel.backgroundColor = [UIColor clearColor];
    recordingLabel.text = @"正在录音";
    [self addSubview:recordingLabel];
    [recordingLabel release];
    
    //--add by kate---------------------------------------------------------
    if (IS_IPHONE_5) {
        
    }else{
        recordingLabel.frame = CGRectMake(0, 320 - 30, WIDTH, 30);
        countDownLabel.frame = CGRectMake(0, 210 - 40, WIDTH, 30);
    }
    //------------------------------------------------------------

    _talkingImageView = [[UIImageView alloc] initWithFrame:frame3];
    _talkingImageView.image = _IMAGE_MIC_TALKING;
    //[self addSubview:_talkingImageView];
    _talkingImageView.center = self.center;
    [_talkingImageView release];
    
    _dynamicProgress = [[LCPorgressImageView alloc] initWithFrame:frame4];
    _dynamicProgress.image = _IMAGE_MIC_WAVE;
    [self addSubview:_dynamicProgress];
    [_dynamicProgress release];
    
    /* set */
    _dynamicProgress.progress = 0;
    _dynamicProgress.hasGrayscaleBackground = NO;
    _dynamicProgress.verticalProgress = YES;
    _dynamicProgress.center = CGPointMake(self.center.x, self.center.y-20);
}

#pragma mark - Custom Accessor

-(void) setProgress:(float)progress{
    
    if (_dynamicProgress){
        
        _dynamicProgress.progress = progress;
        
        if (progress <= 0.01){
            [self showHighLight:NO];
        }
        else{
            [self showHighLight:YES];
        }

    }
    
}

-(float) progress{

    if (_dynamicProgress) return _dynamicProgress.progress;
    
    return 0.f;
}

-(void) removeFromSuperview{
    
    [super removeFromSuperview];
    self = nil;
}

#pragma mark - Public Function

-(void) showHighLight:(BOOL)yesOrNo
{
    if (yesOrNo){
        
        [UIView animateWithDuration:0.2 animations:^{
        
//            _talkingImageView.alpha = 1;
        }];
    }
    else{
        
        [UIView animateWithDuration:0.2 animations:^{
            
//            _talkingImageView.alpha = 0;
        }];
    }
}

-(void) show{
    
    [_DEVICE_WINDOW addSubview:self];
    
    [UIView animateWithDuration:0.25 animations:^{
        self.alpha = 1;
    }];
    
    secondsCountDown = 60;
    countDownTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
    
    countDownLabel.text = [[NSString stringWithFormat:@"%d", secondsCountDown] stringByAppendingString:@"″"];
    countDownLabel.hidden = NO;
}

-(void) hide{
    [countDownTimer invalidate];
    countDownLabel.hidden = YES;

    [self removeFromSuperview];
}


- (void)timeFireMethod
{
	secondsCountDown--;
    countDownLabel.text = [[NSString stringWithFormat:@"%d", secondsCountDown] stringByAppendingString:@"″"];

	if(secondsCountDown==0){
        [countDownTimer invalidate];
	}
}


@end
