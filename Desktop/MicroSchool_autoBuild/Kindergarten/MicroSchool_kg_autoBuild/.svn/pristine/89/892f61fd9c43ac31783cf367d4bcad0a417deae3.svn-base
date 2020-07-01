//
//  News2TableViewCell.m
//  MicroSchool
//
//  Created by 陈思瑞 on 16/4/21.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "News2TableViewCell.h"
#import "Masonry.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface News2TableViewCell()
@property (nonatomic, strong) UILabel *sepLabel;
@property (nonatomic, strong) UIImageView *viewTime;
@property (nonatomic, strong) UIImageView *eyeImage;
@end
@implementation News2TableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        // 缩略图
        self.imv =[UIImageView new];
        _imv.contentMode = UIViewContentModeScaleToFill;
        _imv.layer.cornerRadius = 4;
        _imv.layer.masksToBounds = YES;
        [self.contentView addSubview:_imv];       
        [_imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake(100,75));
        }];

        self.dingzhi = [UIImageView new];
        [_dingzhi setImage:[UIImage imageNamed:@"icon_top.png"]];
        [self.contentView addSubview:_dingzhi];
        [_dingzhi mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.right.equalTo(self.contentView.mas_right).with.offset(-60);
            make.size.mas_equalTo(CGSizeMake(21, 21));
            
        }];
        
        
        self.pinglun = [UIImageView new];
        _pinglun.backgroundColor = [UIColor whiteColor];
        [_pinglun setImage:[UIImage imageNamed:@"news/icon_ping.png"]];
        [self.contentView addSubview:_pinglun];
        [_pinglun mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_right).with.offset(-10);
            make.size.mas_equalTo(CGSizeMake(21, 21));
            
        }];

        // 标题
        self.nameLabel =[UILabel new];
        //设置title自适应对齐
        _nameLabel.lineBreakMode = NSLineBreakByWordWrapping;
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.numberOfLines = 1;
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [UIColor blackColor];
        _nameLabel.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imv.mas_top).with.offset(5);
            make.left.equalTo(self.contentView.mas_left).with.offset(120);
//            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 60 - 120,18));
            make.bottom.equalTo(_imv.mas_top).with.offset(23);
            make.right.equalTo(_dingzhi.mas_left).with.offset(-10);
        }];
        
        
        
        // 内容简报标题
        self.content = [UILabel new];
        //设置title自适应对齐
        _content.lineBreakMode = NSLineBreakByWordWrapping;
        _content.font = [UIFont systemFontOfSize:13.0f];
        _content.numberOfLines = 1;
        _content.lineBreakMode = NSLineBreakByTruncatingTail;
        _content.textAlignment = NSTextAlignmentLeft;
        _content.textColor = [UIColor grayColor];
        _content.backgroundColor = [UIColor cyanColor];
        [self.contentView addSubview:_content];
        [_content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_top).with.offset(18);
            make.left.equalTo(self.contentView.mas_left).with.offset(120);
//            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 60 - 120,20));
            make.bottom.equalTo(_nameLabel.mas_top).with.offset(38);
            make.right.equalTo(_nameLabel.mas_right).with.offset(0);
            
        }];
        
        // 日期
        self.date =[UILabel new];
        _date.font = [UIFont systemFontOfSize:12.0f];
        _date.textColor = [UIColor grayColor];
        _date.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_date];
        [_date mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(70);
            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2+25);
            make.size.mas_equalTo(CGSizeMake(100,15));
        }];
        //时间图标
        self.viewTime =[UIImageView new];
        [_viewTime setImage:[UIImage imageNamed:@"viewTime.png"]];
        [self.contentView addSubview:_viewTime];
        [_viewTime mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_date.mas_top).with.offset(1);
            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2+11);
            make.size.mas_equalTo(CGSizeMake(12,12));
        }];
        
        self.watch =[UILabel new];
        //设置title自适应对齐
        _watch.lineBreakMode = NSLineBreakByWordWrapping;
        _watch.font = [UIFont systemFontOfSize:12.0f];
        _watch.textColor = [UIColor grayColor];
        _watch.lineBreakMode = NSLineBreakByTruncatingTail;
        _watch.textAlignment = NSTextAlignmentLeft;
        _watch.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_watch];
        [_watch mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_date.mas_top).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2-17);
            make.size.mas_equalTo(CGSizeMake(28,15));
        }];
        
        self.eyeImage = [[UIImageView alloc]initWithFrame:CGRectMake(WIDTH/3*2-30, _date.frame.origin.y+1, 12, 12)];
        [_eyeImage setImage:[UIImage imageNamed:@"icon_liulan.png"]];
        [self.contentView addSubview:_eyeImage];
        [_eyeImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_date.mas_top).with.offset(1);
            make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/3*2-30);
            make.size.mas_equalTo(CGSizeMake(12,12));
        }];
        
        // 每条cell最下方的线
        UIImageView *imgView_line1 =[UIImageView new];
        [imgView_line1 setImage:[UIImage imageNamed:@"knowledge/tm.png"]];
        [self.contentView addSubview:imgView_line1];
        [imgView_line1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(94);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(WIDTH,1));
        }];
        

        }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
