//
//  InfoCenterForInspectorViewController.m
//  MicroSchool
//
//  Created by Kate on 14-10-22.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "InfoCenterForInspectorViewController.h"
#import "FRNetPoolUtils.h"
#import "SetPersonalInfoTableViewCell.h"
#import "enterNewProfileViewController.h"
#import "SettingSpacenoteViewController.h"

@interface InfoCenterForInspectorViewController ()

@end

@implementation InfoCenterForInspectorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"督学资料"];
    [super setCustomizeLeftButton];
    
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    
    infoDic =[[NSMutableDictionary alloc] init];
    
    
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    /*
     params.put("ac", ac);
     params.put("op", op);
     params.put("sid", sid);
     params.put("width", SplashScreenActivity.taskWidth + "");
     params.put("uid", String.valueOf(uid));
     Fantasy~NONE  16:41:42
     String ac = "Eduinspector";
     String op = "profile";
     String sid = MainConfig.sid;
     */
    
    //    NSString *width = [NSString stringWithFormat:@"%f",[UIScreen mainScreen].bounds.size.width];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Eduinspector", @"ac",
                          @"profile", @"op",
                          @"290",@"width",
                          _insUid, @"uid",
                          nil];
    
    [network sendHttpReq:HttpReq_EduinspectorProfile andData:data];
    
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,[UIScreen mainScreen].applicationFrame.size.width,[UIScreen mainScreen].applicationFrame.size.height)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(
                                                              0,
                                                              0,
                                                              [UIScreen mainScreen].applicationFrame.size.width,
                                                              [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.backgroundView = nil;
    
    [self.view addSubview:_tableView];
    
    imagePath = @"";
}

-(void)viewWillAppear:(BOOL)animated
{
    
    NSMutableDictionary *tempDic = [[NSUserDefaults standardUserDefaults]objectForKey:@"infoForInspector"];
    settingPersonalInfo = [[NSMutableDictionary alloc]initWithDictionary:tempDic copyItems:YES];
    [_tableView reloadData];
}

-(void)selectLeftAction:(id)sender{
    
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)reload{
    
    [_tableView reloadData];
}

#pragma UITableViewDelegate,UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (0 == section) {
        return 4;
    }
    if (1 == section) {
        return 3;
    }
    return 0;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        return 90;
    }
    
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    static NSString *GroupedTableIdentifier1 = @"GroupedTableIdentifier1";
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        
        SetPersonalInfoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier1];
        if(cell == nil) {
            cell = [[SetPersonalInfoTableViewCell alloc]
                    initWithStyle:UITableViewCellStyleDefault
                    reuseIdentifier:GroupedTableIdentifier1];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        //NSMutableDictionary *user = [g_userInfo getUserDetailInfo];
        NSString *avatar = [settingPersonalInfo objectForKey:@"photo"];;
        
        cell.name = @"设置照片";
        if (nil == image_head)
        {
            [cell.imgView_thumb sd_setImageWithURL:[NSURL URLWithString:avatar] placeholderImage:[UIImage imageNamed:@"loading_gray.png"]];
        }
        else
        {
            [cell.imgView_thumb setImage:image_head];
        }
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc]
                    initWithStyle:UITableViewCellStyleValue1
                    reuseIdentifier:GroupedTableIdentifier];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        }
        
        cell.textLabel.font = [UIFont systemFontOfSize:17.0];
         cell.detailTextLabel.font = [UIFont systemFontOfSize:17.0];
        
        if (0 == [indexPath section] && 0 == [indexPath row]) {
        }else if (0 == [indexPath section] && 1 == [indexPath row]){
            cell.textLabel.text = @"真实姓名";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"name"];
            cell.accessoryType = UITableViewCellAccessoryNone;
        }else if (0 == [indexPath section] && 2 == [indexPath row]){
            cell.textLabel.text = @"电话";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"tel"];
            
        }else if (0 == [indexPath section] && 3 == [indexPath row]){
            cell.textLabel.text = @"邮箱";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"email"];
            //cell.accessoryType = UITableViewCellAccessoryNone;//2015.09.14
            
        }else if (1 == [indexPath section] && 0 == [indexPath row]){
            
            cell.textLabel.text = @"职务";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"job"];
            
        }else if (1 == [indexPath section] && 1 == [indexPath row]){
            
            cell.textLabel.text = @"单位";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"company"];
            
        }else if (1 == [indexPath section] && 2 == [indexPath row]){
            
            cell.textLabel.text = @"基本职责";
            cell.detailTextLabel.text = [settingPersonalInfo objectForKey:@"duty"];
        }
        else{
            return nil;
        }
        
        return cell;
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (0 == [indexPath section] && 0 == [indexPath row]) {
        UIActionSheet *myActionSheet = [[UIActionSheet alloc]
                                        initWithTitle:nil
                                        delegate:self
                                        cancelButtonTitle:@"取消"
                                        destructiveButtonTitle:nil
                                        otherButtonTitles: @"从相册选择", @"拍照",nil];
        [myActionSheet showInView:self.view];
    }else if (0 == [indexPath section] && 1 == [indexPath row]) {
        
        [Utilities showAlert:@"提示" message:@"请在个人中心设置真实姓名" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }else if (0 == [indexPath section] && 2 == [indexPath row]) {
        
        enterNewProfileViewController *profile = [[enterNewProfileViewController alloc]init];
        profile.fromName = @"tel";
        [self.navigationController pushViewController:profile animated:YES];
        
    }else if (0 == [indexPath section] && 3 == [indexPath row]) {
        
        //[Utilities showAlert:@"提示" message:@"如需修改，请登录官网" cancelButtonTitle:@"确定" otherButtonTitle:nil];
        enterNewProfileViewController *profile = [[enterNewProfileViewController alloc]init];
        profile.fromName = @"email";
        [self.navigationController pushViewController:profile animated:YES];
        
    }else if (1 == [indexPath section] && 0 == [indexPath row]) {
        
        enterNewProfileViewController *profile = [[enterNewProfileViewController alloc]init];
        profile.fromName = @"job";
        [self.navigationController pushViewController:profile animated:YES];
        
    }else if (1 == [indexPath section] && 1 == [indexPath row]) {
        
        enterNewProfileViewController *profile = [[enterNewProfileViewController alloc]init];
        profile.fromName = @"company";
        [self.navigationController pushViewController:profile animated:YES];
        
    }else if (1 == [indexPath section] && 2 == [indexPath row]) {
        
        SettingSpacenoteViewController *spacenoteViewCtrl = [[SettingSpacenoteViewController alloc] init];
        spacenoteViewCtrl.fromName = @"dutyForInspector";
        [self.navigationController pushViewController:spacenoteViewCtrl animated:YES];
        
    }
    
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    
    [Utilities dismissProcessingHud:self.view];//2015.05.12
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    NSString *msg = [resultJSON objectForKey:@"message"];
    
    if(true == [result intValue])
    {
        infoDic = [resultJSON objectForKey:@"message"];
        [self saveToSettingPersonalInfo];
    }
    else
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:msg
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
    
}

