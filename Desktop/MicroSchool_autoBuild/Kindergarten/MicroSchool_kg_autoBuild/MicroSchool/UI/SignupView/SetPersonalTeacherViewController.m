//
//  SetPersonalTeacherViewController.m
//  MicroSchool
//
//  Created by jojo on 14-1-11.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "SetPersonalTeacherViewController.h"

@interface SetPersonalTeacherViewController ()

@end

@implementation SetPersonalTeacherViewController

@synthesize reason;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        network = [NetworkUtility alloc];
        network.delegate = self;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [super setCustomizeTitle:@"完善个人信息"];
    
    personalInfo = [g_userInfo getUserPersonalInfo];
    
    [personalInfo setObject:@"" forKey:@"idNumber"];
    [personalInfo setObject:@"" forKey:@"reason"];
    
    [g_userInfo setUserPersonalInfo:personalInfo];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender
{
    // 取消所有的网络请求
    [network cancelCurrentRequest];
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super hideLeftAndRightLine];
    [super setCustomizeLeftButton];
    
    if (nil == photo) {
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    } else {
        [button_photoMask setBackgroundImage:photo forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:photo forState:UIControlStateHighlighted] ;
        
    }
    
    [tableViewIns reloadData];
}

- (void)loadView
{
    UIView *view = [ [ UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame] ;
    self.view = view;
    
    // 背景图片
    UIImageView *imgView_bgImg =[[UIImageView alloc]initWithFrame:CGRectMake(0,0,WIDTH,548)];
    [imgView_bgImg setBackgroundColor:[[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0]];
    [self.view addSubview:imgView_bgImg];
    
    
    _scrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, WIDTH , [UIScreen mainScreen].applicationFrame.size.height - 44)];
    _scrollerView.contentSize = CGSizeMake(WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44);
    _scrollerView.scrollEnabled = YES;
    _scrollerView.delegate = self;
    _scrollerView.bounces = YES;
    _scrollerView.alwaysBounceHorizontal = NO;
    _scrollerView.alwaysBounceVertical = YES;
    _scrollerView.directionalLockEnabled = YES;
    [self.view addSubview:_scrollerView];
    
    // 理由
    UILabel *label = [[UILabel alloc] init];
    NSString *reasonStr = [NSString stringWithFormat:@"拒绝理由：%@", reason];
    label.text = reasonStr;
    [label setNumberOfLines:0];
    label.font = [UIFont systemFontOfSize:13.0f];
    label.textColor = [UIColor blackColor];
    label.backgroundColor = [UIColor clearColor];
    CGSize constraint = CGSizeMake(300, 20000.0f);
    CGSize size = [reasonStr sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    [label setFrame:CGRectMake(10, 30, size.width, size.height)];
    [_scrollerView addSubview:label];
    
    // tableview
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(
                                                                0,
                                                                label.frame.origin.y + label.frame.size.height,
                                                                WIDTH,
                                                                120)
                                               style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    [_scrollerView addSubview:tableViewIns];
    
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    
    // 默认状态图片
    UIImage *image_d = [UIImage imageNamed:@"bg_task_photo.png"];
    image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 添加附件图片背景
    imgView_bg_photo =[[UIImageView alloc]initWithFrame:CGRectMake(10,
                                                                   tableViewIns.frame.origin.y + tableViewIns.frame.size.height + 5,
                                                                   300,
                                                                   120)];
    
    imgView_bg_photo.image = image_d;
    [_scrollerView addSubview:imgView_bg_photo];
    
    button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    button_photoMask.frame = CGRectMake(imgView_bg_photo.frame.origin.x + 185,
                                        imgView_bg_photo.frame.origin.y + 15,
                                        90,
                                        90);
    button_photoMask.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_photoMask.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button_photoMask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_photoMask setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_photoMask.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    if (nil == photo) {
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    } else {
        [button_photoMask setBackgroundImage:photo forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:photo forState:UIControlStateHighlighted] ;
        
    }
    
    [button_photoMask setBackgroundColor:[UIColor clearColor]];
    
    [button_photoMask addTarget:self action:@selector(addPhoto_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [_scrollerView addSubview:button_photoMask];
    
    label_photo = [[UILabel alloc] initWithFrame:CGRectMake(imgView_bg_photo.frame.origin.x + 15,
                                                            imgView_bg_photo.frame.origin.y + (120-20)/2, 160, 20)];
    
    label_photo.lineBreakMode = NSLineBreakByWordWrapping;
    label_photo.text = @"上传有效证件(可选)";
    label_photo.font = [UIFont systemFontOfSize:16.0f];
    label_photo.numberOfLines = 0;
    label_photo.textColor = [UIColor blackColor];
    label_photo.backgroundColor = [UIColor clearColor];
    label_photo.lineBreakMode = NSLineBreakByTruncatingTail;
    [_scrollerView addSubview:label_photo];
    
    // 确定button
    button_create = [UIButton buttonWithType:UIButtonTypeCustom];
    button_create.frame = CGRectMake(20,
                                     imgView_bg_photo.frame.origin.y+imgView_bg_photo.frame.size.height+10,
                                     280, 40);
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    //button.backgroundColor = [UIColor clearColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_create addTarget:self action:@selector(createNext_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"下一步" forState:UIControlStateNormal];
    [button_create setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [_scrollerView addSubview:button_create];
    
    _scrollerView.contentSize = CGSizeMake(WIDTH,
                                           label.frame.size.height + tableViewIns.frame.size.height + imgView_bg_photo.frame.size.height + button_create.frame.size.height + 64);
    
    
    
    
#if 0
    tableViewIns = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, [UIScreen mainScreen].applicationFrame.size.height - 44) style:UITableViewStyleGrouped];
    tableViewIns.delegate = self;
    tableViewIns.dataSource = self;
    tableViewIns.backgroundColor = [UIColor clearColor];
    tableViewIns.backgroundView = nil;
    [tableViewIns setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    //    UIImageView *imgView = [[UIImageView alloc]initWithFrame:(CGRectMake(0, 0, 320, 50))];
    //    imgView.image = [UIImage imageNamed:@"bg_tableViewCell"];
    //    tableViewIns.backgroundView = imgView;
    
    [self.view addSubview:tableViewIns];
    
    CGFloat top = 10; // 顶端盖高度
    CGFloat bottom = 10; // 底端盖高度
    CGFloat left = 10; // 左端盖宽度
    CGFloat right = 10; // 右端盖宽度
    
    UIEdgeInsets insets = UIEdgeInsetsMake(top, left, bottom, right);
    
    // 指定为拉伸模式，伸缩后重新赋值
    
    // 默认状态图片
    UIImage *image_d = [UIImage imageNamed:@"bg_task_photo.png"];
    image_d = [image_d resizableImageWithCapInsets:insets resizingMode:UIImageResizingModeStretch];
    
    // 添加附件图片背景
    imgView_bg_photo =[[UIImageView alloc]initWithFrame:CGRectMake(10,
                                                                   180,
                                                                   300,
                                                                   120)];
    
    imgView_bg_photo.image = image_d;
    [tableViewIns addSubview:imgView_bg_photo];
    
    button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    button_photoMask.frame = CGRectMake(imgView_bg_photo.frame.origin.x + 185,
                                        imgView_bg_photo.frame.origin.y + 15,
                                        90,
                                        90);
    button_photoMask.titleLabel.textAlignment = NSTextAlignmentCenter;
    button_photoMask.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [button_photoMask setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_photoMask setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_photoMask.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    if (nil == photo) {
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo.png"] forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:[UIImage imageNamed:@"icon_add_photo_p.png"] forState:UIControlStateHighlighted] ;
    } else {
        [button_photoMask setBackgroundImage:photo forState:UIControlStateNormal] ;
        [button_photoMask setBackgroundImage:photo forState:UIControlStateHighlighted] ;
        
    }
    
    [button_photoMask setBackgroundColor:[UIColor clearColor]];
    
    [button_photoMask addTarget:self action:@selector(addPhoto_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    [tableViewIns addSubview:button_photoMask];
    
    label_photo = [[UILabel alloc] initWithFrame:CGRectMake(imgView_bg_photo.frame.origin.x + 15,
                                                            imgView_bg_photo.frame.origin.y + (120-20)/2, 100, 20)];
    
    label_photo.lineBreakMode = NSLineBreakByWordWrapping;
    label_photo.text = @"身份证照片";
    label_photo.font = [UIFont systemFontOfSize:16.0f];
    label_photo.numberOfLines = 0;
    label_photo.textColor = [UIColor blackColor];
    label_photo.backgroundColor = [UIColor clearColor];
    label_photo.lineBreakMode = NSLineBreakByTruncatingTail;
    [tableViewIns addSubview:label_photo];
    
    // 确定button
    button_create = [UIButton buttonWithType:UIButtonTypeCustom];
    button_create.frame = CGRectMake(20,
                                     imgView_bg_photo.frame.origin.y+imgView_bg_photo.frame.size.height+10,
                                     280, 40);
    button_create.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    // 设置title自适应对齐
    button_create.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    // 设置颜色和字体
    [button_create setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button_create setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    button_create.titleLabel.font = [UIFont boldSystemFontOfSize:18.0f];
    
    //button.backgroundColor = [UIColor clearColor];
    
    //UIImage* myImage = [[UIImage alloc]initWithContentsOfFile:[NSString stringWithFormat:@"btn_blue_nor@2x.png"]];
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_2-d.png"] forState:UIControlStateNormal] ;
    [button_create setBackgroundImage:[UIImage imageNamed:@"btn_common_2_p.png"] forState:UIControlStateHighlighted] ;
    
    // 添加 action
    [button_create addTarget:self action:@selector(createNext_btnclick:) forControlEvents: UIControlEventTouchUpInside];
    
    //设置title
    [button_create setTitle:@"下一步" forState:UIControlStateNormal];
    [button_create setTitle:@"下一步" forState:UIControlStateHighlighted];
    
    [tableViewIns addSubview:button_create];
#endif
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

- (IBAction)addPhoto_btnclick:(id)sender
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
        sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = NO;
    picker.sourceType = sourceType;
    [self presentModalViewController:picker animated:YES];
}

- (IBAction)createNext_btnclick:(id)sender
{
#if 0
    if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"idNumber"]].length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                       message:@"身份证号输入为空，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"reason"]].length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                       message:@"申请说明输入为空，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    else
    {
        
        NSDictionary *user = [g_userInfo getUserDetailInfo];
        NSString* uid= [user objectForKey:@"uid"];
        
        if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"idNumber"]].length == 0)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"身份证号输入为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"reason"]].length == 0)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"申请说明输入为空，请重新输入"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }
        else if(nil == self->imagePath1)
        {
            UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                           message:@"请选择身份证照片"
                                                          delegate:nil
                                                 cancelButtonTitle:@"确定"
                                                 otherButtonTitles:nil];
            [alert show];
        }else {
            [Utilities showProcessingHud:self.view];
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Apply", @"ac",
                                  @"2", @"v",
                                  @"teacher", @"op",
                                  [personalInfo objectForKey:@"idNumber"], @"idnumber",
                                  [personalInfo objectForKey:@"reason"], @"description",
                                  self->imagePath1, @"idfile",
                                  nil];
            
            [network sendHttpReq:HttpReq_RegisterPersonalTea andData:data];
        }
    }
#endif
    if([NSString stringWithFormat:@"%@", [personalInfo objectForKey:@"reason"]].length == 0)
    {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"输入错误"
                                                       message:@"申请说明输入为空，请重新输入"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }else {
        [Utilities showProcessingHud:self.view];
        
        if (nil == self->imagePath1) {
            self->imagePath1 = @"";
        }
        
        NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                              REQ_URL, @"url",
                              @"Apply", @"ac",
                              @"2", @"v",
                              @"teacher", @"op",
                              [personalInfo objectForKey:@"idNumber"], @"idnumber",
                              [personalInfo objectForKey:@"reason"], @"description",
                              self->imagePath1, @"idfile",
                              nil];
        
        [network sendHttpReq:HttpReq_RegisterPersonalTea andData:data];
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GET_PROFILE object:nil];
}

