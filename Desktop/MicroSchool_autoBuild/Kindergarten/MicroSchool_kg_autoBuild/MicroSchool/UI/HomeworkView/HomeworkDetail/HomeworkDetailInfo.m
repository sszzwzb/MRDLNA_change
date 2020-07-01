//
//  HomeworkDetailInfo.m
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkDetailInfo.h"

@implementation HomeworkDetailInfo

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define LEFT_OFFSET 12                  // 控件到左边距的距离
#define IMAGE_WIDTH  70                 // 缩略图大小
#define IMAGE_GAP_WIDTH  5              // 缩略图间隙

- (void)initElementsWithDic:(NSDictionary *)dic showTitle:(NSString *)title {
    _dicInfo = [[NSMutableDictionary alloc] init];
    _dicInfo = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    _labelAnswerTitle = [UILabel new];
    [self addSubview:_labelAnswerTitle];
    
    _labelAnswerTitle.font = [UIFont systemFontOfSize:14.0f];
    _labelAnswerTitle.textColor = [[UIColor alloc] initWithRed:63/255.0f green:151/255.0f blue:238/255.0f alpha:1.0];
    _labelAnswerTitle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    if ([@"我的批改：作业全部答对。"  isEqual: title]) {
        // 需要为我的批改做一个特殊处理，因为可能需要显示全部答对
        if (0 == [(NSArray *)[_dicInfo objectForKey:@"pics"] count]) {
            // 如果没有作业图片的话，就算是全部答对了。
            NSString *text = @"我的批改：";
            NSString *number = @"作业全部答对。";
            
            NSString *s = [NSString stringWithFormat:@"%@%@", text, number];
            NSInteger textLength = [text length];
            NSInteger numberLength = [number length];
            NSInteger sLength = [s length];
            
            NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:s];
            [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:63/255.0f green:151/255.0f blue:238/255.0f alpha:1.0] range:NSMakeRange(0,textLength)];
            [str addAttribute:NSForegroundColorAttributeName value:[[UIColor alloc] initWithRed:236/255.0f green:80/255.0f blue:81/255.0f alpha:1.0] range:NSMakeRange(textLength,numberLength)];
            
            [str addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14.0f] range:NSMakeRange(0, sLength)];
            
            _labelAnswerTitle.attributedText = str;
        }else {
            _labelAnswerTitle.text = title;
        }
    }else {
        // 其他的都正常显示就行
        _labelAnswerTitle.text = title;
    }
    
    [_labelAnswerTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).with.offset(0);
        make.left.equalTo(self).with.offset(LEFT_OFFSET);
        if (nil != title) {
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, 14));
        }else {
            // 作业有正文的时候
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, 0));
        }
    }];

    _labelContent = [UILabel new];
    _labelContent.font = [UIFont systemFontOfSize:14.0f];
    _labelContent.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    _labelContent.numberOfLines = 0;
    _labelContent.lineBreakMode = NSLineBreakByWordWrapping;
    _labelContent.text = [dic objectForKey:@"content"];
    
    CGSize subjectSize = [Utilities getLabelHeight:_labelContent size:CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, MAXFLOAT)];
    _contentHeight = [NSString stringWithFormat:@"%f", subjectSize.height];
    [self addSubview:_labelContent];
    
    [_labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
        if (nil != title) {
            if (![@"" isEqualToString:[dic objectForKey:@"content"]]) {
                make.top.equalTo(_labelAnswerTitle.mas_bottom).with.offset(10);
            }else {
                make.top.equalTo(_labelAnswerTitle.mas_bottom).with.offset(0);
            }
        }else {
            // 作业有正文的时候
            make.top.equalTo(self).with.offset(0);
        }

        make.left.equalTo(_labelAnswerTitle).with.offset(0);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, subjectSize.height));
    }];

//    if (nil != title) {
//        [_labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(_labelAnswerTitle.mas_bottom).with.offset(10);
//            make.left.equalTo(_labelAnswerTitle).with.offset(0);
//            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, subjectSize.height));
//        }];
//    }else {
//        [_labelContent mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self).with.offset(0);
//            make.left.equalTo(self).with.offset(LEFT_OFFSET);
//            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, subjectSize.height));
//        }];
//    }

    if (0 != [(NSArray *)[_dicInfo objectForKey:@"pics"] count]) {
        // 有图片的时候先去加载图片，整个detailInfo的高度通过TSImageSelectView的代理一起计算发回去
        _imageSelectView = [TSImageSelectView new];
        _imageSelectView.delegate = self;
        [_imageSelectView initArrays];
        [self addSubview:_imageSelectView];
        
        [_imageSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_labelContent.mas_bottom).with.offset(10);
            make.left.equalTo(_labelContent).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, 0));
        }];
        
//            [self updateImageSelectViewElement];
        [self performSelector:@selector(updateImageSelectViewElement) withObject:nil afterDelay:0.3];
    }else {
        // 没有图片的时候，需要直接将整个的高度通过代理发回去
        _headHeight = _contentHeight.floatValue + 10;
        [self performSelector:@selector(handleDelegate) withObject:nil afterDelay:0.2];
    }
}

- (void)updateImageSelectViewElement {
    NSMutableArray *selectedImages = [[NSMutableArray alloc] init];
    NSMutableArray *pics = [_dicInfo objectForKey:@"pics"];
    
    for (int i=0; i<[pics count]; i++) {
        NSDictionary *picDic = [pics objectAtIndex:i];
        
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             [picDic objectForKey:@"url"], @"image",
                             @"selectImageServer", @"imageType",
                             [NSString stringWithFormat:@"%@", [picDic objectForKey:@"id"]], @"id",
                             nil];
        
        [selectedImages addObject:dic];
    }
    
    _imageSelectView.frame = CGRectMake(_imageSelectView.frame.origin.x, _imageSelectView.frame.origin.y,[Utilities getScreenSize].width-LEFT_OFFSET*2, _imageSelectView.frame.size.height);
    
    [_imageSelectView setImages:selectedImages elementWidth:IMAGE_WIDTH gapWidth:IMAGE_GAP_WIDTH];
}

#pragma mark -
#pragma mark TSImageSelectViewSelectDelegate
- (void)tsImageSelectViewSelectIndex:(NSInteger)index infoDic:(NSDictionary *)dic {
    [self.delegate homeworkDetailInfoSelectedImage:self index:index];
}

- (void)tsImageSelectView:(TSImageSelectView *)v height:(NSInteger)h {
    [_imageSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, h));
    }];
    
    _headHeight = h + _contentHeight.floatValue + 15;
    
    // 用约束的话需要等父级约束设置完了再设置子约束才行
    [self.delegate homeworkDetailInfo:self height:_headHeight];
}

- (void)handleDelegate {
    [self.delegate homeworkDetailInfo:self height:_headHeight];
}

@end
