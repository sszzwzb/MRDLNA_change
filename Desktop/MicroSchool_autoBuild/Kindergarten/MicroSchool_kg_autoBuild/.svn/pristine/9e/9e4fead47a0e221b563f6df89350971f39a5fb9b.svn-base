//
//  JKPopMenuView.m
//  
//
//  Created by Bingjie on 14/12/15.
//  Copyright (c) 2015年 Bingjie. All rights reserved.
//

#import "JKPopMenuView.h"
#import "FXBlurView.h"

#define kStringMenuItemAppearKey         @"kStringMenuItemAppearKey"
#define kFloatMenuItemAppearDuration     (0.5f)
#define kFloatTipLabelAppearDuration     (0.45f)
#define kElasticity                      (20.0f)
#define RGB_COLOR(r, g, b)       [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define JK_SCREEN_BOUNDS   [UIScreen mainScreen].bounds
#define JK_SCREEN_WIDTH    ([UIScreen mainScreen].bounds.size.width)
#define JK_SCREEN_HEIGHT   ([UIScreen mainScreen].bounds.size.height)

@interface JKPopMenuView ()
{
    CGFloat firstItemY;
    CGFloat endItemY;
}
@property (strong, nonatomic) FXBlurView *blurBGView;
@end

@implementation JKPopMenuView

+ (instancetype)menuView
{
    JKPopMenuView *view = [[JKPopMenuView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    return view;
}

+ (instancetype)menuViewWithItems:(NSArray*)items
{
    JKPopMenuView *view = [[JKPopMenuView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    view.menuItems = items;
    return view;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.blurBGView = [[FXBlurView alloc] initWithFrame:self.bounds];
        _blurBGView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _blurBGView.dynamic = YES;
        _blurBGView.blurRadius = 10;
        [self addSubview:_blurBGView];
        
        UIView *maskView = [[UIView alloc] initWithFrame:_blurBGView.bounds];
        maskView.backgroundColor = [RGB_COLOR(230, 230, 230) colorWithAlphaComponent:0.6];
        maskView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        [_blurBGView addSubview:maskView];
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
        [_blurBGView addGestureRecognizer:tapGestureRecognizer];

        
        _blurBGView.underlyingView = [UIApplication sharedApplication].keyWindow;
        
        UILabel *_label_content = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                            20,
                                                                            -10,
                                                                            280,
                                                                            300)];
        //设置title自适应对齐
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:16.0f];
        _label_content.numberOfLines = 0;
        //label_content.adjustsFontSizeToFitWidth = YES;
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.textAlignment = NSTextAlignmentLeft;
        _label_content.backgroundColor = [UIColor clearColor];
        _label_content.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        _label_content.text = @"动动手指添加标签即可让全校的人看到您的风采啦，并且有酷炫的朋友圈样式哦。";
        [_blurBGView addSubview:_label_content];
        

    }
    return self;
}

- (IBAction)tags_btnclick:(id)sender
{
    NSLog(@"tags_btnclick");

    [self removeFromSuperview];
    
    [self disappear];
    if ([self.delegate respondsToSelector:@selector(viewSelectIndex:infoDic:)]) {
        [self.delegate popMenuViewSelectIndex:-1];
    }
}

- (void)tapped:(UIGestureRecognizer *)gesture
{
    [self disappear];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    if([touch.view isMemberOfClass:[UIButton class]]) {
        //放过以上事件的点击拦截
        
        return NO;
    }else{
        return YES;

    }
}

