//
//  TSImageSelectView.m
//  MicroSchool
//
//  Created by CheungStephen on 15/12/6.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "TSImageSelectView.h"

@implementation TSImageSelectView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (id) initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];
    if (self != nil) {
        // sth. todo
        _removeIconArr = [[NSMutableArray alloc] init];
        _allImageArr = [[NSMutableArray alloc] init];
        _allImageNameArr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)initArrays
{
    _removeIconArr = [[NSMutableArray alloc] init];
    _allImageArr = [[NSMutableArray alloc] init];
    _allImageNameArr = [[NSMutableArray alloc] init];
    _elementsArr = [[NSMutableArray alloc] init];
}

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth
{
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
    _elementsNumberInEachLine = @"0";
    _totalLines = @"0";

    _elementsArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSMutableArray *eleArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSLog(@"height = %f", self.frame.size.height);
    NSLog(@"width = %f", self.frame.size.width);

    if (0 != [arr count]) {
        NSInteger usedWidth = 0;

        UIView *lastView = nil;
        int line = 0;
        int totalLine = 0;

    TEST:
        for(NSInteger i=1; i<=[eleArr count]; i++) {
            NSDictionary *fileDic = [eleArr objectAtIndex:i-1];
            
            usedWidth = eWidth + gWidth;

            NSLog(@"self.frame.size.width) %f", self.frame.size.width);
            NSLog(@"eWidth %f", eWidth);

            NSLog(@"(self.frame.size.width-usedWidth*(i-1)) %f", (self.frame.size.width-usedWidth*(i-1)));

            if (eWidth <= (self.frame.size.width-usedWidth*(i-1))) {
                // 本行啥都不做
                if ([@"0"  isEqual: _totalLines]) {
                    _elementsNumberInEachLine = [NSString stringWithFormat:@"%d", [_elementsNumberInEachLine intValue] + 1];
                }
            }else {
                // 在下一行绘制
                line = line + 1;
                totalLine = totalLine + 1;
                lastView = nil;
                
                NSRange range = {0,i-1};
                [eleArr removeObjectsInRange:range];

                _totalLines = [NSString stringWithFormat:@"%d", [_totalLines intValue] + 1];
                
                goto TEST;
            }
            
            TSTouchImageView *tsTouchImg = [TSTouchImageView new];
            tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            tsTouchImg.clipsToBounds = YES;
            tsTouchImg.userInteractionEnabled = YES;
            
            // selectButton为选择图片的button，图片为本地图片
            // selectImageLocal为已经选择后的本地图片的uiimage对象
            if ([@"selectButton"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"image"]]];
            }else if ([@"selectImageLocal"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[fileDic objectForKey:@"image"]];
            }else if ([@"selectImageServer"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }else if ([@"selectImageServerCustom"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                UIView *moduleView = [self createmodule:[fileDic objectForKey:@"image"] title:[fileDic objectForKey:@"name"] count:5];

                [tsTouchImg addSubview:moduleView];
                
                
//                [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }
            
            [self addSubview:tsTouchImg];
            [_allImageArr addObject:tsTouchImg];
            
            [tsTouchImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(line*eWidth+gWidth*line);
                //                    make.left.equalTo(self).with.offset(((i-1)*(eWidth)));
                
                make.size.mas_equalTo(CGSizeMake(eWidth, eWidth));
                
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(gWidth);
                }else {
                    make.left.mas_equalTo(self.mas_left);
                }
            }];
            
            lastView = tsTouchImg;
            
            // 设置点击事件
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(memBerListClick:)];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  [NSString stringWithFormat:@"%ld", (long)i-1], @"positionInLine",
                                 _totalLines, @"line",
                                  nil];

            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            myTapGesture.infoDic = dic;
            [tsTouchImg addGestureRecognizer:myTapGesture];

        }
        NSInteger height = (totalLine+1) * (eWidth + gWidth);
        _viewHeight = [NSString stringWithFormat:@"%ld", (long)height];
        
        // 用约束的话需要等父级约束设置完了再设置子约束才行
        [self performSelector:@selector(handleDelegate) withObject:nil afterDelay:0.2];

        // 向需要绘制ImageSelectView的view发送通知
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%ld", (long)height], @"imageSelectViewHeight",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthSubmitUpdateImageSelectView" object:self userInfo:dic];
    }
}

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth radius:(BOOL)isRadius;
{
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
    _elementsNumberInEachLine = @"0";
    _totalLines = @"0";
    
    _elementsArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSMutableArray *eleArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSLog(@"height = %f", self.frame.size.height);
    NSLog(@"width = %f", self.frame.size.width);
    
    if (0 != [arr count]) {
        NSInteger usedWidth = 0;
        
        UIView *lastView = nil;
        int line = 0;
        int totalLine = 0;
        
    TEST:
        for(NSInteger i=1; i<=[eleArr count]; i++) {
            NSDictionary *fileDic = [eleArr objectAtIndex:i-1];
            
            usedWidth = eWidth + gWidth;
            
            if (eWidth <= (self.frame.size.width-usedWidth*(i-1))) {
                // 本行啥都不做
                if ([@"0"  isEqual: _totalLines]) {
                    _elementsNumberInEachLine = [NSString stringWithFormat:@"%d", [_elementsNumberInEachLine intValue] + 1];
                }
            }else {
                // 在下一行绘制
                line = line + 1;
                totalLine = totalLine + 1;
                lastView = nil;
                
                NSRange range = {0,i-1};
                [eleArr removeObjectsInRange:range];
                
                _totalLines = [NSString stringWithFormat:@"%d", [_totalLines intValue] + 1];
                
                goto TEST;
            }
            
            TSTouchImageView *tsTouchImg = [TSTouchImageView new];
            tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            if (isRadius) {
                tsTouchImg.layer.cornerRadius = eWidth/2;
            }
            tsTouchImg.clipsToBounds = YES;
            tsTouchImg.userInteractionEnabled = YES;
            
            // selectButton为选择图片的button，图片为本地图片
            // selectImageLocal为已经选择后的本地图片的uiimage对象
            if ([@"selectButton"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"image"]]];
            }else if ([@"selectImageLocal"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[fileDic objectForKey:@"image"]];
            }else if ([@"selectImageServer"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }
            
            [self addSubview:tsTouchImg];
            [_allImageArr addObject:tsTouchImg];
            
            [tsTouchImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(line*eWidth+gWidth*line);
                //                    make.left.equalTo(self).with.offset(((i-1)*(eWidth)));
                
                make.size.mas_equalTo(CGSizeMake(eWidth, eWidth));
                
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(gWidth);
                }else {
                    make.left.mas_equalTo(self.mas_left);
                }
            }];
            
            lastView = tsTouchImg;
            
            // 设置点击事件
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(memBerListClick:)];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%ld", (long)i-1], @"positionInLine",
                                 _totalLines, @"line",
                                 nil];
            
            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            myTapGesture.infoDic = dic;
            [tsTouchImg addGestureRecognizer:myTapGesture];
            
        }
        NSInteger height = (totalLine+1) * (eWidth + gWidth);
        _viewHeight = [NSString stringWithFormat:@"%ld", (long)height];
        
        // 用约束的话需要等父级约束设置完了再设置子约束才行
        [self performSelector:@selector(handleDelegate) withObject:nil afterDelay:0.2];

        // 向需要绘制ImageSelectView的view发送通知
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%ld", (long)height], @"imageSelectViewHeight",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthSubmitUpdateImageSelectView" object:self userInfo:dic];
    }
}

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth elementHeight:(int)eHeight gapWidth:(int)gWidth
{
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
    _elementsNumberInEachLine = @"0";
    _totalLines = @"0";
    
    _elementsArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSMutableArray *eleArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSLog(@"height = %f", self.frame.size.height);
    NSLog(@"width = %f", self.frame.size.width);
    
    if (0 != [arr count]) {
        NSInteger usedWidth = 0;
        
        UIView *lastView = nil;
        int line = 0;
        int totalLine = 0;
        int cnt = 0;
        
    TEST:
        for(NSInteger i=1; i<=[eleArr count]; i++) {
            NSDictionary *fileDic = [eleArr objectAtIndex:i-1];
            
            usedWidth = eWidth + gWidth;
            
            NSLog(@"self.frame.size.width) %f", self.frame.size.width);
            NSLog(@"eWidth %f", eWidth);
            
            NSLog(@"(self.frame.size.width-usedWidth*(i-1)) %f", (self.frame.size.width-usedWidth*(i-1)));
            
            if (eWidth <= (self.frame.size.width-usedWidth*(i-1))) {
                // 本行啥都不做
                if ([@"0"  isEqual: _totalLines]) {
                    _elementsNumberInEachLine = [NSString stringWithFormat:@"%d", [_elementsNumberInEachLine intValue] + 1];
                }
                
                cnt = cnt + 1;
            }else {
                // 在下一行绘制
                line = line + 1;
                totalLine = totalLine + 1;
                lastView = nil;
                
                NSRange range = {0,i-1};
                [eleArr removeObjectsInRange:range];
                
                _totalLines = [NSString stringWithFormat:@"%d", [_totalLines intValue] + 1];
                
                goto TEST;
            }
            
            TSTouchImageView *tsTouchImg = [TSTouchImageView new];
//            tsTouchImg.backgroundColor = [UIColor redColor];
            tsTouchImg.contentMode = UIViewContentModeScaleAspectFill;
            tsTouchImg.clipsToBounds = YES;
            tsTouchImg.userInteractionEnabled = YES;
            tsTouchImg.tag = 210 + cnt-1;
            // selectButton为选择图片的button，图片为本地图片
            // selectImageLocal为已经选择后的本地图片的uiimage对象
            if ([@"selectButton"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"image"]]];
            }else if ([@"selectImageLocal"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg setImage:[fileDic objectForKey:@"image"]];
            }else if ([@"selectImageServer"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }else if ([@"selectImageServerCustom"  isEqual: [fileDic objectForKey:@"imageType"]]) {
                UIImageView *moduleView = [self createmodule:[fileDic objectForKey:@"image"] title:[fileDic objectForKey:@"name"] count:4];
                tsTouchImg.isShowBgImg = NO;
//                moduleView.userInteractionEnabled = NO;
//
                [tsTouchImg addSubview:moduleView];
//                [tsTouchImg setImage:moduleView.image];

//                [tsTouchImg setImage:[UIImage imageNamed:@"SchoolHomePics/schoolHomeModuleTX"]];

                //                [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
            }
            
            [self addSubview:tsTouchImg];
            [_allImageArr addObject:tsTouchImg];
            
            [tsTouchImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self).with.offset(line*eWidth+gWidth*line);
                //                    make.left.equalTo(self).with.offset(((i-1)*(eWidth)));
                
                make.size.mas_equalTo(CGSizeMake(eWidth, eHeight));
                
                if (lastView) {
                    make.left.mas_equalTo(lastView.mas_right).offset(gWidth);
                }else {
                    make.left.mas_equalTo(self.mas_left);
                }
            }];
            
            lastView = tsTouchImg;
            
            // 设置点击事件
            TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(memBerListClick:)];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 [NSString stringWithFormat:@"%ld", (long)i-1], @"positionInLine",
                                 _totalLines, @"line",
                                 nil];
            
            myTapGesture.infoStr = [NSString stringWithFormat:@"%ld", (long)i-1];
            myTapGesture.infoDic = dic;
            [tsTouchImg addGestureRecognizer:myTapGesture];
            
        }
        NSInteger height = (totalLine+1) * (eHeight + gWidth);
        _viewHeight = [NSString stringWithFormat:@"%ld", (long)height+10];
        
        // 用约束的话需要等父级约束设置完了再设置子约束才行
