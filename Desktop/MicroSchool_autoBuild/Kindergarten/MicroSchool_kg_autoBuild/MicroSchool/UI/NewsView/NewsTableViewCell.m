//
//  NewsTableViewCell.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NewsTableViewCell.h"
#import "Masonry.h"

// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation NewsTableViewCell

//@synthesize content;
//@synthesize contentdetail;
//
//@synthesize date;
//@synthesize imgView_stick;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];

    if (self) {
        // Initialization code
        
        float width = 280;
        // 内容简报标题
        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
            width = 280;
        }
        //标题
        _label_content = [UILabel new];
        //设置title自适应对齐
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:15.0f];
        _label_content.numberOfLines = 1;
        //label_content.adjustsFontSizeToFitWidth = YES;
        _label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_content.textAlignment = NSTextAlignmentLeft;
        _label_content.backgroundColor = [UIColor clearColor];
        _label_content.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label_content];
        [_label_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(16);
            make.left.equalTo(self.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(120,15));
        }];
        
        // 置顶
        _imgView_stick =[UIImageView new];
        _imgView_stick.contentMode = UIViewContentModeScaleToFill;
        [_imgView_stick setImage:[UIImage imageNamed:@"icon_top.png"]];
        [self.contentView addSubview:_imgView_stick];
        [_imgView_stick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(14);
            make.left.equalTo(_label_content.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(21,21));
        }];

        // 是否可编辑
        _imgView_edit =[UIImageView new];
        _imgView_edit.contentMode = UIViewContentModeScaleToFill;
        [_imgView_edit setImage:[UIImage imageNamed:@"news/icon_ping"]];
        [self.contentView addSubview:_imgView_edit];
        [_imgView_edit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(14);
            make.left.equalTo(_imgView_stick.mas_right).with.offset(2);
            make.size.mas_equalTo(CGSizeMake(21,21));
        }];
        // 内容简报内容
        _label_contentDetail = [UILabel new];
        //设置title自适应对齐
        _label_contentDetail.lineBreakMode = NSLineBreakByWordWrapping;
        _label_contentDetail.font = [UIFont systemFontOfSize:13.0f];
        _label_contentDetail.numberOfLines = 1;
        //label_contentDetail.adjustsFontSizeToFitWidth = YES;ret
        _label_contentDetail.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_contentDetail.textAlignment = NSTextAlignmentLeft;
        _label_contentDetail.textColor = [UIColor grayColor];
        _label_contentDetail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_contentDetail];
        [_label_contentDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_content.mas_top).with.offset(15);
            make.left.equalTo(_label_content.mas_left).with.offset(1);
            make.size.mas_equalTo(CGSizeMake(290,39));
        }];

        // 日期
        _label_date = [UILabel new];
        _label_date.font = [UIFont systemFontOfSize:12.0f];
        _label_date.textColor = [UIColor grayColor];
        _label_date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_date];
        [_label_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(70);
            make.left.equalTo(self.mas_left).with.offset(WIDTH/3*2+25);
            make.size.mas_equalTo(CGSizeMake(100,15));
        }];
//#3.22时间图标
        _viewTime = [UIImageView new];
        [_viewTime setImage:[UIImage imageNamed:@"viewTime.png"]];
        [self.contentView addSubview:_viewTime];
        [_viewTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(1);
            make.left.equalTo(self.mas_left).with.offset(WIDTH/3*2+11);
            make.size.mas_equalTo(CGSizeMake(12,12));
        }];

        
#if BUREAU_OF_EDUCATION
        // 下属学校标签
        _imgView_edu =[UIImageView new];
        _imgView_edu.contentMode = UIViewContentModeScaleToFill;
        [_imgView_edu setImage:[UIImage imageNamed:@"news/icon_edu"]];
        [self.contentView addSubview:_imgView_edu];
        [_imgView_edu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(0);
            make.left.equalTo(_label_content.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(51,15));
        }];
#endif

        //----add by kate 2015.03.19--------------------------------------
        _label_viewNum = [UILabel new];
        //设置title自适应对齐
        _label_viewNum.lineBreakMode = NSLineBreakByWordWrapping;
        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        _label_viewNum.textColor = [UIColor grayColor];
        //label_content.numberOfLines = 0;
        //label_content.adjustsFontSizeToFitWidth = YES;
        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_viewNum.textAlignment = NSTextAlignmentLeft;
        _label_viewNum.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_viewNum];
        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(WIDTH/3*2-17);
            make.size.mas_equalTo(CGSizeMake(28,15));
        }];
        //----------------------------------------------------------------
        _eyeImage = [UIImageView new];
        [_eyeImage setImage:[UIImage imageNamed:@"icon_liulan.png"]];
        [self.contentView addSubview:_eyeImage];
        [_eyeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(1);
            make.left.equalTo(self.mas_left).with.offset(WIDTH/3*2-30);
            make.size.mas_equalTo(CGSizeMake(12,12));
        }];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[UIImageView new];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
        [imgView_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(94);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,1));
        }];
    }
    return self;
}
-(void)viewWillAppear:(BOOL)animated
{
}

//- (void) layoutSubviews {
////    [super layoutSubviews];
//    self.backgroundView.frame = CGRectMake(9, 0, 302, 100);
//    self.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 100);
//    NSLog(@"self.backgroundView.frame.size.width is %f", self.backgroundView.frame.size.width);
//    NSLog(@"self.backgroundView.frame.size.height is %f", self.backgroundView.frame.size.height);
//}

//- (void)setFrame:(CGRect)frame
//{
////    frame.origin.x += 120;
////    frame.size.width -= 120;
//    frame = CGRectMake(9, 0, 302, 100);
//    [super setFrame:frame];
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
