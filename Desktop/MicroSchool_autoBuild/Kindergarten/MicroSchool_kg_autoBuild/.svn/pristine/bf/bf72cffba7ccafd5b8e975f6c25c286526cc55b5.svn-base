//
//  RepeatNameTableViewCell.m
//  MicroSchool
//
//  Created by banana on 16/6/22.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "RepeatNameTableViewCell.h"
#import "Masonry.h"
#import "Utilities.h"
#import "RepeatView.h"
#import "UIImageView+WebCache.h"
@implementation RepeatNameTableViewCell
@synthesize arr;
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //cornerView 是用来出现切圆角效果
        self.contentView.backgroundColor = [UIColor clearColor];
        self.cornerView = [UIView new];
        self.cornerView.layer.cornerRadius = 4;
        self.cornerView.layer.masksToBounds = YES;
        self.cornerView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:_cornerView];
        
        self.childLabel = [UILabel new];
        _childLabel.backgroundColor = [UIColor whiteColor];
        //        _childLabel.text = @"奇迹";
        _childLabel.font = [UIFont systemFontOfSize:18];
        //        _childLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        //        _childLabel.text = [self.arr[self.i] objectForKey:@"student_name"];
        [_cornerView addSubview:_childLabel];
        CGSize childSize = [Utilities getLabelHeight:_childLabel size:CGSizeMake(0, 18)];
        CGFloat tempChildFloat = childSize.width;
        if (tempChildFloat == 0) {
            tempChildFloat = 40;
        }
        [self.childLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cornerView.mas_top).with.offset(14);
            make.left.equalTo(_cornerView.mas_left).with.offset(18);
            make.size.mas_equalTo(CGSizeMake(tempChildFloat, 18));
        }];
        
        self.genderImv = [[UIImageView alloc] init];
        _genderImv.backgroundColor = [UIColor whiteColor];
        //        if(1){
        //            [self.genderImv  setImage:[UIImage imageNamed:@"SwitchChild/icon_male"]];
        //        }else {
        //            [self.genderImv  setImage:[UIImage imageNamed:@"SwitchChild/icon_female"]];
        //        }
        [_cornerView addSubview:_genderImv];
        [_genderImv mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_childLabel.mas_top).with.offset(0);
            make.left.equalTo(_childLabel.mas_right).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(18, 18));
        }];
        
        self.childIDLabel = [[UILabel alloc] init];
        //        _childIDLabel.text = @"打算打算打算打算的";
        _childIDLabel.font = [UIFont systemFontOfSize:14];
        _childIDLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        //        _childIDLabel.textColor = [UIColor redColor];
        _childIDLabel.backgroundColor = [UIColor whiteColor];
        [_cornerView addSubview:_childIDLabel];
        //        if (tempChildFloat == 0) {
        //            tempChildFloat = [Utilities convertPixsW:20];
        //        }
        [self.childIDLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_childLabel.mas_bottom).with.offset(8);
            make.left.equalTo(_childLabel.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(150, 14));
        }];
        
        self.selectedButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //        [_selectedButton setImage:[UIImage imageNamed:@"SwitchChild/repeatButtonBackground"] forState:UIControlStateNormal];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"SwitchChild/selectedRepeatButtonBackground"] forState:UIControlStateHighlighted];
        [_selectedButton setBackgroundImage:[UIImage imageNamed:@"SwitchChild/repeatButtonBackground"] forState:UIControlStateNormal];
        [_selectedButton setTitle:@"绑定" forState: UIControlStateNormal];
        [_selectedButton.titleLabel setFont:[UIFont systemFontOfSize:15]];
        [_selectedButton setTitleColor:[UIColor colorWithRed:51.0 / 255 green:153.0 / 255 blue:255.0 / 255  alpha:1] forState:UIControlStateNormal];
        _selectedButton.titleLabel.textAlignment = NSTextAlignmentCenter;
        [_cornerView addSubview:_selectedButton];
        [self.selectedButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cornerView.mas_top).with.offset(18);
            make.left.equalTo(_cornerView.mas_right).with.offset(-78);
            make.size.mas_equalTo(CGSizeMake(62, 26));
        }];
        
        //一条线
        self.lineLabel = [[UILabel alloc] init];
        _lineLabel.backgroundColor = [UIColor colorWithRed:220.0 / 255 green:220.0 / 255 blue:220.0 / 255 alpha:1];
        [_cornerView addSubview:_lineLabel];
        [_lineLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_childIDLabel.mas_bottom).with.offset(10);
            make.left.equalTo(_childIDLabel.mas_left).with.offset(0);
            make.right.equalTo(_cornerView.mas_right).with.offset(-18);
            make.bottom.equalTo(_childIDLabel.mas_bottom).with.offset(11);
        }];
        
        
        [_cornerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            
            make.right.equalTo(self.contentView.mas_right).with.offset(0);
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

-(void)setArr:(NSMutableArray *)tempArr{
    
    if (tempArr == nil) {
        tempArr = [NSMutableArray arrayWithArray:self.arr];
    }
    NSLog(@"数据数组:::::::::%@", tempArr);
    //    self.arr = [NSMutableArray arrayWithArray:arr];
    if (tempArr.count) {
        //aboutVIew 是横线以下的部分
        if (_aboutView) {
            [_aboutView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [_aboutView removeFromSuperview];
        }else{
        }
        _aboutView = [UIView new];
        _aboutView.backgroundColor = [UIColor clearColor];
        
        [_cornerView addSubview:_aboutView];
        [_aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cornerView.mas_top).with.offset(14 + 18 + 8 + 14 + 10 + 1 );
            make.left.equalTo(_cornerView.mas_left).with.offset(18);
            
            make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width - 60,60 * tempArr.count + 14 + 18 + 15));
            
        }];
        
        
        
        
        UILabel *txtLabel = [[UILabel alloc] init];
        txtLabel.text = @"绑定该ID的用户";
        txtLabel.font = [UIFont systemFontOfSize:14];
        txtLabel.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
        [_aboutView addSubview:txtLabel];
        [txtLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_aboutView.mas_top).with.offset(11);
            make.left.equalTo(_aboutView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(250, 14));
        }];
        
        //        self.viewArr = [NSMutableArray array];
        for (NSInteger i = 0; i < tempArr.count; i++) {
            
            self.repeat = [RepeatView new];
            // repeat  是指的可复用的每条相关人物的服用条
            
            _repeat.nameLabel.text = [tempArr[i] objectForKey:@"name"];
            _repeat.IDLabel.text = [NSString stringWithFormat:@"账号:%@", [tempArr[i] objectForKey:@"username"]];
            [_repeat.imv sd_setImageWithURL:[NSURL URLWithString:[tempArr[i] objectForKey:@"avatar"]]];
            [_aboutView addSubview:_repeat];
            [_repeat mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(txtLabel.mas_bottom).with.offset(60 * i + 10);
                make.left.equalTo(txtLabel.mas_left).with.offset(0);
                make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width - 60 - 40,60 * tempArr.count + 14 + 4));
            }];
            
            
            
            //            [_repeat mas_remakeConstraints:^(MASConstraintMaker *make) {
            //            }];
            //            _repeat.frame = CGRectMake(0, 60 * i, self.bounds.size.width, 70);
            
        }
        self.contentView.backgroundColor = [UIColor clearColor];
        _aboutView.backgroundColor = [UIColor clearColor];
        [_aboutView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width - 60,60 * tempArr.count + 14 + 18 + 15));
        }];
        //            [_aboutView mas_makeConstraints:^(MASConstraintMaker *make) {
        //                make.top.equalTo(_lineLabel.mas_bottom).with.offset(0);
        //                make.left.equalTo(_lineLabel.mas_left).with.offset(0);
        //                make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width - 60,50 * tempArr.count + 14 + 18 + 15));
        //            }];
        //
        
        
        [_cornerView mas_updateConstraints:^(MASConstraintMaker *make) {
            
            make.height.mas_equalTo(60 * tempArr.count + 112);
            //            make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width,50 * tempArr.count + 112));
        }];
        
        
        
        UILabel *bottomLabel = [[UILabel alloc] init];
        bottomLabel.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
        [self.contentView addSubview:bottomLabel];
        [bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_cornerView.mas_bottom).with.offset(0);
            make.left.equalTo(self.contentView.mas_left).with.offset(0);
            make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 20, 15));
        }];
        
        
        
        
        
    }
    else{
        
        
        [_cornerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(112 - 48);
            
            //            make.size.mas_equalTo(CGSizeMake( self.contentView.bounds.size.width,112 - 48));
        }];
        
        if (self.bottomLabel) {
            
        }else{
            self.bottomLabel = [UILabel new];
            _bottomLabel.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
            [self.contentView addSubview:_bottomLabel];
            [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_cornerView.mas_bottom).with.offset(10);
                make.left.equalTo(self.contentView.mas_left).with.offset(0);
                make.size.mas_equalTo(CGSizeMake(self.contentView.bounds.size.width - 20, 15));
            }];
        }
    }
}


@end
