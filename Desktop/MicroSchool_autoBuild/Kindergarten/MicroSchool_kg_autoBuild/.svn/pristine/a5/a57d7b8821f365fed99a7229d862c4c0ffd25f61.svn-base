//
//  NoSignedViewController.m
//  MicroSchool
//
//  Created by Kate on 16/8/29.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "NoSignedViewController.h"
#import "MyTabBarController.h"

@interface NoSignedViewController ()
@property (weak, nonatomic) IBOutlet UITextView *titleTextV;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
- (IBAction)bindAction:(id)sender;

@end

@implementation NoSignedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [super setCustomizeTitle:_titleName];
    [super setCustomizeLeftButton];
    _titleTextV.text = @"您还没有绑定签到卡，\n请输入卡面上的卡号进行绑定";
    [_bindBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_d.png"] forState:UIControlStateNormal] ;
    [_bindBtn setBackgroundImage:[UIImage imageNamed:@"btn_common_1_p.png"] forState:UIControlStateHighlighted] ;
    _tableView.backgroundColor = [UIColor redColor];
    _tableView.scrollEnabled = NO;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark Table Data Source Methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    _textFieldOri =[UITextField new];//update by kate 2015.02.28
    _textFieldOri.clearsOnBeginEditing = NO;//鼠标点上时，不清空
    _textFieldOri.borderStyle = UITextBorderStyleNone;
    _textFieldOri.backgroundColor = [UIColor clearColor];
    _textFieldOri.placeholder = @"输入签到卡卡号";
    _textFieldOri.font = [UIFont systemFontOfSize:16.0f];
    _textFieldOri.textColor = [UIColor blackColor];
    _textFieldOri.textAlignment = NSTextAlignmentLeft;
    _textFieldOri.keyboardType= UIKeyboardTypeDefault;
    _textFieldOri.returnKeyType = UIReturnKeyDone;//update 2015.04.13
    _textFieldOri.autocorrectionType = UITextAutocorrectionTypeNo;
    _textFieldOri.tintColor = [UIColor colorWithRed:18.0/255.0 green:65.0/255.0 blue:249.0/255.0 alpha:1];//add by kate 2015.02.28
    _textFieldOri.autocapitalizationType = UITextAutocapitalizationTypeNone;//add 2015.04.13
    [_textFieldOri setDelegate: self];
    //[_textFieldOri performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.01];
    [cell.contentView addSubview: _textFieldOri];
    [_textFieldOri mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView.mas_top).with.offset(0);
        make.left.equalTo(cell.contentView.mas_left).with.offset(20);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 40.0,45));
    }];
    return cell;
    
}

/**
 * 绑定学生打卡纪录
 * @author luke
 * @date 2016.08.29
 * @args
 * v=3 ac=KindergartenCheckin op=bindCard2Number sid= cid= uid= number=学生ID card=卡片ID
 */
- (IBAction)bindAction:(id)sender {
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    [MyTabBarController setTabBarHidden:YES];
}

@end
