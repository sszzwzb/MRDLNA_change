//
//  MyClassDetailViewController.h
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/14.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "EGORefreshTableHeaderView.h"
#import "EGORefreshTableFooterView.h"

@interface MyClassDetailViewController : BaseViewController<UIScrollViewDelegate,EGORefreshTableDelegate>{
    
    UIView *moduleView;//上半部分显示模块的
    
    UIView *newPhotoView;//下半部分显示照片的
    
    UIView *newPhotoSection;//最新照片那一条
    
    UIScrollView *scrollView;//底部的scrollView
    
    UIView *viewWhiteBg;
    
    NSArray *moduleNameArray;
    
    NSMutableArray *moduleArray;//6个模块
    
    NSMutableArray *moduleFromServer;
    
    NSMutableArray *galleriesArray;
    
    NSString *isNumber;// 0 或 其他 0是未绑定
    
    NSString *spaceForClass;//班级是否有学籍 待定

    NSMutableDictionary *redPointDic;//2015.12.18
    
    NSDictionary *messageDic;
    
    NSString *unbindIntroduceUrl;//老师身份班级未绑定学籍介绍页url

    NSString *statusForSpace;//成长空间状态
    
    UIImageView *imageView_rightMenu;
    UIImageView *imageView_bgMask;
    UIView *viewMask;
   
    // 判断右菜单点击状态
    BOOL isRightButtonClicked;
    NSMutableArray *tagArray;
    
    UIImageView *noticeImgVForMsg;//班级tab红点

    UILabel *barTitleLab;
    
    UIView *barView;
    
    UIView *noDataView;
    
    NSInteger reflashFlag;
    EGORefreshTableHeaderView *_refreshHeaderView;
    BOOL _reloading;
    
    NSMutableArray *redImgArray;//红点数组
    NSString *lastLeaveId;// 请假lastId
    NSString *isNewVersion;
    
    NSString *lastMsgId;
    
    float lastYForModuleV;
   
    UIView *bgV;
}

@property(nonatomic,strong)NSString *fromName;
@property(nonatomic,strong)NSString *cId;
@property (assign, nonatomic) BOOL isAdmin;
@property (nonatomic,strong) NSString *titleName;
@property (nonatomic,strong)NSDictionary *newsDic;//2015.11.13

@property(nonatomic,retain) UIView *maskView;
@property(nonatomic,retain) UIImageView *noRecipesView;

@property(nonatomic,retain) NSString *nextNum;

@property(nonatomic,retain) NSDictionary *cameraInfo;

@end
