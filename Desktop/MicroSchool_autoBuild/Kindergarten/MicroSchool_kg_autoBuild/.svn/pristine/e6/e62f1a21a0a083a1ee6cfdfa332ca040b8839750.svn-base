//
//  MMSheetView.m
//  MMPopupView
//
//  Created by Ralph Li on 9/6/15.
//  Copyright © 2015 LJC. All rights reserved.
//

#import "MMSheetView.h"
#import "MMPopupItem.h"
#import "MMPopupCategory.h"
#import "MMPopupDefine.h"
#import <Masonry/Masonry.h>

@interface MMSheetView()

@property (nonatomic, strong) UIView      *titleView;
@property (nonatomic, strong) UILabel     *titleLabel;
@property (nonatomic, strong) UIView      *buttonView;
@property (nonatomic, strong) UIButton    *cancelButton;

@property (nonatomic, strong) NSArray     *actionItems;

@end

@implementation MMSheetView

- (instancetype)initWithTitle:(NSString *)title items:(NSArray *)items
{
    
    
#if 0
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        
//        self.backgroundColor = config.splitColor;
        
//        UIView *a = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 568)];
//        a.backgroundColor = [UIColor whiteColor];
//        [self addSubview:a];
        
//        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        effectView.frame = CGRectMake(0,0, 320, 600);
//        [self addSubview:effectView];
        
        self.frame =CGRectMake(0,0, 320, 600);;
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
        effectView.frame = CGRectMake(0,0, 320, 600);;
//        [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.edges.equalTo(self);
//        }];

        [self addSubview:effectView];
//
        // Vibrancy effect
        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:effect];
        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
        [vibrancyEffectView setFrame: CGRectMake(0,0, 320, 600)];
//        [vibrancyEffectView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.right.top.equalTo(self);
//        }];

//        [[vibrancyEffectView contentView] addSubview:btn];

        
        
//        [self mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
//        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleView = [UIView new];
//            [self addSubview:self.titleView];
            [[vibrancyEffectView contentView] addSubview:self.titleView];

            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo([vibrancyEffectView contentView]);
            }];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(config.innerMargin, 15, config.innerMargin, 15));
            }];
            self.titleLabel.textColor = config.titleColor;
            
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:4];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
            [self.titleLabel setAttributedText:attributedString1];

            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            
            
            
            
//            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.mas_bottom;
        }
        


        
        self.buttonView = [UIView new];
//        [self addSubview:self.buttonView];
        [[vibrancyEffectView contentView] addSubview:self.buttonView];

        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo([vibrancyEffectView contentView]);
            make.top.equalTo(lastAttribute);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            
            
            

            
//            [self.buttonView addSubview:btn];
            [[vibrancyEffectView contentView] addSubview:btn];

            btn.tag = i;
            
//            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:UIBlurEffectStyleExtraLight];
//            [self.buttonView addSubview:effectView];
//            [effectView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.edges.equalTo(self.buttonView);
//            }];
            

            
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, -MM_SPLIT_WIDTH, 0, -MM_SPLIT_WIDTH));
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton )
                {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            
//            UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//            UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//            effectView.frame = CGRectMake(0,0, 320, 50);
//            [btn addSubview:effectView];
            
            
            
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
            
            

        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
        }];
        
        
        
        
        

        
        
        
        
        
        
        self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
//        [self addSubview:self.cancelButton];
        [[vibrancyEffectView contentView] addSubview:self.cancelButton];

        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.buttonView);
            make.height.mas_equalTo(config.buttonHeight);
            make.top.equalTo(self.buttonView.mas_bottom).offset(8);
        }];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
//        [self mas_updateConstraints:^(MASConstraintMaker *make) {
//            make.bottom.equalTo(self.cancelButton.mas_bottom);
//        }];
     
//        [[vibrancyEffectView contentView] addSubview:self.cancelButton];
        
        

        [[effectView contentView] addSubview:vibrancyEffectView];


    }
    
    
    // Add the vibrancy view to the blur view
    


