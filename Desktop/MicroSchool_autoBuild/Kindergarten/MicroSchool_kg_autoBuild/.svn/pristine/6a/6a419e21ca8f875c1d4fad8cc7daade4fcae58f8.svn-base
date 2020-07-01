//
//  GrowthNotValidateViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/9/18.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "GrowthNotValidateViewController.h"
#import "SingleWebViewController.h"
#import "PayViewController.h"
#import "HomePageTableViewCell.h"
#import "ScoreMainViewController.h"
#import "HealthViewController.h"
#import "ClassDiscussViewController.h"
#import "FootmarkListViewController.h"

@interface GrowthNotValidateViewController ()
@property (strong, nonatomic) IBOutlet UIView *popView;
- (IBAction)clickIntroduce:(id)sender;
- (IBAction)clickOK:(id)sender;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIView *probationView;
@property (strong, nonatomic) IBOutlet UILabel *probationTitleLabel;
@property (strong, nonatomic) IBOutlet UIImageView *rightImg;
- (IBAction)closeProbationBar:(id)sender;

- (IBAction)RenewAction:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *renewLabel;
@property (strong, nonatomic) IBOutlet UIButton *closeBtn;
@property (strong, nonatomic) IBOutlet UIButton *okBtn;
@property (strong, nonatomic) IBOutlet UIButton *reNewBtn;
@property (strong, nonatomic) IBOutlet UILabel *growthInfoLabel;

@end

@implementation GrowthNotValidateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_titleName];
    [self setCustomizeTitle:@"成长空间"];
    
    [ReportObject event:ID_OPEN_GROWTH_MAIN];
    
    sectionHeight = 25.0;
    
    _popView.hidden = YES;
    _tableView.hidden = YES;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    profile = [[NSDictionary alloc] init];
    rank = [[NSDictionary alloc] init];
    number = [[NSString alloc] init];
    
    rowCount = 2;
    
    scoreImgView = [[UIImageView alloc] init];
    healthImgView = [[UIImageView alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData)
                                                 name:@"reloadSpace"
                                               object:nil];
    
    /*
     /**
     * 试用期说明文言
     * @author luke
     * @date 2016.02.01
     * @args
     *  v=2, ac=GrowingSpace, op=trialNote, sid=, cid=, uid=
     */
    
    if ([_fromName isEqualToString:@"bind"]) {
        
        _popView.hidden = YES;
        
        [Utilities showProcessingHud:self.view];
        [self getData];
        
    }else{
        
            if([_spaceStatus integerValue] == 0){
                
                _popView.hidden = NO;
                
                if (_growthInfo) {
                  _growthInfoLabel.text = _growthInfo;//2.9.4
                }else{
                    [self getGrowthInfo];
                }
                
            }else{
                
                //[self setCustomizeRightButtonWithName:@"状态" font:[UIFont systemFontOfSize:15.0]];//tony确认 去掉入口
                
                _popView.hidden = YES;
                
                [Utilities showProcessingHud:self.view];
                [self getData];
                
            }
        //}
        
    }
    
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"btn_ok_normal.png"] forState:UIControlStateNormal];
    [_okBtn setBackgroundImage:[UIImage imageNamed:@"btn_ok_press.png"] forState:UIControlStateHighlighted];
    
    //_cId = @"6149";//测试代码

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    if ([_fromName isEqualToString:@"bind"]) {
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* usertype = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
        // 现在接口 0 学生 6 家长 7 老师 9 校园管理员 2督学
        
        if ([usertype integerValue] == 0 || [usertype integerValue] == 6) {
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        }else{
             [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:1] animated:YES];
        }
        
    }else if ([_fromName isEqualToString:@"publishB"]){//跳回发布页或者跳回动态列表
        
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1-2] animated:YES];
        
    }else{
        
        //[self.navigationController popViewControllerAnimated:YES];
        [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:0] animated:YES];
        
    }
    
}

