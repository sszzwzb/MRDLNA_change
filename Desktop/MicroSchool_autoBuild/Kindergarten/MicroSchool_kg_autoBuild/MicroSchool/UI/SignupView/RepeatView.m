//
//  RepeatView.m
//  MicroSchool
//
//  Created by banana on 16/6/23.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "RepeatView.h"
#import "Masonry.h"
@implementation RepeatView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.imv = [[UIImageView alloc] init];
        _imv.backgroundColor = [UIColor whiteColor];
//        [_imv setImage:[UIImage imageNamed:@"icon_qhzn"]];
        _imv.layer.masksToBounds = YES;
        _imv.layer.cornerRadius = 20;
        //                imv.tag = 8001;
        [self addSubview:_imv];
        [_imv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0 );
            make.left.equalTo(self.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(40, 40));
        }];
        
        self.nameLabel = [[UILabel alloc] init];
        _nameLabel.backgroundColor = [UIColor whiteColor];
        //                nameLabel.text = [arr[i] objectForKey:@"name"];
        //                nameLabel.tag = 8002;
        _nameLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        [self addSubview:_nameLabel];
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_imv.mas_top).with.offset(0);
            make.left.equalTo(_imv.mas_right).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(200, 15));
        }];
        
        _IDLabel = [[UILabel alloc] init];
        _IDLabel.backgroundColor = [UIColor whiteColor];
        _IDLabel.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
        _IDLabel.font = [UIFont systemFontOfSize:15];
        //                IDLabel.text = [arr[i] objectForKey:@"账号"];
        //                IDLabel.tag = 8003;
        [self addSubview:_IDLabel];
        [_IDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(8 );
            make.left.equalTo(_nameLabel.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(200, 15));
        }];

    }
    return self;
}
@end
