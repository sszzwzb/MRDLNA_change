//
//  HomeworkDetailHead.m
//  MicroSchool
//
//  Created by CheungStephen on 1/29/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "HomeworkDetailHead.h"

@implementation HomeworkDetailHead

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

#define LEFT_OFFSET 12              // 控件到左边距的距离
#define HEAD_WIDTH  40              // 头像大小

- (void)initElementsWithDic:(NSDictionary *)dic {
    _headHeight = 0;
    
    _labelSubject = [UILabel new];
    _labelSubject.font = [UIFont systemFontOfSize:17.0f];
    _labelSubject.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    _labelSubject.numberOfLines = 0;
    _labelSubject.lineBreakMode = NSLineBreakByWordWrapping;
    _labelSubject.text = [dic objectForKey:@"title"];

    CGSize subjectSize = [Utilities getLabelHeight:_labelSubject size:CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, MAXFLOAT)];
    
    [self addSubview:_labelSubject];

    [_labelSubject mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为15
        make.top.equalTo(self).with.offset(15);
        
        // 距离屏幕左边距为12
        make.left.equalTo(self).with.offset(LEFT_OFFSET);
        
        // _labelSubject的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2, subjectSize.height));
    }];

    _headHeight += subjectSize.height + 15;

    _imageViewHead = [UIImageView new];
    _imageViewHead.layer.masksToBounds = YES;
    _imageViewHead.layer.cornerRadius = HEAD_WIDTH/2;
    [_imageViewHead sd_setImageWithURL:[dic objectForKey:@"avatar"] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];

    [self addSubview:_imageViewHead];

    [_imageViewHead mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离_labelSubject的下边距为15
        make.top.equalTo(_labelSubject.mas_bottom).with.offset(15);
        
        // 距离_labelSubject的左边距为0
        make.left.equalTo(_labelSubject.mas_left).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(HEAD_WIDTH, HEAD_WIDTH));
    }];

    _headHeight += HEAD_WIDTH + 15;

    _labelUsername = [UILabel new];
    _labelUsername.font = [UIFont systemFontOfSize:14.0f];
    _labelUsername.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
    _labelUsername.lineBreakMode = NSLineBreakByTruncatingTail;
    _labelUsername.text = [dic objectForKey:@"name"];
    
    [self addSubview:_labelUsername];
    
    [_labelUsername mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewHead.mas_top).with.offset(3);
        make.left.equalTo(_imageViewHead.mas_right).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2-HEAD_WIDTH-10, 14));
    }];

    _labelDateline = [UILabel new];
    _labelDateline.font = [UIFont systemFontOfSize:12.0f];
    _labelDateline.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
    _labelDateline.lineBreakMode = NSLineBreakByTruncatingTail;
    
    Utilities *util = [Utilities alloc];
    _labelDateline.text = [util linuxDateToString:[dic objectForKey:@"dateline"] andFormat:@"%@-%@-%@ %@:%@" andType:DateFormat_YMDHM];
    
    [self addSubview:_labelDateline];
    
    [_labelDateline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelUsername.mas_bottom).with.offset(5);
        make.left.equalTo(_imageViewHead.mas_right).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-LEFT_OFFSET*2-HEAD_WIDTH-10, 14));
    }];

    _labelExpectedtime = [UILabel new];
    _labelExpectedtime.font = [UIFont systemFontOfSize:12.0f];
    _labelExpectedtime.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
    _labelExpectedtime.lineBreakMode = NSLineBreakByTruncatingTail;
    _labelExpectedtime.text = @"预计完成时间：";
    [self addSubview:_labelExpectedtime];
    
    [_labelExpectedtime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_imageViewHead.mas_bottom).with.offset(10);
        make.left.equalTo(_imageViewHead.mas_left).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(85, 12));
    }];

    _labelTime = [UILabel new];
    _labelTime.font = [UIFont systemFontOfSize:12.0f];
    _labelTime.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
    _labelTime.lineBreakMode = NSLineBreakByTruncatingTail;
    _labelTime.text = [NSString stringWithFormat:@"%@分钟", [dic objectForKey:@"times"]];
    [self addSubview:_labelTime];
    
    [_labelTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_labelExpectedtime.mas_top).with.offset(0);
        make.left.equalTo(_labelExpectedtime.mas_right).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(200, 12));
    }];
    
    _headHeight += 12 + 10;
    
    // 用约束的话需要等父级约束设置完了再设置子约束才行
    [self performSelector:@selector(handleDelegate) withObject:nil afterDelay:0.2];
}

- (void)handleDelegate {
    [self.delegate homeworkDetailHead:self height:_headHeight];
}

@end
