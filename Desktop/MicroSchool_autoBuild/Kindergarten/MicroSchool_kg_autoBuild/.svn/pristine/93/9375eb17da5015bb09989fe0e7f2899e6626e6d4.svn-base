//
//  DropDownListView.m
//  DropDownDemo
//
//  Created by 童明城 on 14-5-28.
//  Copyright (c) 2014年 童明城. All rights reserved.
//

#import "DropDownListView.h"
#define DEGREES_TO_RADIANS(angle) ((angle)/180.0 *M_PI)
#define RADIANS_TO_DEGREES(radians) ((radians)*(180.0/M_PI))

@implementation DropDownListView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame dataSource:(id)datasource delegate:(id) delegate
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        currentExtendSection = -1;
        self.dropDownDataSource = datasource;
        self.dropDownDelegate = delegate;
        
        NSInteger sectionNum =0;
        if ([self.dropDownDataSource respondsToSelector:@selector(numberOfSections)] ) {
            
            sectionNum = [self.dropDownDataSource numberOfSections];
        }
        
        if (sectionNum == 0) {
            self = nil;
        }
        
        //初始化默认显示view
        CGFloat sectionWidth = (1.0*(frame.size.width)/sectionNum);
        for (int i = 0; i <sectionNum; i++) {
            UIButton *sectionBtn = [[UIButton alloc] initWithFrame:CGRectMake(sectionWidth*i, 0, sectionWidth, frame.size.height)];
            sectionBtn.tag = SECTION_BTN_TAG_BEGIN + i;
            [sectionBtn addTarget:self action:@selector(sectionBtnTouch:) forControlEvents:UIControlEventTouchUpInside];
            NSString *sectionBtnTitle = @"--";
            if ([self.dropDownDataSource respondsToSelector:@selector(titleInSection:index:)]) {
                sectionBtnTitle = [self.dropDownDataSource titleInSection:i index:[self.dropDownDataSource defaultShowSection:i]];
            }
//            [sectionBtn  setTitle:sectionBtnTitle forState:UIControlStateNormal];
            [sectionBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            sectionBtn.titleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
            sectionBtn.titleLabel.frame = CGRectMake(0, 0, 10, 44);
//            dateBtn1.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;

            sectionBtn.titleLabel.font = [UIFont systemFontOfSize:15.0f];
            [sectionBtn setBackgroundColor:[UIColor colorWithRed:66/255.0 green:89/255.0 blue:108/255.0 alpha:1]];
            sectionBtn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
            [self addSubview:sectionBtn];
            
            
            UILabel *_label_message = [[UILabel alloc] initWithFrame:CGRectMake(sectionWidth*i + 31, 0, 46, frame.size.height)];
            _label_message.font = [UIFont systemFontOfSize:15.0f];
            _label_message.textColor = [UIColor whiteColor];
            _label_message.backgroundColor = [UIColor clearColor];
            _label_message.lineBreakMode = NSLineBreakByTruncatingTail;
//            _label_message.text = sectionBtnTitle;
            _label_message.textAlignment = NSTextAlignmentCenter;

            _label_message.tag = SECTION_LABEL_TAG_BEGIN + i;
            [self addSubview:_label_message];

            
            
            
            
            
            UIImageView *sectionBtnIv = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +(sectionWidth - 16)-10, (self.frame.size.height-12)/2, 12, 12)];
            [sectionBtnIv setImage:[UIImage imageNamed:@"arrow.png"]];
            [sectionBtnIv setContentMode:UIViewContentModeScaleToFill];
            sectionBtnIv.tag = SECTION_IV_TAG_BEGIN + i;
            
            [self addSubview: sectionBtnIv];
            
            int iconSize = 18;
            
            if (i == 0) {
                UIImageView *img1 = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +10, (self.frame.size.height-iconSize)/2, iconSize, iconSize)];
                [img1 setImage:[UIImage imageNamed:@"icon_lx.png"]];
                [img1 setContentMode:UIViewContentModeScaleToFill];
                [self addSubview: img1];
                
                _label_message.text = @"类型";

            }

            if (i == 1) {
                UIImageView *img2 = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +10, (self.frame.size.height-iconSize)/2, iconSize, iconSize)];
                [img2 setImage:[UIImage imageNamed:@"icon_km.png"]];
                [img2 setContentMode:UIViewContentModeScaleToFill];
                [self addSubview: img2];
                
                _label_message.text = @"科目";

            }

            if (i == 2) {
                UIImageView *img3 = [[UIImageView alloc] initWithFrame:CGRectMake(sectionWidth*i +10, (self.frame.size.height-iconSize)/2, iconSize, iconSize)];
                [img3 setImage:[UIImage imageNamed:@"icon_nj.png"]];
                [img3 setContentMode:UIViewContentModeScaleToFill];
                [self addSubview: img3];
                _label_message.text = @"年级";

            }


