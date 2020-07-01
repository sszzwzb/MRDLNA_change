//
//  ChildViewController.m
//  MicroSchool
//
//  Created by Kate on 14-11-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "ChildViewController.h"
#import "QRCodeGenerator.h" // 用于生成二维码
#import "FRNetPoolUtils.h"
#import "ParenthoodListForChildTableViewController.h"
#import "MyTabBarController.h"

@interface ChildViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *imageview;
@property (strong, nonatomic) IBOutlet UILabel *secretKeyLabel;
@property (strong, nonatomic) IBOutlet UIButton *viewBindConditionBtn;
- (IBAction)ViewBindCondition:(id)sender;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UILabel *alertLabel;

@end

@implementation ChildViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"亲子关系绑定"];
    
    // 背景图片
//    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,320,[UIScreen mainScreen].applicationFrame.size.height)];
//    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
//    [self.view addSubview:imgView_bgImg];
    
//    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    [_viewBindConditionBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [_viewBindConditionBtn setBackgroundImage:[UIImage imageNamed:@"btn_common__1_p.png"] forState:UIControlStateHighlighted] ;
    
    NSString *classStr = @"(请勿将绑定码泄露给他人)";
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:classStr];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,1)];
//    [str addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(1,10)];
    [str addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(12,1)];
    
    _alertLabel.attributedText = str;
    
    
    if (IS_IPHONE_4) {
        
        _scrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, 700);
        
    }
    
    [self getData];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [MyTabBarController setTabBarHidden:YES];

}
-(void)getData{
    
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *msg = [FRNetPoolUtils getQRCodeForChild];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (![Utilities isConnected]) {//2015.06.30
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
               
            }
            
            if (msg ==  nil) {
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];

                
            }else{
                
                [self GenerateQRCodeImg:msg];
                _secretKeyLabel.text = [NSString stringWithFormat:@"绑定码：%@",msg];
            }
        });
    });

}

-(void)GenerateQRCodeImg:(NSString*)str{
    
    /*字符转二维码
     导入 libqrencode文件
     引入头文件#import "QRCodeGenerator.h" 即可使用
     */
    _imageview.image = [QRCodeGenerator qrImageForString:str imageSize:_imageview.bounds.size.width];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)ViewBindCondition:(id)sender {
    
    ParenthoodListForChildTableViewController *listV = [[ParenthoodListForChildTableViewController alloc]init];
    [self.navigationController pushViewController:listV animated:YES];
    
}


@end
