//
//  ChangeSignNumberViewController.m
//  MicroSchool
//
//  Created by banana on 16/9/20.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "ChangeSignNumberViewController.h"

@interface ChangeSignNumberViewController ()<UITextFieldDelegate>{
    UIButton *submitBtn;
    UITextField *textField;
}
@property (nonatomic, strong) TSTableView *signManageVC;


@end

@implementation ChangeSignNumberViewController
- (void)loadView{
    [super loadView];
    [self buildUI];
    [textField becomeFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = TS_COLOR_BACKGROUND_GREY_RGB;
    [self setCustomizeTitle:@"更改"];
    [self setCustomizeLeftButton];


}

- (void) buildUI{
    
    UIView *whiteBG = [[UIView alloc] initWithFrame:CGRectMake(0, 40, [UIScreen mainScreen].applicationFrame.size.width, 45)];
    whiteBG.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:whiteBG];
    
    textField = [[UITextField alloc]init];
    textField.frame = CGRectMake(12, 0, [UIScreen mainScreen].applicationFrame.size.width - 24, 45);
    textField.backgroundColor = [UIColor whiteColor];
    textField.textColor = [UIColor colorWithRed:51.0 / 255 green:51.0 / 255 blue:51.0 / 255 alpha:1];
    textField.font = [UIFont systemFontOfSize:15.0f];
    textField.returnKeyType = UIReturnKeyDone;
    textField.keyboardType = UIKeyboardTypeNumberPad;//考勤卡ID为纯数字 长度限制10位 经纬&Tony确认
    UIColor *color = [UIColor colorWithRed:153.0 / 255 green:153.0 / 255 blue:153.0 / 255 alpha:1];
    textField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"输入更改后的签到卡卡号" attributes:@{NSForegroundColorAttributeName: color}];//设置placeholder颜色
    textField.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];
    textField.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [textField setDelegate: self];
    
    [whiteBG addSubview:textField];
    
    submitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    // 设置title自适应对齐
    submitBtn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.font = [UIFont boldSystemFontOfSize:17.0f];
    
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [submitBtn addTarget:self action:@selector(submitAction) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [submitBtn setTitle:@"绑定" forState:UIControlStateNormal];
    [submitBtn setTitle:@"绑定" forState:UIControlStateHighlighted];
    
    submitBtn.frame = CGRectMake(12, 115, [UIScreen mainScreen].applicationFrame.size.width - 24, 42);
    [self.view addSubview:submitBtn];
    

    
    
}
- (void)submitAction
{
    [textField resignFirstResponder];
    
    if ([textField.text isEqualToString:@""]) {
        
        [Utilities showTextHud:@"请输入签到卡ID" descView:self.view];
        
    }else if ([textField.text length]!=10){
        
        [Utilities showTextHud:@"请输入正确的10位卡号" descView:self.view];
        
    }else{
        
        // 调用绑定接口
        TSPopupItemHandler handlerTest = ^(NSInteger index, NSString *btnTitle) {
            
            [self postData];
            
        };
        
        NSArray *itemsArr = @[TSItemMake(@"确定", TSItemTypeNormal, handlerTest)];
        [Utilities showPopupView:[NSString stringWithFormat:@"确认将您的签到卡改为卡号为%@的签到卡？",textField.text] items:itemsArr];
        
        
    }

}
-(void)postData{//2015.09.16
    if ([_textView.text isEqual:@""]) {
        [Utilities showTextHud:@"请输入卡号" descView:self.view];
    }else{
        NSDictionary *message_info;
        message_info = [g_userInfo getUserDetailInfo];
        
        // 数据部分
        if (nil == message_info) {
            message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        NSString *cid = [message_info objectForKey:@"role_cid"];
        NSString *uid = [message_info objectForKey:@"uid"];
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Checkin",@"ac",
                              @"3",@"v",
                              @"ChangeCard", @"op",
                              cid, @"cid",
                              uid, @"uid",
                              _haveOldCard, @"oldCard",
                              textField.text, @"newCard",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result integerValue] == 1) {
                
                NSLog(@"success");
                
                [Utilities showSuccessedHud:@"保存成功" descView:self.view];
                [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
                
                
            }else{
                
                [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
                
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities dismissProcessingHud:self.view];
            [Utilities showTextHud:@"请重新输入" descView:self.view];
        }];
    }
    
}
- (void)back{
    [self.navigationController popViewControllerAnimated:YES];
}
// 卡号限制10位
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if (range.location >= 10) {
        return NO;
    }
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [self hideKeyBoard];
    
    return YES;
}


- (void)selectLeftAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)getData{//2015.09.16
    if ([_textView.text isEqual:@""]) {
        [Utilities showTextHud:@"请输入卡号" descView:self.view];
    }else{
        NSDictionary *message_info;
        message_info = [g_userInfo getUserDetailInfo];
        
        // 数据部分
        if (nil == message_info) {
            message_info = [[NSUserDefaults standardUserDefaults] objectForKey:@"weixiao_userDetailInfo"];
        }
        NSString *cid = [message_info objectForKey:@"role_cid"];
        NSString *uid = [message_info objectForKey:@"uid"];
        [Utilities showProcessingHud:self.view];
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Checkin",@"ac",
                              @"3",@"v",
                              @"ChangeCard", @"op",
                              cid, @"cid",
                              uid, @"uid",
                              
                              textField.text, @"newCard",
                              nil];
        
        [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
            
            [Utilities dismissProcessingHud:self.view];
            NSDictionary *respDic = (NSDictionary*)responseObject;
            NSString *result = [respDic objectForKey:@"result"];
            
            if ([result integerValue] == 1) {
                
                NSLog(@"success");
                
                [Utilities showSuccessedHud:@"保存成功" descView:self.view];
                [self performSelector:@selector(back) withObject:nil afterDelay:0.5];
                
                
            }else{
                
                [Utilities showTextHud:[respDic objectForKey:@"message"] descView:self.view];
                
            }
            
            
        } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            [Utilities dismissProcessingHud:self.view];
            [Utilities showTextHud:@"请重新输入" descView:self.view];
        }];
    }
    
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
