//
//  FootmarkListViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/12/24.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "FootmarkListViewController.h"
#import "UIImageView+WebCache.h"
#import "MomentsDetailViewController.h"

@interface FootmarkListViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation FootmarkListViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:_titleName];
    
    _tableView.backgroundColor = [UIColor whiteColor];
    _tableView.hidden = YES;
    
    if (![Utilities isConnected]) {//2015.06.30
        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
        [self.view addSubview:noNetworkV];
        return;
    }
    
    if (_refreshHeaderView && [_refreshHeaderView superview]) {
        [_refreshHeaderView removeFromSuperview];
    }
    
    _refreshHeaderView = [[EGORefreshTableHeaderView alloc] initWithFrame:
                          CGRectMake(0.0f, 0.0f - self.view.bounds.size.height,
                                     self.view.frame.size.width, self.view.bounds.size.height)];
    _refreshHeaderView.delegate = self;
    
    
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView addSubview:_refreshHeaderView];
    
    //reLoadFootmarkList
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"reLoadFootmarkList"
                                               object:nil];//2015.11.12

    
    
    
//    [self setCustomizeRightButtonWithName:@"筛选"];
    
    //tagArray = [[NSMutableArray alloc] init];
    tag = @"0";
    heightArray = [[NSMutableArray alloc] init];
    
    [Utilities showProcessingHud:self.view];
    [self getData:@"0" tag:tag];
    startNum = @"0";
    reflashFlag = 1;
    isReflashViewType = 1;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController  popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    //tagArray = [[NSMutableArray alloc] initWithObjects:@"多才多艺",@"德行良好",@"热爱劳动",@"社会实践",@"学业水平",@"茁壮成长",@"全部", nil];
    if (!isRightButtonClicked) {
        
        
        viewMask = [[UIView alloc] initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height)];
        
        imageView_bgMask =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,[UIScreen mainScreen].applicationFrame.size.height-44)];
        [imageView_bgMask setBackgroundColor:[[UIColor alloc] initWithRed:93/255.0f green:106/255.0f blue:122/255.0f alpha:0.4]];
        imageView_bgMask.userInteractionEnabled = YES;
        UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard:)];
        [imageView_bgMask addGestureRecognizer:singleTouch];
        
        // 选项菜单
        imageView_rightMenu =[[UIImageView alloc]initWithFrame:CGRectMake(
                                                                          [UIScreen mainScreen].applicationFrame.size.width - 128 - 10,
                                                                          5,
                                                                          128,
                                                                          35.0*[tagArray count]+10)];
        imageView_rightMenu.contentMode = UIViewContentModeScaleToFill;
        [imageView_rightMenu setImage:[UIImage imageNamed:@"ClassKin/bg_popview.png"]];
        
        [imageView_bgMask addSubview:imageView_rightMenu];

        for (int i=0; i<[tagArray count]; i++) {
            
            NSDictionary *tagDic = [tagArray objectAtIndex:i];
            NSString *tagId = [NSString stringWithFormat:@"%@",[tagDic objectForKey:@"id"]];
            
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.tag = 400+[tagId integerValue];
            button.frame = CGRectMake(imageView_rightMenu.frame.origin.x,imageView_rightMenu.frame.origin.y+9+35.0*i, 128.0, 35.0);
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateNormal];
            [button setTitle:[tagDic objectForKey:@"name"] forState:UIControlStateHighlighted];
            [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            [button setTitleColor:[UIColor colorWithRed:174.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1] forState:UIControlStateHighlighted];
             button.titleLabel.font = [UIFont boldSystemFontOfSize:14.0f];

            [button addTarget:self action:@selector(selectTag:) forControlEvents: UIControlEventTouchUpInside];
            
            UIImageView *lineV = [[UIImageView alloc] init];
            //lineV.image = [UIImage imageNamed:@"friend/bg_contacts_more_line"];
            lineV.image = [UIImage imageNamed:@"ClassKin/bg_contacts_line.png"];
            lineV.frame = CGRectMake(10, button.frame.size.height-1, button.frame.size.width-20, 1);
            if (i<[tagArray count]-1) {
                 [button addSubview:lineV];
            }
           
            
            [imageView_bgMask addSubview:button];
            
        }
        
        
        [viewMask addSubview:imageView_bgMask];
        
        [self.view addSubview:viewMask];
        
        isRightButtonClicked = true;

        
    }else{
        
        [viewMask removeFromSuperview];
        
        isRightButtonClicked = false;

    }
    
    
}

