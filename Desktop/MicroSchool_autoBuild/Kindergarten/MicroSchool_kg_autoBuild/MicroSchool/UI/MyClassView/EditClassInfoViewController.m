//
//  EditClassInfoViewController.m
//  MicroSchool
//
//  Created by Kate on 14-9-20.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "EditClassInfoViewController.h"
#import "EditClassIntroViewController.h"
#import "AddWayViewController.h"
#import "FRNetPoolUtils.h"
#import "Utilities.h"
#import "ImageResourceLoader.h"
#import "UIImageView+WebCache.h"
#import "ClassFilterViewController.h"
#import "SettingNameViewController.h"
#import "MyTabBarController.h"

@interface EditClassInfoViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *headImgV;
@property (strong, nonatomic) IBOutlet UILabel *addWayLabel;
@property (strong, nonatomic) IBOutlet UILabel *introLabel;
- (IBAction)editHeadImg:(id)sender;
- (IBAction)editAddWay:(id)sender;
- (IBAction)editIntro:(id)sender;
@property (strong, nonatomic) IBOutlet UILabel *logoTitleLabel;
@property (strong, nonatomic) IBOutlet UILabel *classInfoLabel;
@property (strong, nonatomic) IBOutlet UILabel *classNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *yeargradeLabel;
@property (strong, nonatomic) IBOutlet UILabel *classTypeLabel;
- (IBAction)gotoYeargrade:(id)sender;
- (IBAction)gotoClassType:(id)sender;
- (IBAction)gotoClassName:(id)sender;
@property (strong, nonatomic) IBOutlet UIView *yeargradeView;
@property (strong, nonatomic) IBOutlet UIView *baseView;
@property (strong, nonatomic) IBOutlet UIView *apartView;
@property (strong, nonatomic) IBOutlet UILabel *nameLabel;
@property (strong, nonatomic) IBOutlet UILabel *typeLabel;

@end

@implementation EditClassInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [MyTabBarController setTabBarHidden:YES];
    [self setCustomizeLeftButton];
    [self setCustomizeTitle:@"编辑资料"];
    dic = [[NSDictionary alloc] init];
    
    self.view.backgroundColor = [UIColor colorWithRed:239.0/255.0 green:239.0/255.0 blue:244.0/255.0 alpha:1];
    
    
    schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];//add 2015.05.11
    if ([@"bureau" isEqualToString:schoolType]) {//2015.10.29
        _logoTitleLabel.text = @"部门LOGO";
        _classInfoLabel.text = @"部门简介";
        _nameLabel.text = @"部门名称";
        _typeLabel.text = @"部门类型";
    }else{
        _logoTitleLabel.text = @"班级LOGO";
        _classInfoLabel.text = @"班级简介";

    }
    
    /*
     type:学校类型 'university' => '大学', 'senior' => '高中', 'technical' => '中职', 'junior' => '初中',
     'primary' => '小学', 'kindergarten' => '幼儿园', 'training' => '培训', 'other' => '其他', 'bureau'=> '教育局'
     */
    if ([@"primary" isEqualToString:schoolType] || [@"junior" isEqualToString:schoolType] || [@"technical" isEqualToString:schoolType] || [@"senior" isEqualToString:schoolType] || [@"university" isEqualToString:schoolType]) {
        
    }else{
        /*教育局、幼儿园、培训、其他四种学校无【入学年份】选项
         其他学校类型有“入学年份”*/
        [_yeargradeView setHidden:YES];
        _apartView.frame = CGRectMake(0, 131.0, _apartView.frame.size.width, _apartView.frame.size.height);
        _baseView.frame = CGRectMake(0, 35.0, _baseView.frame.size.width, _baseView.frame.size.height - 50.0);
    }
    
    if (!setHeadImg) {
        [self getData];
    }
   
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(refreshView)
                                                 name:@"refreshMyClassInfo"
                                               object:nil];
    
    [ReportObject event:ID_SET_MY_CLASS_ACCOUNT];//2015.06.24

}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
}

-(void)refreshView{
    
    [self getData];
}

