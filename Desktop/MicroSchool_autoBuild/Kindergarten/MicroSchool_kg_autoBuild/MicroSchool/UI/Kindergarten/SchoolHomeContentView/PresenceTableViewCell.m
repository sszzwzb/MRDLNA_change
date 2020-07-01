//
//  PresenceTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 3/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "PresenceTableViewCell.h"

@implementation PresenceTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _touchedBgImageView = [TSTouchImageView new];
        _touchedBgImageView.contentMode = UIViewContentModeScaleAspectFill;
        _touchedBgImageView.clipsToBounds = YES;
        _touchedBgImageView.userInteractionEnabled = YES;
        _touchedBgImageView.backgroundColor = [UIColor whiteColor];
        _touchedBgImageView.layer.masksToBounds = YES;
        _touchedBgImageView.layer.cornerRadius = 5;
        [self.contentView addSubview:_touchedBgImageView];
        
        [_touchedBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset([Utilities convertPixsW:10]);
            
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-[Utilities convertPixsW:20],
                                             [Utilities convertPixsH:190]));
        }];

        TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(presenceClicked:)];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             _presenceInfo, @"presenceId",
                             nil];
        
        myTapGesture.infoDic = dic;
        [_touchedBgImageView addGestureRecognizer:myTapGesture];

        _thumbImageView = [UIImageView new];
        _thumbImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_touchedBgImageView addSubview:_thumbImageView];
        
        [_thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(_touchedBgImageView).with.insets(UIEdgeInsetsMake(0, 0, [Utilities convertPixsW:40], 0));
        }];
        
        _whiteImageView = [UIImageView new];
        _whiteImageView.contentMode = UIViewContentModeScaleAspectFill;
        _whiteImageView.backgroundColor = [UIColor whiteColor];
        [_touchedBgImageView addSubview:_whiteImageView];
        
        [_whiteImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_thumbImageView.mas_bottom).with.offset(0);
            make.left.equalTo(_thumbImageView.mas_left).with.offset(0);
            make.right.equalTo(_thumbImageView.mas_right).with.offset(0);
            make.bottom.equalTo(_touchedBgImageView.mas_bottom).with.offset(0);
        }];

        _titleLabel = [UILabel new];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_titleLabel];
        
        [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).with.offset(-26);
            make.left.equalTo(self.mas_left).with.offset(20);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-100, 17));
        }];

        _greenMarkView = [UIView new];
        _greenMarkView.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
        [self.contentView addSubview:_greenMarkView];
        [_greenMarkView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_titleLabel.mas_top).with.offset(-1);
            make.left.equalTo(_whiteImageView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(3, 20));
        }];

        _dateLabel = [UILabel new];
        _dateLabel.font = [UIFont systemFontOfSize:12.0f];
        _dateLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _dateLabel.textAlignment = NSTextAlignmentRight;
        _dateLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self.contentView addSubview:_dateLabel];

        [_dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_bottom).with.offset(-24);
            make.left.equalTo(self.mas_left).with.offset(16);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-[Utilities convertPixsW:20]-13, 13));
        }];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)presenceClicked:(id)sender {
    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
    NSDictionary *positionDic = tsTap.infoDic;

    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_presenceListToDetaile" object:self userInfo:_presenceInfo];
}

@end
