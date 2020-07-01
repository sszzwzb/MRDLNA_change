//
//  SchoolModuleListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/14.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "SchoolModuleListViewController.h"
#import "MicroSchoolMainMenuTableViewCell.h"
#import "NewsListViewController.h"
#import "BroadcastViewController.h"
#import "MyTabBarController.h"

@interface SchoolModuleListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation SchoolModuleListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_otherSchoolName];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.hidden = YES;
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self getData];
    
    //------------------------update by kate 2015.05.21------------------------------------------
    if ([@"SchoolExhibition"  isEqual: _fromView]) {
        if ([self.favorite intValue] == 0 ) {//未收藏
            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
        }else{
            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
        }
        [ReportObject event:ID_OTHER_SCHOOL_DETAIL];//2015.06.25
    }else if ([@"bureauExhibition" isEqualToString:_fromView]){
        if ([self.favorite intValue] == 0 ) {//未收藏
            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
        }else{
            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
        }
    }
    else {//老苗说收藏按钮不区分学校版本 2015.07.10
        NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
        if (![schoolType isEqualToString:@"bureau"]) {
            if ([self.favorite intValue] == 0 ) {//未收藏
                [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
            }else{
                [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
            }
        }else{
            
            [ReportObject event:ID_OPEN_SUBORDINATE_MODULES];//2015.06.25
        }
    }
    
    [MyTabBarController setTabBarHidden:YES];
    //-------------------------------------------------------------------------------------------

    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    if ([self.favorite intValue] == 0) {
        [self collect];
    }else{
        
        UIAlertView *alerV = [[UIAlertView alloc]initWithTitle:@"提示" message:@"是否取消收藏？" delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        [alerV show];
        
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 1) {
        [self cancelCollect];
    }
    
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [FRNetPoolUtils getOtherSchoolModules:_otherSid andsSpecial:_special];
        
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (![Utilities isConnected]) {//2015.06.30
                
                noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
                [self.view addSubview:noNetworkV];
                
            }else{
                
                [noNetworkV removeFromSuperview];
            }
            
            if (dic == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                  NSMutableArray *array = [dic objectForKey:@"list"];
                
                if([array count] >0){
                    
                    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array];
                    
                    NSLog(@"listArray:%@",listArray);
                    
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                }
                
                NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
                
                if ([@"SchoolExhibition"  isEqual: _fromView]) {
                    NSString *favorite = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"favorite"]]];
                    if ([favorite intValue] == 0) {
                        self.favorite = @"0";
                        [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
                    }else{
                        self.favorite = @"1";
                        [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
                    }
                }else if ([@"bureauExhibition" isEqualToString:_fromView]){
                    NSString *favorite = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"favorite"]]];
                    if ([favorite intValue] == 0) {
                        self.favorite = @"0";
                        [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
                    }else{
                        self.favorite = @"1";
                        [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
                    }
                }
                else {
                    if (![schoolType isEqualToString:@"bureau"]) {//老苗说收藏按钮不区分学校版本2015.07.10
                        
                        NSString *favorite = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"favorite"]]];
                        if ([favorite intValue] == 0) {
                            self.favorite = @"0";
                            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
                        }else{
                            self.favorite = @"1";
                            [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
                        }
                    }
                }
            }
        });
        
    });
    
}

// 收藏
-(void)collect{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils collectSchool:_otherSid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (msg == nil) {
                
                //[MBProgressHUD showSuccess:@"收藏成功" toView:nil];
                [Utilities showSuccessedHud:@"收藏成功" descView:self.view];// 2015.05.12
                self.favorite = @"1";
                [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_press.png"];
                
                // add by ht 2015.04.15
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_SCHOOLEXHI_REFLASHVIEW object:self userInfo:nil];
                
                [ReportObject event:ID_OTHER_SCHOOL_ADD];//2015.06.25
                
            }else{
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
        });
        
    });
    
}

// 取消收藏
-(void)cancelCollect{
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils cancelCollectSchool:_otherSid];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (msg == nil) {
                
                //[MBProgressHUD showSuccess:@"取消收藏成功" toView:nil];
                [Utilities showSuccessedHud:@"取消收藏成功" descView:self.view];//2015.05.12
                self.favorite = @"0";
               [self setCustomizeRightButton:@"SchoolExhibition/icon_sc_normal.png"];
                
                // add by ht 2015.04.15
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_UI_SCHOOLEXHI_REFLASHVIEW object:self userInfo:nil];
                
                [ReportObject event:ID_OTHER_SCHOOL_REMOVE];//2015.06.25
                
            }else{
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }
        });
        
    });
    
}