// 获取数据从服务器 更新画面
-(void)getData{
    
    // 调用加入方式保存接口
    [Utilities showProcessingHud:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // 调用班级成员接口
        NSDictionary *tempDic = [FRNetPoolUtils getClassSetting:_cId];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [Utilities dismissProcessingHud:self.view];
            
            if (![Utilities isConnected]) {//2015.06.30
                UIView *noNetworkV = [Utilities showNoNetworkView:TEXT_NONETWORK msg2:@"" andRect:self.view.frame];
                [self.view addSubview:noNetworkV];
                
            }

            if(tempDic == nil){
                
                //[Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
                
            }else{
                
                dic = [NSDictionary dictionaryWithDictionary:tempDic];
                
                if ([dic count] > 0) {
                    
                    [self performSelectorOnMainThread:@selector(updateUI) withObject:nil waitUntilDone:YES];
                    
                }else{
                    
                    
                }
            }
            
           
        });
    });
    
}

-(void)updateUI{
    
    NSString *head_url = [dic objectForKey:@"pic"];
    joinPermStr = [dic objectForKey:@"joinperm"];
    introStr = [dic objectForKey:@"note"];
    [_headImgV sd_setImageWithURL:[NSURL URLWithString:head_url] placeholderImage:[UIImage imageNamed:@"icon_class_avatar_defalt.png"]];
    NSString *className = [dic objectForKey:@"tagname"];//班级名称
    NSString *class_year = [NSString stringWithFormat:@"%@",[dic objectForKey:@"class_year"]];//入学年份
    NSString *class_type = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"class_type"] objectForKey:@"value"]];
    
    // perm={0允许任何人加入,1需消息验证,2只可邀请加入}
    if([joinPermStr intValue] == 0){
        _addWayLabel.text = @"允许任何人加入";
        
    }else if ([joinPermStr intValue] == 1){
        _addWayLabel.text = @"需消息验证";

    }else if ([joinPermStr intValue] == 2){
        _addWayLabel.text = @"只可邀请加入";

    }
    
    _introLabel.text = introStr;
    _classNameLabel.text = className;
    _classTypeLabel.text = class_type;
    if ([class_year length] >0) {
        _yeargradeLabel.text = class_year;
    }
    
}

// 返回
-(void)selectLeftAction:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 去编辑头像页
- (IBAction)editHeadImg:(id)sender {

    [self selectPicConfirm];
    
}

- (void)selectPicConfirm
{
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
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


// 去编辑加入方式页
- (IBAction)editAddWay:(id)sender {

    setHeadImg = NO;
    AddWayViewController *addWay = [[AddWayViewController alloc] init];
    addWay.joinPerm = joinPermStr;
    addWay.cId = _cId;
    [self.navigationController pushViewController:addWay animated:YES];
}


// 去班级简介页
- (IBAction)editIntro:(id)sender {
    
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
    _headImgV.image = image;
//    _headImgV.layer.cornerRadius = _headImgV.frame.size.height/2.0;
//    _headImgV.layer.masksToBounds = YES;
    
    [Utilities saveImage:image withName:@"tempImgForClass.png"];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
    [self setClassAvatar];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}
//入学年份
- (IBAction)gotoYeargrade:(id)sender {
   
    ClassFilterViewController *classfilterV = [[ClassFilterViewController alloc] init];
    classfilterV.fromName = @"yeargradeForClass";
    classfilterV.cId = _cId;
    classfilterV.yeargradeForClass = _yeargradeLabel.text;
    [self.navigationController pushViewController:classfilterV animated:YES];
    
}
//班级类型
- (IBAction)gotoClassType:(id)sender {
    
    NSString *classType_key = [NSString stringWithFormat:@"%@",[[dic objectForKey:@"class_type"] objectForKey:@"key"]];
    ClassFilterViewController *classfilterV = [[ClassFilterViewController alloc] init];
    classfilterV.fromName = @"classType";
    classfilterV.cId = _cId;
    classfilterV.classType = classType_key;
    [self.navigationController pushViewController:classfilterV animated:YES];
    
}

//班级名称
- (IBAction)gotoClassName:(id)sender {
    
    SettingNameViewController *setNameV = [[SettingNameViewController alloc] init];
    setNameV.fromName = @"className";
    setNameV.cid = _cId;
    setNameV.className = _classNameLabel.text;
    [self.navigationController pushViewController:setNameV animated:YES];
    
}
@end
