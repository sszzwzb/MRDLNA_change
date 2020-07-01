//
//  MessageListViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/19.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessageListViewController.h"

#import "MessageListTabBarView.h"
#import "MessageListTableViewCell.h"


#import "MessagePerListViewController.h"



static NSString * showMessageListTableViewCell = @"cell";

@interface MessageListViewController () <UITableViewDelegate,UITableViewDataSource,MessageListTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *dataArr;

@end

@implementation MessageListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    if (iPhoneX) {
        [self setCustomizeTitle:@"消息" bgImg:@"nav12" titleColor:[UIColor whiteColor]];
    } else {
        [self setCustomizeTitle:@"消息" bgImg:@"nav11" titleColor:[UIColor whiteColor]];
    }
    
    
//    [self up_DIYTabBarView];
    
    
    _dataArr = [NSMutableArray array];
    
    [self up_tableView];
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (iPhoneX) {
        [self setCustomizeTitle:@"消息" bgImg:@"nav12" titleColor:[UIColor whiteColor]];
    } else {
        [self setCustomizeTitle:@"消息" bgImg:@"nav11" titleColor:[UIColor whiteColor]];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self setCustomizeTitle:@"消息"];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)up_DIYTabBarView
{
    CGFloat minY = iPhoneX ? 0 : 22;
    
    MessageListTabBarView *DIYtabBar = [[MessageListTabBarView alloc]initWithFrame:
                                     CGRectMake(0, -minY, KScreenWidth, KScreenWidth / 750 * 310)];
    [self.view addSubview:DIYtabBar];
}



#pragma mark -
#pragma mark UITableViewDelegate
-(void)up_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenTabBarHeight - KScreenNavigationBarHeight) style:(UITableViewStyleGrouped)];
    _tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.view addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
//    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    [_tableView registerClass:[MessageListTableViewCell class] forCellReuseIdentifier: showMessageListTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [MessageListTableViewCell cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessageListTableViewCell *cell = (MessageListTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showMessageListTableViewCell forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    
    [cell reloadData];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
}

#pragma mark - MessageListTableViewCellDelegate
-(void)tableViewCellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
    MessagePerListViewController *vc = [[MessagePerListViewController alloc]init];
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


@end
