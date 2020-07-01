//
//  PhotoCollectionEditViewController.m
//  MicroSchool
//
//  Created by Kate's macmini on 16/4/6.
//  Copyright © 2016年 jiaminnet. All rights reserved.
//

#import "PhotoCollectionEditViewController.h"
#import "ImageResourceLoader.h"
#import "SelectPhotoFromAlbumViewController.h"
#import "Toast+UIView.h"

@interface PhotoCollectionEditViewController ()

@end

@implementation PhotoCollectionEditViewController

-(void)loadView{
    
    [self doShowContent];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setCustomizeLeftButton];
    [self setCustomizeRightButtonWithName:@"保存"];
    [self setCustomizeTitle:@"编辑相册"];
    
    self.view.backgroundColor = [UIColor colorWithRed:245.0/255.0 green:245.0/255.0 blue:245.0/255.0 alpha:1];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(changeImg:)
                                                 name:@"changeImg"
                                               object:nil];
    
    network = [NetworkUtility alloc];
    network.delegate = self;
    imgPath = nil;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:text_title];
    
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)selectLeftAction:(id)sender{
    
    [network cancelCurrentRequest];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)doShowContent{
    
    UIView *view = [[UIView alloc] initWithFrame:[UIScreen mainScreen].applicationFrame];
    self.view = view;
    
    // 背景图片
    UILabel *nameLabel =[UILabel new];
    nameLabel.text = @"相册名称";
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.view addSubview:nameLabel];
    [nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self.view).with.offset(15);
        make.left.equalTo(self.view).with.offset(10);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-20.0,15.0));
        
    }];
    
    UIImageView *imgView_line = [UIImageView new];
    imgView_line.image = [UIImage imageNamed:@"lineSystem.png"];
    [self.view addSubview:imgView_line];

    [imgView_line mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(nameLabel.mas_bottom).with.offset(10);
      
        make.left.equalTo(nameLabel).with.offset(-10);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
    }];
    
    
    text_title = [UITextField new];
    text_title.delegate = self;
    text_title.returnKeyType = UIReturnKeyDone;
    text_title.keyboardType=UIKeyboardTypeDefault;
    text_title.text = _albumName;
    text_title.font = [UIFont systemFontOfSize:15.0];
    text_title.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    text_title.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:text_title];
    
    [text_title mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.equalTo(imgView_line.mas_bottom).with.offset(0);
        
        make.left.equalTo(imgView_line).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-20.0, 44));
        
    }];
    
    UIView *leftView = [UIView new];
    leftView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:leftView];
    
    [leftView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(imgView_line.mas_bottom).with.offset(0);
        
        make.left.equalTo(imgView_line).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake(10, 44));
        
    }];
    
    UIView *rightView = [UIView new];
    rightView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:rightView];
    
    [rightView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(imgView_line.mas_bottom).with.offset(0);
        
        make.right.equalTo(imgView_line).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake(10, 44));
        
    }];
    
    
    UIImageView *imgView_line2 = [UIImageView new];
    imgView_line2.image = [UIImage imageNamed:@"lineSystem.png"];
    [self.view addSubview:imgView_line2];
    
    [imgView_line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(text_title.mas_bottom).with.offset(0);
        
        make.left.equalTo(text_title).with.offset(-10);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
        
    }];
    
    UILabel *coverLabel = [UILabel new];
    coverLabel.text = @"相册封面";
    coverLabel.font = [UIFont systemFontOfSize:15.0];
    coverLabel.textColor = [UIColor colorWithRed:102.0/255.0 green:102.0/255.0 blue:102.0/255.0 alpha:1];
    [self.view addSubview:coverLabel];
    
    [coverLabel mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(imgView_line2.mas_bottom).with.offset(15);
        
        make.left.equalTo(imgView_line2).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width-20.0, 15));

    }];
    
    UIImageView *imgView_line3 = [UIImageView new];
    imgView_line3.image = [UIImage imageNamed:@"lineSystem.png"];
    [self.view addSubview:imgView_line3];
    
    [imgView_line3 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(coverLabel.mas_bottom).with.offset(10);
        
        make.left.equalTo(coverLabel).with.offset(-10);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
        
    }];
    
    UIView *coverBgView = [UIView new];
    coverBgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:coverBgView];
    
    [coverBgView mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(imgView_line3.mas_bottom).with.offset(0);
        
        make.left.equalTo(imgView_line3).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 169.0+20.0));
        
    }];
    
    UIImageView *imgView_line4 = [UIImageView new];
    imgView_line4.image = [UIImage imageNamed:@"lineSystem.png"];
    [self.view addSubview:imgView_line4];
    
    [imgView_line4 mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(coverBgView.mas_bottom).with.offset(0);
        
        make.left.equalTo(coverBgView).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, 1));
        
    }];
    
    coverImgV = [UIImageView new];
    coverImgV.contentMode = UIViewContentModeScaleAspectFill;
    coverImgV.layer.masksToBounds = YES;
    coverImgV.layer.cornerRadius = 3.0;
    
    [coverImgV sd_setImageWithURL:[NSURL URLWithString:_key]];
    if ([[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_key]) {
        _image = [[SDImageCache sharedImageCache] imageFromMemoryCacheForKey:_key];
      
    }else{
        [Utilities showProcessingHud:self.view];
        [coverImgV sd_setImageWithURL:[NSURL URLWithString:_key] completed:^(UIImage *image,NSError *error,SDImageCacheType cacheType,NSURL *imageURL) {
            
            _image = image;
            
            [Utilities dismissProcessingHud:self.view];
            
            [self change];
            
        }];
        
    }
    
    [self.view addSubview:coverImgV];
    
    [coverImgV mas_makeConstraints:^(MASConstraintMaker *make){
        
        make.top.equalTo(imgView_line3.mas_bottom).with.offset(10);
        
        make.left.equalTo(imgView_line3).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake(169.0, 169.0));
        
    }];
    
    imgMaskBtn = [UIButton new];
    imgMaskBtn.layer.masksToBounds = YES;
    imgMaskBtn.layer.cornerRadius = 3.0;
    [imgMaskBtn addTarget:self action:@selector(editAction) forControlEvents:UIControlEventTouchUpInside];
    
    if (_image) {
        
        [imgMaskBtn setTitle:@"点击编辑" forState:UIControlStateNormal];
        [imgMaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        imgMaskBtn.titleLabel.textColor = [UIColor whiteColor];
        imgMaskBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"photoDetailMask.png"] forState:UIControlStateNormal];
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"photoDetailMask.png"] forState:UIControlStateHighlighted];
    
    }else{
        
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
    }
    
    [self.view addSubview:imgMaskBtn];
   
    [imgMaskBtn mas_makeConstraints:^(MASConstraintMaker *make){
    
        make.top.equalTo(imgView_line3.mas_bottom).with.offset(10);
        
        make.left.equalTo(imgView_line3).with.offset(10);
        
        make.size.mas_equalTo(CGSizeMake(169.0, 169.0));
    }];
    
    
}

