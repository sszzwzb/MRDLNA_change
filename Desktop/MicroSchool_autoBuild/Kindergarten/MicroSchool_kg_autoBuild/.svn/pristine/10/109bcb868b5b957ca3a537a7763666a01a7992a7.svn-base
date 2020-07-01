//
//  RepeatNameViewController.m
//  
//
//  Created by banana on 16/6/22.
//
//

#import "RepeatNameViewController.h"
#import "RepeatNameTableViewCell.h"
#import "ClassListViewController.h"

@interface RepeatNameViewController ()<UITableViewDelegate, UITableViewDataSource, UIAlertViewDelegate>{
//    NSMutableArray *arr;
    NSMutableArray *heightArr;
    NSDictionary *selectedDic;
}
@property (nonatomic, strong) UITableView *tb;
@end


@implementation RepeatNameViewController
//假入口写在mainmenu 2246   6.22
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self dataHandler];
    [self buildView];
    [self buildRepeatNameTb];
}
- (void)buildRepeatNameTb
{
    self.tb = [[UITableView alloc] initWithFrame:CGRectMake(10, 0, self.view.bounds.size.width - 20, self.view.bounds.size.height - 44 - 50 - 19) style:UITableViewStylePlain];
    _tb.separatorStyle = NO;
    _tb.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
    _tb.delegate = self;
    _tb.dataSource = self;
    [_tb registerClass:[RepeatNameTableViewCell class] forCellReuseIdentifier:@"repeatNameCell"];
    [self.view addSubview:_tb];
    _tb.showsVerticalScrollIndicator = NO;
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, self.view.bounds.size.width, 44 + 48)];
    headView.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
    UILabel *labelTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 24, self.view.bounds.size.width - 20, 22)];
    if (_cId.integerValue > 0) {
    labelTop.text = @"以下是本班和您申请信息有相同姓名的学生信息,";
    }else{
    labelTop.text = @"以下是本校和您申请信息有相同姓名的学生信息,";
    }
    labelTop.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    labelTop.textAlignment = NSTextAlignmentCenter;
    labelTop.font = [UIFont systemFontOfSize:14];
    UILabel *labelDown = [[UILabel alloc] initWithFrame:CGRectMake(0, 24 + 22, self.view.bounds.size.width - 20, 22)];
    labelDown.text = @"如果有您或您的孩子，请点击绑定";
    labelDown.textColor = [UIColor colorWithRed:102.0 / 255 green:102.0 / 255 blue:102.0 / 255 alpha:1];
    labelDown.textAlignment = NSTextAlignmentCenter;
    labelDown.font = [UIFont systemFontOfSize:14];
    [headView addSubview:labelTop];
    [headView addSubview:labelDown];
    _tb.tableHeaderView = headView;
    
  
}


//继续创建
- (void)footerAction{
    
    //暂无学生ID 去选班页面
    if (_cId) {//在班级内 直接绑定
        
        [self.navigationController popViewControllerAnimated:YES];
        NSDictionary *inDic;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStudentID" object:inDic];
    
   }else{//不在班级内 进入选择班级列表
       
        NSLog(@"footerAction apply");
        ClassListViewController *class = [[ClassListViewController alloc] init];
        class.viewType = @"signup";
        class.userInfoDic = _userInfoDic;
        class.flag = 1;
        [self.navigationController pushViewController:class animated:YES];
        
    }
    
}

//点击绑定
- (void)selectedButton:(UIButton *)button{
    
    NSLog(@"%ld", button.tag);
    NSInteger tag = button.tag;
    NSDictionary *dic = _dataArr[tag - 2000];
    NSLog(@"dic:%@",dic);
    selectedDic = [NSDictionary dictionaryWithDictionary:dic];
    
#if 0
    //第二次进这个页 如果用下边新的对话框 点击绑定时 就会一直不停的转圈
    TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle){
       
        [self.navigationController popViewControllerAnimated:YES];
        NSString *student_number = [NSString stringWithFormat:@"%@",[selectedDic objectForKey:@"student_number"]];
        NSString *student_name = [NSString stringWithFormat:@"%@",[selectedDic objectForKey:@"student_name"]];
        NSDictionary *inDic = [[NSDictionary alloc] initWithObjectsAndKeys:student_number,@"student_number",student_name,@"student_name",[_userInfoDic objectForKey:@"parent"],@"parent",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStudentID" object:inDic];

    };
    
    NSArray *itemsArr =
    @[TSItemMake(@"确定", TSItemTypeNormal, handlerTest)];
    [Utilities showPopupView:@"是否应用此ID为您的ID" items:itemsArr];
#endif
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"是否应用此ID为您的ID" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];

    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        
        
        [self.navigationController popViewControllerAnimated:YES];
        NSString *student_number = [NSString stringWithFormat:@"%@",[selectedDic objectForKey:@"student_number"]];
        NSString *student_name = [NSString stringWithFormat:@"%@",[selectedDic objectForKey:@"student_name"]];
        NSDictionary *inDic = [[NSDictionary alloc] initWithObjectsAndKeys:student_number,@"student_number",student_name,@"student_name",[_userInfoDic objectForKey:@"parent"],@"parent",nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"changeStudentID" object:inDic];
        
        
    }else{
        
    }


}