-(void)reciveHttpDataError:(NSError*)err
{
    
    [Utilities dismissProcessingHud:self.view];// 2015.05.12
    UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                   message:@"网络连接错误，请稍候再试"
                                                  delegate:nil
                                         cancelButtonTitle:@"确定"
                                         otherButtonTitles:nil];
    [alert show];
    
}

-(void)saveToSettingPersonalInfo{
    
    //settingPersonalInfo = infoDic;
    settingPersonalInfo = [[NSMutableDictionary alloc]initWithObjectsAndKeys:[infoDic objectForKey:@"duty"],@"duty",[infoDic objectForKey:@"job"],@"job",[infoDic objectForKey:@"tel"],@"tel",[infoDic objectForKey:@"company"],@"company",[infoDic objectForKey:@"name"],@"name",[infoDic objectForKey:@"email"],@"email",[infoDic objectForKey:@"photo"],@"photo", nil];
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setObject:settingPersonalInfo forKey:@"infoForInspector"];
    [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
}

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            // 从相册选择
            [self LocalPhoto];
            break;
        case 1:
            // 拍照
            //[self takePhoto];
            [Utilities takePhotoFromViewController:self];//update by kate 2014.04.17
            break;
        default:
            break;
    }
}

//从相册选择
-(void)LocalPhoto{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    // 资源类型为图片库
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.delegate = self;
    // 设置选择后的图片可被编辑
    picker.allowsEditing = YES;
    
    [self presentViewController:picker animated:YES completion:nil];
}

//拍照
-(void)takePhoto{
    // 资源类型为照相机
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    // 判断是否有相机
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        // 设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        // 资源类型为照相机
        picker.sourceType = sourceType;
        [self presentViewController:picker animated:YES completion:nil];
    }else {
        NSLog(@"该设备无摄像头");
    }
}

#pragma Delegate method UIImagePickerControllerDelegate
// 图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    // 当图片不为空时显示图片并保存图片
    if (image != nil) {
        image_head_pre = image;
        image_head = image;
        
        // 获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        // 指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        // 创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        // 保存图片的路径
        self->imagePath = [imageDocPath stringByAppendingPathComponent:@"imageForInspector.png"];
        
        // 以下是保存文件到沙盒路径下
        // 把图片转成NSData类型的数据来保存文件
        NSData *data;
        // 判断图片是不是png格式的文件
        //        if (UIImagePNGRepresentation(image)) {
        //            // 返回为png图像。
        //            data = UIImagePNGRepresentation(image);
        //        }else {
        //            // 返回为JPEG图像。
        data = UIImageJPEGRepresentation(image, 0.3);
        //        }
        // 保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath contents:data attributes:nil];
        
        [self doUpdateAvatar];
    }
    // 关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
}

-(void)doUpdateAvatar
{
    [Utilities showProcessingHud:self.view];// 2015.05.12
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *phone = @"";
        NSString *job = @"";
        NSString *company = @"";
        NSString *duty = @"";
        NSString *photo = imagePath;
        NSString *email = @"";
        
        // 个人信息保存接口
        NSString *msg = [FRNetPoolUtils updateProfile:phone job:job company:company duty:duty photoPath:photo email:email];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [Utilities dismissProcessingHud:self.view];// 2015.05.12
            
            if (msg!=nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                [_tableView reloadData];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshEduinspectorInfo" object:nil];
                //[self.navigationController popViewControllerAnimated:YES];//Bug 2219 春晖提出
                
                [ReportObject event:ID_SET_EDU_PERSON];//2015.06.25
            }
            
        });
    });
}

// 修改从UIImagePickerController 返回后statusbar消失问题
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated {
    
    if ([navigationController isKindOfClass:[UIImagePickerController class]] &&
        ((UIImagePickerController *)navigationController).sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:NO];
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