- (void)setMenuItems:(NSArray *)menuItems
{
//    _menuItems = menuItems;
//    NSAssert((_menuItems.count%2==0 || _menuItems.count%3==0), @"JKPopMenuView 菜单个数必须为2或3的倍数");
//    [self setupSubviews];
    
    NSMutableArray *a = [[NSMutableArray alloc]init];
    
    for (int i=0; i<[menuItems count]; i++) {
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [[menuItems objectAtIndex:i] objectForKey:@"pic"], @"image",
                             @"selectImageServer", @"imageType",
                             nil];
        
        [a addObject:dic];
    }
    
    int cnt = [menuItems count];
    int line = cnt/3;
    
    _imageSelectView = [[TSImageSelectView alloc] initWithFrame:CGRectMake(
                                                                           20,
                                                                           220,
                                                                           280,
                                                                           line*100)];
    
    //    _imageSelectView.backgroundColor = [UIColor greenColor];
    [_imageSelectView initArrays];
    _imageSelectView.delegate = self;
    [_blurBGView addSubview:_imageSelectView];

    [_imageSelectView setImages:a elementWidth:70 gapWidth:30 radius:YES];

    // 直接发送按钮
    UIButton *button_save = [UIButton buttonWithType:UIButtonTypeCustom];
    button_save.frame = CGRectMake(20, _imageSelectView.frame.origin.y + _imageSelectView.frame.size.height + 10, WIDTH-40, 40);
    
    button_save.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置颜色和字体
    [button_save setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateNormal];
    [button_save setTitleColor:[[UIColor alloc] initWithRed:27/255.0f green:128/255.0f blue:209/255.0f alpha:1.0] forState:UIControlStateHighlighted];
    button_save.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    [button_save setBackgroundImage:[UIImage imageNamed:@"moments/momentsTagsSelect.png"] forState:UIControlStateNormal] ;
    [button_save setBackgroundImage:[UIImage imageNamed:@"moments/momentsTagsSelected.png"] forState:UIControlStateHighlighted] ;
    // 添加 action
    [button_save addTarget:self action:@selector(tags_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_save setTitle:@"直接发布" forState:UIControlStateNormal];
    [button_save setTitle:@"直接发布" forState:UIControlStateHighlighted];
    
    [_blurBGView addSubview:button_save];

}

- (void)itemClick:(UIControl*)control
{
//    NSLog(@"%d", control.tag);
    
//    [self disappear];
//    if ([self.delegate respondsToSelector:@selector(viewSelectIndex:infoDic:)]) {
//        [self.delegate popMenuViewSelectIndex:control.tag];
//    }
//    if (self.selectBlock) {
//        self.selectBlock(control.tag);
//    }
}

