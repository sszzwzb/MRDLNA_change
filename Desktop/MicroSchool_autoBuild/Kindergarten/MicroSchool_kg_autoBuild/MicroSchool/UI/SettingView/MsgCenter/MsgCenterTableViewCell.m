//
//  MsgCenterTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14/11/13.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "MsgCenterTableViewCell.h"

@implementation MsgCenterTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label_subject = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_subject.lineBreakMode = NSLineBreakByTruncatingTail;
//        _label_subject.numberOfLines = 0;
        _label_subject.font = [UIFont systemFontOfSize:13.0f];
        _label_subject.textColor = [UIColor blackColor];
        _label_subject.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_subject];
        
        _label_message = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_message.lineBreakMode = NSLineBreakByTruncatingTail;
//        _label_message.numberOfLines = 0;
        _label_message.font = [UIFont systemFontOfSize:12.0f];
        _label_message.textColor = [UIColor grayColor];
        _label_message.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_message];
        
        _label_dateline = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_dateline.textAlignment = NSTextAlignmentRight;
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:11.0f];
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_dateline];
        
        _label_result = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_result.lineBreakMode = NSLineBreakByWordWrapping;
        _label_result.textAlignment = NSTextAlignmentRight;
        _label_result.font = [UIFont systemFontOfSize:12.0f];
        _label_result.textColor = [UIColor blackColor];
        _label_result.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_result];

        _imageView_img =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView_img.contentMode = UIViewContentModeScaleToFill;
        _imageView_img.layer.masksToBounds = YES;
        [self.contentView addSubview:_imageView_img];
        
        // 每条cell最下方的线
//        _imgView_line =[[UIImageView alloc]initWithFrame:CGRectMake(20,68,280,1)];
//        _imageView_line =[[UIImageView alloc]initWithFrame:CGRectZero];
//        [_imageView_line setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
//        [self.contentView addSubview:_imageView_line];
        
        //---add by kate 2015.01.27------------------------
//        self.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
//        self.contentView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1.0];
        //-------------------------------------------------
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
