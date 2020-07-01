//
//  BroadcastHistTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 15/1/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "BroadcastHistTableViewCell.h"

@implementation BroadcastHistTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // 内容
        _label_message = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    20,
                                                                    10,
                                                                    280,
                                                                    20)];
        _label_message.font = [UIFont systemFontOfSize:16.0f];
        _label_message.textColor = [UIColor blackColor];
        _label_message.backgroundColor = [UIColor clearColor];
        _label_message.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_message];

        // 查看数
        _label_viewNum = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                   160,
                                                                   35,
                                                                   40,
                                                                   20)];
        _label_viewNum.font = [UIFont systemFontOfSize:12.0f];
        _label_viewNum.textColor = [UIColor grayColor];
        _label_viewNum.backgroundColor = [UIColor clearColor];
        _label_viewNum.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_viewNum];

        // 日期
        _label_dateline = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                    200,
                                                                    35,
                                                                    120,
                                                                    20)];
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:12.0f];
        _label_dateline.numberOfLines = 0;
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        _label_dateline.lineBreakMode = NSLineBreakByTruncatingTail;
        [self.contentView addSubview:_label_dateline];
        
        // 查看详情img
        _imgView_viewNum =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                       141,
                                                                       37,
                                                                       15,
                                                                       15)];
        _imgView_viewNum.contentMode = UIViewContentModeScaleToFill;
        [_imgView_viewNum setImage:[UIImage imageNamed:@"icon_broadcast_viewnum.png"]];
        [self.contentView addSubview:_imgView_viewNum];

        // 每条cell最下方的线
        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(20,59,280,1)];
        [_imgView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_imgView_line];

    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
