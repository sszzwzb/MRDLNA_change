//
//  NewsImgTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 13-12-19.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NewsImgTableViewCell2.h"
#import "Masonry.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation NewsImgTableViewCell2

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
#if 0
        // Initialization code
        
//        float width = 200;
//        // 内容简报标题
//        if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0) {
//            width = 195;
//        }
        
        // 是否可编辑
        //        _imgView_edit =[[UIImageView alloc]initWithFrame:CGRectMake(270, 11, 21, 21)];
        //        _imgView_edit.contentMode = UIViewContentModeScaleToFill;
        //        [_imgView_edit setImage:[UIImage imageNamed:@"news/icon_ping"]];
        //        [self.contentView addSubview:_imgView_edit];
        self.imgView_edit = [UIImageView new];
        _imgView_edit.backgroundColor = [UIColor whiteColor];
        [_imgView_edit setImage:[UIImage imageNamed:@"news/icon_ping.png"]];
        [self.contentView addSubview:_imgView_edit];
        [_imgView_edit mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            
        }];
        
        
        // 置顶
//        _imgView_stick =[[UIImageView alloc]initWithFrame:CGRectMake(270, 11, 21, 21)];
//        _imgView_stick.contentMode = UIViewContentModeScaleToFill;
//        [_imgView_stick setImage:[UIImage imageNamed:@"icon_top.png"]];
//        [self.contentView addSubview:_imgView_stick];
        self.imgView_stick = [UIImageView new];
        [_imgView_stick setImage:[UIImage imageNamed:@"icon_top.png"]];
        [self.contentView addSubview:_imgView_stick];
        [_imgView_stick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.right.equalTo(_imgView_edit.mas_left).with.offset(-5);
            make.size.mas_equalTo(CGSizeMake(15, 15));
            
        }];

        


        
        // 缩略图
//        _imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(20,20,70,60)];
//        _imgView_thumb.contentMode = UIViewContentModeScaleToFill;
//        [self.contentView addSubview:_imgView_thumb];
        self.imgView_thumb =[UIImageView new];
        _imgView_thumb.contentMode = UIViewContentModeScaleAspectFill;
        _imgView_thumb.clipsToBounds = YES;
//        _imgView_thumb.layer.cornerRadius = 4;
//        _imgView_thumb.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView_thumb];
        [_imgView_thumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(100,75));
        }];

        
        
        // 内容简报标题
//        _label_content = [[UILabel alloc] initWithFrame:CGRectMake(
//                                                                   _imgView_thumb.frame.origin.x + _imgView_thumb.frame.size.width + 8,
//                                                                   _imgView_thumb.frame.origin.y-5,
//                                                                   width,
//                                                                   18)];
//        //设置title自适应对齐
//        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
//        _label_content.font = [UIFont systemFontOfSize:16.0f];
//        //label_content.numberOfLines = 0;
//        //label_content.adjustsFontSizeToFitWidth = YES;
//        _label_content.lineBreakMode = NSLineBreakByTruncatingTail;
//        _label_content.textAlignment = NSTextAlignmentLeft;
//        _label_content.backgroundColor = [UIColor clearColor];
//        _label_content.textColor = [UIColor blackColor];
//        [self.contentView addSubview:_label_content];
        // 内容简报标题
        self.label_content = [UILabel new];
        //设置title自适应对齐
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:16.0f];
        _label_content.numberOfLines = 1;
        _label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_content.textAlignment = NSTextAlignmentLeft;
        _label_content.backgroundColor = [UIColor whiteColor];
        _label_content.textColor = [UIColor blackColor];
        [self.contentView addSubview:_label_content];
        [_label_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.left.equalTo(_imgView_thumb.mas_right).with.offset(12);
            //            make.size.mas_equalTo(CGSizeMake(120,18));
            make.bottom.equalTo(self.contentView.mas_top).with.offset(31);
            make.right.equalTo(_imgView_stick.mas_left).with.offset(0);
        }];

        
        // 内容简报内容
