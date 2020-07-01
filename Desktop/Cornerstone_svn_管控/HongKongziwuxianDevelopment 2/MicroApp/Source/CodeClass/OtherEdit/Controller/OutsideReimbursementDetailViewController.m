//
//  OutsideReimbursementDetailViewController.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/16.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OutsideReimbursementDetailViewController.h"

#import "OutsideReimbursementListModel.h"
#import "OutsideReimbursementDetailScrollView.h"


#import "ImagePickerViewController.h"


@interface OutsideReimbursementDetailViewController () <OutsideReimbursementDetailScrollViewDelegate,HttpReqCallbackDelegate>

@end

@implementation OutsideReimbursementDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    // Custom initialization
    network = [AFNNetworkUtility alloc];
    network.delegate = self;
    
    [self setCustomizeTitle:self.title];
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"撤销" color:[UIColor whiteColor]];
    
    NSLog(@"OutsideReimbursementDetailViewController  属性传值 = %@",_model.orderName);
    
    
    [self up_view];
    
}


-(void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender
{
    NSLog(@"撤销");
    if ([self.title isEqualToString:@"外采报销详情"]) {
        [self uplaod_dataForOutsideReimbursement];
    } else {
        [self uplaod_dataForOil];
    }
}


-(void)up_view
{
    OutsideReimbursementDetailScrollView *bgView = [[OutsideReimbursementDetailScrollView alloc]initWithFrame:
                                                    self.view.frame];
    [self.view addSubview:bgView];
    
    bgView.model = _model;
    bgView.myDelegate = self;
    
}

#pragma mark - OutsideReimbursementDetailScrollViewDelegate
-(void)selectButtonForImg:(UIImage *)image
{
    ImagePickerViewController *IPVC = [[ImagePickerViewController alloc]initWithImage:image];
    
    IPVC.clipType = originalImage;
    
    [self.navigationController pushViewController:IPVC animated:YES];
}


-(void)uplaod_dataForOutsideReimbursement
{
    //  外采撤销
    /**
     DeleteFinWC(string UserName, string Infoid);  外采撤销
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/DeleteFinWC",
                           
                           @"UserName":[UtilitiesData getLoginUserName],
                           @"Infoid":_model.InfoID
                           };
    
    [network sendHttpReq:HttpReq_DeleteFinWC andData:data];
}


-(void)uplaod_dataForOil
{
    //  剩余油量
    /**
     DeleteFinOil(string UserName, string Infoid); 剩余油量撤销
     */
    
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = @{
                           @"url":REQ_URL,
                           @"url_stringByAppendingString":@"login.svc/DeleteFinOil",
                           
                           @"UserName":[UtilitiesData getLoginUserName],
                           @"Infoid":_model.InfoID
                           };
    
    [network sendHttpReq:HttpReq_DeleteFinOil andData:data];
}


#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(id)data andType:(HttpReqType)type
{
    NSDictionary *resultJSON = data;
    
    NSLog(@"OutsideReimbursementDetailViewController  HttpReqType  %d\n  Data    %@",type,resultJSON);
    
    //   剩余油量撤销
    if (type == HttpReq_DeleteFinOil || type == HttpReq_DeleteFinWC) {
        
        [Utilities dismissProcessingHud:self.view];
        
        if ([resultJSON[@"Result"] boolValue]) {
            
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"OutsideReimbursementListViewController_reloadData" object:self userInfo:nil];
            
            [self performSelector:@selector(selectLeftAction:) withObject:nil afterDelay:1.f];
            
        } else {
            [Utilities showTextHud:[resultJSON objectForKey:@"Message"] descView:self.view];
        }
        
    }
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    {
        [Utilities showTextHud:TEXT_NONETWORK descView:self.view];
//        UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:[UIScreen mainScreen].bounds];
//        [self.view addSubview:noNetworkV];
    }
}

@end
