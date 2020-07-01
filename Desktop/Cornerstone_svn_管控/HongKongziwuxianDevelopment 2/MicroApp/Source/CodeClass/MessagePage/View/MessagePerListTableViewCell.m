//
//  MessagePerListTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/22.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessagePerListTableViewCell.h"

#define height_cellHeight  80


@interface MessagePerListTableViewCell ()

@property (nonatomic,strong) UIImageView *imgLogoV;
@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labContent;

@end

@implementation MessagePerListTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self upCell];
    }
    return self;
}

-(void)upCell
{
    
    self.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UIView *viewB = [[UIView alloc]initWithFrame:self.frame];
    viewB.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = viewB;
    
    
    
    
    UIButton *butBG = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:butBG];
    butBG.frame = CGRectMake(10, 5, KScreenWidth - 20, height_cellHeight - 10);
    butBG.backgroundColor = [UIColor clearColor];
    
    [butBG setBackgroundImage:[UIImage imageNamed:@"MessageListTableViewCellBG"] forState:(UIControlStateNormal)];
    [butBG setBackgroundImage:[UIImage imageNamed:@"MessageListTableViewCellBG_action"] forState:(UIControlStateHighlighted)];
    
    [butBG addTarget:self action:@selector(buttonAction) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    
    CGFloat Height = CGRectGetHeight(butBG.frame);
    CGFloat width = CGRectGetWidth(butBG.frame);
    
    
    
    // 图片
    _imgLogoV = [[UIImageView alloc]initWithFrame:
                 CGRectMake(10, (Height - 55)/2, 55, 55)];
    [butBG addSubview:_imgLogoV];
    _imgLogoV.layer.masksToBounds = YES;
    _imgLogoV.layer.cornerRadius = CGRectGetWidth(_imgLogoV.frame)/2;
    _imgLogoV.backgroundColor = color_blue;
    
    
    
    //  标题
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake(75, 10, width - 75 - 95, 30)];
    [butBG addSubview:_labTitle];
    _labTitle.backgroundColor = [UIColor clearColor];
    _labContent.textColor = color_black;
    _labContent.font = FONT(16.5f);
    
    
    //  内容
    _labContent = [[UILabel alloc]initWithFrame:
                   CGRectMake(CGRectGetMinX(_labTitle.frame), CGRectGetMaxY(_labTitle.frame), CGRectGetWidth(_labTitle.frame), 20)];
    [butBG addSubview:_labContent];
    _labContent.backgroundColor = [UIColor clearColor];
    _labContent.textColor = color_gray2;
    _labContent.font = FONT(15.f);
    
    
    //  阅读详情
    UILabel *labTime = [[UILabel alloc]initWithFrame:
                CGRectMake(width - 95, 0, 70, Height)];
    [butBG addSubview:labTime];
    labTime.backgroundColor = [UIColor clearColor];
    labTime.textColor = color_gray2;
    labTime.font = FONT(16.f);
    labTime.textAlignment = NSTextAlignmentCenter;
    labTime.text = @"阅读详情";
    
    
    //  cell右侧返回
    UIImageView *imgR = [[UIImageView alloc]initWithFrame:
                         CGRectMake(width - 25, (Height - 23)/2, 23, 23)];
    [butBG addSubview:imgR];
    imgR.image = [UIImage imageNamed:@"navicons_03"];
    
}

-(void)buttonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellDidSelectRowAtIndexPath:)]) {
        [self.delegate tableViewCellDidSelectRowAtIndexPath:_indexPath];
    }
}

-(void)reloadData
{
    
}

+(CGFloat)cellHeight
{
    return height_cellHeight;
}


@end
