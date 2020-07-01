//
//  OnlyEditToEditTableViewCell.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/9.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditToEditTableViewCell.h"

#import "OnlyEditPerSQLModel.h"


#define cellHeight_Flighs       70
#define cellHeight_imgs         (((KScreenWidth-90 - 20)/3 + 40) + 30)
#define cellHeight_Perimgs      ((KScreenWidth-90 - 20)/3 + 30)


@interface OnlyEditToEditTableViewCell () <OnlyEditToEditTableViewCellImgAndTextDelegate>

@property (nonatomic,strong) UIButton *cellFlightsView;  //  整体的航班

@property (nonatomic,strong) UILabel *labTitle;
@property (nonatomic,strong) UILabel *labTime;
@property (nonatomic,strong) UIButton *butSelectR;  //   y航班的选择状态



@property (nonatomic,strong) UIView *cellImgsView;
@property (nonatomic,strong) UILabel *labImgTitle;

@property (nonatomic,strong) OnlyEditToEditTableViewCellImgAndText *ImgAndTextV1;
@property (nonatomic,strong) OnlyEditToEditTableViewCellImgAndText *ImgAndTextV2;
@property (nonatomic,strong) OnlyEditToEditTableViewCellImgAndText *ImgAndTextV3;

@end

@implementation OnlyEditToEditTableViewCell

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
                     CGRectMake(0, 0, KScreenWidth, cellHeight_imgs)];
    [self addSubview:_cellImgsView];
    _cellImgsView.backgroundColor = [UIColor whiteColor];
    _cellImgsView.hidden = YES;
    
    
    //  i标题
    _labImgTitle = [[UILabel alloc]initWithFrame:
                    CGRectMake(10, 20, 60, 18)];
    [_cellImgsView addSubview:_labImgTitle];
    _labImgTitle.textColor = color_gray2;
    _labImgTitle.font = FONT(12.f);
    _labImgTitle.textAlignment = NSTextAlignmentCenter;
    
    
    CGFloat imgWidth = (KScreenWidth-90 - 20)/3;
    
    
//    _ImgAndTextV1 = [[OnlyEditToEditTableViewCellImgAndText alloc]initWithFrame:
//                     CGRectMake(CGRectGetMaxX(_labImgTitle.frame) + 10, 20, imgWidth, imgWidth + 30)];
//    [_cellImgsView addSubview:_ImgAndTextV1];
//    _ImgAndTextV1.butDelegate = self;
//
//    _ImgAndTextV2 = [[OnlyEditToEditTableViewCellImgAndText alloc]initWithFrame:
//                     CGRectMake(CGRectGetMaxX(_ImgAndTextV1.frame) + 10, 20, imgWidth, imgWidth + 30)];
//    [_cellImgsView addSubview:_ImgAndTextV2];
//    _ImgAndTextV2.butDelegate = self;
//
//
//    _ImgAndTextV3 = [[OnlyEditToEditTableViewCellImgAndText alloc]initWithFrame:
//                     CGRectMake(CGRectGetMaxX(_ImgAndTextV2.frame) + 10, 20, imgWidth, imgWidth + 30)];
//    [_cellImgsView addSubview:_ImgAndTextV3];
//    _ImgAndTextV3.butDelegate = self;
    
    
    
    
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

-(void)selectImgButAndTextBut:(NSInteger)tag
{
    if (tag == 0) {
        NSLog(@"点击图片");
    }
    if (tag == 1) {
        NSLog(@"点击备注");
    }
    if (tag == 3) {
        NSLog(@"添加图片");
    }
    
}


-(void)reloadData
{
    if (_indexPath.section == 0) {
        _cellFlightsView.hidden = NO;
        _cellImgsView.hidden = YES;
        
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
        
        UIView *view0 = [self viewWithTag:1060];
        [view0 removeFromSuperview];
        
        UIView *view1 = [self viewWithTag:1061];
        [view1 removeFromSuperview];
        
        UIView *view2 = [self viewWithTag:1062];
        [view2 removeFromSuperview];
        
    } else {
        _cellFlightsView.hidden = YES;
        _cellImgsView.hidden = NO;
        self.userInteractionEnabled = YES;
        
        if (_indexPath.row == 0) {
            _labImgTitle.text = @"起飞凭证";
        } else if (_indexPath.row == 1) {
            _labImgTitle.text = @"降落凭证";
        } else if (_indexPath.row == 2) {
            _labImgTitle.text = @"其他凭证";
        } else {
            
        }
        
        
        [_ImgAndTextV1 setImgStr:@"" isHidden:YES isAdd:YES];
        [_ImgAndTextV2 setImgStr:@"" isHidden:YES isAdd:NO];
        [_ImgAndTextV3 setImgStr:@"" isHidden:YES isAdd:NO];
        
        
        [_ImgAndTextV1 setTextContent:@""];
        [_ImgAndTextV2 setTextContent:@""];
        [_ImgAndTextV3 setTextContent:@""];
        
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

+(CGFloat)cellHeithWithSection:(NSInteger)section imgToolHeight:(CGFloat)imgToolHeight
{
    if (section == 0) {
        //  航班的高度
        return cellHeight_Flighs;
    } else {
        //   图片的高度
        return imgToolHeight + 30;
    }
    
}


@end






@interface OnlyEditToEditTableViewCellImgAndText ()

@property (nonatomic,strong) UIButton *butDownNote;
@property (nonatomic,strong) UIButton *butAdd;

@end

@implementation OnlyEditToEditTableViewCellImgAndText

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self up_view];
    }
    return self;
}