//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = CGRectMake(0, 0, 320, 300);
//    [self addSubview:effectView];

    
#else
    self = [super init];
    
    if ( self )
    {
        NSAssert(items.count>0, @"Could not find any items.");
        
        MMSheetViewConfig *config = [MMSheetViewConfig globalConfig];
        
        self.type = MMPopupTypeSheet;
        self.actionItems = items;
        
        self.backgroundColor = config.splitColor;
        
        

        
//        // Blur effect
//        UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *blurEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
//        [blurEffectView setFrame:self.view.bounds];
//        [self.view addSubview:blurEffectView];
//        
//        // Vibrancy effect
//        UIVibrancyEffect *vibrancyEffect = [UIVibrancyEffect effectForBlurEffect:blurEffect];
//        UIVisualEffectView *vibrancyEffectView = [[UIVisualEffectView alloc] initWithEffect:vibrancyEffect];
//        [vibrancyEffectView setFrame:self.view.bounds];
//        
//        // Label for vibrant text
//        UILabel *vibrantLabel = [[UILabel alloc] init];
//        [vibrantLabel setText:@"Vibrant"];
//        [vibrantLabel setFont:[UIFont systemFontOfSize:72.0f]];
//        [vibrantLabel sizeToFit];
//        [vibrantLabel setCenter: self.view.center];
//        
//        UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
//        btn.frame = CGRectMake(10, 50, 100, 40);
//        btn.backgroundColor = [UIColor whiteColor];
//        [btn setTitle:@"btn" forState:UIControlStateNormal];
//        
//        
//        
//        [[vibrancyEffectView contentView] addSubview:btn];
//        // Add label to the vibrancy view
//        [[vibrancyEffectView contentView] addSubview:vibrantLabel];
//        
//        // Add the vibrancy view to the blur view
//        [[blurEffectView contentView] addSubview:vibrancyEffectView];

        
        
        
        
        
        
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width);
        }];
        [self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self setContentHuggingPriority:UILayoutPriorityFittingSizeLevel forAxis:UILayoutConstraintAxisVertical];
        
        MASViewAttribute *lastAttribute = self.mas_top;
        if ( title.length > 0 )
        {
            self.titleView = [UIView new];
            [self addSubview:self.titleView];
            [self.titleView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.right.top.equalTo(self);
            }];
            self.titleView.backgroundColor = config.backgroundColor;
            
            self.titleLabel = [UILabel new];
            [self.titleView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.equalTo(self.titleView).insets(UIEdgeInsetsMake(config.innerMargin, 15, config.innerMargin, 15));
            }];
            self.titleLabel.textColor = config.titleColor;
            
            NSMutableAttributedString * attributedString1 = [[NSMutableAttributedString alloc] initWithString:title];
            NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle1 setLineSpacing:4];
            [attributedString1 addAttribute:NSParagraphStyleAttributeName value:paragraphStyle1 range:NSMakeRange(0, [title length])];
            [self.titleLabel setAttributedText:attributedString1];
            
            self.titleLabel.font = [UIFont systemFontOfSize:config.titleFontSize];
            self.titleLabel.textAlignment = NSTextAlignmentCenter;
            self.titleLabel.numberOfLines = 0;
            
            
            
            
            //            self.titleLabel.text = title;
            
            lastAttribute = self.titleView.mas_bottom;
        }
        
        self.buttonView = [UIView new];
        [self addSubview:self.buttonView];
        [self.buttonView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self);
            make.top.equalTo(lastAttribute);
        }];
        
        __block UIButton *firstButton = nil;
        __block UIButton *lastButton = nil;
        for ( NSInteger i = 0 ; i < items.count; ++i )
        {
            MMPopupItem *item = items[i];
            
            UIButton *btn = [UIButton mm_buttonWithTarget:self action:@selector(actionButton:)];
            
            
            
            
            
            
            
            [self.buttonView addSubview:btn];
            btn.tag = i;
            
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                
                make.left.right.equalTo(self.buttonView).insets(UIEdgeInsetsMake(0, -MM_SPLIT_WIDTH, 0, -MM_SPLIT_WIDTH));
                make.height.mas_equalTo(config.buttonHeight);
                
                if ( !firstButton )
                {
                    firstButton = btn;
                    make.top.equalTo(self.buttonView.mas_top).offset(-MM_SPLIT_WIDTH);
                }
                else
                {
                    make.top.equalTo(lastButton.mas_bottom).offset(-MM_SPLIT_WIDTH);
                    make.height.equalTo(firstButton);
                }
                
                lastButton = btn;
            }];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateDisabled];
            [btn setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
            [btn setTitle:item.title forState:UIControlStateNormal];
            [btn setTitleColor:item.highlight?config.itemHighlightColor:item.disabled?config.itemDisableColor:config.itemNormalColor forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
            btn.layer.borderWidth = MM_SPLIT_WIDTH;
            btn.layer.borderColor = config.splitColor.CGColor;
            btn.enabled = !item.disabled;
        }
        [lastButton mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.buttonView.mas_bottom).offset(MM_SPLIT_WIDTH);
        }];
        
        self.cancelButton = [UIButton mm_buttonWithTarget:self action:@selector(actionCancel)];
        [self addSubview:self.cancelButton];
        [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.buttonView);
            make.height.mas_equalTo(config.buttonHeight);
            make.top.equalTo(self.buttonView.mas_bottom).offset(8);
        }];
        self.cancelButton.titleLabel.font = [UIFont systemFontOfSize:config.buttonFontSize];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.backgroundColor] forState:UIControlStateNormal];
        [self.cancelButton setBackgroundImage:[UIImage mm_imageWithColor:config.itemPressedColor] forState:UIControlStateHighlighted];
        [self.cancelButton setTitle:config.defaultTextCancel forState:UIControlStateNormal];
        [self.cancelButton setTitleColor:config.itemNormalColor forState:UIControlStateNormal];
        
        [self mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.cancelButton.mas_bottom);
        }];
        
        
        

    }
    
    
    
    
#endif
    
    return self;
}

- (void)actionButton:(UIButton*)btn
{
    MMPopupItem *item = self.actionItems[btn.tag];
    NSString *btnTitle = btn.titleLabel.text;
    
    [self hide];
    
    if ( item.handler )
    {
        item.handler(btn.tag, btnTitle);
    }
}

- (void)actionCancel
{
    [self hide];
}

@end


@interface MMSheetViewConfig()

@end

@implementation MMSheetViewConfig

+ (MMSheetViewConfig *)globalConfig
{
    static MMSheetViewConfig *config;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        config = [MMSheetViewConfig new];
        
    });
    
    return config;
}

- (instancetype)init
{
    self = [super init];
    
    if ( self )
    {
        self.buttonHeight   = 50.0f;
        self.innerMargin    = 19.0f;
        
        self.titleFontSize  = 14.0f;
        self.buttonFontSize = 17.0f;
        
        self.backgroundColor    = MMHexColor(0xFFFFFFFF);
        self.titleColor         = MMHexColor(0x666666FF);
        self.splitColor         = MMHexColor(0xCCCCCCFF);
        
        self.itemNormalColor    = MMHexColor(0x333333FF);
        self.itemDisableColor   = MMHexColor(0xCCCCCCFF);
        self.itemHighlightColor = MMHexColor(0xE76153FF);
        self.itemPressedColor   = MMHexColor(0xEFEDE7FF);
        
        self.defaultTextCancel  = @"取消";
    }
    
    return self;
}

@end
