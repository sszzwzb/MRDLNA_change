//
//  BindByTextViewController.m
//  MicroSchool
//
//  Created by Kate on 14-11-12.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "BindByTextViewController.h"
#import "FRNetPoolUtils.h"
#import "FriendProfileViewController.h"

@interface BindByTextViewController ()
@property (strong, nonatomic) IBOutlet UIButton *submitBtn;
- (IBAction)submitAction:(id)sender;
@property (strong, nonatomic) IBOutlet UITextField *textField;

@end

@implementation BindByTextViewController

extern BOOL isScan;

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"亲子关系绑定"];
    self.navigationController.navigationBarHidden = NO;
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    [_textField becomeFirstResponder];

    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [_submitBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    if ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0){
        isScan = YES;
    
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)submitAction:(id)sender {

    if ([_textField.text length] == 0) {
        
        [Utilities showAlert:@"提示" message:@"请输入绑定码" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }else{
        
        [_textField resignFirstResponder];
        
        [Utilities showProcessingHud:self.view];
        
        network = [NetworkUtility alloc];
        network.delegate = self;
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Friend", @"ac",
                              @"1",@"v",
                              @"viewByCode", @"op",
                              _textField.text, @"code",
                              nil];
        
        [network sendHttpReq:HttpReq_ViewFriendProfileByCode andData:data];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    [self submitAction:nil];
    
    return YES;
}

//定义UITextFiled的代理方法：
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    //这里默认是最多输入15位
    if (_textField == textField) {
        if (range.location >= 20)
            return NO; // return NO to not change text
    }

    return YES;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
   
    
    if(true == [result intValue]) {
    
        NSDictionary *message_info = [resultJSON objectForKey:@"message"];
        NSLog(@"message_info:%@",message_info);
        // 把秘钥带到下一页，调用获取个人资料接口
        FriendProfileViewController *fpV = [[FriendProfileViewController alloc]init];
        fpV.infoDic = message_info;
        fpV.fromName = @"scan";
        fpV.code = _textField.text;//---add by kate 2014.12.03------------------
        [self.navigationController pushViewController:fpV animated:YES];
    
    }else{
        
        NSString* message_info = [resultJSON objectForKey:@"message"];
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:message_info
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
        
    }

}

-(void)reciveHttpDataError:(NSError*)err
{
    [Utilities dismissProcessingHud:self.view];
    
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
}

@end
