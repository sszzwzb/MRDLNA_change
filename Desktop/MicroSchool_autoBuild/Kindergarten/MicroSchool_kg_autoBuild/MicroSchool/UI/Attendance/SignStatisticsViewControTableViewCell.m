//
//  SignStatisticsViewControTableViewCell.m
//  MicroSchool
//
//  Created by banana on 16/9/13.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "SignStatisticsViewControTableViewCell.h"
#import "Masonry.h"
@implementation SignStatisticsViewControTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
//        self.headerImv = [[UIImageView alloc] init];
//        _headerImv.layer.cornerRadius = 22;
//        _headerImv.layer.masksToBounds = YES;
//        _headerImv.backgroundColor = [UIColor whiteColor];
//        _headerImv.frame = CGRectMake(12, 8, 44, 44);
//        [self.contentView addSubview:_headerImv];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.frame = CGRectMake(12, 11, [UIScreen mainScreen].applicationFrame.size.width - 24, 17);
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        [self.contentView addSubview:_nameLabel];
        
        self.leaveLabel = [[UILabel alloc] init];
        _leaveLabel.backgroundColor = [UIColor clearColor];
        _leaveLabel.font = [UIFont systemFontOfSize:14];
        _leaveLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        _leaveLabel.textAlignment = NSTextAlignmentLeft;
        [self.contentView addSubview:_leaveLabel];
        [_leaveLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(_nameLabel.mas_left).with.offset(0);
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(140, 14));
            
        }];
        
        
        self.tLabel = [[UILabel alloc] init];
        _tLabel.backgroundColor = [UIColor clearColor];
        _tLabel.font = [UIFont systemFontOfSize:14];
        _tLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        _tLabel.text = @"天";
        _tLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_tLabel];
        [_tLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            make.top.equalTo(_leaveLabel.mas_top).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(15, 13));
            
        }];
        
        self.numLabel = [[UILabel alloc] init];
        _numLabel.backgroundColor = [UIColor clearColor];
        _numLabel.font = [UIFont systemFontOfSize:14];
        _numLabel.textColor = [UIColor colorWithRed:227.0 / 255 green:110.0 / 255 blue:15.0 / 255 alpha:1];
        _numLabel.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_numLabel];
        [_numLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_tLabel.mas_left).with.offset(0);
            make.top.equalTo(_tLabel.mas_top).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(17, 14));
            
        }];
        
        self.lateLabel = [[UILabel alloc] init];
        _lateLabel.backgroundColor = [UIColor clearColor];
        _lateLabel.font = [UIFont systemFontOfSize:14];
        _lateLabel.text = @"本月迟到/早退";
        _lateLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        _lateLabel.textAlignment = NSTextAlignmentRight;
        [self.contentView addSubview:_lateLabel];
        [_lateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(_numLabel.mas_left).with.offset(0);
            make.top.equalTo(_numLabel.mas_top).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(95, 14));
            
        }];

    }
    return self;
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
