//
//  FriendProfileTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 15/7/22.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "FriendProfileTableViewCell.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width

@implementation FriendProfileTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label_name = [[UILabel alloc] initWithFrame:CGRectMake(15, 10, 60, 30)];
        _label_name.lineBreakMode = NSLineBreakByWordWrapping;
        _label_name.font = [UIFont systemFontOfSize:15.0f];
        _label_name.textColor = [UIColor darkGrayColor];
        _label_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_name];
        
        _label_detail = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                  _label_name.frame.origin.x + _label_name.frame.size.width + 20,
                                                                  _label_name.frame.origin.y, WIDTH-100, 30)];
        _label_detail.lineBreakMode = NSLineBreakByTruncatingTail;
        _label_detail.font = [UIFont systemFontOfSize:15.0f];
        _label_detail.textColor = [UIColor blackColor];
        _label_detail.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_detail];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
