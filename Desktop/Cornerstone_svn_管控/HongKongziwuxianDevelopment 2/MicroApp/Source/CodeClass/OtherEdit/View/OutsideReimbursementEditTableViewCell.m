//
//  OutsideReimbursementEditTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/14.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementEditTableViewCell.h"

#import "OnlyEditPerSQLModel.h"


#define cellHeight_Flighs       70
#define cellHeight_imgs         ((KScreenWidth-90 - 20)/3 + 40) + 30
#define cellHeight_TextF       50
#define cellHeight_TextV       100

@interface OutsideReimbursementEditTableViewCell () <UITextViewDelegate,UITextFieldDelegate>

@property (nonatomic,strong) UIButton *cellFlightsView;  //  整体的航班

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labTime;
@property (nonatomic,strong) UIButton *butSelectR;  //   y航班的选择状态



@property (nonatomic,strong) UIView *cellImgsView;
@property (nonatomic,strong) UILabel *labImgTitle;


@property (nonatomic,strong) UIView *TextFView;
@property (nonatomic,strong) UILabel *TextFTitle;
@property (nonatomic,strong) UITextField *TextF;
@property (nonatomic,strong) UITextView *TextV;


@end

@implementation OutsideReimbursementEditTableViewCell

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
        [self up_cell];
    }
    return self;
}

-(void)up_cell
{
    self.backgroundColor = [UIColor whiteColor];
    
    UIView *viewBG = [[UIView alloc]init];
    viewBG.backgroundColor = [UIColor whiteColor];
    self.selectedBackgroundView = viewBG;
    
    
#pragma mark - 整体的航班 UI
    //   整体的航班
    _cellFlightsView = [UIButton buttonWithType:(UIButtonTypeSystem)];
    _cellFlightsView.frame = CGRectMake(0, 0, KScreenWidth, cellHeight_Flighs);
    [self addSubview:_cellFlightsView];
    _cellFlightsView.backgroundColor = [UIColor whiteColor];
    _cellFlightsView.tag = 200;
    [_cellFlightsView addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _cellFlightsView.hidden = YES;
    
    
    //  title
    _labTitle = [[UILabel alloc]initWithFrame:
                 CGRectMake(10, 10, KScreenWidth - 85, 30)];
    [_cellFlightsView addSubview:_labTitle];
    _labTitle.textColor = color_black;
    _labTitle.font = FONT(16.f);
    
    
    
    //   时间
    _labTime = [[UILabel alloc]initWithFrame:
                CGRectMake(CGRectGetMinX(_labTitle.frame), CGRectGetMaxY(_labTitle.frame), CGRectGetWidth(_labTitle.frame), 20)];
    [_cellFlightsView addSubview:_labTime];
    _labTime.textColor = color_gray2;
    _labTime.font = FONT(14.5f);
    
    
    
    //   右侧选项
    _butSelectR = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [_cellFlightsView addSubview:_butSelectR];
    _butSelectR.frame = CGRectMake(KScreenWidth - 40, (cellHeight_Flighs-20)/2, 20, 20);
    _butSelectR.userInteractionEnabled = NO;
    [_butSelectR setImage:[UIImage imageNamed:@"OnlyEditToEditRNormal"] forState:(UIControlStateNormal)];
    [_butSelectR setImage:[UIImage imageNamed:@"OnlyEditToEditRSelect"] forState:(UIControlStateSelected)];
    _butSelectR.tag = 201;
    
    
    
    
    
#pragma mark - 图片
    _cellImgsView = [[UIView alloc]initWithFrame:
                     CGRectMake(0, 0, KScreenWidth, 30)];
    [self addSubview:_cellImgsView];
    _cellImgsView.backgroundColor = [UIColor whiteColor];
    _cellImgsView.hidden = YES;
    
    
    //  i标题
    _labImgTitle = [[UILabel alloc]initWithFrame:
                    CGRectMake(15, 10, 80, 20)];
    [_cellImgsView addSubview:_labImgTitle];
    _labImgTitle.textColor = color_black;
    _labImgTitle.font = FONT(15.f);
    
    
    
    
    _TextFView = [[UIView alloc]initWithFrame:
                  CGRectMake(95, 10, KScreenWidth - 110, cellHeight_TextF - 20)];
    [self addSubview:_TextFView];
    _TextFView.layer.cornerRadius = CGRectGetHeight(_TextFView.frame)/2;
    _TextFView.layer.borderColor = color_gray.CGColor;
    _TextFView.layer.borderWidth = 0.8f;
    _TextFView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TextFView.hidden = YES;
    
    
    _TextFTitle = [[UILabel alloc]initWithFrame:
                   CGRectMake(CGRectGetWidth(_TextFView.frame) - 50, 0, 50, CGRectGetHeight(_TextFView.frame))];
    [_TextFView addSubview:_TextFTitle];
    _TextFTitle.textColor = color_gray2;
    _TextFTitle.textAlignment = NSTextAlignmentCenter;
    _TextFTitle.font = FONT(15.f);
    
    
    //  文本
    _TextF = [[UITextField alloc]initWithFrame:
              CGRectMake(10, 0, CGRectGetWidth(_TextFView.frame) - 60, CGRectGetHeight(_TextFView.frame))];
    [_TextFView addSubview:_TextF];
    _TextF.backgroundColor = [UIColor clearColor];
    _TextF.font = FONT(15.f);
    _TextF.textColor = color_black;
    _TextF.keyboardType = UIKeyboardTypeDecimalPad;
    _TextF.delegate = self;
    
    
    //  文本
    _TextV = [[UITextView alloc]initWithFrame:
              CGRectMake(95, 10, KScreenWidth - 110, cellHeight_TextV - 20)];
    [self addSubview:_TextV];
    _TextV.backgroundColor = [UIColor greenColor];
    _TextV.hidden = YES;
    _TextV.font = FONT(15.f);
    _TextV.backgroundColor = color_black;
    _TextV.layer.cornerRadius = 10;
    _TextV.layer.borderColor = color_gray.CGColor;
    _TextV.layer.borderWidth = 0.8f;
    _TextV.backgroundColor = [UIColor groupTableViewBackgroundColor];
    _TextV.delegate = self;
    
}



-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 200) {
        UIButton *but = [_cellFlightsView viewWithTag:201];
        but.selected = !but.selected;
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(selectCellForSection0WithModel:row:)]) {
            [self.delegate selectCellForSection0WithModel:_model row:_indexPath.row];
        }
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    NSDictionary *dic = @{
                          @"type":@"textField",
                          @"text":textField.text
                          };
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TextOutWithDic:)]) {
        [self.delegate TextOutWithDic:dic];
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView
{
    NSDictionary *dic = @{
                          @"type":@"textView",
                          @"text":textView.text
                          };
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(TextOutWithDic:)]) {
        [self.delegate TextOutWithDic:dic];
    }
}


