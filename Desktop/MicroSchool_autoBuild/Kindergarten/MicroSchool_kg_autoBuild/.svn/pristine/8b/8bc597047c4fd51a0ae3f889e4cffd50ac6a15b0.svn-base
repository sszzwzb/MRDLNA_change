//
//  SwitchChildTableViewCell.m
//  MicroSchool
//
//  Created by CheungStephen on 6/17/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "SwitchChildTableViewCell.h"
#import "QuartzCore/QuartzCore.h"

@implementation SwitchChildTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _touchedBgImageView = [TSTouchImageView new];
//        _touchedBgImageView.contentMode = UIViewContentModeScaleAspectFill;
//        _touchedBgImageView.clipsToBounds = YES;
        _touchedBgImageView.userInteractionEnabled = YES;
        _touchedBgImageView.backgroundColor = [UIColor whiteColor];
//        _touchedBgImageView.layer.masksToBounds = YES;
//        _touchedBgImageView.layer.cornerRadius = 5;
        
        //添加边框
        CALayer * layer = [_touchedBgImageView layer];
        layer.borderColor = [[[UIColor alloc] initWithRed:220/255.0f green:220/255.0f blue:220/255.0f alpha:1.0] CGColor];
        layer.borderWidth = 0.5f;

        
        
        
//        CALayer *shadowLayer = [_touchedBgImageView layer];
//        layer.shadowOffset = CGSizeMake(0, 3);
//        layer.cornerRadius = 5.0;
//        layer.shadowRadius = 5;
//        layer.shadowColor = [[[UIColor alloc] initWithRed:51/255.0f green:153/255.0f blue:255/255.0f alpha:1.0] CGColor]; //设置阴影的颜色为黑色
//        layer.shadowOpacity = 1.0; //设置阴影的不透明度

        
        
        
//        //阴影layer
//        CALayer *shadowLayer = [CALayer layer];
//        shadowLayer.frame = CGRectMake(100, 100, _touchedBgImageView.frame.size.width, _touchedBgImageView.frame.size.height);
//        shadowLayer.backgroundColor = [UIColor blueColor].CGColor;
//        shadowLayer.shadowOffset = CGSizeMake(0, 3);
//        shadowLayer.cornerRadius = 10.0;
//        shadowLayer.shadowRadius = 10.0;
//        shadowLayer.shadowColor = [UIColor greenColor].CGColor; //设置阴影的颜色为黑色
//        shadowLayer.shadowOpacity = 1.0; //设置阴影的不透明度
//        [layer addSublayer:shadowLayer];
        
        
//        _touchedBgImageView.layer.shadowColor = [UIColor redColor].CGColor;
//        _touchedBgImageView.layer.shadowOffset = CGSizeMake(4, 4);
//        _touchedBgImageView.layer.shadowOpacity = 0.5;
//        _touchedBgImageView.layer.shadowRadius = 2.0;
        
        
        
        
//        _touchedBgImageView.layer.shadowColor = [UIColor redColor].CGColor;
//        _touchedBgImageView.layer.shadowOffset = CGSizeMake(5.0, 5.0);
//        _touchedBgImageView.layer.shadowOpacity = YES;
        