// 标签筛选
-(void)selectTag:(id)sender{
    
    UIButton *button = (UIButton*)sender;
    tag = [NSString stringWithFormat:@"%ld",button.tag - 400];
    
    [self dismissKeyboard:nil];
    
    startNum = @"0";
    [Utilities showProcessingHud:self.view];
    [self getData:startNum tag:tag];
    
    
}

-(void)dismissKeyboard:(id)sender{
    
    [viewMask removeFromSuperview];
    isRightButtonClicked = false;
}

/**
 * 成长空间入口－时间轴列表
 * @author luke
 * @date 2015.12.20
 * @args
 *  v=3, ac=GrowingPath, op=streams, sid=, cid=, uid=, number=,
 *  page=, size=, tag=标签ID
 */
-(void)getData:(NSString*)index tag:(NSString*)tagParam{
    
    NSDictionary *data;
    
    // 老师看不见家长或学生手动添加的足迹，所以用两个接口
    if ([_fromName isEqualToString:@"student"]) {
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"GrowingPath",@"ac",
                @"3",@"v",
                @"streams", @"op",
                _cid,@"cid",
                _number,@"number",
                tagParam,@"tag",
                index,@"page",
                @"20",@"size",
                nil];
    }else{
        
        /**
         * 成长足迹－教师入口
         * @author luke
         * @date 2015.12.24
         * @args
         *  v=3, ac=GrowingPath, op=teacher, sid=, cid=, uid=, number=,
         *  page=, size=, tag=标签ID
         */
        
        data = [[NSDictionary alloc] initWithObjectsAndKeys:
                REQ_URL, @"url",
                @"GrowingPath",@"ac",
                @"3",@"v",
                @"teacher", @"op",
                _cid,@"cid",
                _number,@"number",
                tagParam,@"tag",
                index,@"page",
                @"20",@"size",
                nil];
    }
    
 
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSLog(@"成长足迹列表:%@",respDic);
            
            _tableView.hidden = NO;
            
            tagArray = [[NSMutableArray alloc] initWithArray:[[respDic objectForKey:@"message"] objectForKey:@"tags"]];
            
            NSMutableArray *array = [[[respDic objectForKey:@"message"] objectForKey:@"data"] objectForKey:@"list"];
            
            if ([array count] >0) {
                
                [self setCustomizeRightButtonWithName:@"筛选"];
                
                [noDataView removeFromSuperview];
                
                if ([startNum intValue] > 0) {
                    
                    for (int i=0; i<[array count]; i++) {
                        
                        [listArray addObject:[array objectAtIndex:i]];
                    }
                    
                }else{
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                }
                
                [heightArray removeAllObjects];
                
                for (int i=0; i<[listArray count]; i++) {
                   
                    float height;
                    
                    NSDictionary *dic = [listArray objectAtIndex:i];
                    NSString *sharUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shareUrl"]]];
                    NSString *title = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
                    
                    NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
                    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
                    NSLog(@"tempDate:%@",tempDate);
                    
                    if ([(NSArray*)[dic objectForKey:@"pics"] count] > 0) {
                        
                        //如果是图片类型
                        height = 70.0;
                     
                    }else{
                        
                        //如果是链接或文字
                        /*1.纯文字baseView高度为40 cell高度为60 更改baseView的height减少20;
                         2.链接分为有title和没title的。
                         没title的需要更改baseView的height减少15，imgV与linkDescribeLabel的y坐标上移15。
                         */
                        
                        //链接
                        if ([sharUrl length] > 0) {
                            
                            //有title的链接
                            if ([title length] > 0) {
                                
                                height = 70;
                             
                                
                            }else{//无title的链接
                                
                                //height = 70.0-15.0;
                                height = 70.0-20.0;
                                                                
                            }
                            
                            
                        }else{//文本
                            
                            //height = 70.0-15.0;
                            height = 70.0-20.0;

                            
                        }
                        
                    }
                    
                    height = [self getHeight:height index:i];
                   
                    NSString *heightStr = [NSString stringWithFormat:@"%f",height];
                    [heightArray addObject:heightStr];
                    
                }
                
                for (int i =0 ; i<[heightArray count]; i++) {
                    NSLog(@"array row:%d %@",i,[heightArray objectAtIndex:i]);
                }
                
                
            }else{
                
                if([startNum intValue] == 0){
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    
                    [noDataView removeFromSuperview];
                    
                    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 44);
                    noDataView =  [Utilities showNodataView:@"快来踩踩吧~" msg2:@"" andRect:rect imgName:@"noFootmark.png"];
                    [self.view addSubview:noDataView];
                }
                
            }
            
            
        }else{
            [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
            
        }
        
        
        [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
        [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
}

-(void)reload{
    
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return [listArray count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier0 = @"FootmarkPicTableViewCell";//图片类型
    static NSString *GroupedTableIdentifier1 = @"FootmarkLinkOrTxtTableViewCell";//链接或文字
    
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    //NSArray *pics = (NSArray*)[dic objectForKey:@"pics"];
    NSArray *listArr = [dic objectForKey:@"list"];//如果count大于0 就是视频或图片
    NSString *video = [NSString stringWithFormat:@"%@",[dic objectForKey:@"video"]];
    
    if ([listArr count] > 0) {
        
        //如果是图片类型/视频类型
        
        FootmarkPicTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier0];
        
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"FootmarkPicTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier0];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier0];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.delegte = self;
        cell.index = indexPath.row;
        cell.type = @"moment";
        
        NSArray *tagsArray = [dic objectForKey:@"tags"];
        if ([tagsArray count] > 0) {
            
            if ([video integerValue] == 0){
                
                NSDictionary *tagDic = [tagsArray objectAtIndex:0];
                NSString *tagImgUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[tagDic objectForKey:@"pic"]]];
                if ([tagImgUrl length] > 0) {
                    [cell.tagImgV sd_setImageWithURL:[NSURL URLWithString:tagImgUrl]];
                }
                
            }else{
                
                cell.tagImgV.image = nil;
            }
            
            
        }
        
       
        NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        //NSString *imgUrl = [pics objectAtIndex:0];
        NSString *imgUrl = [[listArr objectAtIndex:0] objectForKey:@"thumb"];
        NSString *title = [dic objectForKey:@"message"];
        
        if (indexPath.row == 0) {
            
            NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:9 compareWithToday:YES];
            
            if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]) {
            
                cell.dayLabel.font = [UIFont systemFontOfSize:18.0];
                cell.dayLabel.text = isYestOrToday;
                cell.monthLabel.text = @"";

            
            }else{
                
                cell.dayLabel.font = [UIFont systemFontOfSize:24.0];
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
            }
        
        }
        
        if (indexPath.row-1 >= 0) {
            
             NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:9 compareWithToday:YES];
            
            if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]) {
            
                cell.dayLabel.font = [UIFont systemFontOfSize:18.0];
                cell.dayLabel.text = isYestOrToday;
                cell.monthLabel.text = @"";
                
            }else{
            
                cell.dayLabel.font = [UIFont systemFontOfSize:24.0];
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
            }
            
            NSDictionary *list_dic = [listArray objectAtIndex:indexPath.row-1];
            NSString *dateline = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
            NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
            
            if (![tempDate isEqualToString:tempDateB]) {
                
               // NSString *isYestOrToday  = [Utilities timeIntervalToDate:[dateline longLongValue] timeType:9 compareWithToday:YES];
                
                if ([@"昨天" isEqualToString:isYestOrToday] || [@"今天" isEqualToString:isYestOrToday]){
                    
                    cell.dayLabel.font = [UIFont systemFontOfSize:18.0];
                    cell.dayLabel.text = isYestOrToday;
                    cell.monthLabel.text = @"";
                    
                }else{
                
                    cell.dayLabel.font = [UIFont systemFontOfSize:24.0];
                    cell.monthLabel.text = [tempDate substringToIndex:3];
                    cell.dayLabel.text = [tempDate substringFromIndex:3];
                }
                
               
                
            }else{
                cell.monthLabel.text = @"";
                cell.dayLabel.text = @"";
                
            }
            
        }
        
        [cell.imgV sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        
        if ([video integerValue] == 0) {// =0 图片
            
            cell.videoImgV.hidden = YES;
            
        }else{// >0 视频
            
              cell.videoImgV.hidden = NO;
        }
        
        if ([listArr count] > 1) {
            cell.imgNumLabel.text = [NSString stringWithFormat:@"共%lu张",(unsigned long)[listArr count]];
        }else{
            cell.imgNumLabel.text = @"";
        }
        
        cell.titleLabel.text = title;
        
        cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x,cell.baseView.frame.origin.y , cell.baseView.frame.size.width, 60.0);
        
        return cell;

        
    }else{
        
        //如果是链接或文字
        /*1.纯文字baseView高度为40 cell高度为60 更改baseView的height减少20;
         2.链接分为有title和没title的。
         没title的需要更改baseView的height减少15，imgV与linkDescribeLabel的y坐标上移15。
         */
        
        FootmarkLinkOrTxtTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
       
        if(cell == nil) {
            
            UINib *nib = [UINib nibWithNibName:@"FootmarkLinkOrTxtTableViewCell" bundle:nil];
            [tableView registerNib:nib forCellReuseIdentifier:GroupedTableIdentifier1];
            cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.selectionStyle = UITableViewCellSelectionStyleGray;
        }
        
        cell.delegte = self;
        cell.index = indexPath.row;
        
        NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
        NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        NSString *title = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
        NSString *sharUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shareUrl"]]];
        NSString *shareSnapshot = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shareSnapshot"]]];
        NSString *shareContent = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shareContent"]]];
        
        if (indexPath.row == 0) {
            
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
            
        }
        
        if (indexPath.row-1 >= 0) {
            
            cell.monthLabel.text = [tempDate substringToIndex:3];
            cell.dayLabel.text = [tempDate substringFromIndex:3];
            
            NSDictionary *list_dic = [listArray objectAtIndex:indexPath.row-1];
            NSString *dateline = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
            NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
            
            if (![tempDate isEqualToString:tempDateB]) {
                cell.monthLabel.text = [tempDate substringToIndex:3];
                cell.dayLabel.text = [tempDate substringFromIndex:3];
                
            }else{
                cell.monthLabel.text = @"";
                cell.dayLabel.text = @"";
                
            }
            
        }
        
        //链接
        if ([sharUrl length] > 0) {
            
            cell.type = @"link";
            cell.linkDescribeLabel.hidden = NO;
            cell.imgV.hidden = NO;
            cell.txtTitleLabel.hidden = YES;
            
            //有title的链接
            if ([title length] > 0) {
                
                cell.linkTitleLabel.hidden = NO;
                cell.linkTitleLabel.text = title;
                cell.imgV.frame = CGRectMake(cell.imgV.frame.origin.x,20.0 , cell.imgV.frame.size.width, cell.imgV.frame.size.height);
                cell.linkDescribeLabel.frame = CGRectMake(cell.linkDescribeLabel.frame.origin.x,20.0 , cell.linkDescribeLabel.frame.size.width, cell.linkDescribeLabel.frame.size.height);
                cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x,cell.baseView.frame.origin.y , cell.baseView.frame.size.width, 60.0);
                
            }else{//无title的链接
                
                cell.linkTitleLabel.hidden = YES;
                cell.imgV.frame = CGRectMake(cell.imgV.frame.origin.x,2.0, cell.imgV.frame.size.width, cell.imgV.frame.size.height);
                cell.linkDescribeLabel.frame = CGRectMake(cell.linkDescribeLabel.frame.origin.x,2.0 , cell.linkDescribeLabel.frame.size.width, cell.linkDescribeLabel.frame.size.height);
                cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x,cell.baseView.frame.origin.y , cell.baseView.frame.size.width, 39.0);
            }
            
            cell.linkDescribeLabel.text = shareContent;
            
            [cell.imgV sd_setImageWithURL:[NSURL URLWithString:shareSnapshot] placeholderImage:[UIImage imageNamed:@"CommonIconsAndPics/default_link.png"]];
            
            cell.imgV.image = [UIImage imageNamed:@"CommonIconsAndPics/default_link.png"];
            
            
        }else{//文本
            
            cell.type = @"moment";
            cell.txtTitleLabel.text = title;
            cell.baseView.frame = CGRectMake(cell.baseView.frame.origin.x,cell.baseView.frame.origin.y , cell.baseView.frame.size.width, 40.0);
            cell.linkTitleLabel.hidden = YES;
            cell.linkDescribeLabel.hidden = YES;
            cell.imgV.hidden = YES;
            cell.txtTitleLabel.hidden = NO;
            
        }
        
        cell.clickChangeColorBtn.frame = CGRectMake(0, 0, cell.baseView.frame.size.width, cell.baseView.frame.size.height); 
        
        return cell;
        
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 8.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    float height = [[heightArray objectAtIndex:indexPath.row] floatValue];
    
    /*
    NSDictionary *dic = [listArray objectAtIndex:indexPath.row];
    NSString *sharUrl = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"shareUrl"]]];
    NSString *title = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[dic objectForKey:@"message"]]];
    
    //NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
   // NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
    
    if ([(NSArray*)[dic objectForKey:@"pics"] count] > 0) {
        
        //如果是图片类型
        height = 70.0;
        
    }else{
        
        //如果是链接或文字
        //1.纯文字baseView高度为40 cell高度为60 更改baseView的height减少20;
         //2.链接分为有title和没title的。
        // 没title的需要更改baseView的height减少15，imgV与linkDescribeLabel的y坐标上移15。
        //
    
        //链接
        if ([sharUrl length] > 0) {
            
            //有title的链接
            if ([title length] > 0) {
                
                height = 70.0;
                           }else{//无title的链接
                
                height = 70.0-15.0;
               
                
            }
            
            
        }else{//文本
            
            height = 70.0-20.0;
            
        }
        
    }*/
    
    NSLog(@"row:%ld %f",(long)indexPath.row,height);
    
    return height;
    
}