-(void)selectRightAction:(id)sender{
    
    [text_title resignFirstResponder];
    
    if ([text_title.text isEqualToString:@""]) {
        
        //[Utilities showFailedHud:@"请添加相册名称" descView:nil];
        
        [self.view makeToast:@"请添加相册名称"
                    duration:2.5
                    position:@"center"
                       title:nil];
        
    }else{
        
        [self submit];
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

// 改变封面图片的url
-(void)changeImg:(NSNotification*)notify{
    
    _key = (NSString*)[notify object];
    [coverImgV sd_setImageWithURL:[NSURL URLWithString:_key]];
    imgPath = nil;
    [self change];
    
}

-(void)submit{
    
    /**
     * 班级相册编辑
     * @author luke
     * @date 2016.04.05
     * @args
     *  v=3 ac=Kindergarten op=setClassAlbum sid= cid= uid= app= aid=相册ID name=相册名称 png0=相册封面 cover=相册封面URL
     */
    [Utilities showProcessingHud:self.view];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"3",@"v",
                          @"Kindergarten", @"ac",
                          @"setClassAlbum", @"op",
                          _cid, @"cid",
                          _aid, @"aid",
                          text_title.text, @"name",
                          _key,@"cover",
                          imgPath, @"png0",
                          nil];
    
    [network sendHttpReq:HttpReq_ThreadReplyPicture andData:data];
    
    
    
}

-(void)editAction{
    
    [text_title resignFirstResponder];
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从本相册中选择",@"从手机相册选择",@"拍照", nil];
    sheet.actionSheetStyle = UIActionSheetStyleDefault;
    [sheet showInView:self.view];
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex NS_DEPRECATED_IOS(2_0, 8_3) __TVOS_PROHIBITED{
    
    
    if(buttonIndex == 0){//本相册
        
        SelectPhotoFromAlbumViewController *spfavc = [[SelectPhotoFromAlbumViewController alloc] init];
        spfavc.cid = _cid;
        spfavc.aid = _aid;
        [self.navigationController pushViewController:spfavc animated:YES];
        
    }else if (buttonIndex == 1){//手机相册
        
        [self actionOpenPhotoLibrary];
        
    }else if(buttonIndex  == 2){//拍照
        
         [self actionUseCamera];
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

-(void)change{
    
    if (_image || _key) {
        
        [imgMaskBtn setTitle:@"点击编辑" forState:UIControlStateNormal];
        [imgMaskBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        imgMaskBtn.titleLabel.textColor = [UIColor whiteColor];
        imgMaskBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
        
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"photoDetailMask.png"] forState:UIControlStateNormal];
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"photoDetailMask.png"] forState:UIControlStateHighlighted];
        
    }else{
        
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"addImg.png"] forState:UIControlStateNormal];
        [imgMaskBtn setBackgroundImage:[UIImage imageNamed:@"addImg_press.png"] forState:UIControlStateHighlighted];
    }
}

