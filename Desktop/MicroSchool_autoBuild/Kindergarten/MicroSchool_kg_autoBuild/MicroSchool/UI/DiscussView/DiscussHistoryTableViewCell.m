//
//  DiscussHistoryTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14/12/8.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "DiscussHistoryTableViewCell.h"

@implementation DiscussHistoryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label_name = [[UILabel alloc] initWithFrame:CGRectMake(60, (60-20)/2, 160, 20)];
        _label_name.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_name.font = [UIFont systemFontOfSize:14.0f];
        _label_name.textColor = [UIColor blackColor];
        _label_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_name];
        
        _label_dateline = [[UILabel alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-75.0-20.0, (60-20)/2, 85.0, 20)];
        _label_dateline.lineBreakMode = NSLineBreakByWordWrapping;
        _label_dateline.font = [UIFont systemFontOfSize:13.0f];
        _label_dateline.textColor = [UIColor grayColor];
        _label_dateline.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_dateline];
        
        _imageView_img =[[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _imageView_img.contentMode = UIViewContentModeScaleToFill;
        _imageView_img.layer.masksToBounds = YES;
        _imageView_img.layer.cornerRadius = 40/2;
        [self.contentView addSubview:_imageView_img];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
