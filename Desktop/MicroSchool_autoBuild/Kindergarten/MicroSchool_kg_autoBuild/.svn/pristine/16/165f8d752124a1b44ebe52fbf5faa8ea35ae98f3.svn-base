//
//  WeeklyRecipesTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 3/15/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "WeeklyRecipesTableViewCell.h"

@implementation WeeklyRecipesTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:15.0f];
        _dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _dateLabel.textAlignment = NSTextAlignmentLeft;
        _dateLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_dateLabel];
        
        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset([Utilities convertPixsH:13]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10, 15));
        }];

        _greenMarkView = [UIView new];
        _greenMarkView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        [self.contentView addSubview:_greenMarkView];
        [_greenMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.mas_top).with.offset(-1);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake([Utilities convertPixsH:3], [Utilities convertPixsH:21]));
        }];

        _icon1ImageView = [UIImageView new];
        _icon1ImageView.hidden = YES;
        _icon1ImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon1ImageView];
        
        [_icon1ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];

        _title1Label = [UILabel new];
        _title1Label.font = [UIFont systemFontOfSize:14.0f];
        _title1Label.lineBreakMode = NSLineBreakByTruncatingTail;
        _title1Label.textAlignment = NSTextAlignmentLeft;
        _title1Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_title1Label];
        
        [_title1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_dateLabel.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(_icon1ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
        }];

        _content1Label = [UILabel new];
        _content1Label.font = [UIFont systemFontOfSize:14.0f];
        _content1Label.lineBreakMode = NSLineBreakByWordWrapping;
        _content1Label.numberOfLines = 0;
        _content1Label.textAlignment = NSTextAlignmentLeft;
        _content1Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_content1Label];
        
        [_content1Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title1Label.mas_bottom).with.offset([Utilities convertPixsH:10]);
            make.left.equalTo(_icon1ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities convertPixsW:10]);
        }];
        
        _icon2ImageView = [UIImageView new];
        _icon2ImageView.hidden = YES;
        _icon2ImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon2ImageView];
        
        [_icon2ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content1Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];

        _title2Label = [UILabel new];
        _title2Label.font = [UIFont systemFontOfSize:14.0f];
        _title2Label.lineBreakMode = NSLineBreakByTruncatingTail;
        _title2Label.textAlignment = NSTextAlignmentLeft;
        _title2Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_title2Label];
        
        [_title2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content1Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(_icon1ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
        }];
        
        _content2Label = [UILabel new];
        _content2Label.font = [UIFont systemFontOfSize:14.0f];
        _content2Label.lineBreakMode = NSLineBreakByWordWrapping;
        _content2Label.numberOfLines = 0;
        _content2Label.textAlignment = NSTextAlignmentLeft;
        _content2Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_content2Label];
        
        [_content2Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title2Label.mas_bottom).with.offset([Utilities convertPixsH:10]);
            make.left.equalTo(_icon1ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities convertPixsW:10]);
        }];

        _icon3ImageView = [UIImageView new];
        _icon3ImageView.hidden = YES;
        _icon3ImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon3ImageView];
        
        [_icon3ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content2Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        _title3Label = [UILabel new];
        _title3Label.font = [UIFont systemFontOfSize:14.0f];
        _title3Label.lineBreakMode = NSLineBreakByTruncatingTail;
        _title3Label.textAlignment = NSTextAlignmentLeft;
        _title3Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_title3Label];
        
        [_title3Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content2Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(_icon2ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
        }];
        
        _content3Label = [UILabel new];
        _content3Label.font = [UIFont systemFontOfSize:14.0f];
        _content3Label.lineBreakMode = NSLineBreakByWordWrapping;
        _content3Label.numberOfLines = 0;
        _content3Label.textAlignment = NSTextAlignmentLeft;
        _content3Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_content3Label];
        
        [_content3Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title3Label.mas_bottom).with.offset([Utilities convertPixsH:10]);
            make.left.equalTo(_icon2ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities convertPixsW:10]);
        }];

        _icon4ImageView = [UIImageView new];
        _icon4ImageView.hidden = YES;
        _icon4ImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon4ImageView];
        
        [_icon4ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content3Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        _title4Label = [UILabel new];
        _title4Label.font = [UIFont systemFontOfSize:14.0f];
        _title4Label.lineBreakMode = NSLineBreakByTruncatingTail;
        _title4Label.textAlignment = NSTextAlignmentLeft;
        _title4Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_title4Label];
        
        [_title4Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content3Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(_icon3ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
        }];
        
        _content4Label = [UILabel new];
        _content4Label.font = [UIFont systemFontOfSize:14.0f];
        _content4Label.lineBreakMode = NSLineBreakByWordWrapping;
        _content4Label.numberOfLines = 0;
        _content4Label.textAlignment = NSTextAlignmentLeft;
        _content4Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_content4Label];
        
        [_content4Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title4Label.mas_bottom).with.offset([Utilities convertPixsH:10]);
            make.left.equalTo(_icon3ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities convertPixsW:10]);
        }];

        _icon5ImageView = [UIImageView new];
        _icon5ImageView.hidden = YES;
        _icon5ImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_icon5ImageView];
        
        [_icon5ImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content4Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(self.contentView.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        _title5Label = [UILabel new];
        _title5Label.font = [UIFont systemFontOfSize:14.0f];
        _title5Label.lineBreakMode = NSLineBreakByTruncatingTail;
        _title5Label.textAlignment = NSTextAlignmentLeft;
        _title5Label.textColor = [[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0];
        [self.contentView addSubview:_title5Label];
        
        [_title5Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_content4Label.mas_bottom).with.offset([Utilities convertPixsH:18]);
            make.left.equalTo(_icon4ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-17-10, 17));
        }];
        
        _content5Label = [UILabel new];
        _content5Label.font = [UIFont systemFontOfSize:14.0f];
        _content5Label.lineBreakMode = NSLineBreakByWordWrapping;
        _content5Label.numberOfLines = 0;
        _content5Label.textAlignment = NSTextAlignmentLeft;
        _content5Label.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_content5Label];
        
        [_content5Label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_title5Label.mas_bottom).with.offset([Utilities convertPixsH:10]);
            make.left.equalTo(_icon4ImageView.mas_right).with.offset([Utilities convertPixsW:10]);
            make.right.equalTo(self.mas_right).with.offset(-[Utilities convertPixsW:10]);
        }];

        
        
        
        
        
        