//        _label_contentDetail = [[UILabel alloc] initWithFrame:CGRectMake(_label_content.frame.origin.x,
//                                                                         _label_content.frame.origin.y + 15,
//                                                                         _label_content.frame.size.width,
//                                                                         39)];
//        //设置title自适应对齐
//        _label_contentDetail.lineBreakMode = NSLineBreakByWordWrapping;
//        _label_contentDetail.font = [UIFont systemFontOfSize:12.0f];
//        _label_contentDetail.numberOfLines = 2;
//        //label_contentDetail.adjustsFontSizeToFitWidth = YES;ret
//        _label_contentDetail.lineBreakMode = NSLineBreakByTruncatingTail;
//        _label_contentDetail.textAlignment = NSTextAlignmentLeft;
//        _label_contentDetail.textColor = [UIColor grayColor];
//        _label_contentDetail.backgroundColor = [UIColor clearColor];
//        [self.contentView addSubview:_label_contentDetail];
        
        // 内容简报内容
        self.label_contentDetail =[UILabel new];
        //设置title自适应对齐
        _label_contentDetail.lineBreakMode = NSLineBreakByWordWrapping;
        _label_contentDetail.font = [UIFont systemFontOfSize:13.0f];
        _label_contentDetail.numberOfLines = 0;
        _label_contentDetail.lineBreakMode = NSLineBreakByWordWrapping
        ;
        _label_contentDetail.textAlignment = NSTextAlignmentLeft;
        _label_contentDetail.textColor = [UIColor grayColor];
        _label_contentDetail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_contentDetail];
        [_label_contentDetail mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_content.mas_bottom).with.offset(6);
            make.left.equalTo(_label_content.mas_left).with.offset(0);
//            make.size.mas_equalTo(CGSizeMake(130,20));
            make.bottom.equalTo(self.contentView.mas_top).with.offset(75);
            //            make.bottom.equalTo(self.contentView.mas_top).with.offset(83);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        }];

        

        //----add by kate 2015.03.19--------------------------------------
        //        _label_viewNum = [[UILabel alloc] initWithFrame:CGRectMake(_label_content.frame.origin.x, _label_date.frame.origin.y, 100, 15)];
        //        //设置title自适应对齐
        //        _label_viewNum.lineBreakMode = NSLineBreakByWordWrapping;
        //        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        //        _label_viewNum.textColor = [UIColor grayColor];
        //        //label_content.numberOfLines = 0;
        //        //label_content.adjustsFontSizeToFitWidth = YES;
        //        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        //        _label_viewNum.textAlignment = NSTextAlignmentLeft;
        //        _label_viewNum.backgroundColor = [UIColor clearColor];
        //        [self.contentView addSubview:_label_viewNum];
        //----------------------------------------------------------------
        
        
        // 日期
        self.label_date =[UILabel new];
        _label_date.font = [UIFont systemFontOfSize:12.0f];
        _label_date.textColor = [UIColor grayColor];
        _label_date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_date];
        //        [_label_date mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_label_viewNum.mas_top).with.offset(0);
        //            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2+25);
        //            make.size.mas_equalTo(CGSizeMake(100,15));
        //        }];
        [_label_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(6);
            make.left.equalTo(_label_contentDetail.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(80,12));
        }];
        
        self.seeImg = [UIImageView new];
        [_seeImg setImage:[UIImage imageNamed:@"icon_see.png"]];
        [self.contentView addSubview:_seeImg];
        [_seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(0);
            make.left.equalTo(_label_date.mas_right).with.offset(6);
            make.size.mas_equalTo(CGSizeMake(15, 12));
            
        }];
        
        self.label_viewNum =[UILabel new];
        //设置title自适应对齐
        _label_viewNum.lineBreakMode = NSLineBreakByWordWrapping;
        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        _label_viewNum.textColor = [UIColor grayColor];
        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_viewNum.textAlignment = NSTextAlignmentLeft;
        _label_viewNum.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_viewNum];
        //        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(10);
        //            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2-17);
        //            make.size.mas_equalTo(CGSizeMake(28,15));
        //        }];
        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(0);
            make.left.equalTo(_seeImg.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(25,12));
        }];
        
        
        self.commentImg = [UIImageView new];
        [_commentImg setImage:[UIImage imageNamed:@"icon_comment.png"]];
        [self.contentView addSubview:_commentImg];
        [_commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_date.mas_top).with.offset(0);
            make.left.equalTo(_label_viewNum.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(15, 12));
            
        }];
        
        self.label_comment =[UILabel new];
        //设置title自适应对齐
        _label_comment.lineBreakMode = NSLineBreakByWordWrapping;
        _label_comment.font = [UIFont systemFontOfSize:12.0f];
        _label_comment.textColor = [UIColor grayColor];
        _label_comment.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_comment.textAlignment = NSTextAlignmentLeft;
        _label_comment.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_comment];
        //        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(10);
        //            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2-17);
        //            make.size.mas_equalTo(CGSizeMake(28,15));
        //        }];
        [_label_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_commentImg.mas_top).with.offset(0);
            make.left.equalTo(_commentImg.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(25,12));
        }];
        
        // 日期
        //        _label_date = [[UILabel alloc] initWithFrame:CGRectMake(_label_contentDetail.frame.origin.x,
        //                                                                _label_contentDetail.frame.origin.y + _label_content.frame.size.height + 25,
        //                                                                _label_contentDetail.frame.size.width,
        //                                                                15)];
        //        _label_date.font = [UIFont systemFontOfSize:12.0f];
        //        _label_date.textColor = [UIColor grayColor];
        //        _label_date.backgroundColor = [UIColor clearColor];
        //        _label_date.textAlignment = NSTextAlignmentRight;
        //
        //        [self.contentView addSubview:_label_date];
        
        
        
