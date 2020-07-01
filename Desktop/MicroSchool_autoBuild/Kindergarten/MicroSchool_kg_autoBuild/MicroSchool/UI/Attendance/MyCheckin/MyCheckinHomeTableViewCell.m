//
//  MyCheckinHomeTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 9/18/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "MyCheckinHomeTableViewCell.h"
#import "Utilities.h"
#import "UIGuidelineDefine.h"

#import "Masonry.h"


#import "MJPhotoBrowser.h"
#import "MJPhoto.h"

@implementation MyCheckinHomeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _checkinTimeLabel = [UILabel new];
        _checkinTimeLabel.font = [UIFont systemFontOfSize:13];
        _checkinTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _checkinTimeLabel.textAlignment = NSTextAlignmentLeft;
        _checkinTimeLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self.contentView addSubview:_checkinTimeLabel];
        
        [_checkinTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(15);
            make.left.equalTo(self.contentView.mas_left).with.offset(18);
            make.size.mas_equalTo(CGSizeMake(37, 13));
        }];
        
        _checkinContentLabel = [UILabel new];
        _checkinContentLabel.font = [UIFont systemFontOfSize:15];
        _checkinContentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _checkinContentLabel.textAlignment = NSTextAlignmentLeft;
        _checkinContentLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_checkinContentLabel];
        
        [_checkinContentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_checkinTimeLabel.mas_top).with.offset(0);
            make.left.equalTo(_checkinTimeLabel.mas_right).with.offset(40);
            make.size.mas_equalTo(CGSizeMake(33, 15));
        }];
        
        _checkinStatusImageView = [UIImageView new];
        _checkinStatusImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_checkinStatusImageView];
        
        [_checkinStatusImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_checkinTimeLabel.mas_top).with.offset(1);
            make.left.equalTo(_checkinContentLabel.mas_right).with.offset(11);
            
            make.size.mas_equalTo(CGSizeMake(26, 13));
        }];
        
        _bottomLineImageView = [UIImageView new];
        _bottomLineImageView.contentMode = UIViewContentModeScaleAspectFill;
        _bottomLineImageView.backgroundColor = TS_COLOR_TABLEVIEW_SEPARATOR_RGB;
        [self.contentView addSubview:_bottomLineImageView];
        
        [_bottomLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_bottom).with.offset(-0.5);
            make.left.equalTo(_checkinTimeLabel.mas_left).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(-18);
            
            make.height.mas_equalTo(0.5);
        }];
        
        
        
        
        //
        
        
        _imgLogo = [[UIImageView alloc]initWithFrame:
                    CGRectMake(55, 43, 100, 75)];
        [self addSubview:_imgLogo];
        _imgLogo.backgroundColor = [UIColor clearColor];
        
        
        _imgLogoBut = [UIButton buttonWithType:(UIButtonTypeSystem)];
        _imgLogoBut.frame = CGRectMake(55, 43, 100, 75);
        [self addSubview:_imgLogoBut];
        _imgLogoBut.backgroundColor = [UIColor clearColor];
        
    }
    return self;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end