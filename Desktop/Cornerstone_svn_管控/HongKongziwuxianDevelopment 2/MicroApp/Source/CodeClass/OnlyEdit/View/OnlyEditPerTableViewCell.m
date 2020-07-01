//
//  OnlyEditPerTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditPerTableViewCell.h"

#import "OnlyEditPerSQLModel.h"

@interface OnlyEditPerTableViewCell ()

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labTime;
@property (nonatomic,strong) UIButton *butR;

@property (nonatomic,strong) OnlyEditPerTableViewCellIconView *ImgV1;
@property (nonatomic,strong) OnlyEditPerTableViewCellIconView *ImgV2;
@property (nonatomic,strong) OnlyEditPerTableViewCellIconView *ImgV3;

@end

@implementation OnlyEditPerTableViewCell

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
    
    UIView *viewCell = [[UIView alloc]init];
    viewCell.backgroundColor = [UIColor clearColor];
    self.selectedBackgroundView = viewCell;
    
    
    //   标题
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake(10, 10, KScreenWidth - 85, 30)];
    [self addSubview:_labTitle];
    _labTitle.textColor = color_black;
    _labTitle.font = FONT(16.f);
    
    
    
    //   时间
    _labTime = [[UILabel alloc]initWithFrame:
                CGRectMake(CGRectGetMinX(_labTitle.frame), CGRectGetMaxY(_labTitle.frame), CGRectGetWidth(_labTitle.frame), 20)];
    [self addSubview:_labTime];
    _labTime.textColor = color_gray2;
    _labTime.font = FONT(14.5f);
    
    
    
    //  u右侧按键
    _butR = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butR];
    _butR.frame = CGRectMake(KScreenWidth - 75, 18, 65, 25);
    _butR.layer.masksToBounds = YES;
    _butR.layer.cornerRadius = CGRectGetHeight(_butR.frame)/2;
    [_butR setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    _butR.titleLabel.font = FONT(15.f);
    [_butR setBackgroundImage:[UIImage imageNamed:@"nav14"] forState:(UIControlStateNormal)];
    [_butR addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    
    CGFloat widthImg = (KScreenWidth/3-30)/4*3;
    
    _ImgV1 = [[OnlyEditPerTableViewCellIconView alloc]initWithFrame:
              CGRectMake(0, CGRectGetMaxY(_labTime.frame) + 20, KScreenWidth/3, widthImg)];
    [self addSubview:_ImgV1];
    
    
    _ImgV2 = [[OnlyEditPerTableViewCellIconView alloc]initWithFrame:
              CGRectMake(KScreenWidth/3, CGRectGetMaxY(_labTime.frame) + 20, KScreenWidth/3, widthImg)];
    [self addSubview:_ImgV2];
    
    
    _ImgV3 = [[OnlyEditPerTableViewCellIconView alloc]initWithFrame:
              CGRectMake(KScreenWidth/3*2, CGRectGetMaxY(_labTime.frame) + 20, KScreenWidth/3, widthImg)];
    [self addSubview:_ImgV3];
    
    _ImgV1.hidden = YES;
    _ImgV2.hidden = YES;
    _ImgV3.hidden = YES;
    
}

-(void)buttonAction:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(selectCellButtonWithType:didSelectRowAtIndexPath:)]) {
        [self.delegate selectCellButtonWithType:_type didSelectRowAtIndexPath:_indexPath];
    }
}

