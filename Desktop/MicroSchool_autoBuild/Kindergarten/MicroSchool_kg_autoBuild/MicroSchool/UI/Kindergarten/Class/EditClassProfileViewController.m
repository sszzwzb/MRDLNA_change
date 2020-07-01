//
//  EditClassProfileViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/3/16.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "EditClassProfileViewController.h"
#import "FRNetPoolUtils.h"
#import "EditClassIntroViewController.h"
#import "SettingNameViewController.h"
#import "ImageResourceLoader.h"
#import "UIImageView+WebCache.h"
#import "MyTabBarController.h"

@interface EditClassProfileViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation EditClassProfileViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self setCustomizeTitle:@"编辑资料"];
    [self setCustomizeLeftButton];
    
    [MyTabBarController setTabBarHidden:YES];
    
    dic = [[NSDictionary alloc] init];
    
    headImgV = [[UIImageView alloc] initWithFrame:CGRectMake([UIScreen mainScreen].bounds.size.width - 30.0 - 50.0, (75.0-50.0)/2.0, 50.0, 50.0)];
    
    if (!setHeadImg) {
        [self getData];
    }
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshMyClassInfo"
                                               object:nil];
    
    [ReportObject event:ID_SET_MY_CLASS_ACCOUNT];//2015.06.24
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)refreshView{
    
    [self getData];
}

-(void)reload{
    
    [_tableView reloadData];
}

// 获取数据从服务器 更新画面
-(void)getData{
    
    // 调用加入方式保存接口
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"Class",@"ac",
                          @"2",@"v",
                          @"getClassSetting", @"op",
                          _cId,@"cid",
                          nil];
    
    [[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
        
        [Utilities dismissProcessingHud:self.view];
        NSDictionary *respDic = (NSDictionary*)responseObject;
        NSString *result = [respDic objectForKey:@"result"];
        
        if ([result integerValue] == 1) {
            
            NSDictionary *tempDic = [respDic objectForKey:@"message"];
            dic = [NSDictionary dictionaryWithDictionary:tempDic];
            
            [self performSelectorOnMainThread:@selector(reload) withObject:nil waitUntilDone:YES];
            
        }else{
            
        }
        
        
    } failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
        
        [Utilities dismissProcessingHud:self.view];
        [Utilities doHandleTSNetworkingErr:error descView:self.view];
        
    }];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *GroupedTableIdentifier = @"GroupedTableIdentifier";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:GroupedTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                initWithStyle:UITableViewCellStyleValue1
                reuseIdentifier:GroupedTableIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    // Configure the cell...
    NSString *className = [dic objectForKey:@"tagname"];//班级名称
    introStr = [dic objectForKey:@"note"];
    NSString *head_url = [dic objectForKey:@"pic"];
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"班级Logo";
            [cell addSubview:headImgV];
            [headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
            
        }else if (indexPath.row == 1){
            
            cell.textLabel.text = @"班级名称";
            cell.detailTextLabel.text = className;
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            cell.textLabel.text = @"班级简介";
            cell.detailTextLabel.text = introStr;
        }
    }
    
    cell.detailTextLabel.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:16.0];
    cell.textLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:16.0];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
     [tableView deselectRowAtIndexPath:indexPath animated:YES];//选中后的反显颜色即刻消失
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            [self selectPicConfirm];
            
        }else if (indexPath.row == 1){
            
            [self gotoClassName:nil];
        }
        
    }else if (indexPath.section == 1){
        
        if (indexPath.row == 0) {
            
            [self editIntro:nil];
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger rowHeight = 44.0;
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == 0) {
            
            rowHeight = 75.0;
        }
    }else if(indexPath.section == 1){
        
        rowHeight = 75.0;
    }
    
    return rowHeight;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    if (section == 0) {
        return 20.0;
    }else{
        return 5.0;
    }
    
}

- (void)selectPicConfirm
{
    UIActionSheet * sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
    //[sheet release];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (0 == buttonIndex) {
        [self actionUseCamera];
    } else if (1 == buttonIndex) {
        [self actionOpenPhotoLibrary];
    }
}

// 打开照相机
- (void)actionUseCamera
{
    if (nil == imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
    }
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
        NSLog(@"打开照相机");
    }];
}

// 打开相册
- (void)actionOpenPhotoLibrary
{
    if (nil == imagePickerController) {
        imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.delegate = self;
    }
    
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    [self presentViewController:imagePickerController animated:YES completion:^{
        NSLog(@"打开相册");
    }];
}

//班级名称
- (void)gotoClassName:(id)sender {
    
    SettingNameViewController *setNameV = [[SettingNameViewController alloc] init];
    setNameV.fromName = @"className";
    setNameV.cid = _cId;
    setNameV.className = [dic objectForKey:@"tagname"];
    [self.navigationController pushViewController:setNameV animated:YES];
    
}


// 去班级简介页
- (void)editIntro:(id)sender {
    
    setHeadImg = NO;
    EditClassIntroViewController *editCV = [[EditClassIntroViewController alloc]init];
    editCV.introStr = introStr;
    editCV.cId = _cId;
    [self.navigationController pushViewController:editCV animated:YES];
    
}

// 设置头像接口
-(void)setClassAvatar{
    // 调用加入方式保存接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSString *msg = [FRNetPoolUtils setClassAvatar:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (msg != nil) {
                
                [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                //[self.navigationController popViewControllerAnimated:YES];
            }
        });
    });
 
}


- (void)showImagePickerForSourceType:(UIImagePickerControllerSourceType)sourceType
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.modalPresentationStyle = UIModalPresentationCurrentContext;
    imagePickerController.allowsEditing = YES;
    imagePickerController.sourceType = sourceType;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    setHeadImg = YES;
    
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    image = [ImageResourceLoader CompressImage:image withHeight:160.0 withWidth:160.0];
    headImgV.image = image;
   
    [Utilities saveImage:image withName:@"tempImgForClass.png"];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self setClassAvatar];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


@end