#if 0
        
        _iconImageView = [UIImageView new];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:_iconImageView];
        
        [_iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            
            make.size.mas_equalTo(CGSizeMake(17, 17));
        }];
        
        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.backgroundColor = [UIColor clearColor];
        _titleLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(_iconImageView.mas_right).with.offset(10);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-20, 15));
        }];
        
        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        _thumbImageView.layer.masksToBounds = YES;
        [self.contentView addSubview:_thumbImageView];
        
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.left.equalTo(self.mas_left).with.offset(10);
            
            make.size.mas_equalTo(CGSizeMake(90, 90));
        }];
        _thumbImageView.layer.cornerRadius = 5;
        
        _contentLabel = [UILabel new];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _contentLabel.textAlignment = NSTextAlignmentLeft;
        _contentLabel.numberOfLines = 0;
        _contentLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_contentLabel];
        
        [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_thumbImageView.mas_top).with.offset(10);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(10);
        }];
        
        _picsNumberLabel = [UILabel new];
        _picsNumberLabel.font = [UIFont systemFontOfSize:12.0f];
        _picsNumberLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _picsNumberLabel.textAlignment = NSTextAlignmentLeft;
        _picsNumberLabel.backgroundColor = [UIColor clearColor];
        _picsNumberLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self.contentView addSubview:_picsNumberLabel];
        
        [_picsNumberLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.mas_bottom).with.offset(-8);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(10);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-10-10-20, 12));
        }];
        
        //        _thumbImageView = [UIImageView new];
        //        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        //        [self.contentView addSubview:_thumbImageView];
        //
        //        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        //            make.top.equalTo(_iconImageView.mas_bottom).with.offset([Utilities convertPixs:12]);
        //            make.left.equalTo(self.mas_left).with.offset([Utilities convertPixs:10]);
        //            make.size.mas_equalTo(CGSizeMake([Utilities convertPixs:90], [Utilities convertPixs:90]));
        //        }];
        
        _downLineImageView = [UIImageView new];
        [_downLineImageView setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_downLineImageView];
        
        [_downLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).with.offset(-1);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 1));
        }];
        
        _upLineImageView = [UIImageView new];
        [_upLineImageView setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:_upLineImageView];
        
        [_upLineImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(35);
            make.left.equalTo(_thumbImageView.mas_right).with.offset(-2);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, 1));
        }];
#endif
    }
    return self;
}

- (void)updateCellConstraints {
    [self mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_content1Label.mas_bottom).with.offset(1);

        
//        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width, _content1Label.));
    }];
}

@end