//            if (i<sectionNum && i != 0) {
//                UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(sectionWidth*i, frame.size.height/4, 1, frame.size.height/2)];
//                lineView.backgroundColor = [UIColor lightGrayColor];
//                [self addSubview:lineView];
//            }
            
        }
        
    }
    return self;
}

-(void)sectionBtnTouch:(UIButton *)btn
{
    NSInteger section = btn.tag - SECTION_BTN_TAG_BEGIN;
    
    UIImageView *currentIV= (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN +currentExtendSection)];
    
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    
    if (currentExtendSection == section) {
        [self hideExtendedChooseView];
    }else{
        currentExtendSection = section;
        currentIV = (UIImageView *)[self viewWithTag:SECTION_IV_TAG_BEGIN + currentExtendSection];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];
        
        [self showChooseListViewInSection:currentExtendSection choosedIndex:[self.dropDownDataSource defaultShowSection:currentExtendSection]];
    }

}

- (void)setTitle:(NSString *)title inSection:(NSInteger) section
{
    UIButton *btn = (id)[self viewWithTag:SECTION_BTN_TAG_BEGIN +section];
    [btn setTitle:title forState:UIControlStateNormal];
}

- (BOOL)isShow
{
    if (currentExtendSection == -1) {
        return NO;
    }
    return YES;
}
-  (void)hideExtendedChooseView
{
    if (currentExtendSection != -1) {
        currentExtendSection = -1;
        CGRect rect = self.mTableView.frame;
        rect.size.height = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.mTableBaseView.alpha = 1.0f;
            self.mTableView.alpha = 1.0f;
            
            self.mTableBaseView.alpha = 0.2f;
            self.mTableView.alpha = 0.2;
            
            self.mTableView.frame = rect;
        }completion:^(BOOL finished) {
            [self.mTableView removeFromSuperview];
            [self.mTableBaseView removeFromSuperview];
        }];
    }
}

-(void)showChooseListViewInSection:(NSInteger)section choosedIndex:(NSInteger)index
{
    if (!self.mTableView) {
        self.mTableBaseView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height , self.frame.size.width, self.mSuperView.frame.size.height - self.frame.origin.y - self.frame.size.height)];
        self.mTableBaseView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.5];

        UITapGestureRecognizer *bgTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(bgTappedAction:)];
        [self.mTableBaseView addGestureRecognizer:bgTap];
        
        self.mTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y + self.frame.size.height, self.frame.size.width, 240) style:UITableViewStylePlain];
        self.mTableView.tableFooterView = [[UIView alloc]init];

        self.mTableView.delegate = self;
        self.mTableView.dataSource = self;
        
    }
    
    //修改tableview的frame
    int sectionWidth = (self.frame.size.width);
    CGRect rect = self.mTableView.frame;
    rect.origin.x = 0;
    rect.size.width = sectionWidth;
    rect.size.height = 0;
    self.mTableView.frame = rect;
    [self.mSuperView addSubview:self.mTableBaseView];
    [self.mSuperView addSubview:self.mTableView];
    
    //动画设置位置
    rect .size.height = 240;
    [UIView animateWithDuration:0.3 animations:^{
        self.mTableBaseView.alpha = 0.2;
        self.mTableView.alpha = 0.2;
        
        self.mTableBaseView.alpha = 1.0;
        self.mTableView.alpha = 1.0;
        self.mTableView.frame =  rect;
    }];
    [self.mTableView reloadData];
}

-(void)bgTappedAction:(UITapGestureRecognizer *)tap
{
    UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
    [UIView animateWithDuration:0.3 animations:^{
        currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
    }];
    [self hideExtendedChooseView];
}
#pragma mark -- UITableView Delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dropDownDelegate respondsToSelector:@selector(chooseAtSection:index:)]) {
        UIImageView *currentIV = (UIImageView *)[self viewWithTag:(SECTION_IV_TAG_BEGIN + currentExtendSection)];
        [UIView animateWithDuration:0.3 animations:^{
            currentIV.transform = CGAffineTransformRotate(currentIV.transform, DEGREES_TO_RADIANS(180));
        }];

        NSString *chooseCellTitle = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
        
//        UIButton *currentSectionBtn = (UIButton *)[self viewWithTag:SECTION_BTN_TAG_BEGIN + currentExtendSection];
//        [currentSectionBtn setTitle:chooseCellTitle forState:UIControlStateNormal];
        
        UILabel *tlabel = (UILabel *)[self viewWithTag:SECTION_LABEL_TAG_BEGIN + currentExtendSection];
        tlabel.text = chooseCellTitle;

        [self.dropDownDelegate chooseAtSection:currentExtendSection index:indexPath.row];
        [self hideExtendedChooseView];
    }
}

#pragma mark -- UITableView DataSource


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dropDownDataSource numberOfRowsInSection:currentExtendSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.textLabel.text = [self.dropDownDataSource titleInSection:currentExtendSection index:indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    return cell;
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
