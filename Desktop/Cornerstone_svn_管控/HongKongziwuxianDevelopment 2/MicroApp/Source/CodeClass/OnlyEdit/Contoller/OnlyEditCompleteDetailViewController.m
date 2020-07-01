//
//  OnlyEditCompleteDetailViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditCompleteDetailViewController.h"

#import "OnlyEditPerSQLModel.h"
#import "OnlyEditCompleteDetailTableViewCell.h"


#import "ImagePickerViewController.h"


static NSString * showOnlyEditCompleteDetailTableViewCell = @"cell";

@interface OnlyEditCompleteDetailViewController () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) UIView *headerView;

@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *imgArr0;
@property (nonatomic,strong) NSMutableArray *imgArr1;
@property (nonatomic,strong) NSMutableArray *imgArr2;

@end

@implementation OnlyEditCompleteDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self setCustomizeTitle:@"已完成详情"];
    [self setCustomizeLeftButton];
    
    
    NSLog(@"OnlyEditCompleteDetailViewController  属性传值 = %@",_model.orderName);
    
    _dataArr = [NSMutableArray array];
    _imgArr0 = [NSMutableArray array];
    _imgArr1 = [NSMutableArray array];
    _imgArr2 = [NSMutableArray array];
    
    
    
    [self up_tableView];
    
    
    
    [self up_data];
    
    
}

-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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
    
    _headerView = [[UIView alloc]initWithFrame:
                   CGRectMake(0, 0, KScreenWidth, 100)];
    _headerView.backgroundColor = [UIColor whiteColor];
    _tableView.tableHeaderView = _headerView;
    
    
    if (@available(iOS 11.0, *)) {
        _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        _tableView.contentInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableView.scrollIndicatorInsets = _tableView.contentInset;
    }
    
    _tableView.estimatedRowHeight = 0;
    _tableView.estimatedSectionHeaderHeight = 0;
    _tableView.estimatedSectionFooterHeight = 0;
    
    
    [_tableView registerClass:[OnlyEditCompleteDetailTableViewCell class] forCellReuseIdentifier: showOnlyEditCompleteDetailTableViewCell];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [OnlyEditCompleteDetailTableViewCell cellHeight];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ([_dataArr[section] count] > 0) {
        return 40;
    }
    return 0.01;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (section == 2) {
        return KScreenTabBarIndicatorHeight + 0.01;
    }
    return 0.01;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [_dataArr count];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_dataArr[section] count];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *viewnil = [[UIView alloc]initWithFrame:
                       CGRectMake(0, 0, KScreenWidth, 40)];
    viewnil.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    UILabel *titleLab = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, 10, 200, 30)];
    [viewnil addSubview:titleLab];
    if (section == 0 && [_dataArr[section] count] > 0) {
        titleLab.text = @"起飞凭证";
    } else if (section == 1 && [_dataArr[section] count] > 0) {
        titleLab.text = @"降落凭证";
    } else if (section == 2 && [_dataArr[section] count] > 0) {
        titleLab.text = @"其他凭证";
    }
    
    return viewnil;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *viewnil = [UIView new];
    viewnil.hidden = YES;
    return viewnil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    OnlyEditCompleteDetailTableViewCell *cell = (OnlyEditCompleteDetailTableViewCell *)[tableView dequeueReusableCellWithIdentifier: showOnlyEditCompleteDetailTableViewCell forIndexPath:indexPath];
    
    if ([_dataArr count] > 0) {
        if ([_dataArr[indexPath.section] count] > 0) {
            
            cell.imgUrl = _dataArr[indexPath.section][indexPath.row][@"imgUrl"];
            cell.content = _dataArr[indexPath.section][indexPath.row][@"content"];
            [cell reloadData];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///  取消按键效果  按中后会返回成没有安过的效果
    [self.tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSLog(@"我点击了  %ld   %ld",(long)indexPath.section,(long)indexPath.row);
    
    NSLog(@"网络图片地址 = %@",_dataArr[indexPath.section][indexPath.row][@"content"]);
    
    OnlyEditCompleteDetailTableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
    
    [self.tableView beginUpdates];
    [self.tableView endUpdates];
    
    UIImage *img = [UIImage new];
    img = cell.imgV.image;
    
    ImagePickerViewController *IPVC = [[ImagePickerViewController alloc]initWithImage:img];
    
    IPVC.clipType = originalImage;
    
    [self.navigationController pushViewController:IPVC animated:YES];
    
}




-(void)up_data
{
    
    UILabel *labTitle = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, 15, KScreenWidth - 40, 32)];
    [_headerView addSubview:labTitle];
    labTitle.textColor = color_black;
    labTitle.font = FONT(16.f);
    labTitle.attributedText = [self attributedTextWithTitle0:@"航班" title1:[Utilities replaceNull:_model.airplaneType] title2:[Utilities replaceNull:_model.orderName]];
    
    
    UILabel *labDate = [[UILabel alloc]initWithFrame:
                         CGRectMake(20, CGRectGetMaxY(labTitle.frame) + 10, KScreenWidth - 40, 32)];
    [_headerView addSubview:labDate];
    labDate.textColor = color_black;
    labDate.font = FONT(16.f);
    labDate.attributedText = [self attributedTextWithTitle0:@"时间" title1:[Utilities replaceNull:_model.departureDate]];
    
    
    
   
    
    NSArray *PicUrlArr = [Utilities JsonStrtoArrayOrNSDictionary:[Utilities replaceNull:_model.PicUrl]];
    
    
    
    for (NSDictionary *dic in PicUrlArr) {
        if ([dic[@"type"] isEqualToString:@"1"]) {
            [_imgArr0 addObject:@{
                                  @"imgUrl":dic[@"xnpicurl"],
                                  @"content":dic[@"PicRemark"]
                                  }];
        }
        if ([dic[@"type"] isEqualToString:@"2"]) {
            [_imgArr1 addObject:@{
                                  @"imgUrl":dic[@"xnpicurl"],
                                  @"content":dic[@"PicRemark"]
                                  }];
        }
        if ([dic[@"type"] isEqualToString:@"3"]) {
            [_imgArr2 addObject:@{
                                  @"imgUrl":dic[@"xnpicurl"],
                                  @"content":dic[@"PicRemark"]
                                  }];
        }
    }
    
    
    [_dataArr addObject:[Utilities replaceArrNull:_imgArr0]];
    [_dataArr addObject:[Utilities replaceArrNull:_imgArr1]];
    [_dataArr addObject:[Utilities replaceArrNull:_imgArr2]];
    
    [_tableView reloadData];
    
}

-(NSAttributedString *)attributedTextWithTitle0:(NSString *)title0 title1:(NSString *)title1 title2:(NSString *)title2{
    NSString *string = [NSString stringWithFormat:@"%@:  %@  %@",title0 , title1 , title2];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:color_blue
                range:NSMakeRange([title0 length] + 3,[title1 length])];
    
    
    return str;
}

-(NSAttributedString *)attributedTextWithTitle0:(NSString *)title0 title1:(NSString *)title1 {
    NSString *string = [NSString stringWithFormat:@"%@:  %@",title0 , title1 ];
    
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    
    [str addAttribute:NSForegroundColorAttributeName
                value:color_gray2
                range:NSMakeRange([title0 length] + 3,[title1 length])];
    
    
    return str;
}


@end
