//
//  OutsideReimbursementListTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementListTableViewCell.h"

#import "OutsideReimbursementListModel.h"


#define height_cellHeight   140


@interface OutsideReimbursementListTableViewCell ()

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labDate;

@property (nonatomic,strong) UILabel *labFocus;
@property (nonatomic,strong) UILabel *labContent;

@end

@implementation OutsideReimbursementListTableViewCell

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
    
    
    _labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, 10, KScreenWidth - 40, 20)];
    [self addSubview:_labTitle];
    _labTitle.textColor = color_black;
    _labTitle.font = FONT(17.f);
    
    
    
    _labDate = [[UILabel alloc]initWithFrame:
                        CGRectMake(20, CGRectGetMaxY(_labTitle.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labDate];
    _labDate.textColor = color_gray2;
    _labDate.font = FONT(15.f);
    
    
    //  线
    UIImageView *viewXian = [[UIImageView alloc]initWithFrame:
                             CGRectMake(20, CGRectGetMaxY(_labDate.frame) + 10 - 0.5, KScreenWidth, 0.5)];
    [self addSubview:viewXian];
    viewXian.image = [UIImage imageNamed:@"lineSystem"];
    
    
    
    //   报销价格
    _labFocus = [[UILabel alloc]initWithFrame:
                 CGRectMake(20, CGRectGetMaxY(viewXian.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labFocus];
    _labFocus.textColor = color_blue2;
    _labFocus.font = FONT(16.5f);
    
    
    
    //   备注
    _labContent = [[UILabel alloc]initWithFrame:
                 CGRectMake(20, CGRectGetMaxY(_labFocus.frame) + 10, KScreenWidth - 40, 20)];
    [self addSubview:_labContent];
    _labContent.textColor = color_gray2;
    _labContent.font = FONT(15.f);
    
    
}



-(void)reloadData
{
    if (_model) {
        _labTitle.text = [NSString stringWithFormat:@"%@  %@",_model.airplaneType,_model.orderName];
        _labDate.text = [Utilities replaceNull:_model.departureDate];
        
        
        if (_model.subsidiesamount) {
            NSString *subsidiesamount = [[Utilities replaceNull:_model.subsidiesamount] isEqualToString:@""] ? @"0" : [Utilities replaceNull:_model.subsidiesamount];
            _labFocus.text = [NSString stringWithFormat:@"报销价格：%@",subsidiesamount];
        }
        if (_model.oilnum) {
            NSString *oilNum = [[Utilities replaceNull:_model.oilnum] isEqualToString:@""] ? @"0" : [Utilities replaceNull:_model.oilnum];
            _labFocus.text = [NSString stringWithFormat:@"剩余油量：%@ kg",oilNum];
        }
        
        
        
        
        
        NSString *Memo = [[Utilities replaceNull:_model.Memo] isEqualToString:@""] ? @"无" : [Utilities replaceNull:_model.Memo];
        _labContent.text = [NSString stringWithFormat:@"备注：%@",Memo];
    }
}

+(CGFloat)cellHeight
{
    return height_cellHeight;
}

@end