- (void)dataHandler
{

//    arr = [NSMutableArray arrayWithArray:@[@{@"childName" : @"奇迹",@"childID" : @"123213", @"arr" : @[@{@"name":@"奇迹", @"账号":@"133131313"}, @{@"name":@"奇迹yeye", @"账号":@"133131313"}, @{@"name":@"奇迹mama", @"账号":@"133131313"}]},@{@"childName" : @"奇迹",@"childID" : @"123213", @"arr" : @[]}, @{@"childName" : @"奇迹",@"childID" : @"123213", @"arr" : @[@{@"name":@"奇迹", @"账号":@"133131313"}, @{@"name":@"奇迹yeye", @"账号":@"133131313"}, @{@"name":@"奇迹mama", @"账号":@"133131313"}]}, @{@"childName" : @"奇迹",@"childID" : @"123213", @"arr" : @[@{@"name":@"奇迹", @"账号":@"133131313"}, @{@"name":@"奇迹yeye", @"账号":@"133131313"}, @{@"name":@"奇迹mama", @"账号":@"133131313"},@{@"name": @"sbbbbb", @"账号":@"250"},@{@"name":@"奇迹yeye", @"账号":@"133131313"}, @{@"name":@"奇迹mama", @"账号":@"133131313"},@{@"name": @"sbbbbb", @"账号":@"250"}]}]];
    //高度数组
    heightArr = [NSMutableArray array];
    for (NSDictionary *tempDic in _dataArr) {
        NSArray *tempArr = [tempDic objectForKey:@"list"];
        if (tempArr.count == 0) {
            int height = 14 + 18 + 8 + 14 + 20 + 15;
            NSNumber *aNum = [NSNumber numberWithInt:height];
            [heightArr addObject:aNum];
        }else{
            int height = 60 * (int)tempArr.count + 15 + 14 + 18 + 8 + 14 + 20 + 15 + 4 + 10 + 14 + 10;
            NSNumber *aNum = [NSNumber numberWithInt:height];
            [heightArr addObject:aNum];
        }
        
    }
    [self.tb reloadData];
    
}
- (void)buildView
{
    self.view.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@""];
    
    
//    UILabel *footerView = [[UILabel alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 50 - 44 - 19, self.view.bounds.size.width, 50)];
//
//    footerView.backgroundColor = [UIColor colorWithRed:0.0 / 255 green:151.0 / 255 blue:254.0 / 255 alpha:1];
//    footerView.text = @"并没有我的孩子信息,继续创建";
//    footerView.textAlignment = UITextAlignmentCenter;
//    footerView.textColor = [UIColor whiteColor];
//    [self.view addSubview:footerView];
    
    
    //底部蓝条
    
    UIButton *footerButton = [UIButton buttonWithType:UIButtonTypeCustom];
    footerButton.backgroundColor = [UIColor colorWithRed:54.0/255.0 green:182.0/255.0 blue:169.0/255.0 alpha:1];
    footerButton.frame = CGRectMake(0, self.view.bounds.size.height - 50 - 44 - 19, self.view.bounds.size.width, 50);
    [footerButton setTitle:@"并没有我的孩子信息，继续创建" forState: UIControlStateNormal];
    [footerButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [footerButton setTitleColor:[UIColor colorWithRed:255.0 / 255 green:255.0 / 255 blue:255.0 / 255 alpha:1] forState:UIControlStateHighlighted];
    [footerButton.titleLabel setFont:[UIFont systemFontOfSize:16]];
    [self.view addSubview:footerButton];
    [footerButton addTarget:self action:@selector(footerAction) forControlEvents:UIControlEventTouchUpInside];
    
    

//    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(reload) userInfo:nil repeats:NO];

}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [heightArr[indexPath.row] floatValue];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"repeatNameCell";
    RepeatNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    RepeatNameTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    NSLog(@"%@", _dataArr);
    if (nil == cell) {
        cell = [[RepeatNameTableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        
    }else{
//        [(UIView *)[cell.contentView.subviews lastObject] removeFromSuperview];
    }
    cell.arr = [NSMutableArray arrayWithArray:[_dataArr[indexPath.row] objectForKey:@"list"]];
    cell.i = indexPath.row;
    NSDictionary *dic = _dataArr[indexPath.row];
    cell.backgroundColor = [UIColor colorWithRed:245.0 / 255 green:245.0 / 255 blue:245.0 / 255 alpha:1];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.childLabel.text = [dic objectForKey:@"student_name"];
    cell.childIDLabel.text = [NSString stringWithFormat:@"学生ID:%@",[dic objectForKey:@"student_number"]];
    cell.selectedButton.tag = 2000 + indexPath.row;
    
    
    //通过名字来计算长度  得到长度之后更新布局

    cell.childLabel.text = [self.dataArr[indexPath.row] objectForKey:@"student_name"];
    CGSize childSize = [Utilities getLabelHeight:cell.childLabel size:CGSizeMake(0, 18)];
    CGFloat tempChildFloat = childSize.width;
    if (tempChildFloat == 0) {
        tempChildFloat = 40;
    }

    [cell.childLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(tempChildFloat, 18));
    }];

    //根据数据得到性别图标
    if([[dic objectForKey:@"sex"] integerValue] == 2){
       
        [cell.genderImv  setImage:[UIImage imageNamed:@"personalInfo/female.png"]];
    }else {
        [cell.genderImv  setImage:[UIImage imageNamed:@"personalInfo/male.png"]];
    }

    [cell.selectedButton addTarget:self action:@selector(selectedButton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    return cell;


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