#if BUREAU_OF_EDUCATION
        // 下属学校标签
        _imgView_edu =[UIImageView new];
        _imgView_edu.contentMode = UIViewContentModeScaleToFill;
        [_imgView_edu setImage:[UIImage imageNamed:@"news/icon_edu"]];
        [self.contentView addSubview:_imgView_edu];
        [_imgView_edu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(10);
            make.left.equalTo(_label_contentDetail.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(50,15));
        }];
#endif
        
        
        
        
        // 每条cell最下方的线
        //        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,98,280,1)];
        //        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        //        [self.contentView addSubview:imgView_line1];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[UIImageView new];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
        [imgView_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(104);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,1));
        }];
        
#if 0
        self.label_viewNum =[UILabel new];
        //设置title自适应对齐
        _label_viewNum.lineBreakMode = NSLineBreakByWordWrapping;
        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        _label_viewNum.textColor = [UIColor grayColor];
        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_viewNum.textAlignment = NSTextAlignmentLeft;
        _label_viewNum.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_viewNum];
        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(10);
            make.left.equalTo(_imgView_thumb.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(60,15));
        }];
        
        // 日期
        //        _label_date = [[UILabel alloc] initWithFrame:CGRectMake(_label_contentDetail.frame.origin.x,
        //                                                                _label_contentDetail.frame.origin.y + _label_content.frame.size.height + 25,
        //                                                                _label_contentDetail.frame.size.width,
        //                                                                15)];
        //        _label_date.font = [UIFont systemFontOfSize:12.0f];
        //        _label_date.textColor = [UIColor grayColor];
        //        _label_date.backgroundColor = [UIColor clearColor];
        //        _label_date.textAlignment = NSTextAlignmentRight;
        //
        //        [self.contentView addSubview:_label_date];
        
        
        // 日期
        self.label_date =[UILabel new];
        _label_date.font = [UIFont systemFontOfSize:12.0f];
        _label_date.textColor = [UIColor grayColor];
        _label_date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_date];
        [_label_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_viewNum.mas_top).with.offset(0);
            make.left.equalTo(_label_viewNum.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(120,15));
        }];
        
#if BUREAU_OF_EDUCATION
        // 下属学校标签
        _imgView_edu =[UIImageView new];
        _imgView_edu.contentMode = UIViewContentModeScaleToFill;
        [_imgView_edu setImage:[UIImage imageNamed:@"news/icon_edu"]];
        [self.contentView addSubview:_imgView_edu];
        [_imgView_edu mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_label_contentDetail.mas_bottom).with.offset(10);
            make.left.equalTo(_label_contentDetail.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(50,15));
        }];
#endif

        

        
        // 每条cell最下方的线
//        UIImageView *imgView_line1 =[[UIImageView alloc]initWithFrame:CGRectMake(20,98,280,1)];
//        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
//        [self.contentView addSubview:imgView_line1];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[UIImageView new];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
        [imgView_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(94);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,1));
        }];
