//
//  SetMyPrivacyViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-27.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetMyPrivacyViewController.h"
#import "MyPrivacyWaysViewController.h"
#import "FRNetPoolUtils.h"

@interface SetMyPrivacyViewController ()

@end

@implementation SetMyPrivacyViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"个人隐私设置"];
    
    // 背景图片
    UIImageView *imgView_bgImg =[UIImageView new];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    [imgView_bgImg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).with.offset(0);
        make.left.equalTo(self.view).with.offset(0);
        make.size.mas_equalTo(CGSizeMake(WIDTH,HEIGHT));
    }];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              WIDTH,
                                                            HEIGHT - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    
    [self.view addSubview:_tableView];
    
    [self getData];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(getData)
                                                 name:@"refreshMyPrivacyView"
                                               object:nil];
    
    [ReportObject event:ID_OPEN_MY_PRIVACY];//2015.06.25
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    //[_tableView reloadData];
}

-(void)getData{
    
    [Utilities showProcessingHud:self.view];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用查看个人隐私接口
        NSMutableArray *array = [FRNetPoolUtils viewMyPrivacy];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (array == nil) {
                
                [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                if ([array count] > 0 ) {
                    
                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                }
                
            }
        });
    });

}

-(void)reload{
    
    [_tableView reloadData];
}


#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    
    return [listArray count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    
    for (int i=0; i<[listArray count]; i++) {
        
        NSDictionary *dic = [listArray objectAtIndex:i];
        NSArray *rowCount = [dic objectForKey:@"fields"];
        
        if (section == i) {
           return [rowCount count];
        }
       
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:17.0];
    
    for (int i=0; i<[listArray count]; i++) {
        
        NSDictionary *dic = [listArray objectAtIndex:i];
        NSArray *rowCount = [dic objectForKey:@"fields"];
       
        for (int j =0 ; j<[rowCount count]; j++) {
             NSDictionary *rowDic = [rowCount objectAtIndex:j];
            if (indexPath.section == i && indexPath.row == j) {
                cell.textLabel.text = [rowDic objectForKey:@"title"];
                NSString *authFlag = [rowDic objectForKey:@"friend"];
                if ([authFlag intValue] == 0) {
                    cell.detailTextLabel.text = @"所有人可见";
                }else if ([authFlag intValue] == 1){
                    cell.detailTextLabel.text = @"仅好友可见";
                }else if ([authFlag intValue] == 3){
                    cell.detailTextLabel.text = @"仅自己可见";
                }
            }
        }
        
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    NSDictionary *dic = [listArray objectAtIndex:indexPath.section];
    NSString *type = [dic objectForKey:@"type"];
    NSArray *rowCount = [dic objectForKey:@"fields"];
    NSDictionary *rowDic = [rowCount objectAtIndex:indexPath.row];
    NSString *subtype = [rowDic objectForKey:@"type"];
    NSString *title = [rowDic objectForKey:@"title"];
    NSString *friend = [rowDic objectForKey:@"friend"];
    
    MyPrivacyWaysViewController *privacyW = [[MyPrivacyWaysViewController alloc]init];
    privacyW.fromName = title;
    privacyW.type = type;
    privacyW.subtype = subtype;
    privacyW.joinPerm = friend;
    [self.navigationController pushViewController:privacyW animated:YES];
    
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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

@end
