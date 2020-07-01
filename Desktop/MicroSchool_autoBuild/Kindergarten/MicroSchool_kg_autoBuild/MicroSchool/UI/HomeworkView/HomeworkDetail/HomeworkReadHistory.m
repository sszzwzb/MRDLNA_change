//
//  HomeworkReadHistory.m
//  MicroSchool
//
//  Created by CheungStephen on 3/5/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkReadHistory.h"

@implementation HomeworkReadHistory

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)setImages:(NSArray *)arr elementWidth:(int)eWidth gapWidth:(int)gWidth radius:(BOOL)isRadius number:(NSString *)num {
    NSArray *views = [self subviews];
    for(UIView* view in views)
    {
        [view removeFromSuperview];
    }
    
    _elementsArr = [[NSMutableArray alloc] initWithArray:arr];
    
    NSMutableArray *eleArr = [[NSMutableArray alloc] initWithArray:arr];

    for(NSInteger i=1; i<=[eleArr count]; i++) {
        NSDictionary *fileDic = [eleArr objectAtIndex:i-1];

        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
//        tsTouchImg.layer.cornerRadius = eWidth/2;
        imgView.clipsToBounds = YES;
//        tsTouchImg.userInteractionEnabled = YES;
        
        [imgView sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

        
        // selectButton为选择图片的button，图片为本地图片
        // selectImageLocal为已经选择后的本地图片的uiimage对象
//        if ([@"selectButton"  isEqual: [fileDic objectForKey:@"imageType"]]) {
//            [tsTouchImg setImage:[UIImage imageNamed:[fileDic objectForKey:@"image"]]];
//        }else if ([@"selectImageLocal"  isEqual: [fileDic objectForKey:@"imageType"]]) {
//            [tsTouchImg setImage:[fileDic objectForKey:@"image"]];
//        }else if ([@"selectImageServer"  isEqual: [fileDic objectForKey:@"imageType"]]) {
//            [tsTouchImg sd_setImageWithURL:[fileDic objectForKey:@"image"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
//        }
        
        [self addSubview:imgView];
//        [_allImageArr addObject:tsTouchImg];
        
        
        int pos = 0;
        
        [imgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).with.offset(5);
            //                    make.left.equalTo(self).with.offset(((i-1)*(eWidth)));
            
            make.size.mas_equalTo(CGSizeMake(eWidth, eWidth));
            
//            if (lastView) {
//                make.left.mas_equalTo(lastView.mas_right).offset(gWidth);
//            }else {
                make.left.mas_equalTo(self.mas_left);
//            }
        }];
    }
    
    
#if 0
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
    
#endif
    
    
}

@end
