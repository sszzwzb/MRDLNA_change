//
//  NewsTableViewCell.h
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-9.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "NetworkUtility.h"
#import "UIImageView+WebCache.h"

@interface NewsTableViewCell : UITableViewCell
{
//    UILabel *label_content;
//    UILabel *label_contentDetail;
//    UILabel *label_date;
}

@property (copy, nonatomic) UILabel *label_content;
@property (copy, nonatomic) UILabel *label_contentDetail;
@property (copy, nonatomic) UILabel *label_date;
@property (nonatomic, retain) UIImageView *imgView_stick;
@property (nonatomic, retain) UIImageView *imgView_edit;

#if BUREAU_OF_EDUCATION
// 下属学校标签
@property (nonatomic, retain) UIImageView *imgView_edu;
#endif

@property (nonatomic,strong) UILabel *label_viewNum;//viewnum浏览次数
@property (nonatomic,strong) UIImageView *eyeImage;
@property (nonatomic,strong) UIImageView *viewTime;
@end