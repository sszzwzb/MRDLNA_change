//
//  ViewController.h
//  segmentControllerl
//
//  Created by kaiyi on 16/12/23.
//          改自  李佳佳 on 15/6/30. LjjUIsegumentViewController.h
//          二次修改  kaiyi on 18/04/27 KYSegmentedControl
//  Copyright © 2016年 kaiyi. All rights reserved.
//

#import "KYSegmentedControl.h"


@interface KYSegmentedControl ()
{
    UIView *buttonDown;
    NSInteger selectSeugment;
}

@property(nonatomic,strong)NSMutableArray* ButtonArray;

@property(nonatomic,strong)NSMutableArray *widthButDownFloatArr;  //  下划线长度数组
@property(nonatomic,strong)NSMutableArray *widthPerButFloat;  //   每个的总长度

@end

@implementation KYSegmentedControl

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        //       默认
        _ButtonArray = [NSMutableArray array];
        _widthButDownFloatArr = [NSMutableArray array];
        _widthPerButFloat = [NSMutableArray array];
        
        
        selectSeugment = 0;   //   开始的位置
        
        _kySegmentButDown = kySegmentButDownSType1;
        _kySegmentPerBut = kySegmentPerButType1;
        
        
        self.LJBackGroundColor = [UIColor whiteColor];
        
        self.titleFont = [UIFont systemFontOfSize:17.f];
        self.selectTitleFont = [UIFont systemFontOfSize:17.f weight:2.f];
        
        self.titleColor = [UIColor blackColor];
        self.selectColor = [UIColor blueColor];
        
        
        self.showsHorizontalScrollIndicator = NO;
        self.alwaysBounceVertical = NO;
        self.scrollsToTop = NO;
//        self.pagingEnabled = YES;
        
    }
    return self;
}


-(void)setSegumentArray:(NSArray *)segumentArray
{
    _SegumentArray = segumentArray;
    
    [self setBackgroundColor:self.LJBackGroundColor];
    
    NSInteger seugemtNumber = segumentArray.count;
    
    
    if (_kySegmentButDown == kySegmentButDownSType1) {
        //  一样长
        for (int i = 0; i < [segumentArray count]; i++) {
            
            CGFloat perWitdFloat = 24.f;
            
            [_widthButDownFloatArr addObject:[NSString stringWithFormat:@"%lf",perWitdFloat]];
            
        }
    } else {
        //  算的长度，不一样
        for (NSString *str in segumentArray) {
            
            CGFloat perWitdFloat = [self getWidthWithTitle:str font:_selectTitleFont];
                
            [_widthButDownFloatArr addObject:[NSString stringWithFormat:@"%lf",perWitdFloat]];
            
        }
        
    }
    
    
    
    if (_kySegmentPerBut == kySegmentPerButType1) {
        //  最大是 选择的宽度，小了压缩
        for (int i = 0; i < seugemtNumber; i++) {
            
            [_widthPerButFloat addObject:[NSString stringWithFormat:@"%lf",self.bounds.size.width/seugemtNumber]];
            
        }
        
    } else {
        //  每个使用不同的间距
        
        CGFloat allWidth = 0;
        for (NSString *str in segumentArray) {
            
            CGFloat perWitdFloat = [self getWidthWithTitle:str font:_selectTitleFont];
            
            allWidth += perWitdFloat + 45;
            
            [_widthPerButFloat addObject:[NSString stringWithFormat:@"%lf",perWitdFloat + 45]];
            
        }
        
        self.contentSize = CGSizeMake(allWidth, self.bounds.size.height);
        
    }
    
    
    
    CGFloat allWidth = 0;
    for (int i = 0; i < [segumentArray count]; i++) {
        
        CGFloat perWitdFloat = [_widthPerButFloat[i] floatValue];
        
        UIButton *button = [UIButton buttonWithType:(UIButtonTypeCustom)];
        button.frame = CGRectMake(allWidth, 0, perWitdFloat, self.bounds.size.height - 2);
        
        
        allWidth += [_widthPerButFloat[i] floatValue];
        
        
        [button setTitle:segumentArray[i] forState:UIControlStateNormal];
        [button.titleLabel setFont:self.titleFont];
        [button setTitleColor:self.titleColor forState:UIControlStateNormal];
        [button setTitleColor:self.selectColor forState:UIControlStateSelected];
        [button setTag:i];
        [button addTarget:self action:@selector(changeTheSegument:) forControlEvents:UIControlEventTouchUpInside];
        
        button.tag = 200 + i;
        
        if (i == 0) {
            
            CGFloat width = [_widthButDownFloatArr[i] floatValue];
            
            buttonDown = [[UIView alloc]initWithFrame:CGRectMake((perWitdFloat - width)/2, self.bounds.size.height - 2, width, 2)];
            //  下划线
            [buttonDown setBackgroundColor: _selectColor];
            [self addSubview:buttonDown];
            
            [button.titleLabel setFont:self.selectTitleFont];
        }
        
        [self addSubview:button];
        [self.ButtonArray addObject:button];
    }
    [[self.ButtonArray firstObject] setSelected:YES];
}


-(void)changeTheSegument:(UIButton*)button
{
    [self selectTheSegument:button.tag - 200];
}


-(void)selectTheSegument:(NSInteger)segument
{
    if (selectSeugment != segument) {
        
        [self.ButtonArray[selectSeugment] setSelected:NO];
        [self.ButtonArray[segument] setSelected:YES];
        
        CGFloat width = [_widthButDownFloatArr[segument] floatValue];
        
        CGFloat selectAllWidht = 0;
        for (int i = 0; i < segument; i++) {
            selectAllWidht += [_widthPerButFloat[i] floatValue];
        }
        
        [UIView animateWithDuration:0.5 animations:^{
            [buttonDown setFrame:CGRectMake(selectAllWidht + ([_widthPerButFloat[segument] floatValue] - width)/2, self.bounds.size.height - 2, width, 2)];
        }];
        
        selectSeugment = segument;
        
        if (self.myDelegate && [self.myDelegate respondsToSelector:@selector(segumentSelectionChange:)]) {
            [self.myDelegate segumentSelectionChange:selectSeugment];
        }
        
    }
    
    for (int i = 0; i < [_SegumentArray count]; i++) {
        
        UIButton *button = [self viewWithTag:200 + i];
        [button.titleLabel setFont:self.titleFont];
        
    }
    UIButton *button = [self viewWithTag:200 + segument];
    [button.titleLabel setFont:self.selectTitleFont];
    
    
//    [self setContentOffset:CGPointMake(0,200) animated:YES];
    [self scrollRectToVisible:button.frame animated:YES];
}


-(void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    UISegmentedControl *sgement = [[UISegmentedControl alloc]init];
    [sgement addTarget:target action:action forControlEvents:controlEvents];
}

-(CGFloat)getWidthWithTitle:(NSString *)title font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 1000, 0)];
    label.text = title;
    label.font = font;
    [label sizeToFit];
    return label.frame.size.width;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