-(float)getHeight:(float)height index:(NSInteger)row{
    
    NSDictionary *dic = [listArray objectAtIndex:row];
    NSString *dateline = [NSString stringWithFormat:@"%@",[dic objectForKey:@"dateline"]];
    NSString *tempDate = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];

    if (row+1 < [listArray count]) {
        
        NSDictionary *list_dic = [listArray objectAtIndex:row+1];
        NSString *dateline = [NSString stringWithFormat:@"%@",[list_dic objectForKey:@"dateline"]];
        NSString *tempDateB = [[Utilities alloc] linuxDateToString:dateline andFormat:@"%@月%@" andType:DateFormat_MD];
        
        if (![tempDate isEqualToString:tempDateB]) {
            
            height = height;
            
        }else{
            
            height = height - 7;
        }
        
    }
    
    return height;
}

//点击一行 回调
-(void)gotoFootmarkDetail:(NSInteger)index type:(NSString *)type{
    
    //if ([type isEqualToString:@"moment"]) {
    
    //threadtype  0 普通动态， 1 相册 2 小视频
    NSString *threadtype = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:index] objectForKey:@"threadtype"]];
    if ([threadtype integerValue] == 0) {//去动态详情
        
        MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
        momentsDetailViewCtrl.tid = [[listArray objectAtIndex:index] objectForKey:@"tid"];//动态id
        momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
        momentsDetailViewCtrl.fromName = @"footmark";
        momentsDetailViewCtrl.cid = _cid;
        [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
        
    }else{//去相册详情
        
        MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
        momentsDetailViewCtrl.tid = [[listArray objectAtIndex:index] objectForKey:@"tid"];//动态id
        momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
        momentsDetailViewCtrl.fromName = @"classPhoto";
        momentsDetailViewCtrl.cid = _cid;
        [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
    }
  
    //}
    /*else if ([type isEqualToString:@"link"]){
        
        NSDictionary *dic = [listArray objectAtIndex:index];
        NSString *shareUrl = [dic objectForKey:@"shareUrl"];
        NSString *shareSnapshot = [dic objectForKey:@"shareSnapshot"];
        NSString *shareContent = [dic objectForKey:@"shareContent"];
        
        NSLog(@"clickSharedLink url = %@", shareUrl);
       
        SingleWebViewController *fileViewer = [[SingleWebViewController alloc] init];
        fileViewer.requestURL = shareUrl;
        fileViewer.currentHeadImgUrl = shareSnapshot;
        fileViewer.titleName = shareContent;
        
        [self.navigationController pushViewController:fileViewer animated:YES];
        
    }*/
}

//回调
-(void)gotoFootmarkPicDetail:(NSInteger)index type:(NSString *)type{
    
    NSString *threadtype = [NSString stringWithFormat:@"%@",[[listArray objectAtIndex:index] objectForKey:@"threadtype"]];

     if ([threadtype integerValue] == 0) {//去动态详情
     
         MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
         momentsDetailViewCtrl.tid = [[listArray objectAtIndex:index] objectForKey:@"tid"];//动态id
         momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
         momentsDetailViewCtrl.fromName = @"footmark";
         momentsDetailViewCtrl.cid = _cid;
         [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
         
     }else{//相册详情
         
         MomentsDetailViewController *momentsDetailViewCtrl = [[MomentsDetailViewController alloc] init];
         momentsDetailViewCtrl.tid = [[listArray objectAtIndex:index] objectForKey:@"tid"];//动态id
         momentsDetailViewCtrl.path = [[listArray objectAtIndex:index] objectForKey:@"id"];//足迹id
         momentsDetailViewCtrl.fromName = @"classPhoto";
         momentsDetailViewCtrl.cid = _cid;
         [self.navigationController pushViewController:momentsDetailViewCtrl animated:YES];
         
     }
   

}

-(void)refreshView
{
    isReflashViewType = 1;
    
    if (reflashFlag == 1) {
        NSLog(@"刷新完成");
        startNum = @"0";
        [self getData:startNum tag:tag];
        
    }
}

//加载调用的方法
-(void)getNextPageView
{
    isReflashViewType = 0;
    
    if (reflashFlag == 1) {
        
        startNum = [NSString stringWithFormat:@"%lu",(unsigned long)[listArray count]];
        [self getData:startNum tag:tag];
        
    }
    
    [self performSelector:@selector(testFinishedLoadData) withObject:nil afterDelay:0.2];
    //[self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
    
    
}

-(void)testFinishedLoadData{
    
    [self finishReloadingData];
    [self setFooterView];
    
}

#pragma mark -
#pragma mark method that should be called when the refreshing is finished
- (void)finishReloadingData{
    
    //  model should call this when its done loading
    _reloading = NO;
    
    if (_refreshHeaderView) {
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
    }
    
    if (_refreshFooterView) {
        [_refreshFooterView egoRefreshScrollViewDataSourceDidFinishedLoading:self->_tableView];
        [self setFooterView];
    }
    
    // overide, the actula reloading tableView operation and reseting position operation is done in the subclass
}

-(void)setFooterView{
    //    UIEdgeInsets test = self.aoView.contentInset;
    // if the footerView is nil, then create it, reset the position of the footer
    
    CGFloat height = MAX(self->_tableView.bounds.size.height, self->_tableView.contentSize.height);
    //CGFloat height = MAX(self->_tableView.contentSize.height, self->_tableView.frame.size.height);
    if (_refreshFooterView && [_refreshFooterView superview])
    {
        // reset position
        _refreshFooterView.frame = CGRectMake(0.0f,
                                              height,
                                              self->_tableView.frame.size.width,
                                              self.view.bounds.size.height);
    }else
    {
        // create the footerView
        _refreshFooterView = [[EGORefreshTableFooterView alloc] initWithFrame:
                              CGRectMake(0.0f, height,
                                         self.view.frame.size.width, self->_tableView.bounds.size.height)];
        //self->_tableView.frame.size.width, self.view.bounds.size.height)];
        _refreshFooterView.delegate = self;
        [self->_tableView addSubview:_refreshFooterView];
    }
    
    if (_refreshFooterView)
    {
        [_refreshFooterView refreshLastUpdatedDate];
    }
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
    }else if(aRefreshPos == EGORefreshFooter)
    {
        // pull up to load more data
        [self performSelector:@selector(getNextPageView) withObject:nil afterDelay:0.005];
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
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidScroll:scrollView];
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
        
        if (_refreshFooterView)
        {
            [_refreshFooterView egoRefreshScrollViewDidEndDragging:scrollView];
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




@end
