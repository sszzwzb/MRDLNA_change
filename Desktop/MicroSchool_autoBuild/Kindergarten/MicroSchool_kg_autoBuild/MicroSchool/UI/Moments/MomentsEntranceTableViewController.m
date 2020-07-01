//
//  MomentsEntranceTableViewController.m
//  MicroSchool
//
//  Created by Kate on 15-2-3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "MomentsEntranceTableViewController.h"
#import "MomentsViewController.h"
#import "MyTabBarController.h"
#import "KnowlegeHomePageViewController.h"
#import "SubscribeNumListViewController.h"
#import "UIImageView+WebCache.h"
#import "TOWebViewController.h"


@interface MomentsEntranceTableViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

UIImageView *newIconImg;
@implementation MomentsEntranceTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    //isNewForScan = [[UIImageView alloc] init];去掉new标实2015.07.29
   // NSString *isK = [[NSUserDefaults standardUserDefaults] objectForKey:@"isKnowledge"];
    
    //_foundModuleName = [[NSUserDefaults standardUserDefaults] objectForKey:@"foundModule"];

    if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
        _foundModuleName = @"校友圈";
#endif
        _foundModuleName = @"师生圈";//2016.01.05
    }

    /*if([isK intValue] == 1){
        isKnowledge = YES;
        
        knowledgeName = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"knowledgeName"]];
    }else{
        isKnowledge = NO;
    }*/
    
    
    newIconImg = [[UIImageView alloc]init];
    newIconImg.hidden = YES;
    newIconImg.frame = CGRectMake([_foundModuleName length]*17 + 63, (44 - 18)/2+30, 10, 10);
    newIconImg.image = [UIImage imageNamed:@"icon_new"];
   
    
    noticeImgVForMsg = [[UIImageView alloc]initWithFrame:CGRectMake(80-22-10, 5, 10, 10)];//update by kate 2014.12.30
    noticeImgVForMsg.image = [UIImage imageNamed:@"icon_new"];
    noticeImgVForMsg.tag = 431;
    
    _tableView.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    [super setCustomizeTitle:_titleName];
    
    //----add by kate---------------------------------------------------
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    [_tableView addSubview:_refreshHeaderView];
    //--------------------------------------------------------------------
    
    //-------------------------------------------------
    NSMutableArray *tempArray = [[NSUserDefaults standardUserDefaults]objectForKey:@"tabTitles"];
    
    if([tempArray count] > 0){
        [self setCustomizeTitle:[tempArray objectAtIndex:2]];
    }
    //----------------------------------------------------------
    
#if 0 //2015.12.30 校友圈cell红点
    [_tableView addSubview:newIconImg];
#endif
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"getMomentsNotify" object:nil];// 2015.05.13
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(isConnected)
                                                 name:@"isConnectedForMoments"
                                               object:nil];//2015.06.25

    
    [self getData];// 2015.05.13

}


-(void)checkSelfMomentsNew{
    
    MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
    UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
    UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
    [imgV removeFromSuperview];
    UIImageView *imgV2 = (UIImageView*)[button viewWithTag:431];
    [imgV2 removeFromSuperview];

#if 0 //2015.12.30 发现tab上的红点
    [button addSubview:noticeImgVForMsg];
#endif
    
    newIconImg.hidden = NO;
    
}

