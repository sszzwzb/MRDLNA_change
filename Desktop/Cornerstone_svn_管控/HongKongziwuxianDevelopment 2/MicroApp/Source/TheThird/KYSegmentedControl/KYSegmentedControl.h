//
//  ViewController.h
//  segmentControllerl
//
//  Created by kaiyi on 16/12/23.
//          改自  李佳佳 on 15/6/30. LjjUIsegumentViewController.h
//          二次修改  kaiyi on 18/04/27 KYSegmentedControl
//  Copyright © 2016年 kaiyi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, kySegmentButDown) {  //  按键下面的下划线大小
    kySegmentButDownSType1,  //  一样长
    kySegmentButDownSType2,  //  算的长度，不一样
};

typedef NS_ENUM(NSInteger, kySegmentPerBut) {  //  整体按键大小
    kySegmentPerButType1,   //  最大是 选择的宽度，小了压缩
    kySegmentPerButType2,   //  每个使用不同的间距
};

@protocol KYSegmentedControlDelegate <NSObject>

-(void)segumentSelectionChange:(NSInteger)selection;

@end


@interface KYSegmentedControl : UIScrollView

@property (nonatomic,assign) kySegmentButDown kySegmentButDown;
@property (nonatomic,assign) kySegmentPerBut kySegmentPerBut;

@property(strong,nonatomic)UIColor *LJBackGroundColor;      //    背景颜色
@property(strong,nonatomic)UIColor *titleColor;             //    未选中的字体颜色
@property(strong,nonatomic)UIColor *selectColor;            //    选中的字体颜色
@property(strong,nonatomic)UIFont *titleFont;               //    字体大小
@property(strong,nonatomic)UIFont *selectTitleFont;         //    选中字体大小


@property(nonatomic,strong) id <KYSegmentedControlDelegate> myDelegate;

@property (nonatomic,strong) NSArray *SegumentArray;

-(void)selectTheSegument:(NSInteger)segument;  //   显示第几页

@end

