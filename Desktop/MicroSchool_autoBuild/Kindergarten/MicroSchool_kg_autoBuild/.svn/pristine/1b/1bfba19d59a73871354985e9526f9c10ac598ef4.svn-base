//
//  NameAndImgTableViewCell.m
//  MicroSchool
//
//  Created by jojo on 14-9-15.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "NameAndImgTableViewCell.h"

@implementation NameAndImgTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        _label_name = [[UILabel alloc] initWithFrame:CGRectZero];
        _label_name.lineBreakMode = NSLineBreakByWordWrapping;
        _label_name.font = [UIFont systemFontOfSize:15.0f];
        _label_name.textColor = [UIColor blackColor];
        _label_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:_label_name];
        
        //---add by kate 2014.11.25---------------------------------------
        _btn_name = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn_name.titleLabel.font = [UIFont systemFontOfSize:17.0];
        [_btn_name setTintColor:[UIColor whiteColor]];
        [_btn_name setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
        [_btn_name setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
        [self.contentView addSubview:_btn_name];
       //-------------------------------------------------------------------

        _imageView_img =[[UIImageView alloc]initWithFrame:CGRectZero];
        _imageView_img.contentMode = UIViewContentModeScaleToFill;
        [self.contentView addSubview:_imageView_img];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