// check发现cell的红点
-(void)checkMomentsMsgNew{
    
    /**
     * 动态消息检查数量
     * @author luke
     * @date 2015.06.05
     * @args
     *  ac=Circle, v=2, op=check, sid=, uid=, last=
     */
    NSMutableDictionary *tempSelfDic = [[NSMutableDictionary alloc]initWithDictionary:[[NSUserDefaults standardUserDefaults]objectForKey:@"lastMyNewMsgIdDic"]];
    NSString *msgLastId = [Utilities replaceNull:[tempSelfDic objectForKey:[Utilities getUniqueUid]]];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          @"Circle",@"ac",
                          @"2",@"v",
                          @"check", @"op",
                          msgLastId, @"last",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"respDic:%@",respDic);
            NSString *message = [respDic objectForKey:@"message"];
            
            if ([message integerValue] > 0) {
                
                [self checkSelfMomentsNew];
            }
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];

    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:NO];
    self.navigationController.navigationBarHidden = NO;
    
     reflashFlag = 1;

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(checkSelfMomentsNew)
                                                 name:@"checkMomentsNew"
                                               object:nil];
    
    // 发现tab上的红点remove update by kate 2015.03.03
    if (newIconImg.hidden == YES) {
        
        MicroSchoolAppDelegate *appDelegate = (MicroSchoolAppDelegate *)[UIApplication sharedApplication].delegate;
        UIButton *button = [appDelegate.tabBarController.buttons objectAtIndex:2];
        UIImageView *imgV = (UIImageView*)[button viewWithTag:430];
        [imgV removeFromSuperview];
        
    }
    
    [self checkMomentsMsgNew];
    
    //----离线缓存2015.05.14---------------------------------------------------------------------
    BOOL isConnect = [Utilities connectedToNetwork];
    if (isConnect) {
        
    }else{
        NSDictionary *result = [[NSUserDefaults standardUserDefaults]objectForKey:@"momentEnter"];
        //NSLog(@"result:%@",result);
        
        if (result) {
            
            if ([[result objectForKey:@"result"] integerValue] == 1) {
                
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"momentEnter"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                _tableView.hidden = NO;
                
                listArray =[[NSMutableArray alloc] initWithArray:[result objectForKey:@"message"] copyItems:YES];
                
                
                for (int i=0; i<[listArray count]; i++) {
                    
                    NSArray *array =[listArray objectAtIndex:i];
                    for (int j=0; j<[array count]; j++) {
                        
                        NSDictionary *dic = [array objectAtIndex:j];
                        NSString *type = [dic objectForKey:@"type"];
                        if ([type integerValue] == 10001) {
                            _foundModuleName = [dic objectForKey:@"name"];
                        }
                        
                    }
                    
                }
                
                
                if ([_foundModuleName length]>13) {
                    newIconImg.frame = CGRectMake(14*16 + 63, (44 - 18)/2+30, 10, 10);
                }else{
                    newIconImg.frame = CGRectMake([_foundModuleName length]*16 + 63, (44 - 18)/2+30, 10, 10);
                    
                }
                
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
            }else{
                [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            }
            
            
        }
    }
    
    //---------------------------------------------------------------------------------------------
    
    if ((nil == _foundModuleName) || ([@""  isEqual: _foundModuleName])) {
#if 0
        _foundModuleName = @"校友圈";
#endif
        _foundModuleName = @"师生圈";//2016.01.05
    }

    if ([_foundModuleName length]>13) {
        newIconImg.frame = CGRectMake(14*16 + 63, (44 - 18)/2+30, 10, 10);
    }else{
        newIconImg.frame = CGRectMake([_foundModuleName length]*16 + 63, (44 - 18)/2+30, 10, 10);
        
    }

    [_tableView reloadData];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
     [[NSNotificationCenter defaultCenter] removeObserver:self name:@"checkMomentsNew" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
         NSDictionary *result = [FRNetPoolUtils getMoments];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                
                
                if ([[result objectForKey:@"result"] integerValue] == 1) {
                    
                    [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"momentEnter"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                   
                    _tableView.hidden = NO;
                    
                    listArray =[[NSMutableArray alloc] initWithArray:[result objectForKey:@"message"] copyItems:YES];
                    
                    
                    for (int i=0; i<[listArray count]; i++) {
                        
                        NSArray *array =[listArray objectAtIndex:i];
                        for (int j=0; j<[array count]; j++) {
                            
                            NSDictionary *dic = [array objectAtIndex:j];
                            NSString *type = [dic objectForKey:@"type"];
                            if ([type integerValue] == 10001) {
                                _foundModuleName = [dic objectForKey:@"name"];
                            }
                            
                        }
                        
                    }
                    
                
                    if ([_foundModuleName length]>13) {
                        newIconImg.frame = CGRectMake(14*16 + 63, (44 - 18)/2+30, 10, 10);
                    }else{
                        newIconImg.frame = CGRectMake([_foundModuleName length]*16 + 63, (44 - 18)/2+30, 10, 10);

                    }
                    
                     [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                     [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                    [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
                }
                
                
            }else{
                
                 [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
                //---update 2015.06.25--------------------------------------------------------------
                 //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
                [self isConnected];
                //------------------------------------------------------------------------------------
                
            }
            
        });
        
    });
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    //return 2;
    return [listArray count];// 2015.05.13
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   
    
    /*// Return the number of rows in the section.
    if (0 == section) {// 校友圈
        return 1;
    }else if (1 == section) {// 知识库 校校通
        if(isKnowledge){
            return 2;
        }else{
            return 1;
        }
    }
    
    return 1;*/
    
    return [(NSArray*)[listArray objectAtIndex:section] count];// 2015.05.13

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    
    static NSString *GroupedTableIdentifier = @"reuseIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }

    NSArray *array = [listArray objectAtIndex:indexPath.section];
    NSDictionary *dic = [array objectAtIndex:indexPath.row];
    NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
    
    cell.textLabel.text = name;
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    [cell.imageView sd_setImageWithURL:[dic objectForKey:@"icon"] placeholderImage:[UIImage imageNamed:@"knowledge/icon_xyq.png"]];
    
    
    /* 去掉new标实 2015.07.29
     if ([type integerValue] == 10003) {//扫一扫
        
        NSString *isNewForScann = [[NSUserDefaults standardUserDefaults] objectForKey:@"isNewForScan"];
        
        if (!isNewForScann) {
            isNewForScan.image = [UIImage imageNamed:@"icon_forNew.png"];
            
            if ([name length]>11) {
                isNewForScan.frame = CGRectMake(12*16 + 63+5, (50.0 - 18)/2, 30, 18.0);
            }else{
                isNewForScan.frame = CGRectMake([name length]*16 + 63+5, (50.0 - 18)/2, 30.0, 18.0);
                
            }
            [cell addSubview:isNewForScan];
        }
        
    }else{
        isNewForScan.image = nil;
    }*/
    
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    /*if(isKnowledge){
        if (indexPath.section == 0) {//校友圈
            
            MomentsViewController *commentList  = [[MomentsViewController alloc]init];
            commentList.titleName = _foundModuleName;
            commentList.fromName = @"school";
            commentList.cid = @"0";
            // Push the view controller.
            [self.navigationController pushViewController:commentList animated:YES];
            
        }else if (indexPath.section == 1){
            if (indexPath.row == 0) {//知识库
                KnowlegeHomePageViewController *kbV = [[KnowlegeHomePageViewController alloc]init];
                [self.navigationController pushViewController:kbV animated:YES];
            }else if (indexPath.row == 1) {//校校通
                SchoolExhibitionViewController *schoolExhi = [[SchoolExhibitionViewController alloc]init];
                [self.navigationController pushViewController:schoolExhi animated:YES];
            }
        }
        
    }else{
        if (indexPath.section == 0) {//校友圈
            MomentsViewController *commentList  = [[MomentsViewController alloc]init];
            commentList.titleName = _foundModuleName;
            commentList.fromName = @"school";
            commentList.cid = @"0";
            // Push the view controller.
            [self.navigationController pushViewController:commentList animated:YES];
        }else if (indexPath.section == 1) {//校校通
            SchoolExhibitionViewController *schoolExhi = [[SchoolExhibitionViewController alloc]init];
            [self.navigationController pushViewController:schoolExhi animated:YES];
        }

    }*/
    
    NSArray *array = [listArray objectAtIndex:indexPath.section];
    NSDictionary *dic = [array objectAtIndex:indexPath.row];
    NSString *type = [NSString stringWithFormat:@"%@",[dic objectForKey:@"type"]];
    NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"name"]]];
    switch ([type integerValue]) {
        case 10001:// 校友圈
        {
            MomentsViewController *commentList  = [[MomentsViewController alloc]init];
            commentList.titleName = name;
            commentList.fromName = @"school";
            commentList.cid = @"0";
            [self.navigationController pushViewController:commentList animated:YES];
        }
            break;
            
        case 9:// 知识库
        {
            KnowlegeHomePageViewController *kbV = [[KnowlegeHomePageViewController alloc]init];
            [self.navigationController pushViewController:kbV animated:YES];
        }
            break;
            
        case 10002:// 校校通
        {
            SchoolExhibitionViewController *schoolExhi = [[SchoolExhibitionViewController alloc]init];
            [self.navigationController pushViewController:schoolExhi animated:YES];
        }
            break;
            
        case 10003:// 扫一扫
        {
//            [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"isNewForScan"];
//            [[NSUserDefaults standardUserDefaults] synchronize];//去掉new标实 2015.07.29
            
            ScanViewController *scan = [[ScanViewController alloc]init];
            scan.viewType = @"scanView";
            [self.navigationController pushViewController:scan animated:YES];
            
        }
            break;
            
        case 10004:{// 同城服务
            
            NSString *tempUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"extra"]]];
            NSString *url = [Utilities appendUrlParams:tempUrl];
            NSLog(@"url:%@",url);
