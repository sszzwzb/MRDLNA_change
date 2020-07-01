//
//  NewsImgTableViewCell.h
//  MicroSchool
//
//  Created by jojo on 13-12-19.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkUtility.h"
#import "UIImageView+WebCache.h"

@interface NewsImgTableViewCell2 : UITableViewCell
{
}

@property (strong, nonatomic) UILabel *label_content;
@property (strong, nonatomic) UILabel *label_contentDetail;
@property (strong, nonatomic) UILabel *label_date;
//缩略图
@property (nonatomic, retain) UIImageView *imgView_thumb;
//赞
@property (nonatomic, retain) UIImageView *imgView_stick;
//评论
@property (nonatomic, retain) UIImageView *imgView_edit;

#if BUREAU_OF_EDUCATION
// 下属学校标签
@property (nonatomic, retain) UIImageView *imgView_edu;
#endif

@property (nonatomic,strong) UILabel *label_viewNum;//viewnum浏览次数
@property (nonatomic, strong) UIImageView *seeImg;
@property (nonatomic, strong) UIImageView *commentImg;
@property (nonatomic, strong) UILabel *label_comment;
@property (nonatomic, strong) UIImageView *imgView_line1;
@property (nonatomic, strong) UIButton *btn_stick;
@property (nonatomic, strong) UIButton *btn_comment;
@end