-(void)up_view
{
    self.backgroundColor = [UIColor whiteColor];
    
    //  图片
    _butImg = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butImg];
    _butImg.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
    _butImg.backgroundColor = [UIColor clearColor];
    _butImg.tag = 500;
    [_butImg addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_butImg setContentMode:UIViewContentModeScaleAspectFill];
    _butImg.clipsToBounds = YES;
    
    //  添加的图片
    _butAdd = [UIButton buttonWithType:(UIButtonTypeSystem)];
    [self addSubview:_butAdd];
    _butAdd.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame));
    _butAdd.backgroundColor = [UIColor clearColor];
    _butAdd.tag = 503;
    [_butAdd addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    [_butAdd setBackgroundImage:[UIImage imageNamed:@"ImgAdd"] forState:(UIControlStateNormal)];
    
    
    //   查看备注图片
    _butDownNote = [UIButton buttonWithType:(UIButtonTypeCustom)];
    [self addSubview:_butDownNote];
    _butDownNote.frame = CGRectMake(10, CGRectGetMaxY(_butImg.frame) + (CGRectGetHeight(self.frame) - CGRectGetWidth(self.frame) - 18)/2, CGRectGetWidth(self.frame) - 20, 18);
    _butDownNote.layer.cornerRadius = CGRectGetHeight(_butDownNote.frame)/2;
    _butDownNote.layer.borderColor = color_gray2.CGColor;
    _butDownNote.layer.borderWidth = 0.8f;
    [_butDownNote setTitle:@"添加备注" forState:(UIControlStateNormal)];
    [_butDownNote setTitle:@"查看备注" forState:(UIControlStateSelected)];
    _butDownNote.titleLabel.font = FONT(11.f);
    [_butDownNote setTitleColor:color_black forState:(UIControlStateNormal)];
    _butDownNote.tag = 501;
    [_butDownNote addTarget:self action:@selector(buttonAction:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _butImg.hidden = YES;
    _butAdd.hidden = YES;
    _butDownNote.hidden = YES;
}

-(void)buttonAction:(UIButton *)button
{
    if (button.tag == 500) {
        NSLog(@"点击图片");
    }
    if (button.tag == 501) {
        NSLog(@"点击备注");
    }
    if (button.tag == 503) {
        NSLog(@"添加图片");
    }
    
    if (self.butDelegate && [self.butDelegate respondsToSelector:@selector(selectImgButAndTextBut:)]) {
        [self.butDelegate selectImgButAndTextBut:button.tag - 500];
    }
}

-(void)setImgStr:(NSString *)imgStr isHidden:(BOOL)isHidden isAdd:(BOOL)isAdd
{
    _butAdd.hidden = !isAdd;
    
    if (isHidden) {
        _butImg.hidden = YES;
        _butDownNote.hidden = YES;
        _textContent = @"";
        _butDownNote.selected = NO;
        
        [_butImg setBackgroundImage:[UIImage new] forState:(UIControlStateNormal)];
        
    } else {
        _butImg.hidden = NO;
        _butDownNote.hidden = NO;
        if ([[Utilities replaceNull:_textContent] isEqualToString:@""]) {
            _butDownNote.selected = NO;
            _butDownNote.backgroundColor = [UIColor whiteColor];
        } else {
            _butDownNote.selected = YES;
            _butDownNote.backgroundColor = [UIColor groupTableViewBackgroundColor];
        }
        
        [_butImg setBackgroundImage:[UIImage imageNamed:imgStr] forState:(UIControlStateNormal)];
    }
}

-(void)setTextContent:(NSString *)textContent
{
    _textContent = textContent;
    
    if ([[Utilities replaceNull:_textContent] isEqualToString:@""]) {
        _butDownNote.selected = NO;
        _butDownNote.backgroundColor = [UIColor whiteColor];
    } else {
        _butDownNote.selected = YES;
        _butDownNote.backgroundColor = [UIColor groupTableViewBackgroundColor];
    }
    
}


@end