#if 0
            SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
            //fileViewer.url = [NSURL URLWithString:url];
            fileViewer.fromName = @"momentsEntrance";
            fileViewer.requestURL = url;
            fileViewer.titleName = @"";
            fileViewer.isShowSubmenu = @"0";
            fileViewer.isRotate = @"1";
#endif
            if (isOSVersionLowwerThan(@"9.0")){
                
                // 2015.09.23
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.requestURL = url;
                fileViewer.titleName = @"";
                fileViewer.isShowSubmenu = @"0";
                fileViewer.isRotate = @"1";
                [self.navigationController pushViewController:fileViewer animated:YES];
                
            }else{// iOS9.0以上 同城服务内发布页点击相册问题 先跳转到浏览器
                
                NSLog(@"url:%@",url);
             
                
                SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
                fileViewer.requestURL = url;
                fileViewer.titleName = @"";
                fileViewer.isShowSubmenu = @"0";
                fileViewer.isRotate = @"1";
                [self.navigationController pushViewController:fileViewer animated:YES];
                
                
//                
//                NSURL *serveUrl = [[NSURL alloc]initWithString:url];
//                [[UIApplication sharedApplication ]openURL:serveUrl];
                
            }
          
            
        }
            break;

        default:
            break;
    }
    
}

//----add by  kate 2015.06.26---------------
-(void)isConnected{
    
    FileManager *maa = [FileManager shareFileManager];
    
    //NSLog(@"-----网络状态----%ld---%d", (long)status,maa.netState);
    
    if (maa.netState == 0) {
        
        if (!networkVC) {
            
            networkVC = [[networkBar alloc] init];
//            topBar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 40.0)];
//            topBar = networkVC.view;
            
//            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
//            singleTouch.delegate = self;
//            [topBar addGestureRecognizer:singleTouch];
//            
//            [self.view addSubview:topBar];
            
            _tableView.tableHeaderView = networkVC.view;
            
            UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNetworkGuide)];
            singleTouch.delegate = self;
            [_tableView.tableHeaderView addGestureRecognizer:singleTouch];
            
            if (!newIconImg.hidden) {
                
                 newIconImg.frame = CGRectMake(newIconImg.frame.origin.x, newIconImg.frame.origin.y + 40.0, newIconImg.frame.size.width, newIconImg.frame.size.height);
                
            }
            
        }
        
    }else{
        
        networkVC = nil;
        //[topBar removeFromSuperview];
        _tableView.tableHeaderView = nil;
        
        if (!newIconImg.hidden) {
            if ([_foundModuleName length]>13) {
                newIconImg.frame = CGRectMake(14*16 + 63, (44 - 18)/2+30, 10, 10);
            }else{
                newIconImg.frame = CGRectMake([_foundModuleName length]*16 + 63, (44 - 18)/2+30, 10, 10);
                
            }
        }
        
       
    }
    
}
//去网络设置引导页
-(void)gotoNetworkGuide{
    
    NetworkGuideViewController *networkGVC = [[NetworkGuideViewController alloc]init];
    [self.navigationController pushViewController:networkGVC animated:YES];
}