#endif
#endif
        // 缩略图
        //        _imgView_thumb =[[UIImageView alloc]initWithFrame:CGRectMake(20,20,70,60)];
        //        _imgView_thumb.contentMode = UIViewContentModeScaleToFill;
        //        [self.contentView addSubview:_imgView_thumb];
        self.imgView_thumb =[UIImageView new];
        _imgView_thumb.contentMode = UIViewContentModeScaleAspectFill;
        _imgView_thumb.clipsToBounds = YES;
        //        _imgView_thumb.layer.cornerRadius = 4;
        //        _imgView_thumb.layer.masksToBounds = YES;
        [self.contentView addSubview:_imgView_thumb];
        [_imgView_thumb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
            make.size.mas_equalTo(CGSizeMake(100,75));
        }];
        
        // 内容简报标题
        self.label_content = [UILabel new];
        //设置title自适应对齐
        _label_content.lineBreakMode = NSLineBreakByWordWrapping;
        _label_content.font = [UIFont systemFontOfSize:16.0f];
        _label_content.numberOfLines = 1;
        _label_content.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_content.textAlignment = NSTextAlignmentLeft;
        _label_content.backgroundColor = [UIColor clearColor];
        _label_content.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        [self.contentView addSubview:_label_content];
        [_label_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(12);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 36 - 100 ,18));
            //            make.bottom.equalTo(self.contentView.mas_top).with.offset(31);
            //            make.right.equalTo(self.contentView.mas_right).with.offset(-12);
        }];
        
        self.btn_stick = [UIButton new];
        [_btn_stick setTitle:[NSString stringWithFormat:@"置顶"] forState: UIControlStateNormal];
        [_btn_stick setTitleColor:[UIColor colorWithRed:51.0 / 255 green:153.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateNormal];
        _btn_stick.titleLabel.font = [UIFont systemFontOfSize:11];
        _btn_stick.hidden = YES;
        [self.contentView addSubview:_btn_stick];
        [_btn_stick mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(28,11));
            //            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            //            make.right.equalTo(self.contentView.mas_left).with.offset(34);
        }];
        
        self.btn_comment = [UIButton new];
        [_btn_comment setTitle:[NSString stringWithFormat:@"评论"] forState: UIControlStateNormal];
        [_btn_comment setTitleColor:[UIColor colorWithRed:255.0 / 255 green:156.0 / 255 blue:0 / 255 alpha:1] forState:UIControlStateNormal];
        _btn_comment.titleLabel.font = [UIFont systemFontOfSize:11];
        _btn_comment.hidden = YES;
        [self.contentView addSubview:_btn_comment];
        [_btn_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).with.offset(-25);
            make.left.equalTo(self.contentView.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake(28,11));
            //            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            //            make.right.equalTo(_btn_stick.mas_right).with.offset(27);
        }];
        
        
        
        // 日期
        self.label_date =[UILabel new];
        _label_date.font = [UIFont systemFontOfSize:12.0f];
        _label_date.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255  blue:153.0 / 255 alpha:1];
        _label_date.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_label_date];
        [_label_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            make.left.equalTo(_btn_comment.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(74,12));
        }];
        
        self.seeImg = [UIImageView new];
        [_seeImg setImage:[UIImage imageNamed:@"icon_see.png"]];
        _seeImg.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_seeImg];
        [_seeImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            make.left.equalTo(_label_date.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 12));
            
        }];
        
        self.label_viewNum =[UILabel new];
        //设置title自适应对齐
        _label_viewNum.lineBreakMode = NSLineBreakByWordWrapping;
        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        _label_viewNum.textColor = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_viewNum.textAlignment = NSTextAlignmentLeft;
        _label_viewNum.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_label_viewNum];
        [_label_viewNum mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            make.left.equalTo(_seeImg.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(25,12));
        }];
        
        
        self.commentImg = [UIImageView new];
        [_commentImg setImage:[UIImage imageNamed:@"icon_comment.png"]];
        [self.contentView addSubview:_commentImg];
        [_commentImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            make.left.equalTo(_label_viewNum.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(15, 12));
            
        }];
        
        self.label_comment =[UILabel new];
        //设置title自适应对齐
        _label_comment.lineBreakMode = NSLineBreakByWordWrapping;
        _label_comment.font = [UIFont systemFontOfSize:12.0f];
        _label_comment.textColor = [UIColor grayColor];
        _label_comment.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_comment.textAlignment = NSTextAlignmentLeft;
        _label_comment.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_comment];
        [_label_comment mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-14);
            make.left.equalTo(_commentImg.mas_right).with.offset(5);
            make.size.mas_equalTo(CGSizeMake(25,12));
        }];
        
        // 每条cell最下方的线
        self.imgView_line1 =[UIImageView new];
        [_imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_imgView_line1];
        [_imgView_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.contentView.mas_bottom).with.offset(-1);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,1));
        }];
        
        
    
    }
    return self;
}

//- (void) layoutSubviews {
//    [super layoutSubviews];
//    self.backgroundView.frame = CGRectMake(9, 0, 302, 100);
//    self.selectedBackgroundView.frame = CGRectMake(9, 0, 302, 100);
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
