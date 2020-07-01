//
//  MessageListTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/21.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessageListTableViewCell.h"

#define height_cellHeight  80


@interface MessageListTableViewCell ()

@property (nonatomic,strong) UIImageView *imgLogoV;
@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labContent;
@property (nonatomic,strong) UILabel *labTime;

@property (nonatomic,strong) UILabel *LabNewNum;  //  消息数

@end

@implementation MessageListTableViewCell

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
    
    
    
    // 消息数目
    _LabNewNum = [[UILabel alloc]initWithFrame:
                  CGRectMake(45, 5, 20, 20)];
    [butBG addSubview:_LabNewNum];
    _LabNewNum.backgroundColor = [UIColor whiteColor];
    _LabNewNum.textColor = color_purple;
    _LabNewNum.font = FONT(12.f);
    _LabNewNum.textAlignment = NSTextAlignmentCenter;
    _LabNewNum.layer.masksToBounds = YES;
    _LabNewNum.layer.cornerRadius = CGRectGetHeight(_LabNewNum.frame)/2;
    _LabNewNum.layer.borderColor = color_purple.CGColor;
    _LabNewNum.layer.borderWidth = 0.8f;
    
    
    _LabNewNum.hidden = YES;
    
    
    //  标题
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake(75, 10, width - 75 - 70, 30)];
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
    
    
    //  时间
    _labTime = [[UILabel alloc]initWithFrame:
                CGRectMake(width - 70, 0, 70, Height)];
    [butBG addSubview:_labTime];
    _labTime.backgroundColor = [UIColor clearColor];
    _labTime.textColor = color_gray2;
    _labTime.font = FONT(16.f);
    _labTime.textAlignment = NSTextAlignmentCenter;
    
}

-(void)buttonAction
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tableViewCellDidSelectRowAtIndexPath:)]) {
        [self.delegate tableViewCellDidSelectRowAtIndexPath:_indexPath];
    }
}

-(void)reloadData
{
    _LabNewNum.hidden = NO;
    
    
    NSString *strNum = @"115";
    CGFloat widthNum = [Utilities getWidthWithTitle:strNum font:FONT(12.f)] + 10 > 20 ? [Utilities getWidthWithTitle:strNum font:FONT(12.f)] + 10 : 20;
    _LabNewNum.frame = CGRectMake(CGRectGetMinX(_LabNewNum.frame), CGRectGetMinY(_LabNewNum.frame), widthNum, CGRectGetHeight(_LabNewNum.frame));
    
    
    
}

+(CGFloat)cellHeight
{
    return height_cellHeight;
}

@end
