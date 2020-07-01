//
//  TestApiTSNetworkingViewController.m
//  MicroSchool
//
//  Created by jojo on 15/4/13.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TestApiTSNetworkingViewController.h"

@interface TestApiTSNetworkingViewController ()

@end

@implementation TestApiTSNetworkingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [super setCustomizeTitle:@"test API"];
    [super setCustomizeLeftButton];

    int a=99;
    
    NSString *g_uid = [[NSUserDefaults standardUserDefaults] objectForKey:G_NSUserDefaults_UserUniqueUid];

    NSString *g_uid1 = [Utilities getUniqueUid];
    
    _label_content = [[UILabel alloc] initWithFrame:CGRectMake(20, 20, 200, 15)];
    //设置title自适应对齐
    _label_content.lineBreakMode = NSLineBreakByWordWrapping;
    _label_content.font = [UIFont systemFontOfSize:16.0f];
    //label_content.numberOfLines = 0;
    //label_content.adjustsFontSizeToFitWidth = YES;
    _label_content.lineBreakMode = NSLineBreakByTruncatingTail;
    _label_content.textAlignment = NSTextAlignmentLeft;
    _label_content.backgroundColor = [UIColor clearColor];
    
    _label_content.textColor = [UIColor blackColor];
    _label_content.text = @"saldkfjasldjf";
    [self.view addSubview:_label_content];

#if 9
    
    [Utilities showProcessingHud:self.view];
    
    
//    [Utilities showGlobalProgressHUDWithTitle:@"aaaaaa"];
    
    // test for sleep
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"Test",@"ac",
            @"2",@"v",
            @"sleep", @"op",
            @"1", @"time",
            nil];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSString *str = self.testStr;
        
        int b = a;
        int c = 0;
        
        _label_content.text = @"1111";

        [Utilities dismissProcessingHud:self.view];
        
        [Utilities showFailedHud:nil descView:self.view];
        
//        [Utilities showSuccessedHud:@"" descView:self.view];
//        [Utilities dismissGlobalHUD];
        
        NSLog(@"sleep 3");
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];

//    [Utilities addProcessingHud:self.view];

    data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Test",@"ac",
                          @"2",@"v",
                          @"sleep", @"op",
                          @"5", @"time",
                          nil];
    
//    [Utilities addProcessingHud:self.view];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"sleep 5");
        
//        [Utilities removeProcessingHud:self.view];
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];

    data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"Test",@"ac",
            @"2",@"v",
            @"sleep", @"op",
            @"4", @"time",
            nil];
    
//    [Utilities addProcessingHud:self.view];

    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        NSLog(@"sleep 4");
        
//        [Utilities removeProcessingHud:self.view];

        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
    }];

#endif
    
    
#if 0
    // 后台返回数据解析不了
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
            REQ_URL, @"url",
            @"Test",@"ac",
            @"2",@"v",
            @"sql", @"op",
            nil];

    
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if(true == [result intValue]) {
            
        } else {
            
        }
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        NSLog(@"error: %d", (TSNetworkingErrType)error);
        
//        [Utilities doHandleTSNetworkingErr:error addedView:self.view];
        [Utilities doHandleTSNetworkingErr:error addedView:self.view];

    }];

    
#endif
    
    
    
    
#if 0
    // 超时测试
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Test",@"ac",
                          @"2",@"v",
                          @"sleep", @"op",
                          @"5", @"time",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        NSLog(@"sleep 3");
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        NSLog(@"error: %d", (TSNetworkingErrType)error);

    }];
#endif
    
    
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

- (void)selectLeftAction:(id)sender
{
//    // 取消所有的网络请求
//    [network cancelCurrentRequest];
    
    [[TSNetworking sharedClient] cancelAll];

    [self.navigationController popViewControllerAnimated:YES];
    
}

@end