- (void)setupSubviews
{
    CGFloat y_Offset = 20;
    CGFloat offset = 0;
    NSInteger count = self.menuItems.count;
    if (count == 2 || count == 4) {
        offset = (JK_SCREEN_WIDTH - PopMenuItemWidth*2)/3;
        
        NSInteger verticalNum = self.menuItems.count/2;
        CGFloat yStart = (JK_SCREEN_HEIGHT - verticalNum*(PopMenuItemHeight + y_Offset/2))/2;
        firstItemY = yStart;
        NSInteger index = 0;
        for (JKPopMenuItem *item in self.menuItems) {
            NSInteger y_index = index/2;
            NSInteger x_index = index%2;
            item.frame = CGRectMake(offset + (PopMenuItemWidth+offset)*x_index, yStart + (PopMenuItemHeight + y_Offset)*y_index + (JK_SCREEN_HEIGHT - firstItemY), PopMenuItemWidth, PopMenuItemHeight);
            switch (x_index) {
                case 0:
                    item.animationTime = 0.0 + 0.03*y_index;
                    break;
                case 1:
                    item.animationTime = 0.1 + 0.03*y_index;
                    break;
            }
            item.tag = index;
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            endItemY = item.center.y;
            index ++;
        }
    }
    if (count%3 == 0) {
        offset = (JK_SCREEN_WIDTH - PopMenuItemWidth*3)/4;
        
        // 3 的情况
        NSInteger verticalNum = self.menuItems.count/3;
        CGFloat yStart = (JK_SCREEN_HEIGHT - verticalNum*(PopMenuItemHeight + y_Offset/2))/2;
        firstItemY = yStart;
        NSInteger index = 0;
        for (JKPopMenuItem *item in self.menuItems) {
            NSInteger y_index = index/3;
            NSInteger x_index = index%3;
            item.frame = CGRectMake(offset + (PopMenuItemWidth+offset)*x_index, yStart + (PopMenuItemHeight + y_Offset)*y_index + (JK_SCREEN_HEIGHT - firstItemY), PopMenuItemWidth, PopMenuItemHeight);
            switch (x_index) {
                case 0:
                    item.animationTime = 0.15 + 0.03*y_index;
                    break;
                case 1:
                    item.animationTime = 0.0 + 0.03*y_index;
                    break;
                    
                case 2:
                    item.animationTime = 0.15 + 0.03*y_index;
                    break;
            }
            item.tag = index;
            [item addTarget:self action:@selector(itemClick:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:item];
            endItemY = item.center.y;
            index ++;
        }
        
    }
}

- (void)appear
{
    [self.layer addAnimation:[self fadeIn] forKey:@"fadeIn"];
    

//    NSInteger index = 0;
//    for (JKPopMenuItem *item in self.menuItems) {
//        float delayInSeconds = item.animationTime;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self appearMenuItem:item animated:YES];
//        });
//        index++;
//    }
    
}

- (void)disappear
{
//    NSInteger index = 0;
//    for (JKPopMenuItem *item in self.menuItems) {
//        double delayInSeconds = item.animationTime;
//        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
//        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
//            [self disappearMenuItem:item animated:YES];
//        });
//        index++;
//    }
//    
//    [UIView animateWithDuration:0.1 delay:0.6 options:UIViewAnimationOptionCurveEaseIn animations:^{
//        self.alpha = 0.5;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
    
    [self removeFromSuperview];

}

- (void)disappearMenuItem:(JKPopMenuItem *)item animated:(BOOL )animted
{
    CGPoint point = item.center;
    CGPoint finalPoint = CGPointMake(point.x, point.y - endItemY);
    if (animted) {
        CABasicAnimation *disappear = [CABasicAnimation animationWithKeyPath:@"position"];
        disappear.duration = 0.3;
        disappear.fromValue = [NSValue valueWithCGPoint:point];
        disappear.toValue = [NSValue valueWithCGPoint:finalPoint];
        disappear.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
        [item.layer addAnimation:disappear forKey:kStringMenuItemAppearKey];
    }
    item.layer.position = finalPoint;
}

- (void)appearMenuItem:(JKPopMenuItem *)item animated:(BOOL )animated
{
    CGPoint point0 = CGPointMake(item.center.x, item.center.y);
    CGPoint point1 = CGPointMake(point0.x, item.center.y - (JK_SCREEN_HEIGHT - firstItemY) - kElasticity);
    CGPoint point2 = CGPointMake(point1.x, point1.y + kElasticity);
    
    if (animated)
    {
        CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
        animation.values = @[[NSValue valueWithCGPoint:point0], [NSValue valueWithCGPoint:point1], [NSValue valueWithCGPoint:point2]];
        animation.keyTimes = @[@(0), @(0.6), @(1)];
        animation.timingFunctions = @[[CAMediaTimingFunction functionWithControlPoints:0.10 :0.87 :0.68 :1.0], [CAMediaTimingFunction functionWithControlPoints:0.66 :0.37 :0.70 :0.95]];
        animation.duration = kFloatMenuItemAppearDuration;
        [item.layer addAnimation:animation forKey:kStringMenuItemAppearKey];
    }
    item.layer.position = point2;
}

- (void)show
{
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:self];
    [self appear];
}

// add by kate 2016.01.06
- (void)show2
{
    UIWindow *keyWindow = [[UIApplication sharedApplication].windows firstObject];
    [keyWindow addSubview:self];
    [self appear];
}

-(void)viewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic;
{
    NSLog(@"%d",index);
    
    [self removeFromSuperview];
    
    [self disappear];
    if ([self.delegate respondsToSelector:@selector(viewSelectIndex:infoDic:)]) {
        [self.delegate popMenuViewSelectIndex:index];
    }

}

- (void)tsImageSelectViewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic {
    NSLog(@"%d",index);
    
    [self removeFromSuperview];
    
    [self disappear];
    if ([self.delegate respondsToSelector:@selector(viewSelectIndex:infoDic:)]) {
        [self.delegate popMenuViewSelectIndex:index];
    }
}

- (void)tsImageSelectView:(TSImageSelectView *)v height:(NSInteger)h {
    // nothing to do here.
}

@end

@implementation UIView (Additions)

- (CABasicAnimation *)fadeIn
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.2;
    animation.fromValue = [NSNumber numberWithFloat:0.0f];
    animation.toValue = [NSNumber numberWithFloat:0.8f];
    return animation;
}

- (CABasicAnimation *)fadeOut
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.duration = 0.2;
    animation.fromValue = [NSNumber numberWithFloat:0.8f];
    animation.toValue = [NSNumber numberWithFloat:0.0f];
    return animation;
}


@end
