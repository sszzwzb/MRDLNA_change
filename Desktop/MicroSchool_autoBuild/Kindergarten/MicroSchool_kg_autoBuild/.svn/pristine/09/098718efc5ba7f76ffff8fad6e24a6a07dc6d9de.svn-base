//
//  Camera360TableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 26/10/2016.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "Camera360TableViewCell.h"

#import "Masonry.h"

@implementation Camera360TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        _cameraNameLabel = [UILabel new];
        _cameraNameLabel.font = [UIFont systemFontOfSize:13];
        _cameraNameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _cameraNameLabel.textAlignment = NSTextAlignmentLeft;
        _cameraNameLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:_cameraNameLabel];
        
        [_cameraNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(((90-26)/2)/2);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(((400-30-40-40)/2), 13));
        }];
        
        _cameraOpenTimeLabel = [UILabel new];
        _cameraOpenTimeLabel.font = [UIFont systemFontOfSize:11];
        _cameraOpenTimeLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _cameraOpenTimeLabel.textAlignment = NSTextAlignmentLeft;
        _cameraOpenTimeLabel.textColor = [UIColor colorWithRed:200/255.0 green:200/255.0 blue:200/255.0 alpha:1];
        [self.contentView addSubview:_cameraOpenTimeLabel];
        
        [_cameraOpenTimeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cameraNameLabel.mas_bottom).with.offset(8);
            make.left.equalTo(self.contentView.mas_left).with.offset(15);
            make.size.mas_equalTo(CGSizeMake(((400-30-40-40)/2), 13));
        }];
        
//        _cameraSettingImageView = [UIImageView new];
//        _cameraSettingImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _cameraSettingImageView.image = [UIImage imageNamed:@"Camera360/camera360_icon_setting"	];
//        [self.contentView addSubview:_cameraSettingImageView];
//        
//        [_cameraSettingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.contentView.mas_top).with.offset(12);
//            make.right.equalTo(self.contentView.mas_right).with.offset(-10);
//            
//            make.size.mas_equalTo(CGSizeMake(20, 20));
//        }];
        
        _cameraIconButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _cameraIconButton.backgroundColor = [UIColor redColor];
        [_cameraIconButton setImage:[UIImage imageNamed:@"Camera360/camera360_icon_setting"] forState:UIControlStateNormal];
        [_cameraIconButton setImage:[UIImage imageNamed:@"Camera360/camera360_icon_setting"] forState:UIControlStateSelected];
        [_cameraIconButton addTarget:self action:@selector(camera360Setting) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_cameraIconButton];

        [_cameraIconButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
            
            make.size.mas_equalTo(CGSizeMake(50 , self.contentView.frame.size.height));
        }];
        
        _cameraIconImageView = [UIView new];
        _cameraIconImageView.backgroundColor = [UIColor colorWithRed:51/255.0 green:153/255.0 blue:255/255.0 alpha:1];
        _cameraIconImageView.hidden = YES;
        [self.contentView addSubview:_cameraIconImageView];
        [_cameraIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cameraNameLabel.mas_top).with.offset(-4);
            make.left.equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(3, 21));
        }];
    }
    return self;
}

-(void)camera360Setting {
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_cameraId,@"cameraId", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"goToCamera360Setting" object:dic];
}

@end