#pragma mark - UIImagePickerControllerDelegate

// This method is called when an image has been chosen from the library or taken from the camera.
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = [info valueForKey:UIImagePickerControllerEditedImage];
    image = [ImageResourceLoader CompressImage:image withHeight:[UIScreen mainScreen].bounds.size.width * 2 withWidth:500.0];
    
    _image = image;
    
    coverImgV.image = image;
   
    [Utilities saveImage:image withName:@"tempImgForAlbum.png"];
    
    _key = @"";
    
    imgPath = [[Utilities SystemDir] stringByAppendingPathComponent:@"tempImgForAlbum.png"];
    
    [self change];
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
   
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:NULL];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [text_title resignFirstResponder];
    return YES;
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    //NSLog(@"protocol:%@",[resultJSON objectForKey:@"protocol"]);
    //NSString *protocol = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"protocol"]];
    NSString *result = [resultJSON objectForKey:@"result"];

    [Utilities dismissProcessingHud:self.view];
    NSString *msg = [NSString stringWithFormat:@"%@",[resultJSON objectForKey:@"message"]];
    
    if ([result integerValue] == 1) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollectionDetail" object:nil];

        [[NSNotificationCenter defaultCenter] postNotificationName:@"reLoadPhotoCollection" object:nil];
        
        [Utilities showSuccessedHud:msg descView:self.view];
        [self.navigationController popViewControllerAnimated:YES];
        
    }else{
        
        [Utilities showAlert:@"错误" message:msg cancelButtonTitle:@"确定" otherButtonTitle:nil];
        
    }
    
    
}


-(void)reciveHttpDataError:(NSError*)err{
    
    
    [Utilities dismissProcessingHud:self.view];
    
}





@end