#pragma UITableViewDelegate UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [listArray count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellTableIdentifier = @"CellTableIdentifier";
    
    MicroSchoolMainMenuTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        cell = [[MicroSchoolMainMenuTableViewCell alloc]
                initWithStyle:UITableViewCellStyleDefault
                reuseIdentifier:CellTableIdentifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
   
    NSDictionary* list_dic = [listArray objectAtIndex:indexPath.row];
    
    NSString* iconName= [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"icon"]];
    NSString* name= [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"name"]];
    NSString* comment= [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"note"]];
    
    cell.name = [Utilities replaceNull:name];
    cell.comment = [Utilities replaceNull:comment];
    
    [cell.imgView_icon sd_setImageWithURL:[NSURL URLWithString:iconName] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
    
    return cell;

}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    NSDictionary *list_dic = [listArray objectAtIndex:indexPath.row];
    NSString *name = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"name"]];
    NSString *type = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"type"]];
    
    if ([type integerValue] == 20) {
        
        BroadcastViewController *broadcastViewCtrl = [[BroadcastViewController alloc] init];
        broadcastViewCtrl.moduleName = name;
        broadcastViewCtrl.otherSid = _otherSid;// add by kate 2015.04.22
        [self.navigationController pushViewController:broadcastViewCtrl animated:YES];

      
    }else if([type integerValue] == 1  || [type integerValue] == 28){
    
        NewsListViewController *newsViewCtrl = [[NewsListViewController alloc] initWithVar:name];
        newsViewCtrl.otherSid = _otherSid;
        [self.navigationController pushViewController:newsViewCtrl animated:YES];
        
    }else if([type integerValue] == 2){
        
        DiscussViewController *discussViewCtrl = [[DiscussViewController alloc] init];
        discussViewCtrl.fromName = @"schoolExhi";
        discussViewCtrl.schoolExhiId = _otherSid;
        [self.navigationController pushViewController:discussViewCtrl animated:YES];
        discussViewCtrl.titleName = name;//update by kate
        [MyTabBarController setTabBarHidden:YES];
        
        [ReportObject event:ID_OPEN_SUBORDINATE_FORUM];//2015.06.25
        
    }else if ([type integerValue] == 23){
        // 链接模块
        
        
            NSURL *webUrl = [NSURL URLWithString:[list_dic objectForKey:@"url"]];
            
            if ([[UIApplication sharedApplication]canOpenURL:webUrl]) {
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"message";
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
#endif
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadURl;
                fileViewer.url = webUrl;
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }else {
#if 0
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.fromName = @"scan";
                fileViewer.loadHtmlStr = [list_dic objectForKey:@"url"];
                fileViewer.currentHeadImgUrl = nil;
#endif
                //2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.webType = SWLoadHtml;
                fileViewer.loadHtmlStr = [list_dic objectForKey:@"url"];
                fileViewer.currentHeadImgUrl = nil;
                
                [self.navigationController pushViewController:fileViewer animated:YES];
            }
            
            [ReportObject event:ID_OPEN_OUTER_LINK];//2015.06.25
            
        
    }else if ([type integerValue] == 24){
        
        
            // 内链模块
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  @"News", @"ac",
                                  @"2", @"v",
                                  @"innerLinkModule", @"op",
                                  _otherSid, @"sid",
                                  [list_dic objectForKey:@"name"], @"module",
                                  @"290",@"width",
                                  nil];
            
            NewsDetailViewController *newsDetailViewCtrl = [[NewsDetailViewController alloc] initWithVar:[list_dic objectForKey:@"name"]];
            
            newsDetailViewCtrl.viewType = @"innerLink";
            newsDetailViewCtrl.innerLinkReqData = data;
            
            [self.navigationController pushViewController:newsDetailViewCtrl animated:YES];
            
            [MyTabBarController setTabBarHidden:YES];
            
            [ReportObject event:ID_OPEN_HTML];//2015.06.25
    }else{
        
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"提示"
                                                       message:@"敬请期待"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    }
    
}


@end