-(void)reloadDataWithType:(NSInteger)tag
{
    if (tag == 0) {
        
        if (_indexPath.section == 0) {
            _cellFlightsView.hidden = NO;
            _cellImgsView.hidden = YES;
            _TextFView.hidden = YES;
            _TextV.hidden = YES;
            
            if (_model) {
                
                _labTitle.attributedText = [self attributedTextWithID:[Utilities replaceNull:_model.airplaneType] title:[Utilities replaceNull:_model.orderName]];
                _labTime.text = [Utilities replaceNull:_model.departureDate];
                
                if ([_model.selectForCell isEqualToString:@"userInteractionEnabled_NO"]) {
                    _butSelectR.hidden = YES;
                    self.userInteractionEnabled = NO;
                } else {
                    _butSelectR.selected = [_model.selectForCell isEqualToString:@"YES"] ? YES : NO;
                    _butSelectR.hidden = NO;
                    self.userInteractionEnabled = YES;
                }
                
            }
            
        } else {
            _cellFlightsView.hidden = YES;
            _cellImgsView.hidden = NO;
            _TextFView.hidden = YES;
            _TextV.hidden = YES;
            _TextFTitle.text = @"元";
            
            
            if (_indexPath.row == 0) {
                _TextFView.hidden = NO;
                _labImgTitle.text = @"报销总价";
                
                
            }
            if (_indexPath.row == 1) {
                _TextV.hidden = NO;
                _labImgTitle.text = @"报销备注";
                
                
            }
            if (_indexPath.row == 2) {
                _labImgTitle.text = @"外采凭证";
            }
            
        }
    }
    
    if (tag == 1) {
        
        if (_indexPath.section == 0) {
            _cellFlightsView.hidden = NO;
            _cellImgsView.hidden = YES;
            _TextFView.hidden = YES;
            _TextV.hidden = YES;
            
            if (_model) {
                
                _labTitle.attributedText = [self attributedTextWithID:[Utilities replaceNull:_model.airplaneType] title:[Utilities replaceNull:_model.orderName]];
                _labTime.text = [Utilities replaceNull:_model.departureDate];
                
                if ([_model.selectForCell isEqualToString:@"userInteractionEnabled_NO"]) {
                    _butSelectR.hidden = YES;
                    self.userInteractionEnabled = NO;
                } else {
                    _butSelectR.selected = [_model.selectForCell isEqualToString:@"YES"] ? YES : NO;
                    _butSelectR.hidden = NO;
                    self.userInteractionEnabled = YES;
                }
                
            }
            
        } else {
            _cellFlightsView.hidden = YES;
            _cellImgsView.hidden = NO;
            _TextFView.hidden = YES;
            _TextV.hidden = YES;
            _TextFTitle.text = @"KG";
            
            
            if (_indexPath.row == 0) {
                _TextFView.hidden = NO;
                _labImgTitle.text = @"剩余油量";
                
                
            }
            if (_indexPath.row == 1) {
                _TextV.hidden = NO;
                _labImgTitle.text = @"剩余备注";
                
                
            }
            if (_indexPath.row == 2) {
                _labImgTitle.text = @"剩余凭证";
            }
            
        }
    }
}

-(NSAttributedString *)attributedTextWithID:(NSString *)ID title:(NSString *)title{
    NSString *string = [NSString stringWithFormat:@"%@  %@",ID , title];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:color_blue
                range:NSMakeRange(0,[ID length])];
    
    
    return str;
}

+(CGFloat)cellHeithWithIndexPath:(NSIndexPath *)indexPath imgToolHeight:(CGFloat)imgToolHeight
{
    if (indexPath.section == 0) {
        //  航班的高度
        return cellHeight_Flighs;
    } else {
        //   图片的高度
        if (indexPath.row == 2) {
            return imgToolHeight;
        } else if (indexPath.row == 0) {
            return cellHeight_TextF;
        } else {
            return cellHeight_TextV;
        }
        
    }
    
}


@end
