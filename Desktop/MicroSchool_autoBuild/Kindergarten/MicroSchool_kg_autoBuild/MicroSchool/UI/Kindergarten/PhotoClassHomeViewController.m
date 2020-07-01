//
//  PhotoClassHomeViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/5.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "PhotoClassHomeViewController.h"
#import "PhotoCollectionViewController.h"
#import "NewClassPhotoViewController.h"
#import "PublishMomentsViewController.h"
#import "CreatePhotoCollectionViewController.h"
#import "MomentsDetailViewController.h"
#import "PhotoCollectionDetailViewController.h"
#import "SightRecordViewController.h"

@interface PhotoClassHomeViewController ()

@end

@implementation PhotoClassHomeViewController

- (void)loadView
{
    self.view = [[UIView alloc] initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height-29)];
    
    [self setCustomizeLeftButton];
   
    contactTabbar = [[PhonebookTabBarViewController alloc]init];
    
    NewClassPhotoViewController *newClassPVC = [[NewClassPhotoViewController alloc] init];
    newClassPVC.cId = _cid;
    
    
    PhotoCollectionViewController *photoCVC = [[PhotoCollectionViewController alloc] init];
    photoCVC.cid = _cid;
    
    NSArray *viewControllers = [NSArray arrayWithObjects:newClassPVC,
                                photoCVC,
                                nil];
    
    [contactTabbar setViewControllers:viewControllers];
    
    [self.view addSubview:contactTabbar.view];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoCreatePhotoCollection:) name:@"gotoCreatePhotoCollection" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoPhotoCollectionDetail:) name:@"gotoPhotoCollectionDetail" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoFootmarkPicDetail:) name:@"gotoFootmarkPicDetail" object:nil];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // 导航栏上加segment
    NSArray *segmentedArray = [NSArray arrayWithObjects:@"最新",@"相册",nil];
    segmentedControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    segmentedControl.layer.masksToBounds = YES;
    segmentedControl.frame = CGRectMake(0.0, 0.0, 100, 30.0);
    //[segmentedControl sizeToFit];
    // to do:弄成完全的圆角 边缘线就会缺一块 why
    segmentedControl.layer.cornerRadius = CGRectGetHeight(segmentedControl.frame) / 2.0f;
    segmentedControl.layer.borderWidth = 1.0f;
    segmentedControl.layer.borderColor = [UIColor whiteColor].CGColor;
    
    //[segmentedControl sizeToFit];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.tintColor = [UIColor whiteColor];
    
    [segmentedControl addTarget:self  action:@selector(changeForSegmentedControl:)
               forControlEvents:UIControlEventValueChanged];
    //方法1
    //[self.navigationController.navigationBar.topItem setTitleView:segmentedControl];
    //方法2
    [self.navigationItem setTitleView:segmentedControl];
    
    if ([Utilities getUserType] != UserType_Parent && [Utilities getUserType] != UserType_Student) {
        [self setCustomizeRightButton:@"ClassKin/icon_sendPhoto"];
    }

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)changeForSegmentedControl:(UISegmentedControl *)Seg{
    
    contactTabbar.selectedIndex = Seg.selectedSegmentIndex;
    
}

-(void)selectRightAction:(id)sender{
    
    //弹出actionsheet 小视频 传照片
    UIActionSheet *alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"传照片",@"小视频", nil];
    [alertSheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED{
    
    if(buttonIndex == 0){
       
        PublishMomentsViewController *publish = [[PublishMomentsViewController alloc]init];
        publish.flag = 0;
        publish.cid = _cid;
        publish.fromName = @"classPhotoList";
        [self.navigationController pushViewController:publish animated:YES];
        
    }else if (buttonIndex == 1){//传照片
        //to beck:小视频入口
        
        //to do:到小视频录制页
        
        SightRecordViewController *vc = [[SightRecordViewController alloc]init];
        vc.fromName = @"PhotoHome";
        vc.cid = _cid;
        [self.navigationController pushViewController:vc animated:YES];
        
    }
}

//去新建相册
-(void)gotoCreatePhotoCollection:(NSNotification*)notify{
    
    NSLog(@"创建相册");
    CreatePhotoCollectionViewController *cpcv = [[CreatePhotoCollectionViewController alloc] init];
    cpcv.cid = _cid;
    [self.navigationController pushViewController:cpcv animated:YES];
    
}

//去相册详情
-(void)gotoPhotoCollectionDetail:(NSNotification*)notify{
    
    NSDictionary *dic = [notify userInfo];
    PhotoCollectionDetailViewController *pcdvc = [[PhotoCollectionDetailViewController alloc] init];
    pcdvc.cid = _cid;
    pcdvc.aid = [dic objectForKey:@"aid"];
    pcdvc.photoAlbumTitle = [dic objectForKey:@"title"];
    [self.navigationController pushViewController:pcdvc animated:YES];
    
    
}

//去最新详情
-(void)gotoFootmarkPicDetail:(NSNotification*)notify{
    
    NSString *tid = (NSString*)[notify object];
    MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
    momentsDetailViewCtrl.tid = tid;//动态id
    momentsDetailViewCtrl.fromName = @"classPhoto";
    momentsDetailViewCtrl.cid = _cid;
    [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];

}


@end
