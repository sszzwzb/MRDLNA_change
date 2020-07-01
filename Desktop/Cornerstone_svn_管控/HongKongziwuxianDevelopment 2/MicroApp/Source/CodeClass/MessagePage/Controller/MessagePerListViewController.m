//
//  MessagePerListViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/9/20.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "MessagePerListViewController.h"

#import "MessagePerListTableViewCell.h"
#import "MessagePerListTableViewHeaderView.h"



static NSString *HeaderIdentifier = @"header";
static NSString * showMessagePerListTableViewCell = @"cell";

@interface MessagePerListViewController () <UITableViewDelegate,UITableViewDataSource,MessagePerListTableViewCellDelegate>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation MessagePerListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setCustomizeTitle:@"列表"];
    [self setCustomizeLeftButton];
    
    
    [self up_tableView];
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark UITableViewDelegate
-(void)up_tableView
{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight - KScreenNavigationBarHeight) style:(UITableViewStyleGrouped)];
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
    
    [_tableView registerClass:[MessagePerListTableViewCell class] forCellReuseIdentifier: showMessagePerListTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 90;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return [MessagePerListTableViewHeaderView headerHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 8;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    MessagePerListTableViewHeaderView *headView = [tableView dequeueReusableHeaderFooterViewWithIdentifier: HeaderIdentifier];
    if (headView == nil) {
        headView = [[MessagePerListTableViewHeaderView alloc] initWithReuseIdentifier:HeaderIdentifier];
    }
    
    headView.timeStr = @"今天 777777";
    
    return headView;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MessagePerListTableViewCell *cell = (MessagePerListTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showMessagePerListTableViewCell forIndexPath:indexPath];
    
    cell.indexPath = indexPath;
    cell.delegate = self;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
}

#pragma mark - MessagePerListTableViewCellDelegate
-(void)tableViewCellDidSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
}

@end
