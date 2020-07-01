//
//  GenderViewController.m
//  MicroSchool
//
//  Created by jojo on 13-12-18.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "GenderViewController.h"

@interface GenderViewController ()

@end

@implementation GenderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [super setCustomizeTitle:@"性别"];
    [super setCustomizeLeftButton];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height) style:UITableViewStyleGrouped];
    _tableViewIns.delegate = self;
    _tableViewIns.dataSource = self;
    [_tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, 320, 50))];
    //    imgView.image = [UIImage imageNamed:@"bg_tableViewCell"];
    //    tableViewIns.backgroundView = imgView;
    
    [self.view addSubview:_tableViewIns];
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 2;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    NSString *value = [personalInfo objectForKey:@"gender"];

    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        if ([@"1" isEqual:value]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = @"男";
    }else if (0 == [indexPath section] && 1 == [indexPath row]){
        if ([@"2" isEqual:value]) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        cell.textLabel.text = @"女";
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];

    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSArray *array = [tableView visibleCells];
    for (UITableViewCell *cell in array) {
        [cell setAccessoryType:UITableViewCellAccessoryNone];
    }
    [[tableView cellForRowAtIndexPath:indexPath]setAccessoryType:UITableViewCellAccessoryCheckmark];
    
    NSString *gender = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    
    if ([@"男" isEqual:gender]) {
        gender = @"1";
    } else {
        gender = @"2";
    }

    GlobalSingletonUserInfo* g_userPersonalInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    NSMutableDictionary *personalInfo = [g_userPersonalInfo getUserPersonalInfo];
    
    [personalInfo setObject:gender forKey:@"gender"];
    
    // 更新单例中得数据
    [g_userPersonalInfo setUserPersonalInfo:personalInfo];
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
