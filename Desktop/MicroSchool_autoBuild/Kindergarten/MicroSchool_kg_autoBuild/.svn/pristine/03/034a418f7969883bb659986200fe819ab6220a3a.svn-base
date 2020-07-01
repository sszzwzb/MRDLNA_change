//
//  HomeworkDetailBottomButton.m
//  MicroSchool
//
//  Created by CheungStephen on 2/4/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkDetailBottomButton.h"

@implementation HomeworkDetailBottomButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define BOTTOM_BUTTON_HEIGHT  50              // 底部button的高度

- (void)initElementsWithDic:(NSArray *)buttonArray{
    for (int i=0; i<[buttonArray count]; i++) {
        NSDictionary *buttonDic = [buttonArray objectAtIndex:i];
        
        UIButton *buttonElement = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:buttonElement];
        
        NSMutableAttributedString *mutableString = [self createButtonMutableAttributeString:
                                                    [buttonDic objectForKey:@"name"]
                                                    number:[buttonDic objectForKey:@"number"]
                                                    color:[buttonDic objectForKey:@"color"]];
        [buttonElement setAttributedTitle:mutableString forState:UIControlStateNormal];
        
        [buttonElement setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
        [buttonElement addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
        
        [buttonElement mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT);
            make.left.equalTo(self).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
        }];
    }
    
    
#if 0
    _buttonFirst = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_buttonFirst];
    
    NSMutableAttributedString *notDone = [self createButtonMutableAttributeString:@"未完成"
                                                                           number:[_statistics objectForKey:@"state3"]
                                                                            color:[[UIColor alloc] initWithRed:236/255.0f green:80/255.0f blue:81/255.0f alpha:1.0]];
    [_buttonFirst setAttributedTitle:notDone forState:UIControlStateNormal];
    
    [_buttonFirst setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
    [_buttonFirst addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
    
    [_buttonFirst mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT);
        make.left.equalTo(self).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
    }];
    
    _buttonSecond = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_buttonSecond];
    
    NSMutableAttributedString *notComment = [self createButtonMutableAttributeString:@"未批改"
                                                                              number:[_statistics objectForKey:@"state0"]
                                                                               color:[[UIColor alloc] initWithRed:255/255.0f green:138/255.0f blue:67/255.0f alpha:1.0]];
    [_buttonSecond setAttributedTitle:notComment forState:UIControlStateNormal];
    
    [_buttonSecond setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
    [_buttonSecond addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
    
    [_buttonSecond mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT);
        make.left.equalTo(_buttonFirst.mas_right).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
    }];
    
    _buttonThird = [UIButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:_buttonThird];
    
    NSMutableAttributedString *done = [self createButtonMutableAttributeString:@"已完成"
                                                                        number:[_statistics objectForKey:@"state2"]
                                                                         color:[[UIColor alloc] initWithRed:76/255.0f green:175/255.0f blue:130/255.0f alpha:1.0]];
    [_buttonThird setAttributedTitle:done forState:UIControlStateNormal];
    
    [_buttonThird setBackgroundColor:[[UIColor alloc] initWithRed:245/255.0f green:245/255.0f blue:245/255.0f alpha:1.0]];
    [_buttonThird addTarget:self action:@selector(buttonClickEvent:) forControlEvents: UIControlEventTouchUpInside];
    
    [_buttonThird mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset([Utilities getScreenSizeWithoutBar].height-BOTTOM_BUTTON_HEIGHT);
        make.left.equalTo(_buttonSecond.mas_right).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width/3, BOTTOM_BUTTON_HEIGHT));
    }];
#endif
}

- (NSMutableAttributedString *)createButtonMutableAttributeString:(NSString *)text
                                                           number:(NSString *)number
                                                            color:(UIColor *)color {
    NSString *s = [NSString stringWithFormat:@"%@ %@人", text, number];
    NSInteger textLength = [text length];
    NSInteger numberLength = [number length];
    NSInteger sLength = [s length];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
    [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] range:NSMakeRange(0,textLength)];
    [str addAttribute:NSForegroundColorAttributeName value:color range:NSMakeRange(textLength+1,numberLength)];
    [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0] range:NSMakeRange(textLength + numberLength + 1,1)];
    
    [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, sLength)];
    
    return str;
}

#pragma mark -
#pragma mark UIButton callback
- (IBAction)buttonClickEvent:(id)sender {
#if 0
    UIButton *button = (UIButton *)sender;
    NSString *viewType = @"";
    NSString *titleName = @"";
    
    if (button == _buttonNotDone) {
        viewType = @"notDone";
        titleName = @"未完成";
    }else if (button == _buttonNotComment) {
        viewType = @"notComment";
        titleName = @"未批改";
    }else if (button == _buttonDone) {
        viewType = @"done";
        titleName = @"已完成";
    }
    
    HomeworkStateListViewController *vc = [[HomeworkStateListViewController alloc] init];
    vc.viewType = viewType;
    vc.titleName = titleName;
    vc.cid = _cid;
    vc.tid = _tid;
    [self.navigationController pushViewController:vc animated:YES];
#endif
}

@end