/// 获取试用期文言
-(void)getGrowthInfo{
    
    /**
     * 试用期说明文言
     * @author luke
     * @date 2016.02.01
     * @args
     *  v=2, ac=GrowingSpace, op=trialNote, sid=, cid=, uid=
     */
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"trialNote", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSDictionary *message = [respDic objectForKey:@"message"];
            
            _growthInfo = [NSString stringWithFormat:@"%@",[message objectForKey:@"note"]];
            
            _growthInfoLabel.text = _growthInfo;//2.9.4
            
            
        }else{
            
//            [Utilities showAlert:@"错误" message:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
    
}


//点我了解什么是成长空间 进入wap页
- (IBAction)clickIntroduce:(id)sender {
    
    [ReportObject event:ID_OPEN_SPACE_INTRO];
    
    SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
    
    NSURL *url = [NSURL URLWithString:_urlStr];
    fileViewer.webType = SWLoadURl;
    fileViewer.url = url;
    fileViewer.isShowSubmenu = @"0";
    [self.navigationController pushViewController:fileViewer animated:YES];
}

// 知道了 弹出框消失
- (IBAction)clickOK:(id)sender {
    
    [self tellProbation];
    
}

-(void)selectRightAction:(id)sender{
    
    [ReportObject event:ID_TITLEBAR_TO_STATUS];

    PayViewController *payVC = [[PayViewController alloc] init];
    payVC.isTrial = _isTrial;
    [self.navigationController pushViewController:payVC animated:YES];
    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
  {
       
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
        if (indexPath.section == 0) {
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"身体健康";
                if ([_spaceStatus  isEqual: @"3"] || [_spaceStatus  isEqual: @"4"]) {
                    cell.imageView.image = [UIImage imageNamed:@"stjk_unuseful.png"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.imageView.image = [UIImage imageNamed:@"stjk.png"];
                    
                    if ([_redPointDic objectForKey:@"10005"]) {
                        
                        if ([[_redPointDic objectForKey:@"10005"] integerValue] > 0){
                            healthImgView.frame = CGRectMake(cell.frame.size.width - 40.0,(50.0 - 10)/2-0.5 , 10.0, 10.0);
                            healthImgView.image = [UIImage imageNamed:@"icon_new.png"];//2015.12.18
                            healthImgView.tag = 224;
                            
                            if ([cell viewWithTag:224]) {
                                
                            }else{
                                [cell addSubview:healthImgView];
                            }
                        }else{
                            
                            [healthImgView removeFromSuperview];
                        }
                        
                    }
                    
                }
                
            }
        }else if (indexPath.section == 1){
            
            if (indexPath.row == 0) {
                
                cell.textLabel.text = @"成长足迹";
                
                if ([_spaceStatus  isEqual: @"3"] || [_spaceStatus  isEqual: @"4"]) {
                    cell.imageView.image = [UIImage imageNamed:@"czzj_unuseful.png"];
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                }else{
                    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
                    cell.imageView.image = [UIImage imageNamed:@"czzj.png"];
                }
                
                
            }
            
        }
        return cell;
    }
    
}


- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
//    if (indexPath.section == 0 && indexPath.row == 0) {// 学习成绩
//        
//        if ([_spaceStatus  isEqual: @"3"] || [_spaceStatus  isEqual: @"4"]) {
//            
//        }else{
//            
//            
//            ScoreMainViewController *scoreMV = [[ScoreMainViewController alloc] init];
//            scoreMV.cId = _cId;
//            scoreMV.number = number;
//            [self.navigationController pushViewController:scoreMV animated:YES];
//            
//            if ([_redPointDic objectForKey:@"10006"]) {
//                
//                [Utilities updateSpaceRedPoints:_cId last:[_redPointDic objectForKey:@"10006"] mid:@"10006"];//2015.12.18 在成绩主页更新红点 志伟确认
//                
//                 if ([[_redPointDic objectForKey:@"10006"] integerValue] > 0) {
//                     
//                     [_redPointDic setObject:@"0" forKey:@"10006"];
//                     [tableView reloadData];
//                }
//                
//            }
//            
//
//        }
//        
//    }else if (indexPath.section == 2 && indexPath.row == 0){// 学籍信息
//        
//    }else
    
    if (indexPath.section == 0 && indexPath.row == 0){// 体育评测
    
        if ([_spaceStatus  isEqual: @"3"] || [_spaceStatus  isEqual: @"4"]) {
            
        }else{
    
            HealthViewController *healthV = [[HealthViewController alloc] init];
            healthV.titleName = @"身体健康";
            healthV.cid = _cId;
            healthV.number = number;
            [self.navigationController pushViewController:healthV animated:YES];
            
            if ([_redPointDic objectForKey:@"10005"]) {
                
                [Utilities updateSpaceRedPoints:_cId last:[_redPointDic objectForKey:@"10005"] mid:@"10006"];//2015.12.18 在成绩主页更新红点 志伟确认
                
                if ([[_redPointDic objectForKey:@"10005"] integerValue] > 0) {
                    
                    [_redPointDic setObject:@"0" forKey:@"10005"];
                    [tableView reloadData];
                }
                
            }
        }
        
    }else if (indexPath.section == 1 && indexPath.row == 0){//成长足迹
        
        if ([_spaceStatus  isEqual: @"3"] || [_spaceStatus  isEqual: @"4"]) {
            
        }else{
            
            FootmarkListViewController *flvc = [[FootmarkListViewController alloc] init];
            flvc.cid = _cId;
            flvc.number = number;
            flvc.titleName = @"成长足迹";
            flvc.fromName = @"student";
            [self.navigationController pushViewController:flvc animated:YES];

        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return sectionHeight;
    }else{
      return 10;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 10;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
}

/**
 * 成长空间首页接口
 * @author luke
 * @date 2015.09.21
 * @args
 *  v=2, ac=GrowingSpace, op=mine, sid=, uid=, cid=
 */
-(void)getData{
    
    // 备注此处返回的uid即是number
   
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"mine", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
//            _tableView.hidden = NO;
            
            NSDictionary *messageDic = [respDic objectForKey:@"message"];
            
            NSLog(@"messageDic:%@",messageDic);
            
            // 用于详情页的评论
            number = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"profile"] objectForKey:@"uid"]];
            
//            NSString *name = [[messageDic objectForKey:@"profile"] objectForKey:@"name"];
//            
//            if ([name length] >0) {
//                
//                ((UILabel *)self.navigationItem.titleView).text = [NSString stringWithFormat:@"%@的成长空间",name];
//                [self setCustomizeTitle: [NSString stringWithFormat:@"%@的成长空间",name]];
//            }
           
            NSString *status = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"status"]]];
            
            NSString *content = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"content"]];//状态文言
            // 是否跳过试用期 2015.12.21
            NSString *trial = [NSString stringWithFormat:@"%@",[[messageDic objectForKey:@"space"] objectForKey:@"trial"]];
            _isTrial = trial;
            