//        [self performSelector:@selector(handleDelegate) withObject:nil afterDelay:0.1];
        
        [self handleDelegate];
        
        // 向需要绘制ImageSelectView的view发送通知
        NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSString stringWithFormat:@"%ld", (long)height], @"imageSelectViewHeight",
                             nil];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"healthSubmitUpdateImageSelectView" object:self userInfo:dic];
    }
}

- (IBAction)memBerListClick:(id)sender
{
//    NSString *aaa = _elementsNumberInEachLine;
//    NSString *bbb = _totalLines;

    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    NSDictionary *positionDic = tsTap.infoDic;
    int positionInLine = [[positionDic objectForKey:@"positionInLine"] intValue];
    int line = [[positionDic objectForKey:@"line"] intValue];
    
    int tag = line*[_elementsNumberInEachLine intValue] + positionInLine;

    NSDictionary *eleDic = [_elementsArr objectAtIndex:tag];
    NSString *imageType = [eleDic objectForKey:@"imageType"];
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSString stringWithFormat:@"%d", tag], @"tag",
                         imageType, @"imageType",
                         nil];
    
    NSLog(@"---tag---------%@", [dic objectForKey:@"tag"]);
    NSLog(@"---imageType---------%@", [dic objectForKey:@"imageType"]);

    [[NSNotificationCenter defaultCenter] postNotificationName:@"TSImageSelectViewClickEvent" object:self userInfo:dic];
    
    
    if ([self.delegate respondsToSelector:@selector(tsImageSelectViewSelectIndex:infoDic:)]) {
        [self.delegate tsImageSelectViewSelectIndex:tag infoDic:dic];
    }