#pragma Delegate method UIImagePickerControllerDelegate
//图像选取器的委托方法，选完图片后回调该方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    
    //当图片不为空时显示图片并保存图片
    if (image != nil) {
        //        image_head_pre = image;
        UIImage *scaledImage;
        UIImage *updateImage;
        
        //        CGSize imageSize = image.size;
        
        // 如果宽度超过800，则按照比例进行缩放，把宽度固定在800
        if (image.size.width >= 800) {
            float scaleRate = 800/image.size.width;
            
            float w = 800;
            float h = image.size.height * scaleRate;
            
            scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
        }
        
        if (scaledImage != Nil) {
            updateImage = scaledImage;
        } else {
            updateImage = image;
        }
        
        //        CGSize imageSize1 = updateImage.size;
        
        photo = updateImage;
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateNormal] ;
        //        [button_photoMask setBackgroundImage:image forState:UIControlStateHighlighted] ;
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"ImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        //保存图片的路径
        self->imagePath1 = [imageDocPath stringByAppendingPathComponent:@"image.png"];
        
        //以下是保存文件到沙盒路径下
        //把图片转成NSData类型的数据来保存文件
        NSData *data;
        //判断图片是不是png格式的文件
        //        if (UIImagePNGRepresentation(updateImage)) {
        //            //返回为png图像。
        //            data = UIImagePNGRepresentation(updateImage);
        //        }else {
        //返回为JPEG图像。
        data = UIImageJPEGRepresentation(updateImage, 0.3);
        //        }
        //保存
        [[NSFileManager defaultManager] createFileAtPath:self->imagePath1 contents:data attributes:nil];
        
        //        [self doUpdateAvatar];
    }
    //关闭相册界面
    [picker dismissModalViewControllerAnimated:YES];
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

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //指定行的高度
    return 50;
}

//- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
//{
//    NSString *reasonStr;
//    if (nil != reason) {
//        reasonStr = [NSString stringWithFormat:@"拒绝理由：%@", reason];
//    } else {
//        reasonStr = @"拒绝理由：";
//    }
//    return reasonStr;
//}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
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
    if (0 == [indexPath section] && 0 == [indexPath row]){
        cell.textLabel.text = @"申请说明(必填)";
        cell.detailTextLabel.text = [personalInfo objectForKey:@"reason"];
    }    else{
        return nil;
    }
    
    //设置textLabel的背景色为空
    cell.textLabel.backgroundColor = [UIColor clearColor];
    
    return cell;
}

//选中Cell响应事件
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if(0 == [indexPath section] && 0 == [indexPath row]){
        ReasonViewController *reasonViewCtrl = [[ReasonViewController alloc] init];
        [self.navigationController pushViewController:reasonViewCtrl animated:YES];
    }
}

#if 9
#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    [Utilities dismissProcessingHud:self.view];
    
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    NSString* message_info = [resultJSON objectForKey:@"message"];
    
    if(true == [result intValue])
    {
        //NSDictionary* message_info = [resultJSON objectForKey:@"message"];
        
        // 客户端先改变checked的值，以便马上在主menu中显示变化
        NSMutableDictionary *userDetailInfo = [g_userInfo getUserDetailInfo];
        [userDetailInfo setObject:@"0" forKey:@"role_checked"];
        [g_userInfo setUserDetailInfo:userDetailInfo];
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
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
#endif

@end
