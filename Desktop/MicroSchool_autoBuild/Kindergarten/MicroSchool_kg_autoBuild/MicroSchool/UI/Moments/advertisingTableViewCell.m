//
//  advertisingTableViewCell.m
//  MicroSchool
//
//  Created by banana on 16/11/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "advertisingTableViewCell.h"
#import "Masonry.h"
@implementation advertisingTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        
        //头像
        self.headImv = [[UIImageView alloc] init];
        _headImv.backgroundColor = [UIColor clearColor];
        _headImv.frame = CGRectMake(10, 10, 45, 45);
        _headImv.layer.cornerRadius = 45.0 / 2;
        _headImv.layer.masksToBounds = YES;
        _headImv.contentMode = UIViewContentModeScaleToFill;
        _headImv.userInteractionEnabled = YES;
        [self.contentView addSubview:_headImv];
        
        // 名字
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(
                                                                         _headImv.frame.origin.x + _headImv.frame.size.width + 10,
                                                                         15,
                                                                         240,
                                                                         15)];
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.numberOfLines = 0;
        _nameLabel.backgroundColor = [UIColor clearColor];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_nameLabel];
        
        // 描述
        self.describeLabel = [[UILabel alloc] init];
        _describeLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _describeLabel.font = [UIFont systemFontOfSize:14.0f];
        _describeLabel.backgroundColor = [UIColor clearColor];
        _describeLabel.numberOfLines = 0;
//        _describeLabel.backgroundColor = [UIColor clearColor];
        _describeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _describeLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_describeLabel];
        [_describeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_headImv.mas_left).with.offset(0);
            make.top.equalTo(_headImv.mas_bottom).with.offset(9);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].applicationFrame.size.width - 20, 16));
        }];

        
        
        //大图
        self.bigImv = [[UIImageView alloc] init];
        _bigImv.backgroundColor = [UIColor clearColor];
//        _bigImv.frame = CGRectMake(10, 10, 45, 45);
        _bigImv.layer.cornerRadius = 8;
        _bigImv.layer.masksToBounds = YES;
        _bigImv.contentMode = UIViewContentModeScaleToFill;
        _bigImv.userInteractionEnabled = YES;
        [self.contentView addSubview:_bigImv];
        [_bigImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_describeLabel.mas_left).with.offset(0);
            make.top.equalTo(_describeLabel.mas_bottom).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(240, 180));
        }];
        
        //背景灰
//        UIView *grayView = [[UIView alloc] init];
//        grayView.backgroundColor = [UIColor colorWithRed:242.0 / 255 green:242.0 / 255 blue:242.0 / 255 alpha:1];
//        grayView.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 45, 15, 35, 16);
//        [self.contentView addSubview:grayView];
        
        // 广告字样 Label
        self.advertisingLabel = [[UILabel alloc] init];
//        _advertisingLabel.frame = CGRectMake([UIScreen mainScreen].applicationFrame.size.width - 40, 15, 35, 16);
        _advertisingLabel.font = [UIFont systemFontOfSize:12.0f];
        _advertisingLabel.numberOfLines = 1;
        _advertisingLabel.backgroundColor = [UIColor clearColor];
        _advertisingLabel.contentMode = NSTextAlignmentCenter;
        _advertisingLabel.text = @"广告";
        _advertisingLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self.contentView addSubview:_advertisingLabel];
        [_advertisingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(_nameLabel.mas_left).with.offset(0);
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(9);
            make.size.mas_equalTo(CGSizeMake(35, 16));
        }];

        
        UIImageView *lineView =[[UIImageView alloc] init];
        lineView.image=[UIImage imageNamed:@"knowledge/tm.png"];
        [self.contentView addSubview:lineView];
        [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.top.equalTo(_bigImv.mas_bottom).with.offset(15);
            make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].applicationFrame.size.width, 1));
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
