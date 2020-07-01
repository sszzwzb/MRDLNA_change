//
//  ShareWechatView.m
//  MicroApp
//
//  Created by kaiyi on 2018/4/12.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "ShareWechatView.h"

#import "ShareWechatUtility.h"

@interface ShareWechatView ()

@property (strong, nonatomic) UIButton *pickerView_bg_gray;  //  整体的按键 浅灰色

@property (nonatomic,strong) NSString *title;  //  标题
@property (nonatomic,strong) NSString *myDescription;   //  描述
@property (nonatomic,strong) UIImage *thumbImage; //  缩略图
@property (nonatomic,strong) NSString *detailUrl;

@end

@implementation ShareWechatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


- (instancetype)initShareTitle:(NSString *)title  //  标题
                   description:(NSString *)description   //  描述
                    thumbImage:(UIImage *)thumbImage //  缩略图
                     detailUrl:(NSString *)detailUrl
{
    self = [super init];
    if (self) {
        _title = title;
        _myDescription = description;
        _thumbImage = thumbImage;
        _detailUrl = detailUrl;
        
        [self upView];
    }
    return self;
}

-(void)upView
{
    self.frame = [UIScreen mainScreen].bounds;
    self.backgroundColor = [UIColor clearColor];
    
    
    //   整体的按键
    _pickerView_bg_gray = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _pickerView_bg_gray.frame = [UIScreen mainScreen].bounds;
    _pickerView_bg_gray.backgroundColor = rgba(0, 0, 0, 0.2);  //  去掉颜色
    //  取消
    [_pickerView_bg_gray addTarget:self action:@selector(btnCancelAction) forControlEvents:(UIControlEventTouchUpInside)];
    [self addSubview:_pickerView_bg_gray];
    
    
    
    UIView *rootViewBackGround = [[UIView alloc]initWithFrame:
                                  CGRectMake(0, KScreenHeight - 149  + 200 - KScreenTabBarIndicatorHeight, KScreenWidth, 150)];
    [self addSubview:rootViewBackGround];
    rootViewBackGround.backgroundColor = [UIColor whiteColor];
    
    BOOL isHaveWeChat = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"wechat://"]]) {
        //微信
        isHaveWeChat = YES;
    }
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]]) {
        //微信
        isHaveWeChat = YES;
    }
    
    
    NSMutableArray *arr = [NSMutableArray array];
    
    [arr addObject:@{@"img":@"UM_copy",@"title":@"复制链接"}];
    
    if (isHaveWeChat) {
        
        [arr addObject:@{@"img":@"UMS_wechat_session_icon",@"title":@"微信好友"}];
        [arr addObject:@{@"img":@"UMS_wechat_timeline_icon",@"title":@"微信朋友圈"}];
        
    }
    
    CGFloat width = 80;
    CGFloat height = 90;
    
    for (int i = 0; i < [arr count]; i++) {
        ShareBut *but = [ShareBut buttonWithType:(UIButtonTypeCustom)];
        [rootViewBackGround addSubview:but];
        but.frame = CGRectMake(10 + i * (width + 10) , (CGRectGetHeight(rootViewBackGround.frame) - height)/2, width, height);
        
        but.titleLabel.font = [UIFont systemFontOfSize:14.f];
        but.titleLabel.textAlignment = NSTextAlignmentCenter;
        [but setTitleColor:color_black forState:(UIControlStateNormal)];
        
        [but setTitle:arr[i][@"title"] forState:(UIControlStateNormal)];
        [but setImage:[UIImage imageNamed:arr[i][@"img"]] forState:(UIControlStateNormal)];
        
        but.tag = 200 + i;
        [but addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
        
    }
    
    
    //   动画
    [self animationWithView:rootViewBackGround duration:0.5];
    [self showKyTypePicker];
}

//   动画
- (void)animationWithView:(UIView *)view duration:(CFTimeInterval)duration{
    [UIView animateWithDuration:duration animations:^{
        view.transform=CGAffineTransformMakeTranslation(0, -200);  //  200 为移动的大小
    }];
}

-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 200) {
        NSLog(@"复制链接");
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = _detailUrl;
        
        [Utilities showTextHud:@"复制链接成功" descView:self];
        
        [self performSelector:@selector(btnSureAction) withObject:nil afterDelay:0.5];

    }
    if (button.tag == 201) {
        NSLog(@"分享微信");
        
        [ShareWechatUtility shareWeChatScene:MyWXSceneSession type:(MyWXTypeAdsHtml)
                                       title:_title
                                 description:_myDescription
                                  thumbImage:_thumbImage
                                   imageData:nil
                                   detailUrl:_detailUrl];
        
        [self btnSureAction];
        
    }
    if (button.tag == 202) {
        NSLog(@"分享到朋友圈");
        
        [ShareWechatUtility shareWeChatScene:MyWXSceneTimeline type:(MyWXTypeAdsHtml)
                                       title:_title
                                 description:_myDescription
                                  thumbImage:_thumbImage
                                   imageData:nil
                                   detailUrl:_detailUrl];
        
        [self btnSureAction];
    }
    
    
}

//   取消按键
- (void)btnCancelAction{
    [self disMissTypePicker];
}

//   确认按键
- (void)btnSureAction{
    
    
    
    [self disMissTypePicker];
}

//    让这个界面为主
- (void)showKyTypePicker{
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    self.center = [UIApplication sharedApplication].keyWindow.center;
}

//   确认，或者退出的时候，清空这个页面
-(void)disMissTypePicker{
    [self removeFromSuperview];
}

@end


@implementation ShareBut

-(CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, contentRect.size.height - 20, contentRect.size.width, 20);
}

-(CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width - (contentRect.size.height - 40))/2, 10, contentRect.size.height - 40, contentRect.size.height - 40);
}

@end