//刷新调用的方法
-(void)refreshView
{
    if (reflashFlag == 1) {
        
        [self getData];
        
    }
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

//===============
//刷新delegate
#pragma mark -
#pragma mark data reloading methods that must be overide by the subclass
-(void)beginToReloadData:(EGORefreshPos)aRefreshPos{
    
    //  should be calling your tableviews data source model to reload
    _reloading = YES;
    
    if (aRefreshPos == EGORefreshHeader)
    {
        // pull down to refresh data
        //[self refreshView];
        [self performSelector:@selector(refreshView) withObject:nil afterDelay:0.1];
    }
    
    // overide, the actual loading data operation is done in the subclass
}

#pragma mark -
#pragma mark UIScrollViewDelegate Methods
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
        }
        
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (_reloading == NO) {
        if (_refreshHeaderView)
        {
            [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
        }
        
    }
}

#pragma mark -
#pragma mark EGORefreshTableDelegate Methods
- (void)egoRefreshTableDidTriggerRefresh:(EGORefreshPos)aRefreshPos
{
    if (_reloading == NO) {
        [self beginToReloadData:aRefreshPos];
    }
}

- (BOOL)egoRefreshTableDataSourceIsLoading:(UIView*)view
{
    return _reloading; // should return if data source model is reloading
}

// if we don't realize this method, it won't display the refresh timestamp
- (NSDate*)egoRefreshTableDataSourceLastUpdated:(UIView*)view
{
    return [NSDate date]; // should return date data source was last changed
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    
}


@end