-(void)reloadData
{
    if (_model) {
        
        
        if ([_type isEqualToString:@"0"]) {
            _butR.hidden = NO;
            [_butR setTitle:@"编辑" forState:(UIControlStateNormal)];
        } else if ([_type isEqualToString:@"1"]) {
            _butR.hidden = NO;
            [_butR setTitle:@"上传" forState:(UIControlStateNormal)];
        } else {
            _butR.hidden = NO;
            [_butR setTitle:@"修改" forState:(UIControlStateNormal)];
        }
        
        
        
        _ImgV1.hidden = NO;
        _ImgV2.hidden = NO;
        _ImgV3.hidden = NO;
        
        
        
        
        if ([_type intValue] == 0 || [_type intValue] == 1) {
            
            _labTitle.text = [[Utilities replaceNull:_model.selectDateForSection0Model_orderName]isEqualToString:@""] ? @"未选中航段" : [NSString stringWithFormat:@"%@  %@", _model.selectDateForSection0Model_airplaneType, _model.selectDateForSection0Model_orderName];
            _labTime.text = _model.selectDateForSection0Model_departureDate;
            
            
            
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentPath = [path objectAtIndex:0];
            //指定新建文件夹路径
            NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"OnlyEditToEditViewController/"];
            
            NSDictionary *ImgDic0 = [Utilities JsonStrtoArrayOrNSDictionary:_model.imgsDic0PathName];
            NSDictionary *ImgDic1 = [Utilities JsonStrtoArrayOrNSDictionary:_model.imgsDic1PathName];
            NSDictionary *ImgDic2 = [Utilities JsonStrtoArrayOrNSDictionary:_model.imgsDic2PathName];
            
            NSString *imgArrNumStr0 = [NSString stringWithFormat:@"%ld",[ImgDic0 count]];
            NSString *imgArrNumStr1 = [NSString stringWithFormat:@"%ld",[ImgDic1 count]];
            NSString *imgArrNumStr2 = [NSString stringWithFormat:@"%ld",[ImgDic2 count]];
            
            NSString *imgPath0 = @"";
            NSString *imgPath1 = @"";
            NSString *imgPath2 = @"";
            
            if ([ImgDic0 count] > 0) {
                imgPath0 = [NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic0[@"0"]];
            }
            if ([ImgDic1 count] > 0) {
                imgPath1 = [NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic1[@"0"]];
            }
            if ([ImgDic2 count] > 0) {
                imgPath2 = [NSString stringWithFormat:@"%@/%@",imageDocPath , ImgDic2[@"0"]];
            }
            
            
            [_ImgV1 setTitle:@"起飞" imgPathUrl:imgPath0 numStr:imgArrNumStr0];
            [_ImgV2 setTitle:@"降落" imgPathUrl:imgPath1 numStr:imgArrNumStr1];
            [_ImgV3 setTitle:@"其他" imgPathUrl:imgPath2 numStr:imgArrNumStr2];
            
        } else {
            
            
            _labTitle.text = [[Utilities replaceNull:_model.orderName]isEqualToString:@""] ? @"未选中航段" : [NSString stringWithFormat:@"%@  %@", _model.airplaneType, _model.orderName];
            _labTime.text = _model.departureDate;
            
            
            NSArray *PicUrlArr = [Utilities JsonStrtoArrayOrNSDictionary:[Utilities replaceNull:_model.PicUrl]];
            
            NSString *imgPath0 = @"";
            NSString *imgPath1 = @"";
            NSString *imgPath2 = @"";
            
            NSMutableArray *imgArr0 = [NSMutableArray array];
            NSMutableArray *imgArr1 = [NSMutableArray array];
            NSMutableArray *imgArr2 = [NSMutableArray array];
            
            for (NSDictionary *dic in PicUrlArr) {
                if ([dic[@"type"] isEqualToString:@"1"]) {
                    [imgArr0 addObject:dic[@"xnpicurl"]];
                }
                if ([dic[@"type"] isEqualToString:@"2"]) {
                    [imgArr1 addObject:dic[@"xnpicurl"]];
                }
                if ([dic[@"type"] isEqualToString:@"3"]) {
                    [imgArr2 addObject:dic[@"xnpicurl"]];
                }
            }
            
            if ([imgArr0 count] > 0) {
                imgPath0 = [Utilities replaceNull:imgArr0[0]];
            }
            if ([imgArr1 count] > 0) {
                imgPath1 = [Utilities replaceNull:imgArr1[0]];
            }
            if ([imgArr2 count] > 0) {
                imgPath2 = [Utilities replaceNull:imgArr2[0]];
            }
            
            
            [_ImgV1 setTitle:@"起飞" imgPathUrl:imgPath0 numStr:[NSString stringWithFormat:@"%ld",[imgArr0 count]]];
            [_ImgV2 setTitle:@"降落" imgPathUrl:imgPath1 numStr:[NSString stringWithFormat:@"%ld",[imgArr1 count]]];
            [_ImgV3 setTitle:@"其他" imgPathUrl:imgPath2 numStr:[NSString stringWithFormat:@"%ld",[imgArr2 count]]];
        }
        
        
    }
}

+(CGFloat)cellheight
{
    CGFloat widthImg = (KScreenWidth/3-30)/4*3 + 20;
    return 70 + widthImg;
}

@end



@interface OnlyEditPerTableViewCellIconView ()

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labNum;
@property (nonatomic,strong) UIImageView *imgV;

@end

@implementation OnlyEditPerTableViewCellIconView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self upView];
    }
    return self;
}

-(void)upView
{
    self.backgroundColor = [UIColor clearColor];
    
    CGFloat widthImg = (CGRectGetWidth(self.frame)-30)/4*3;
    
    //  文字
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake((CGRectGetWidth(self.frame)-widthImg-30)/2, 0, 30, 13)];
    [self addSubview:_labTitle];
    _labTitle.textColor = color_gray2;
    _labTitle.font = FONT(11.5f);
    _labTitle.textAlignment = NSTextAlignmentCenter;
    
    
    //   图片
    _imgV = [[UIImageView alloc]initWithFrame:
             CGRectMake(CGRectGetMaxX(_labTitle.frame), 0, widthImg, widthImg)];
    [self addSubview:_imgV];
    _imgV.layer.masksToBounds = YES;
    _imgV.layer.cornerRadius = 10;
    _imgV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [_imgV setContentMode:UIViewContentModeScaleAspectFill];
    _imgV.clipsToBounds = YES;
    
    
    //   数目
    _labNum = [[UILabel alloc]initWithFrame:
               CGRectMake(CGRectGetWidth(_imgV.frame) - 40, 5, 35, 12)];
    [_imgV addSubview:_labNum];
    _labNum.backgroundColor = color_blackAlpha;
    _labNum.layer.masksToBounds = YES;
    _labNum.layer.cornerRadius = CGRectGetHeight(_labNum.frame)/2;
    _labNum.textColor = [UIColor whiteColor];
    _labNum.textAlignment = NSTextAlignmentCenter;
    _labNum.font = FONT(10.f);
    
}

-(void)setTitle:(NSString *)title imgPathUrl:(NSString *)imgPathUrl numStr:(NSString *)numStr
{
    _labTitle.text = title;
    _labNum.text = [numStr stringByAppendingString:@"张"];
    
    
//            UIImage *img = [UIImage imageWithContentsOfFile:imgpath];
    _imgV.image = [UIImage imageNamed:imgPathUrl];
    
    [_imgV sd_setImageWithURL:[NSURL URLWithString:imgPathUrl] placeholderImage:[UIImage imageNamed:imgPathUrl]];
    
}

@end