//    if (self.selectBlock) {
//        self.selectBlock(control.tag);
//    }

}

- (IBAction)removeMemBerListClick:(id)sender
{
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:
                         tsTap.infoStr, @"tag",
                         nil];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_GROUPCHAT_REMOVEMEMBERLIST object:self userInfo:dic];
}

- (void)setRemoveIconHidden:(BOOL)isHidden;
{
    for(id obj in _removeIconArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        tsTouchImg.hidden = isHidden;
    }
}

- (void)removeAllImage
{
    for(id obj in _allImageArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        [tsTouchImg removeFromSuperview];
    }
    [_allImageArr removeAllObjects];
    
    for(id obj in _removeIconArr) {
        TSTouchImageView *tsTouchImg = (TSTouchImageView *)obj;
        [tsTouchImg removeFromSuperview];
    }
    [_removeIconArr removeAllObjects];
    
    for(id obj in _allImageNameArr) {
        UILabel *_label_name = (UILabel *)obj;
        [_label_name removeFromSuperview];
    }
    [_allImageNameArr removeAllObjects];
    
}

- (void)removeImageAtIndex:(NSInteger)pos
{
    TSTouchImageView *_tsTouchImg = (TSTouchImageView *)[_allImageArr objectAtIndex:pos];
    [_tsTouchImg removeFromSuperview];
}

- (void)handleDelegate {
    [self.delegate tsImageSelectView:self height:_viewHeight.integerValue];
}

- (UIImageView*)createmodule:(NSString*)imgName title:(NSString*)moduleTitle count:(NSUInteger)count{
    
    float width = [UIScreen mainScreen].bounds.size.width/count;
    
    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 14, width, 40+21.0)];
    UIImageView *imgV = [[UIImageView alloc] initWithFrame:CGRectMake((width-40)/2.0, 0, 40, 40)];
    [imgV sd_setImageWithURL:[NSURL URLWithString:imgName] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

//    imgV.image = [UIImage imageNamed:imgName];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2, 40+6, width, 21.0)];
    label.font = [UIFont systemFontOfSize:13.0];
    label.textAlignment = NSTextAlignmentCenter;
    label.text = moduleTitle;
    label.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    [view addSubview:imgV];
    [view addSubview:label];
    
    return view;
}

@end
