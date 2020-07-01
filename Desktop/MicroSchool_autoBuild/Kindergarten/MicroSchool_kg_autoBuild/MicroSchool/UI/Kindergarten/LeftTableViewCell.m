//
//  LeftTableViewCell.m
//  MicroSchool
//
//  Created by banana on 16/7/25.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "LeftTableViewCell.h"
#import "Masonry.h"
// 屏幕高度
#define HEIGHT [UIScreen mainScreen].bounds.size.height
// 屏幕宽度
#define WIDTH [UIScreen mainScreen].bounds.size.width
@implementation LeftTableViewCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       
        
        self.imageViewC = [UIImageView new];
        _imageViewC.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_imageViewC];
        [_imageViewC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(10);
            make.left.equalTo(self.contentView.mas_left).with.offset(25);
            make.size.mas_equalTo(CGSizeMake(20,20));
        }];
        
        self.textLabelC = [UILabel new];
        _textLabelC.backgroundColor = [UIColor clearColor];
        _textLabelC.font = [UIFont systemFontOfSize:15];
        _textLabelC.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_textLabelC];
        [self.textLabelC mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(self.imageViewC.mas_top).with.offset(0);
                make.left.equalTo(self.imageViewC.mas_right).with.offset(15);
                make.size.mas_equalTo(CGSizeMake(100,20));
            }];
        
        self.detailTextLabelC = [UILabel new];
        _detailTextLabelC.backgroundColor = [UIColor clearColor];
        _detailTextLabelC.font = [UIFont systemFontOfSize:15];
        _detailTextLabelC.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_detailTextLabelC];
        [_detailTextLabelC mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.imageViewC.mas_top).with.offset(0);
            make.left.equalTo(_textLabelC.mas_right).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(50,20));
        }];
        

    [self.contentView addSubview:[self arrow]];
    [self.arrowImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset(15);
        make.left.equalTo(self.contentView.mas_left).with.offset(WIDTH/2+50);
        make.size.mas_equalTo(CGSizeMake(10,10));
    }];

    
    self.redPoint = [UIImageView new];
        _redPoint.hidden = YES;
//        _redPoint.frame = CGRectMake(240 - 40.0,(50.0 - 10)/2-0.5 - 5 , 10.0, 10.0);
        _redPoint.image = [UIImage imageNamed:@"icon_new.png"];//2015.11.25
        _redPoint.tag = 223;
    [self.contentView addSubview:_redPoint];
    [_redPoint mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).with.offset((50.0 - 10)/2-0.5 - 5);
        make.left.equalTo(self.contentView.mas_left).with.offset(240 - 40.0);
        make.size.mas_equalTo(CGSizeMake(10,10));
    }];
        
        self.MyMsgsImgView = [[UIImageView alloc] init];
//        _MyMsgsImgView.frame = CGRectMake(240 - 40.0,(50.0 - 10)/2-0.5 - 5 , 10.0, 10.0);
        _MyMsgsImgView.image = [UIImage imageNamed:@"icon_new.png"];//2015.11.25
        _MyMsgsImgView.tag = 224;
        _MyMsgsImgView.hidden = YES;
        [self.contentView addSubview:_MyMsgsImgView];
        [_MyMsgsImgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset((50.0 - 10)/2-0.5 - 5);
            make.left.equalTo(self.contentView.mas_left).with.offset(240 - 40.0);
            make.size.mas_equalTo(CGSizeMake(10,10));
        }];
}
    return self;
}
//自定义cell右侧小箭头
-(UIImageView*)arrow{
    self.arrowImg = [UIImageView new];
    [self.arrowImg setImage:[UIImage imageNamed:@"左侧菜单-箭头_03"]];
    return self.arrowImg;
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
