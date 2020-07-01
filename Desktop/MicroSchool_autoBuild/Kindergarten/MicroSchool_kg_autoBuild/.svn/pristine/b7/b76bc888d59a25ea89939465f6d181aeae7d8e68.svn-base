//
//  CertificationViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 15/4/23.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "CertificationViewController.h"
#import "CertificationTableViewCell.h"
#import "UIImageView+WebCache.h"

@interface CertificationViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *otherIcon;
@property (strong, nonatomic) IBOutlet UIImageView *icon;
@property (strong, nonatomic) IBOutlet UIImageView *headImgV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIView *headerView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UILabel *otherDetailLabel;

@end

@implementation CertificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomizeTitle:@"认证详情"];
    [self setCustomizeLeftButton];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90.0, 18.0, 209.0, 21.0)];
    _titleLabel.numberOfLines = 0;
    _titleLabel.font = [UIFont systemFontOfSize:15.0];
    [_headerView addSubview:_titleLabel];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(109.0, 55.0, 191.0, 21.0)];
    _detailLabel.numberOfLines = 0;
    _detailLabel.font = [UIFont systemFontOfSize:14.0];
    [_headerView addSubview:_detailLabel];
    
    _tableView.tableFooterView = [[UIView alloc] init];
    _tableView.tableHeaderView =  _headerView;
    _tableView.hidden = YES;
    
    [self getData];
    
    [ReportObject event:ID_SUBSCRIPTION_INFO];//2015.06.25
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

