//
//  JKPopMenuItem.m
//  
//
//  Created by Bingjie on 14/12/15.
//  Copyright (c) 2015年 Bingjie. All rights reserved.
//

#import "JKPopMenuItem.h"

@interface JKPopMenuItem ()

@property (nonatomic, strong) UIImageView  *imageView;
@property (nonatomic, strong) UILabel      *titleLabel;
@end

@implementation JKPopMenuItem

+ (instancetype)item
{
    JKPopMenuItem *item = [[JKPopMenuItem alloc]init];
    return item;
}

+ (instancetype)itemWithTitle:(NSString*)title image:(NSString*)image
{
    JKPopMenuItem *item = [[JKPopMenuItem alloc]init];
//    item.title = title;
    
    
#if 0
    [[SDImageCache sharedImageCache] imageWithURL:url];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    UIImage *cachedImage = [manager imageWithURL:url]; // 将需要缓存的图片加载进来
    if (cachedImage) {
        // 如果Cache命中，则直接利用缓存的图片进行有关操作
        // Use the cached image immediatly
    } else {
        // 如果Cache没有命中，则去下载指定网络位置的图片，并且给出一个委托方法
        // Start an async download
        [manager downloadWithURL:url delegate:self];
    }
    
#endif
    
    
    
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    
    [manager downloadImageWithURL:[NSURL URLWithString:image] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
//        NSLog(@"receivedSize %ld", (long)receivedSize);
        item.icon = [UIImage imageNamed:@"grey.png"];

    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        item.icon = image;
//        NSLog(@"下载完成");
    }];
    
//    item.icon = image;
//    [item.icon sd_setImageWithURL:imagePath1];

//    [item.icon sd_setImageWithURL:[NSURL URLWithString:@""] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    return item;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupSubviews];
    }
    return self;
}

- (void)setIcon:(UIImage *)icon
{
    _icon = icon;
    self.imageView.image = _icon;
}

- (void)setTitle:(NSString *)title
{
    _title = title;
    self.titleLabel.text = _title;
}

- (void)setTextColor:(UIColor *)textColor
{
    _textColor = textColor;
    self.titleLabel.textColor = _textColor;
}

- (void)setupSubviews
{
    _imageView = [[UIImageView alloc]init];
    _imageView.contentMode = UIViewContentModeScaleAspectFit;
//    [_imageView sd_setImageWithURL:[NSURL URLWithString:pic] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    [self addSubview:_imageView];
    _imageView.image = self.icon;
    
    _titleLabel = [[UILabel alloc]init];
    _titleLabel.textColor = [UIColor blackColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font  = [UIFont boldSystemFontOfSize:14];
    _titleLabel.backgroundColor = [UIColor clearColor];
    [self addSubview:_titleLabel];
    _titleLabel.text = self.title;
    
    [_imageView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_titleLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    NSDictionary *dict1 = NSDictionaryOfVariableBindings(_imageView,_titleLabel);
    
    
    NSArray *vfls = @[
                      @"H:|-0-[_imageView]-0-|",
                      @"H:|-0-[_titleLabel]-0-|",
                      @"V:|-0-[_imageView]-5-[_titleLabel(20)]-0-|"
                      ];
    
    for (NSString *vlf in vfls) {
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:vlf
                                                                                 options:0
                                                                                 metrics:nil
                                                                                   views:dict1]];
    }
}

@end