//            urlStr = [NSString stringWithFormat:@"%@",[[[messageDic objectForKey:@"space"] objectForKey:@"url"] objectForKey:@"help"]];//helpUrl
            //判断空间状态
            //开通状态：未开通、试用、正常、欠费，试用期结束
            // 开通空间0:未开通,1付费已开通,2试用已开通，3试用到期，4付费到期
            
            //status = @"3";//测试代码
            _spaceStatus = status;
            
            if([_spaceStatus integerValue] == 0){//未开通
                
                _popView.hidden = NO;
                [self getGrowthInfo];
                
                
            }else{
                
                _popView.hidden = YES;
                //[self setCustomizeRightButtonWithName:@"状态" font:[UIFont systemFontOfSize:15.0]];//tony确认 去掉入口
                
            }
            
            _tableView.hidden = NO;
            
            if ([status integerValue] == 0 || [status integerValue] == 1) {
                
                [_probationView removeFromSuperview];
                
            }else{
                
                sectionHeight = 40.0;
                [_tableView addSubview:_probationView];
                if ([status integerValue] == 2) {
                    
                    _reNewBtn.hidden = YES;
                    _probationTitleLabel.text = content;
                    _renewLabel.hidden = YES;
                    _rightImg.hidden = YES;
                    
                }else if([status integerValue] == 3 || [status integerValue] == 4){
                    
                    _probationTitleLabel.text = content;
                    _renewLabel.hidden = NO;
                    _rightImg.image = [UIImage imageNamed:@"rightArrowBlueIcon.png"];
                    _closeBtn.hidden = YES;

                }
            }
            
            NSDictionary *examDic = [messageDic objectForKey:@"exam"];
            
            if ([examDic count] > 0) {
                
                profile = [[messageDic objectForKey:@"exam"] objectForKey:@"profile"];
                rank = [[[messageDic objectForKey:@"exam"] objectForKey:@"clazz"] objectForKey:@"rank"];
                
                //NSString *lastIdStr = [NSString stringWithFormat:@"%@",[profile objectForKey:@"id"]];
#if 0
                NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
                NSMutableDictionary *tempDic = [[NSMutableDictionary alloc]initWithDictionary:[userDefaults objectForKey:@"lastScoreIdDic"]];
                [tempDic setObject:lastIdStr forKey:_cId];
                [userDefaults setObject:tempDic forKey:@"lastScoreIdDic"];
                [userDefaults synchronize];
#endif
                
                //[Utilities updateClassRedPoints:_cId last:lastIdStr mid:_mid];//2015.11.13
                /*
                 const SPACE_PHYSICAL_SCORE = 10005; //成长空间：体测成绩
                 const SPACE_EXAM_SCORE = 10006; //成长空间：考试成绩
                 
                [Utilities updateSpaceRedPoints:_cId last:lastIdStr mid:@"10006"];//2015.12.17
                */
                
            }else{
                
                rowCount =1;
            }
            
           [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:NO];
            
           
            
        }else{
            [Utilities showAlert:@"错误" message:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

/**
 * 告知后台终端触发了试用期
 * @author luke
 * @date 2015.10.12
 * @args
 *  v=2, ac=GrowingSpace, op=trail, sid=, cid=, uid=
 */
-(void)tellProbation{
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"GrowingSpace",@"ac",
                          @"2",@"v",
                          @"trial", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            [ReportObject event:ID_MOTIVATE_SPACE];
            
            // 动态列表，动态详情，发布动态 三个入口来
            if ([_fromName isEqualToString:@"publish"] || [_fromName isEqualToString:@"publishB"]) {
            
                //[[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadGrowingPathStatus" object:nil];
                
                NSString *msg = [NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]];
                UIAlertView *alertV = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                alertV.tag = 333;
                [alertV show];
                
            }else{
                
                _popView.hidden = YES;
                [Utilities showProcessingHud:self.view];
                [self getData];
            }
            
        }else{
            
            [Utilities showAlert:@"错误" message:[NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]] cancelButtonTitle:@"确定" otherButtonTitle:nil];

        }
        
//        //-----测试代码-------------------------
//        _popView.hidden = YES;
//        [Utilities showProcessingHud:self.view];
//        [self getData];
//        //-------------------------------------
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

-(void)reload{
    
    [_tableView reloadData];
}

// 关闭黄条
- (IBAction)closeProbationBar:(id)sender {
    
    [_probationView removeFromSuperview];
    sectionHeight = 30.0;
    [_tableView reloadData];
    
}
// 续费
- (IBAction)RenewAction:(id)sender {
    [ReportObject event:ID_SPACEBAR_TO_STATUS];
    
    PayViewController *pvc = [[PayViewController alloc] init];
    pvc.cId = _cId;
    [self.navigationController pushViewController:pvc animated:YES];
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 9_0){
    
    if(alertView.tag == 333){
        
        if ([_fromName isEqualToString:@"publishB"]){//跳回发布页或者跳回动态列表
            
            [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-1-2] animated:YES];
            
        }else{
            [self.navigationController popViewControllerAnimated:YES];
        }
        
        [self performSelector:@selector(test) withObject:nil afterDelay:0.5];

//        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];

        
        
    }
}

- (void)test
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPublishGrowingStatus" object:nil];
}

@end
