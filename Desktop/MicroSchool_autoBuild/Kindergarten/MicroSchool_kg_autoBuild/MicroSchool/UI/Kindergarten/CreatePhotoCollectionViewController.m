//
//  CreatePhotoCollectionViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/5.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "CreatePhotoCollectionViewController.h"
#import "Toast+UIView.h"

@interface CreatePhotoCollectionViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation CreatePhotoCollectionViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"新建相册"];
    [self setCustomizeRightButtonWithName:@"保存"];
    
    text_title = [[UITextField alloc]initWithFrame:CGRectMake(15, 0, 310, 44.0)];
    text_title.borderStyle = UITextBorderStyleNone;
    text_title.backgroundColor = [UIColor clearColor];
    text_title.placeholder = @"输入相册名称";
    text_title.font = [UIFont systemFontOfSize:15.0f];
    text_title.textColor = [UIColor blackColor];
    text_title.clearButtonMode = UITextFieldViewModeNever;
    text_title.textAlignment = NSTextAlignmentLeft;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.returnKeyType =UIReturnKeyDone;
    text_title.delegate = self;
    text_title.tag = 111;
    [text_title becomeFirstResponder];
    //[text_title performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.006];
    
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:text_title];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)selectRightAction:(id)sender{
    
    [text_title resignFirstResponder];
    
    if (text_title.text == nil || [text_title.text isEqualToString:@""]) {
        
        [self.view makeToast:@"请输入相册名字" duration:0.5 position:@"center"];
        
    }else{
        
        [Utilities showProcessingHud:self.view];
        [self getData];
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    
    NSInteger limit = 10;// 新建相册名字最长输入10个 经纬确认
    
    UITextField *textField = (UITextField *)obj.object;
    
    NSString *toBeString = textField.text;
    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    if ([lang isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > limit) {
                textField.text = [toBeString substringToIndex:limit];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > limit) {
            textField.text = [toBeString substringToIndex:limit];
        }
    }
}

-(void)getData{
    
    /**
     * 班级新建相册
     * @author luke
     * @date 2016.03.14
     * @args
     *  v=3 ac=Kindergarten op=addClassAlbum sid= cid= uid= app= title=相册名称
     */
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Kindergarten",@"ac",
                          @"3",@"v",
                          @"addClassAlbum", @"op",
                          _cid,@"cid",
                          text_title.text,@"title",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
    
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            
            if ([@"chooseAlbum" isEqualToString:_fromName]) {
                
                if (_isSelectPhoto == 1) {
                    
                    NSString *title = text_title.text;
                    NSString *aid = [NSString stringWithFormat:@"%@",[respDic objectForKey:@"message"]];
                    
                    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:title,@"title",aid,@"aid",nil];
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ChangePhotoAlbum" object:nil userInfo:dic];
                    
                }
                
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoAlbum" object:nil];
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
                [Utilities showSuccessedHud:@"新建成功" descView:self.view];
                if (_isSelectPhoto == 1) {
                    
                     [self.navigationController popToViewController:[self.navigationController.viewControllers objectAtIndex:[self.navigationController.viewControllers count]-3] animated:YES];
                    
                }else{
                   [self.navigationController popViewControllerAnimated:YES];
                }
               
                
                
            }else{
               
                [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
                [Utilities showSuccessedHud:@"新建成功" descView:self.view];
                [self.navigationController popViewControllerAnimated:YES];
            }
           
           
            
        }else{
            
            [Utilities showFailedHud:@"新建失败" descView:self.view];
        }

    
    
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
            
            [Utilities dismissProcessingHud:self.view];
            [Utilities doHandleTSNetworkingErr:error descView:self.view];
            
        
    }];
    

    
}

#pragma mark - UITableViewDataSource,UITableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //这个方法告诉表格第section个分组有多少行
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryNone;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.textLabel.font = [UIFont systemFontOfSize:15.0];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    if (![cell viewWithTag:111]) {
        [cell addSubview:text_title];
    }
    
    return cell;
}

@end
