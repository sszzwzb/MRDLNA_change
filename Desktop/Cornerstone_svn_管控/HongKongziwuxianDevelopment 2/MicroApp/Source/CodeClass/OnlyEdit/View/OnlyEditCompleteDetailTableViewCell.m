//
//  OnlyEditCompleteDetailTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditCompleteDetailTableViewCell.h"



#define height_cellHeight   90


@interface OnlyEditCompleteDetailTableViewCell ()

//@property (nonatomic,strong) UIImageView *imgV;
@property (nonatomic,strong) UILabel *labContent;

@end

@implementation OnlyEditCompleteDetailTableViewCell

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
    
    self.backgroundColor = [UIColor whiteColor];
    
    
    _imgV = [[UIImageView alloc]initWithFrame:
             CGRectMake(15, 15, 60, 60)];
    [self addSubview:_imgV];
    
    
    
    _labContent = [[UILabel alloc]initWithFrame:
                   CGRectMake(90, 10, KScreenWidth - 100, height_cellHeight - 20)];
    [self addSubview:_labContent];
    _labContent.textColor = color_black;
    _labContent.numberOfLines = 0;
    _labContent.font = FONT(16.f);
    
    
    
}

-(void)reloadData
{
    _labContent.text = [Utilities replaceNull:_content];
    [_imgV sd_setImageWithURL:[NSURL URLWithString:[Utilities replaceNull:_imgUrl]] placeholderImage:[UIImage imageNamed:@"loading"]];
}

+(CGFloat)cellHeight
{
    return height_cellHeight;
}


@end