//        CALayer *bottomBorder = [CALayer layer];
//        bottomBorder.borderColor = [UIColor greenColor].CGColor;
//        bottomBorder.borderWidth = 5;
//        bottomBorder.frame = CGRectMake(-1, layer.frame.size.height-1, layer.frame.size.width, 1);
//        [bottomBorder setBorderColor:[UIColor greenColor].CGColor];
//        [layer addSublayer:bottomBorder];
        
        
//        layer.shadowColor = [UIColor greenColor].CGColor;//阴影颜色
//        layer.shadowOffset = CGSizeMake(1, 1);//偏移距离
//        layer.shadowOpacity = 1.5;//不透明度
//        layer.shadowRadius = 20.0;//半径
        
        [self.contentView addSubview:_touchedBgImageView];
        
        [_touchedBgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top).with.offset(0);
            make.left.equalTo(self.mas_left).with.offset(12);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-24,
                                             100));
        }];
        
        TSTapGestureRecognizer *myTapGesture = [[TSTapGestureRecognizer alloc] initWithTarget:self action:@selector(presenceClicked:)];
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             _presenceInfo, @"presenceId",
                             nil];
        
        myTapGesture.infoDic = dic;
        [_touchedBgImageView addGestureRecognizer:myTapGesture];
        
        _nameLabel = [UILabel new];
        _nameLabel.font = [UIFont systemFontOfSize:18.0f];
        _nameLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _nameLabel.textAlignment = NSTextAlignmentLeft;
        _nameLabel.textColor = [[UIColor alloc] initWithRed:51/255.0f green:51/255.0f blue:51/255.0f alpha:1.0];
        [self.contentView addSubview:_nameLabel];
        
        [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_touchedBgImageView.mas_top).with.offset(37/2);
            make.left.equalTo(_touchedBgImageView.mas_left).with.offset(18);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-100, 20));
        }];

        _genderImageView = [UIImageView new];
        _genderImageView.contentMode = UIViewContentModeScaleAspectFill;
        _genderImageView.backgroundColor = [UIColor clearColor];
        [_touchedBgImageView addSubview:_genderImageView];
        
        [_genderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_top).with.offset(2);
            make.left.equalTo(_nameLabel.mas_right).with.offset(8);
            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];

        _studentIdLabel = [UILabel new];
        _studentIdLabel.font = [UIFont systemFontOfSize:14.0f];
        _studentIdLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _studentIdLabel.textAlignment = NSTextAlignmentLeft;
        _studentIdLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self.contentView addSubview:_studentIdLabel];
        
        [_studentIdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_nameLabel.mas_bottom).with.offset(12);
            make.left.equalTo(_touchedBgImageView.mas_left).with.offset(18);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-50, 14));
        }];

        _studentSchoolLabel = [UILabel new];
        _studentSchoolLabel.font = [UIFont systemFontOfSize:14.0f];
        _studentSchoolLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _studentSchoolLabel.textAlignment = NSTextAlignmentLeft;
        _studentSchoolLabel.textColor = [[UIColor alloc] initWithRed:102/255.0f green:102/255.0f blue:102/255.0f alpha:1.0];
        [self.contentView addSubview:_studentSchoolLabel];
        
        [_studentSchoolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_studentIdLabel.mas_bottom).with.offset(5);
            make.left.equalTo(_touchedBgImageView.mas_left).with.offset(18);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-50, 14));
        }];

        _unbindButton = [UIButton buttonWithType:UIButtonTypeCustom];
//        _unbindButton.backgroundColor = [UIColor redColor];
        [_unbindButton setTitle:@"解绑" forState:UIControlStateNormal];
        [_unbindButton setTitle:@"解绑" forState:UIControlStateHighlighted];
        _unbindButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        [_unbindButton setTitleColor:[[UIColor alloc] initWithRed:54/255.0f green:182/255.0f blue:169/255.0f alpha:1.0] forState:UIControlStateNormal];
        [_unbindButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _unbindButton.hidden = YES;
        [_unbindButton addTarget:self action:@selector(unbindButtonClick:) forControlEvents: UIControlEventTouchUpInside];

        [self.contentView addSubview:_unbindButton];

        [_unbindButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).with.offset((100-15)/2);
            make.right.equalTo(_touchedBgImageView.mas_right).with.offset(-12);
            make.size.mas_equalTo(CGSizeMake(30, 15));
        }];

        _addChildLabel = [UILabel new];
        _addChildLabel.font = [UIFont systemFontOfSize:18.0f];
        _addChildLabel.hidden = YES;
        _addChildLabel.textAlignment = NSTextAlignmentCenter;
        _addChildLabel.textColor = [[UIColor alloc] initWithRed:153/255.0f green:153/255.0f blue:153/255.0f alpha:1.0];
        [self.contentView addSubview:_addChildLabel];
        
        [_addChildLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_touchedBgImageView.mas_top).with.offset((100-18)/2);
            make.left.equalTo(_touchedBgImageView.mas_left).with.offset(10);
            make.size.mas_equalTo(CGSizeMake([Utilities getScreenSizeWithoutBar].width-24, 18));
        }];

        _addChildImageView = [UIImageView new];
        _addChildImageView.hidden = YES;
        [_addChildImageView setImage:[UIImage imageNamed:@"SwitchChild/icon_addChild"]];
        _addChildImageView.contentMode = UIViewContentModeScaleAspectFill;
        _addChildImageView.backgroundColor = [UIColor whiteColor];
        [_touchedBgImageView addSubview:_addChildImageView];
        
        [_addChildImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(_touchedBgImageView.mas_centerX).with.offset(-50);
            make.centerY.equalTo(_touchedBgImageView.mas_centerY);

            make.size.mas_equalTo(CGSizeMake(15, 15));
        }];
    }
    
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (IBAction)presenceClicked:(id)sender {
//    TSTapGestureRecognizer *tsTap = (TSTapGestureRecognizer *)sender;
//    NSDictionary *positionDic = tsTap.infoDic;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_switchChildSelectChild" object:self userInfo:_presenceInfo];
}

- (IBAction)unbindButtonClick:(id)sender {
    NSLog(@"unbind");
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"zhixiao_switchChildUnbindChild" object:self userInfo:_presenceInfo];


}

@end