-(void)getData{
    
    //HUD = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    //HUD.labelText = @"加载中...";
    [Utilities showProcessingHud:self.view];//2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSDictionary *dic = [FRNetPoolUtils getCertificateDetail:_number];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //[HUD hide:YES];
            [Utilities dismissProcessingHud:self.view];
            
            if (![Utilities isConnected]) {//2015.06.30
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
            }
            
            if (dic == nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                _tableView.hidden = NO;
                
                /*
                 {
                 message =     {
                 article =         {
                 count = 0;
                 dateline = 1429779826;
                 title = luke;
                 };
                 "auth_dateline" = 1429677323;
                 "auth_desc" = "\U6211\U662f\U63cf\U8ff0";//认证说明
                 "auth_status" = 1;
                 company = "<null>";
                 name = "\U77e5\U6821";
                 note = "";//功能简介
                 number = 1;
                 pic = "http://test.5xiaoyuan.cn/ucenter/data/avatar/000/06/32/35_avatar_middle.jpg";
                 type = 2;
                 };
                 protocol = "SchoolSubscriptionAction.profile";
                 result = 1;
                 }
                 */
                
                _tableView.hidden = NO;
                
                diction = [[NSDictionary alloc] initWithDictionary:dic];
                
//                NSMutableArray *array =[dic objectForKey:@"list"];
//                
//                if ([array count] >0) {
//                    
//                    listArray = [[NSMutableArray alloc]initWithArray:array copyItems:YES];
//                    
//                    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
//                }
           
                _headImgV.layer.cornerRadius = 60.0/2.0;
                _headImgV.layer.masksToBounds = YES;
                
                NSString *head_url = [diction objectForKey:@"pic"];
                [_headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"SchoolExhibition/icon_school_avatar_defalt.png"]];
                
                NSString *name = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"name"]]];
                
                _titleLabel.text = name;
                
                CGSize size = [Utilities getStringHeight:name andFont:[UIFont systemFontOfSize:15.0] andSize:CGSizeMake(209.0, 0)];
                if (size.height > 21.0) {
                    _titleLabel.frame = CGRectMake(_titleLabel.frame.origin.x,_titleLabel.frame.origin.y , 209.0, 40.0);
                }
               
                _detailLabel.textColor = [UIColor colorWithRed:0.0/255.0 green:122.0/255.0 blue:212.0/255.0 alpha:1] ;
                
                NSString *type = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"type"]]];
                //1:政府,2:企业,3:媒体,4:其他组织,5:个人
                
                NSString *company = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"company"]]];
                 //company = @"大连致胜传媒科技股份有限责任公司";//测试数据
                _detailLabel.text = company;
               
                CGSize detailSize = [Utilities getStringHeight:company andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake(191.0, 0)];
                
                float detailLabelHeight = detailSize.height;
                if (detailLabelHeight > 21.0) {
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                        detailLabelHeight +=7;
                    }
                }else{
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

                        detailLabelHeight = 21.0;
                    }else{
                        detailLabelHeight = 16.0;// iOS7的label有一个最小高度 这里设置了也不好用
                    }
                    
                }
                
                if ([type integerValue] == 4) {
                    
                     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
                         _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x - 3, _detailLabel.frame.origin.y,_detailLabel.frame.size.width , detailLabelHeight);
                     }else{
                         _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x - 3, _detailLabel.frame.origin.y-10,_detailLabel.frame.size.width , detailLabelHeight);
                     }
                   
                }else{
                    
                    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {

                       _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y,_detailLabel.frame.size.width , detailLabelHeight);
                    }else{
                         _detailLabel.frame = CGRectMake(_detailLabel.frame.origin.x, _detailLabel.frame.origin.y-10,_detailLabel.frame.size.width , detailLabelHeight);
                    }
                }
                
               
                
                switch ([type integerValue]) {
                    case 1:
                        _icon.image = [UIImage imageNamed:@"zf_.png"];
                        break;
                    case 2:
                        _icon.image = [UIImage imageNamed:@"qy_.png"];
                        break;
                    case 3:
                        _icon.image = [UIImage imageNamed:@"mt_.png"];
                        break;
                    case 4:
                        _otherIcon.image = [UIImage imageNamed:@"qt_.png"];
                        break;
                    case 5:
                        _icon.image = [UIImage imageNamed:@"gr_.png"];
                        break;
                        
                    default:
                        break;
                }
                
                if (_detailLabel.frame.origin.y+_detailLabel.frame.size.height > _headerView.frame.size.height) {
                    
                    float temp = _detailLabel.frame.origin.y+_detailLabel.frame.size.height - _headerView.frame.size.height;
                    _headerView.frame = CGRectMake(0, 0, _headerView.frame.size.width, _headerView.frame.size.height +temp);
                     _tableView.tableHeaderView = _headerView;
                }
                
               
                [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            }
        });
        
    });
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    
    return 3;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellTableIdentifier = @"CertificationTableViewCell";
    CertificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
    if(cell == nil) {
        
        UINib *nib = [UINib nibWithNibName:@"CertificationTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellTableIdentifier];
        cell = [tableView dequeueReusableCellWithIdentifier:CellTableIdentifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    
    if (indexPath.row == 0) {
        
        NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"note"]]];
        CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90.0, 0)];
        
        if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {//ios8
             cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 35.0, cell.detailLabel.frame.size.width, size.height);
        }else{// ios7
            cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 35.0 - 10.0, cell.detailLabel.frame.size.width, size.height);
        }
        
        cell.titleLabel.text = @"功能简介";
        cell.detailLabel.text  = detailStr;
        cell.headImgV.image = [UIImage imageNamed:@"icon_gnjj_.png"];
        
    }else if (indexPath.row == 1){
        
        cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, cell.detailLabel.frame.origin.y, cell.detailLabel.frame.size.width,20.0);
        
        cell.titleLabel.text = @"认证时间";
       NSString *dateStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"auth_dateline"]]];
        dateStr = [[Utilities alloc] linuxDateToString:dateStr andFormat:@"%@-%@-%@" andType:DateFormat_YMD];
        cell.detailLabel.text = dateStr;
        cell.headImgV.image = [UIImage imageNamed:@"icon_rzsj_.png"];
        
    }else if (indexPath.row == 2){
        
        NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"auth_desc"]]];
        CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90.0, 0)];
        
         if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {//ios8
        
             cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 35.0, cell.detailLabel.frame.size.width, size.height);
         }else{//ios7
             cell.detailLabel.frame = CGRectMake(cell.detailLabel.frame.origin.x, 35.0 - 10.0, cell.detailLabel.frame.size.width, size.height);
         }
        cell.titleLabel.text = @"认证说明";
        cell.detailLabel.text =detailStr;
        cell.headImgV.image = [UIImage imageNamed:@"icon_rzsm_.png"];
        
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    float height = 20.0;
    
    if (indexPath.row == 0) {
        
        NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"note"]]];
        CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90, 0)];
         if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {//ios8
             height = size.height + 45.0;
         }else{//ios7
             height = size.height + 35.0-10.0;
         }
        
        
    }else if (indexPath.row == 1){
        
        height += 40.0;
        
    }else if (indexPath.row == 2){
        
        NSString *detailStr = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[diction objectForKey:@"auth_desc"]]];
        CGSize size = [Utilities getStringHeight:detailStr andFont:[UIFont systemFontOfSize:14.0] andSize:CGSizeMake([UIScreen mainScreen].bounds.size.width - 90.0, 0)];
        if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {//ios8
            height = size.height +45.0;
        }else{// ios7
            height = size.height +35.0 -10.0;
        }
    }
    
    return height;
}

#pragma mark - Table view delegate
// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    
    
}

@end
