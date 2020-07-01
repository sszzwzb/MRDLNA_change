//
//  HealthSubmitViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 15/12/1.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "HealthSubmitViewController.h"

#import "Masonry.h"

@interface HealthSubmitViewController ()

@end


@implementation HealthSubmitViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    network = [NetworkUtility alloc];
    network.delegate = self;

    _selectedImages = [[NSMutableArray alloc] init];
    _selectedImageNumber = 0;

    self.assetsAndImgs = [[NSMutableArray alloc]init];
    _imageArray = [[NSMutableDictionary alloc] init];
    _editImageArray = [[NSMutableArray alloc] init];
    _editDeleteImageIdArray = [[NSMutableArray alloc] init];
    _editLoacalImageIdArray = [[NSMutableArray alloc] init];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(healthSubmitUpdateImageSelectView:) name:@"healthSubmitUpdateImageSelectView" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tSImageSelectViewClickEvent:) name:@"TSImageSelectViewClickEvent" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(deletePhoto:)
                                                 name:@"deletePhoto"
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldHeight];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldWeight];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldSightLeft];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)
                                                name:@"UITextFieldTextDidChangeNotification"
                                              object:_textFieldSightRight];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardDidHide:)
                                                 name:UIKeyboardDidHideNotification
                                               object:nil];

    UITapGestureRecognizer *singleTouch = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    singleTouch.delegate = self;
    [self.view addGestureRecognizer:singleTouch];

    [self setCustomizeLeftButton];
    
    if ([@"submitHealth"  isEqual: _viewType]) {
        [ReportObject event:ID_OPEN_BODY_ADD];

        [super setCustomizeTitle:@"添加记录"];
    }else if ([@"editHealth"  isEqual: _viewType]) {
        [ReportObject event:ID_OPEN_BODY_REEDIT];

        [super setCustomizeTitle:@"编辑记录"];
    }
    
    [super setCustomizeRightButtonWithName:@"完成"];

    [self doShowContent];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)healthSubmitUpdateImageSelectView:(NSNotification *)notification
{
    NSLog(@"healthSubmitUpdateImageSelectView");
    
    NSDictionary *dic = [notification userInfo];
    NSString *height = [dic objectForKey:@"imageSelectViewHeight"];

    [_imageSelectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-100, [height intValue]));
    }];


//    int a = _imageSelectView.frame.size.height;
//    int b = _imageSelectView.frame.origin.y;
}

- (void)resignKeyboard
{
    [_textFieldHeight resignFirstResponder];
    [_textFieldWeight resignFirstResponder];
    [_textFieldSightLeft resignFirstResponder];
    [_textFieldSightRight resignFirstResponder];

    [_textViewComment resignFirstResponder];
}

-(void)tSImageSelectViewClickEvent:(NSNotification *)notification
{
    NSLog(@"tSImageSelectViewClickEvent");
    NSDictionary *dic = [notification userInfo];
    NSString *imageType = [dic objectForKey:@"imageType"];
    
    if ([@"submitHealth"  isEqual: _viewType]) {
        if ([@"selectButton"  isEqual: imageType]) {
            [self resignKeyboard];
            
            if (!_alertSheet) {
                _alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            }
            [_alertSheet showInView:self.view];
        }else if ([@"selectImageLocal"  isEqual: imageType]) {
            
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            fullImageViewController.assetsArray = self.assetsAndImgs;
            fullImageViewController.currentIndex = [[dic objectForKey:@"tag"] integerValue];
            [self.navigationController pushViewController:fullImageViewController animated:YES];
        }
    }else if ([@"editHealth"  isEqual: _viewType]) {
        if ([@"selectButton"  isEqual: imageType]) {
            if (!_alertSheet) {
                [self resignKeyboard];

                _alertSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从手机相册选择", nil];
            }
            [_alertSheet showInView:self.view];
        }else {
            
            FullImageViewController *fullImageViewController = [[FullImageViewController alloc] init];
            
            if ([_selectedImages count] <= 9) {
                NSDictionary *last = [_selectedImages lastObject];
                if ([@"selectButton"  isEqual: [last objectForKey:@"imageType"]]) {
                    [_selectedImages removeLastObject];
                }
            }
            NSLog(@"---tag---------%@", [dic objectForKey:@"tag"]);
            NSLog(@"---imageType---------%@", [dic objectForKey:@"imageType"]);

            fullImageViewController.imageArray = _selectedImages;
            fullImageViewController.currentIndex = [[dic objectForKey:@"tag"] integerValue];
            fullImageViewController.viewType = @"health";
            [self.navigationController pushViewController:fullImageViewController animated:YES];
        }
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex == 0) {
        //拍照
        [Utilities takePhotoFromViewController:self];
    }else if (buttonIndex == 1){
        //从手机相册选择
        if (!self.assets)
            self.assets = [[NSMutableArray alloc] init];
        
        [self.assets removeAllObjects];
        
        
        for (int i=0; i<[self.assetsAndImgs count]; i++) {
            
            if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
//                photoNum ++;
            }
            
        }
        
        CTAssetsPickerController  *picker = [[CTAssetsPickerController alloc] init];
        
        picker.assetsFilter         = [ALAssetsFilter allPhotos];
        picker.showsCancelButton    = (UI_USER_INTERFACE_IDIOM() != UIUserInterfaceIdiomPad);
        picker.delegate             = self;
        picker.selectedAssets       = [NSMutableArray arrayWithArray:self.assets];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)selectRightAction:(id)sender {
    // 添加记录
    
    // 防止多次快速提交
    self.navigationItem.rightBarButtonItem.enabled = NO;

    /**
     * 体育评测：身体添加记录
     * @author luke
     * @date 2015.11.27
     * @args
     *  v=2, ac=Physical, op=addCondition, sid=, uid=, cid=, height=, weight=, left=左眼视力, right=, note=寄语,
     * png0=,...png9=
     */
    
    // 寄语如果没写，则用placeholder中的语句
    NSString *note = _textViewComment.text;
    if ([@""  isEqual: note]) {
        note = _textViewCommentPlaceholder.text;
    }
    
    // 视力需要成对填写
    BOOL isInputSight = NO;
    
    if (([@""  isEqual: _textFieldSightLeft.text]) && ([@""  isEqual: _textFieldSightRight.text])) {
        isInputSight = NO;
    }else if (![@""  isEqual: _textFieldSightLeft.text] && ([@""  isEqual: _textFieldSightRight.text])) {
        isInputSight = YES;
    }else if ([@""  isEqual: _textFieldSightLeft.text] && (![@""  isEqual: _textFieldSightRight.text])) {
        isInputSight = YES;
    }
    
    // 除了选择9张图片之外，去掉最后一张也就是添加图片的button
    if (9 > [_selectedImages count]) {
        [_selectedImages removeLastObject];
    }
    
    if (([@""  isEqual: _textFieldHeight.text]) && ([@""  isEqual: _textFieldWeight.text])) {
        [Utilities showTextHud:@"请正确填写身高，体重数据。" descView:self.view];
    }else if (([@""  isEqual: _textFieldHeight.text])) {
        [Utilities showTextHud:@"请正确填写身高数据。" descView:self.view];
    }else if (([@""  isEqual: _textFieldWeight.text])) {
        [Utilities showTextHud:@"请正确填写体重数据。" descView:self.view];
    }else if (isInputSight) {
        [Utilities showTextHud:@"视力需成对填写。" descView:self.view];
    }else if ([Utilities isBiggerThan:0.9 number:[_textFieldHeight.text floatValue]] || ([Utilities isBiggerThan:[_textFieldHeight.text floatValue] number:300.1])) {
        [Utilities showTextHud:@"请输入正确身高。" descView:self.view];
    }else if ([Utilities isBiggerThan:0.9 number:[_textFieldWeight.text floatValue]] || ([Utilities isBiggerThan:[_textFieldWeight.text floatValue] number:300.1])) {
        [Utilities showTextHud:@"请输入正确体重。" descView:self.view];
    }else if ((![@""  isEqual: _textFieldSightLeft.text]) && (![@""  isEqual: _textFieldSightRight.text])) {
        if ([Utilities isBiggerThan:0.09 number:[_textFieldSightRight.text floatValue]] || ([Utilities isBiggerThan:[_textFieldSightRight.text floatValue] number:5.51])) {
            [Utilities showTextHud:@"视力数据范围0.1-5.5。" descView:self.view];
        }else if ([Utilities isBiggerThan:0.09 number:[_textFieldSightLeft.text floatValue]] || ([Utilities isBiggerThan:[_textFieldSightLeft.text floatValue] number:5.51])) {
            [Utilities showTextHud:@"视力数据范围0.1-5.5。" descView:self.view];
        }else {
            [Utilities showProcessingHud:self.view];
            
            if ([@"submitHealth"  isEqual: _viewType]) {

                [self saveButtonImageToFile];
                
                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Physical", @"ac",
                                      @"2",@"v",
                                      @"addCondition", @"op",
                                      _cid, @"cid",
                                      _textFieldHeight.text, @"height",
                                      _textFieldWeight.text, @"weight",
                                      _textFieldSightLeft.text,@"left",
                                      _textFieldSightRight.text,@"right",
                                      note,@"note",
                                      _imageArray, @"imageArray",
                                      nil];
                
                // 防止多次快速提交
                self.navigationItem.rightBarButtonItem.enabled = NO;

                [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
            }else if ([@"editHealth"  isEqual: _viewType]) {
                
                NSString *deletePids = [_editDeleteImageIdArray componentsJoinedByString:@","];;
//                NSString *deleteLocalPids = [_editLoacalImageIdArray componentsJoinedByString:@","];;
//                NSString *deleteLocalArr = [_editImageArray componentsJoinedByString:@","];;

                NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
                //添加5和2
//                [idxSet addIndex:5];
//                [idxSet addIndex:2];
                
//                [idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
//                {
//                    NSLog(@"%lu", (unsigned long)idx);
//                }];
                
                
                
                for (int i=0; i<[_editLoacalImageIdArray count]; i++) {
                    int tag = [[_editLoacalImageIdArray objectAtIndex:i] intValue];
                    [idxSet addIndex:tag];

                }
                
                [_editImageArray removeObjectsAtIndexes:idxSet];
                [self.assetsAndImgs removeObjectsAtIndexes:idxSet];
                
                [self saveButtonImageToFile];

                // 防止多次快速提交
                self.navigationItem.rightBarButtonItem.enabled = NO;

                NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                      REQ_URL, @"url",
                                      @"Physical", @"ac",
                                      @"2",@"v",
                                      @"editCondition", @"op",
                                      _cid, @"cid",
                                      [_editDic objectForKey:@"pid"], @"pid",
                                      _textFieldHeight.text, @"height",
                                      _textFieldWeight.text, @"weight",
                                      _textFieldSightLeft.text,@"left",
                                      _textFieldSightRight.text,@"right",
                                      note,@"note",
                                      _imageArray, @"imageArray",
                                      deletePids, @"delete",
                                      nil];
                
                [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
            }
        }
    }else {
        [Utilities showProcessingHud:self.view];
        
        if ([@"submitHealth"  isEqual: _viewType]) {
            [self saveButtonImageToFile];
            
            // 防止多次快速提交
            self.navigationItem.rightBarButtonItem.enabled = NO;

            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Physical", @"ac",
                                  @"2",@"v",
                                  @"addCondition", @"op",
                                  _cid, @"cid",
                                  _textFieldHeight.text, @"height",
                                  _textFieldWeight.text, @"weight",
                                  _textFieldSightLeft.text,@"left",
                                  _textFieldSightRight.text,@"right",
                                  note,@"note",
                                  _imageArray, @"imageArray",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
        }else if ([@"editHealth"  isEqual: _viewType]) {
            
            NSString *deletePids = [_editDeleteImageIdArray componentsJoinedByString:@","];;
            NSString *deleteLocalPids = [_editLoacalImageIdArray componentsJoinedByString:@","];;
            NSString *deleteLocalArr = [_editImageArray componentsJoinedByString:@","];;
            
            NSMutableIndexSet *idxSet = [[NSMutableIndexSet alloc] init];
            //添加5和2
            //                [idxSet addIndex:5];
            //                [idxSet addIndex:2];
            
            //                [idxSet enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
            //                {
            //                    NSLog(@"%lu", (unsigned long)idx);
            //                }];
            
            
            
            for (int i=0; i<[_editLoacalImageIdArray count]; i++) {
                int tag = [[_editLoacalImageIdArray objectAtIndex:i] intValue];
                [idxSet addIndex:tag];
                
            }
            
            [_editImageArray removeObjectsAtIndexes:idxSet];
            [self.assetsAndImgs removeObjectsAtIndexes:idxSet];
            
            [self saveButtonImageToFile];
            
            // 防止多次快速提交
            self.navigationItem.rightBarButtonItem.enabled = NO;
            
            NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                                  REQ_URL, @"url",
                                  @"Physical", @"ac",
                                  @"2",@"v",
                                  @"editCondition", @"op",
                                  _cid, @"cid",
                                  [_editDic objectForKey:@"pid"], @"pid",
                                  _textFieldHeight.text, @"height",
                                  _textFieldWeight.text, @"weight",
                                  _textFieldSightLeft.text,@"left",
                                  _textFieldSightRight.text,@"right",
                                  note,@"note",
                                  _imageArray, @"imageArray",
                                  deletePids, @"delete",
                                  nil];
            
            [network sendHttpReq:HttpReq_ThreadMomentsSubmit andData:data];
        }
    }
}

- (void)selectLeftAction:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)doShowContent {
    _scrollViewBg = [UIScrollView new];
    _scrollViewBg.scrollEnabled = YES;
    _scrollViewBg.delegate = self;
    _scrollViewBg.backgroundColor = [[UIColor alloc] initWithRed:239/255.0f green:239/255.0f blue:244/255.0f alpha:1.0];
    [self.view addSubview:_scrollViewBg];
    
    [_scrollViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为0
        make.top.equalTo(self.view).with.offset(0);
        
        // 距离屏幕左边距为20
        make.left.equalTo(self.view).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, [Utilities getScreenSize].height - 44));
    }];
    
    _viewWhiteBg = [UIView new];
    _viewWhiteBg.backgroundColor = [UIColor whiteColor];
    [_scrollViewBg addSubview:_viewWhiteBg];
    
    // 这里设置了背景白色view的edges与scrollView的一致，这样就不需要再次计算这个白色view的size了
    // 这样做可以避免同时两个view依赖于scrollView的contentSize来计算自己的size。
    // 如果有两个view同时依赖于scrollView算高度的话，就会出现其中一个view无法计算正确地高度，并且会有很多警告。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(_scrollViewBg);
        make.edges.equalTo(_scrollViewBg).with.insets(UIEdgeInsetsMake(20, 0, 25, 0));

        make.width.equalTo(_scrollViewBg);
    }];
    
    // 身高
    _labelHeight = [UILabel new];
    _labelHeight.textAlignment = NSTextAlignmentLeft;
    _labelHeight.font = [UIFont systemFontOfSize:17.0f];
    _labelHeight.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelHeight.text = @"身高";
    [_scrollViewBg addSubview:_labelHeight];
    
    [_labelHeight mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(_scrollViewBg).with.offset(30);
        
        // 距离屏幕左边距为20
        make.left.equalTo(_scrollViewBg).with.offset(20);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    _textFieldHeight = [UITextField new];
    _textFieldHeight.placeholder = @"请输入身高";
    _textFieldHeight.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    _textFieldHeight.keyboardType = UIKeyboardTypeDecimalPad;
    _textFieldHeight.textAlignment = NSTextAlignmentLeft;
    _textFieldHeight.delegate = self;
    //    _textFieldHeight.backgroundColor = [UIColor redColor];
    [_scrollViewBg addSubview:_textFieldHeight];
    
    [_textFieldHeight mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_labelHeight的y相同
        make.top.equalTo(_labelHeight).with.offset(1);
        
        // x距离_labelHeight右边最长处相同
        make.left.equalTo(_labelHeight.mas_right).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(90, 20));
    }];
    
    _labelCM = [UILabel new];
    _labelCM.textAlignment = NSTextAlignmentLeft;
    _labelCM.font = [UIFont systemFontOfSize:17.0f];
    _labelCM.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    //    _labelCM.backgroundColor = [UIColor greenColor];
    _labelCM.text = @"cm";
    [_scrollViewBg addSubview:_labelCM];
    
    [_labelCM mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(_textFieldHeight).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(_textFieldHeight.mas_right).with.offset(5);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];

    UIView *lineV = [UIView new];
    lineV.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.7];
    [_scrollViewBg addSubview:lineV];
    
    [lineV mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(_labelCM.mas_bottom).with.offset(10);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(_labelHeight).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-20, 1));
    }];
    
    
    // 体重
    _labelWeight = [UILabel new];
    _labelWeight.textAlignment = NSTextAlignmentLeft;
    _labelWeight.font = [UIFont systemFontOfSize:17.0f];
    _labelWeight.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelWeight.text = @"体重";
    [_scrollViewBg addSubview:_labelWeight];
    
    [_labelWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(lineV).with.offset(10);
        
        // 距离屏幕左边距为20
        make.left.equalTo(_scrollViewBg).with.offset(20);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    _textFieldWeight = [UITextField new];
    _textFieldWeight.placeholder = @"请输入体重";
    _textFieldWeight.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    _textFieldWeight.keyboardType = UIKeyboardTypeDecimalPad;
    _textFieldWeight.textAlignment = NSTextAlignmentLeft;
    //    _textFieldHeight.backgroundColor = [UIColor redColor];
    [_scrollViewBg addSubview:_textFieldWeight];
    
    [_textFieldWeight mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_labelHeight的y相同
        make.top.equalTo(_labelWeight).with.offset(1);
        
        // x距离_labelHeight右边最长处相同
        make.left.equalTo(_labelWeight.mas_right).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(90, 20));
    }];
    
    _labelKG = [UILabel new];
    _labelKG.textAlignment = NSTextAlignmentLeft;
    _labelKG.font = [UIFont systemFontOfSize:17.0f];
    _labelKG.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    _labelKG.text = @"kg";
    [_scrollViewBg addSubview:_labelKG];
    
    [_labelKG mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(_textFieldWeight).with.offset(0);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(_textFieldWeight.mas_right).with.offset(5);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(30, 20));
    }];

    UIView *lineV1 = [UIView new];
    lineV1.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.7];
    [_scrollViewBg addSubview:lineV1];
    
    [lineV1 mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(_labelKG.mas_bottom).with.offset(10);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(_labelHeight).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-20, 1));
    }];
    
    // 视力
    _labelSight = [UILabel new];
    _labelSight.textAlignment = NSTextAlignmentLeft;
    _labelSight.font = [UIFont systemFontOfSize:17.0f];
    _labelSight.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelSight.text = @"视力";
    [_scrollViewBg addSubview:_labelSight];
    
    [_labelSight mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(lineV1).with.offset(10);
        
        // 距离屏幕左边距为20
        make.left.equalTo(_scrollViewBg).with.offset(20);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];
    
    // 左眼
    _labelSightLeft = [UILabel new];
    _labelSightLeft.textAlignment = NSTextAlignmentLeft;
    _labelSightLeft.font = [UIFont systemFontOfSize:17.0f];
    _labelSightLeft.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelSightLeft.text = @"左眼";
    [_scrollViewBg addSubview:_labelSightLeft];
    
    [_labelSightLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(lineV1).with.offset(10);
        
        // 距离_labelSight左边距为10
        make.left.equalTo(_labelSight.mas_right).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(45, 20));
    }];
    
    _textFieldSightLeft = [UITextField new];
    _textFieldSightLeft.placeholder = @"请输入左眼度数";
    _textFieldSightLeft.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    _textFieldSightLeft.keyboardType = UIKeyboardTypeDecimalPad;
    _textFieldSightLeft.textAlignment = NSTextAlignmentLeft;
    //    _textFieldHeight.backgroundColor = [UIColor redColor];
    [_scrollViewBg addSubview:_textFieldSightLeft];
    
    [_textFieldSightLeft mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_labelHeight的y相同
        make.top.equalTo(_labelSightLeft).with.offset(1);
        
        // x距离_labelHeight右边最长处相同
        make.left.equalTo(_labelSightLeft.mas_right).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
    
    // 右眼
    _labelSightRight = [UILabel new];
    _labelSightRight.textAlignment = NSTextAlignmentLeft;
    _labelSightRight.font = [UIFont systemFontOfSize:17.0f];
    _labelSightRight.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelSightRight.text = @"右眼";
    [_scrollViewBg addSubview:_labelSightRight];
    
    [_labelSightRight mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离左眼上边距为10
        make.top.equalTo(_labelSightLeft.mas_bottom).with.offset(10);
        
        // 距离_labelSight左边距为10
        make.left.equalTo(_labelSight.mas_right).with.offset(0);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(45, 20));
    }];
    
    _textFieldSightRight = [UITextField new];
    _textFieldSightRight.placeholder = @"请输入右眼度数";
    _textFieldSightRight.textColor = [[UIColor alloc] initWithRed:71/255.0f green:187/255.0f blue:174/255.0f alpha:1.0];
    _textFieldSightRight.keyboardType = UIKeyboardTypeDecimalPad;
    _textFieldSightRight.textAlignment = NSTextAlignmentLeft;
    //    _textFieldHeight.backgroundColor = [UIColor redColor];
    [_scrollViewBg addSubview:_textFieldSightRight];
    
    [_textFieldSightRight mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_labelHeight的y相同
        make.top.equalTo(_labelSightRight).with.offset(1);
        
        // x距离_labelHeight右边最长处相同
        make.left.equalTo(_labelSightRight.mas_right).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake(140, 20));
    }];
    
    UIView *lineV2 = [UIView new];
    lineV2.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:200.0/255.0 blue:200.0/255.0 alpha:0.7];
    [_scrollViewBg addSubview:lineV2];
    
    [lineV2 mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_textFieldHeight的y相同
        make.top.equalTo(_labelSightRight.mas_bottom).with.offset(10);
        
        // x距离_labelHeight右边最长处5
        make.left.equalTo(_labelHeight).with.offset(0);
        
        // _textFieldHeight的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-20, 1));
    }];

    // 寄语
    _labelComment = [UILabel new];
    _labelComment.textAlignment = NSTextAlignmentLeft;
    _labelComment.font = [UIFont systemFontOfSize:17.0f];
    _labelComment.textColor = [UIColor grayColor];
    //    _labelHeight.backgroundColor = [UIColor greenColor];
    _labelComment.text = @"寄语";
    [_scrollViewBg addSubview:_labelComment];
    
    [_labelComment mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离屏幕上边距为80
        make.top.equalTo(lineV2).with.offset(10);
        
        // 距离屏幕左边距为20
        make.left.equalTo(_scrollViewBg).with.offset(20);
        
        // _labelHeight的大小
        make.size.mas_equalTo(CGSizeMake(60, 20));
    }];

    _textViewComment = [UITextView new];
    _textViewComment.text = @"";
    _textViewComment.textAlignment = NSTextAlignmentLeft;
    _textViewComment.textColor = [UIColor grayColor];
    _textViewComment.font = [UIFont systemFontOfSize:17.0f];
//    _textViewComment.backgroundColor = [UIColor redColor];
    _textViewComment.scrollEnabled = NO;
        _textViewComment.contentInset = UIEdgeInsetsMake(-8, 0, 0, 0);;
    _textViewComment.delegate = self;
    [_scrollViewBg addSubview:_textViewComment];
    
    [_textViewComment mas_makeConstraints:^(MASConstraintMaker *make) {
        // y与_labelComment的y相同
        make.top.equalTo(_labelComment).with.offset(1);
        
        // x距离_labelComment右边最长处相同
        make.left.equalTo(_labelComment.mas_right).with.offset(0);
        
        // _textFieldComment的大小
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-100, 28));
        
//        make.bottom.equalTo( _scrollViewBg.mas_bottom).with.offset(-20);;
    }];
    
    
    _textViewCommentPlaceholder = [UILabel new];
    _textViewCommentPlaceholder.textAlignment = NSTextAlignmentLeft;
    _textViewCommentPlaceholder.font = [UIFont systemFontOfSize:17.0f];
    _textViewCommentPlaceholder.textColor = [UIColor grayColor];
    _textViewCommentPlaceholder.text = @"记录成长中的点点滴滴！";
    [_scrollViewBg addSubview:_textViewCommentPlaceholder];
    
    [_textViewCommentPlaceholder mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_textViewComment).with.offset(0);
        make.left.equalTo(_textViewComment).with.offset(3);
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-100, 20));
    }];

    _imageSelectView = [TSImageSelectView new];
//    _imageSelectView.backgroundColor = [UIColor greenColor];
    [_imageSelectView initArrays];
    [_scrollViewBg addSubview:_imageSelectView];

    [_imageSelectView mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离_textViewComment下距离为10
        make.top.equalTo(_textViewComment.mas_bottom).with.offset(10);
        
        // 距离_textViewComment的左边距为0
        make.left.equalTo(_textViewComment).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width-100, 0));
        
//        make.bottom.equalTo( _textViewComment.mas_bottom).with.offset(0);
//        make.bottom.equalTo( _scrollViewBg.mas_bottom).with.offset(-40);
    }];

    // 通过之前设置这个view得edges与scrollView相同，就不需要计算size了，直接可以指定bottom
    // 如果还在这里计算的话，就会出问题。
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_imageSelectView.mas_bottom);
    }];

    // 错误范例如下：
#if 0
    // 设置背景白色的约束
    [_viewWhiteBg mas_makeConstraints:^(MASConstraintMaker *make) {
        // 距离_scrollViewBg为0
        make.top.equalTo(_labelHeight).with.offset(-10);
        
        // 距离_scrollViewBg左边距为0
        make.left.equalTo(_scrollViewBg).with.offset(0);
        
        make.size.mas_equalTo(CGSizeMake([Utilities getScreenSize].width, 0));
        
//        make.height.mas_equalTo(_scrollViewBg.contentSize.height);
        
        // _labelHeight的大小
        make.bottom.equalTo(_scrollViewBg.mas_bottom).with.offset(100);;
    }];
#endif
    
    // submitHealth 为添加记录
    // editHealth 为编辑记录

    if ([@"submitHealth"  isEqual: _viewType]) {
        // 由于约束的存在，需要延迟才能获取到动态的高度
        [self performSelector:@selector(updateImageSelectViewElement) withObject:nil afterDelay:0.1];

    }else if ([@"editHealth"  isEqual: _viewType]) {
        [self performSelector:@selector(updateImageSelectViewElement) withObject:nil afterDelay:0.1];

    }
    
    
}

-(void)updateImageSelectViewElement
{
    if ([@"submitHealth"  isEqual: _viewType]) {
        for (int i=0; i<1; i++) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"moments/tj.png", @"image",
                                 @"selectButton", @"imageType",
                                 nil];
            
            [_selectedImages addObject:dic];
        }
        
        [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
    }else if ([@"editHealth"  isEqual: _viewType]) {
        
        if (nil != _editDic) {
            NSString *height = [_editDic objectForKey:@"height"];
            NSRange foundHeight = [height rangeOfString:@"c" options:NSCaseInsensitiveSearch];
            height = [height substringToIndex:foundHeight.location];
            _textFieldHeight.text = height;
            
            NSString *weight = [_editDic objectForKey:@"weight"];
            NSRange foundWeight = [weight rangeOfString:@"k" options:NSCaseInsensitiveSearch];
            weight = [weight substringToIndex:foundWeight.location];
            _textFieldWeight.text = weight;
            
            NSDictionary *vision = [_editDic objectForKey:@"vision"];
            if (![@"--"  isEqual: [vision objectForKey:@"left"]]) {
                _textFieldSightLeft.text = [vision objectForKey:@"left"];
            }
            
            if (![@"--"  isEqual: [vision objectForKey:@"right"]]) {
                _textFieldSightRight.text = [vision objectForKey:@"right"];
            }

            // 寄语
            _textViewComment.text = [_editDic objectForKey:@"note"];
            _textViewCommentPlaceholder.hidden = YES;
            
            CGSize constraintSize;
            constraintSize.width = _textViewComment.frame.size.width;
            constraintSize.height = MAXFLOAT;
            
            CGSize sizeFrame = [_textViewComment sizeThatFits:constraintSize];
            
            // 修改下边距约束
            [_textViewComment mas_updateConstraints:^(MASConstraintMaker *make) {
                make.size.mas_equalTo(CGSizeMake(_textViewComment.frame.size.width,sizeFrame.height));
            }];
            
            // 图片
            NSArray *picsArr = (NSArray *)[_editDic objectForKey:@"pics"];
            for (int i=0; i<[picsArr count]; i++) {
                NSDictionary *picsDic = [picsArr objectAtIndex:i];
                
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     [picsDic objectForKey:@"url"], @"image",
                                     @"selectImageServer", @"imageType",
                                     [picsDic objectForKey:@"id"], @"id",
                                     nil];
                
                [_selectedImages addObject:dic];
            }
            
            // 再加上添加图片的button
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"moments/tj.png", @"image",
                                 @"selectButton", @"imageType",
                                 @"", @"id",
                                 nil];
            [_selectedImages addObject:dic];
            
            // 这里最多可以选择9张图片，选择完9张之后，就要把最后的加号取消掉。
            if (10 == [_selectedImages count]) {
                [_selectedImages removeObjectAtIndex:9];
            }
            
            [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
        }
    }
}

- (void)textViewDidChange:(UITextView *)textView {
    if ([textView.text length] == 0) {
        [_textViewCommentPlaceholder setHidden:NO];
    }else{
        [_textViewCommentPlaceholder setHidden:YES];
    }

    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > 50)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:50];
        
        [textView setText:s];
    }else {
        CGSize constraintSize;
        constraintSize.width = textView.frame.size.width;
        constraintSize.height = MAXFLOAT;
        
        CGSize sizeFrame = [textView sizeThatFits:constraintSize];
        
        // 修改下边距约束
        [_textViewComment mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(textView.frame.size.width,sizeFrame.height));
        }];
        
        // 先取得光标位置
        NSRange cursorTextRange = [_textViewComment selectedRange];
        
        // 获取光标位置之前的所有文字text
        NSString *cursorText = [_textViewComment.text substringToIndex:cursorTextRange.location];
        
        // 接着获取此光标之前的文字在该textView中的高度
        UITextView *tv = [[UITextView alloc] init];
        tv.textAlignment = NSTextAlignmentLeft;
        tv.font = [UIFont systemFontOfSize:17.0f];
        tv.text = cursorText;
        CGSize sizeToFit = [tv sizeThatFits:CGSizeMake(_textViewComment.frame.size.width, MAXFLOAT)];
        int cursorHeight = sizeToFit.height;
        //    NSLog(@"cursorHeight = %d", cursorHeight);
        
        // 整个textView的高度
        int textViewTotalHeight = sizeFrame.height;
        
        // textView的y坐标到屏幕底部的高度
        int r = [Utilities getScreenSize].height - _textViewComment.frame.origin.y-44;
        
        // 为了防止光标点击在整个textView中间时候修改后，scrollView的偏移问题，这里计算一下textView整个的高度距离光标的高度
        int ooo = textViewTotalHeight - cursorHeight;
        //    NSLog(@"ooo = %d", ooo);
        
        // 首先，如果整个textView的高度超出了textView的y坐标到屏幕底部的高度的话，就认为已经超出了屏幕的绘制范围，需要将scrollView的offset设置为输入的文字超出的高度。
        if (textViewTotalHeight > r) {
            // 如果textView整个的高度距离光标的高度小于一行的高度，就认为在整个textView的最下面，需要更改scrollView的offset，并设置偏移。
            if (ooo < 20) {
                // 最后多加的20是为了多偏移一些，露出一些余白，好看一点。。
                [_scrollViewBg setContentOffset:CGPointMake(0, textViewTotalHeight-r+20+10) animated:YES];
            }else {
                //            [_scrollViewBg setContentOffset:CGPointMake(0, ooo+10) animated:YES];
            }
        }
        
        //    NSLog(@"textViewTotalHeight = %d", textViewTotalHeight);
        //    NSLog(@"r = %d", r);
        //    NSLog(@"textViewTotalHeight-r = %d", textViewTotalHeight-r);
        
        [UIView animateWithDuration:0.2 animations:^{
            [self.view layoutIfNeeded]; }];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < 50) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = 50 - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            //            label_leftNum.text = [NSString stringWithFormat:@"%d/%ld",0,(long)50];
        }
        return NO;
    }
}

-(void)textFiledEditChanged:(NSNotification *)obj{
    NSInteger limit;
    limit = 3;

    UITextField *textField = (UITextField *)obj.object;

    if ((_textFieldHeight == textField) || (_textFieldWeight == textField)) {
        
        NSString *toBeString = textField.text;

        NSRange foundObj=[toBeString rangeOfString:@"." options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            // 带小数点
            // 先判断小数点前面的位数
            NSString *beforePointNum = [toBeString substringToIndex:foundObj.location];
            
            limit = beforePointNum.length+2;
        } else {
            // 不带小数点
            limit = 3;
        }
        
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
                NSString *toBeString = textField.text;
                textField.text = [toBeString substringToIndex:limit];
            }
        }
    }else if ((_textFieldSightLeft == textField) || (_textFieldSightRight == textField)) {
        NSString *toBeString = textField.text;
        
        NSRange foundObj=[toBeString rangeOfString:@"." options:NSCaseInsensitiveSearch];
        if(foundObj.length>0) {
            // 带小数点
            // 先判断小数点前面的位数
            NSString *beforePointNum = [toBeString substringToIndex:foundObj.location];
            
            limit = beforePointNum.length+2;
        } else {
            // 不带小数点
            limit = 3;
        }
        
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
                NSString *toBeString = textField.text;
                textField.text = [toBeString substringToIndex:limit];
            }
        }
    }
}

- (void)keyboardWillShow:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-keyboardHeight); }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
}

- (void)keyboardWillHide:(NSNotification *)notification {
    NSDictionary *userInfo = [notification userInfo];
//    CGRect rect = [userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    
//    CGFloat keyboardHeight = CGRectGetHeight(rect);
    CGFloat keyboardDuration =
    [userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    
    // 修改下边距约束
    [_scrollViewBg mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view); }];
    
    // 更新约束
    [UIView animateWithDuration:keyboardDuration animations:^{
        [self.view layoutIfNeeded]; }];
}

- (void)keyboardDidHide:(NSNotification *)notification {

}

-(void)dismissKeyboard{
    
    [_textFieldHeight resignFirstResponder];
    [_textFieldWeight resignFirstResponder];
    [_textFieldSightLeft resignFirstResponder];
    [_textFieldSightRight resignFirstResponder];

    [_textViewComment resignFirstResponder];
    
//    UIMenuController *menuController = [UIMenuController sharedMenuController];
//    [menuController setMenuVisible:NO animated:YES];
    
}

#pragma mark - Assets Picker Delegate

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker isDefaultAssetsGroup:(ALAssetsGroup *)group
{
    return ([[group valueForProperty:ALAssetsGroupPropertyType] integerValue] == ALAssetsGroupSavedPhotos);
}

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    
    
    if ([@"submitHealth"  isEqual: _viewType]) {
        self.assets = [NSMutableArray arrayWithArray:assets];
        
        // 先把最后的添加图片的button移除
        NSDictionary *dic11 = [_selectedImages lastObject];
        if ([@"selectButton"  isEqual: [dic11 objectForKey:@"imageType"]]) {
            [_selectedImages removeLastObject];
        }
        
        for (int i=0; i<[self.assets count]; i++) {
            ALAsset *asset = [self.assets objectAtIndex:i];
            UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 img, @"image",
                                 @"selectImageLocal", @"imageType",
                                 nil];
            
            [_selectedImages addObject:dic];
            
            [_editImageArray addObject:dic];
        }
        
        // 再加上添加图片的button
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"moments/tj.png", @"image",
                             @"selectButton", @"imageType",
                             nil];
        [_selectedImages addObject:dic];
        
        // 这里最多可以选择9张图片，选择完9张之后，就要把最后的加号取消掉。
        if (10 == [_selectedImages count]) {
            [_selectedImages removeObjectAtIndex:9];
        }
        
        [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
        
        self.assets = [NSMutableArray arrayWithArray:assets];
        
        for (int i=0; i<[self.assets count]; i++) {
            [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
        }
    }else if ([@"editHealth"  isEqual: _viewType]) {
        _selectedImageNumber = 0;
        
        self.assets = [NSMutableArray arrayWithArray:assets];
        
        // 先把最后的添加图片的button移除
        NSDictionary *dic11 = [_selectedImages lastObject];
        if ([@"selectButton"  isEqual: [dic11 objectForKey:@"imageType"]]) {
            [_selectedImages removeLastObject];
        }
        
        for (int i=0; i<[self.assets count]; i++) {
            ALAsset *asset = [self.assets objectAtIndex:i];
            UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
            
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 img, @"image",
                                 @"selectImageLocal", @"imageType",
                                 @"", @"id",
                                 [NSString stringWithFormat:@"%d", i], @"eidtTag",

                                 nil];
            
            [_selectedImages addObject:dic];
            
            [_editImageArray addObject:dic];
        }
        
        // 再加上添加图片的button
        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                             @"moments/tj.png", @"image",
                             @"selectButton", @"imageType",
                             @"", @"id",
                             nil];
        [_selectedImages addObject:dic];
        
        // 这里最多可以选择9张图片，选择完9张之后，就要把最后的加号取消掉。
        if (10 == [_selectedImages count]) {
            [_selectedImages removeObjectAtIndex:9];
        }
        
        [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
        
        self.assets = [NSMutableArray arrayWithArray:assets];
        
        for (int i=0; i<[self.assets count]; i++) {
            [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
        }
        
//        NSArray *b = self.assetsAndImgs;
//        int a= 0;
    }
}

- (void)assetsPickerControllerDidCancel:(CTAssetsPickerController *)picker{
    
//    [text_content becomeFirstResponder];
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldEnableAsset:(ALAsset *)asset
{
    // Enable video clips if they are at least 5s
    if ([[asset valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo])
    {
        NSTimeInterval duration = [[asset valueForProperty:ALAssetPropertyDuration] doubleValue];
        return lround(duration) >= 5;
    }
    else
    {
        return YES;
    }
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(ALAsset *)asset
{
    BOOL selectPhoto = NO;
    
    if (!asset.defaultRepresentation)
    {
        UIAlertView *alertView =
        [[UIAlertView alloc] initWithTitle:@"提示"
                                   message:@"您的资源尚未下载到您的设备"
                                  delegate:nil
                         cancelButtonTitle:nil
                         otherButtonTitles:@"OK", nil];
        
        [alertView show];
    }
    else
    {
        if ([@"submitHealth"  isEqual: _viewType]) {
            if (9 == [(NSArray *)[_editDic objectForKey:@"pics"] count]) {
                
            }
            
            int cnt = [_selectedImages count];
            
            NSDictionary *dic = [_selectedImages lastObject];
            if ([@"selectButton"  isEqual: [dic objectForKey:@"imageType"]]) {
                cnt = cnt -1;
            }
            
            if (_selectedImageNumber >= 9){
                //        if ((_selectedImageNumber+[(NSArray *)[_editDic objectForKey:@"pics"] count]) >= 9){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)picker.selectedAssets.count]
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                
                [alertView show];
                
                selectPhoto = NO;
            }else{
                _selectedImageNumber ++;
                selectPhoto = YES;
            }
        }else if ([@"editHealth"  isEqual: _viewType]) {
            int cnt = [_selectedImages count];

            if (9 == [_selectedImages count]) {
                NSDictionary *dic = [_selectedImages lastObject];
                if ([@"selectButton"  isEqual: [dic objectForKey:@"imageType"]]) {
                    cnt = cnt -1;
                }
            }
            
            
            
            if ((_selectedImageNumber+cnt) >= 9){
                //        if ((_selectedImageNumber+[(NSArray *)[_editDic objectForKey:@"pics"] count]) >= 9){
                UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                    message:[NSString stringWithFormat:@"最多只能选择%ld张照片",(unsigned long)picker.selectedAssets.count]
                                                                   delegate:nil
                                                          cancelButtonTitle:nil
                                                          otherButtonTitles:@"OK", nil];
                
                [alertView show];
                
                selectPhoto = NO;
            }else{
                _selectedImageNumber ++;
                selectPhoto = YES;
            }

            
        }
        
        
        
        
        
        
        
        
        
        
    }
    
    //return (picker.selectedAssets.count < 9 && asset.defaultRepresentation != nil);
    return (selectPhoto && asset.defaultRepresentation != nil);// update 2015.04.13
}

- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldDeselectAsset:(ALAsset *)asset{
    
    _selectedImageNumber-- ;
    return YES;
}

// add 2015.04.10
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0){
    
    
    
#if 0
    for (int i=0; i<[buttonArray count]; i++) {
        [(UIButton*)[buttonArray objectAtIndex:i] removeFromSuperview];
    }
    [buttonArray removeAllObjects];
    [button_photoMask0 removeFromSuperview];
    
    UIImage *img = nil;
    
    for (int i=0; i<[self.assetsAndImgs count]; i++) {
        
        UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
        [button_photoMask setImage:[UIImage imageNamed:@"moments/tj.png"] forState:UIControlStateNormal] ;
        [button_photoMask setImage:[UIImage imageNamed:@"moments/tj_p.png"] forState:UIControlStateHighlighted] ;
        //button_photoMask.tag = i+1;
        [buttonArray addObject:button_photoMask];
        
        if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
            
            ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
            img = [UIImage imageWithCGImage:asset.thumbnail];
            
        }else{
            img = [self.assetsAndImgs objectAtIndex:i];
        }
        
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateNormal] ;
        [[buttonArray objectAtIndex:i] setImage:img forState:UIControlStateHighlighted];
        
        NSLog(@"tag0:%d",button_photoMask.tag);
    }
    
    
    UIButton *button_photoMask = [UIButton buttonWithType:UIButtonTypeCustom];
    [button_photoMask setImage:[UIImage imageNamed:@"moments/tj.png"] forState:UIControlStateNormal] ;
    [button_photoMask setImage:[UIImage imageNamed:@"moments/tj_p.png"] forState:UIControlStateHighlighted] ;
    //button_photoMask.tag = [self.assets count]+1;
    NSLog(@"tag:%d",button_photoMask.tag);
    [buttonArray addObject:button_photoMask];
    
    [self showImageButtonArray];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    [text_content becomeFirstResponder];
    
    
#else
    //NSLog(@"拍照成功后放入图片数组");
    [self.assetsAndImgs addObject:image];

    
    // 先把最后的添加图片的button移除
    NSDictionary *dic11 = [_selectedImages lastObject];
    if ([@"selectButton"  isEqual: [dic11 objectForKey:@"imageType"]]) {
        [_selectedImages removeLastObject];
    }
    
    NSDictionary *dic111 = [[NSDictionary alloc] initWithObjectsAndKeys:
                         image, @"image",
                         @"selectImageLocal", @"imageType",
                         nil];
    
    [_selectedImages addObject:dic111];

//    for (int i=0; i<[self.assets count]; i++) {
//        ALAsset *asset = [self.assets objectAtIndex:i];
//        UIImage *img = [UIImage imageWithCGImage:asset.thumbnail];
//        
//        NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
//                             img, @"image",
//                             @"selectImageLocal", @"imageType",
//                             nil];
//        
//        [_selectedImages addObject:dic];
//        
//        [_editImageArray addObject:dic];
//    }
    
    // 再加上添加图片的button
    NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                         @"moments/tj.png", @"image",
                         @"selectButton", @"imageType",
                         nil];
    [_selectedImages addObject:dic];
    
    // 这里最多可以选择9张图片，选择完9张之后，就要把最后的加号取消掉。
    if (10 == [_selectedImages count]) {
        [_selectedImages removeObjectAtIndex:9];
    }
    
    [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
    
//    self.assets = [NSMutableArray arrayWithArray:assets];
    
//    for (int i=0; i<[self.assets count]; i++) {
//        [self.assetsAndImgs addObject:[self.assets objectAtIndex:i]];
//    }

    
    
    [picker dismissViewControllerAnimated:YES completion:nil];

    
#endif
    
//    cameraNum++;
    
}

// 删除照片
-(void)deletePhoto:(NSNotification*)notification{
    NSString *currentIndex = (NSString*)[notification object];
    int tag = (int)[currentIndex integerValue];

    if ([@"submitHealth"  isEqual: _viewType]) {
        
        
        [_selectedImages removeObjectAtIndex:tag];
        
        
        [self.assetsAndImgs removeObjectAtIndex:tag];
        
//        [_selectedImages removeLastObject];
        
        NSMutableArray *a = [[NSMutableArray alloc] initWithArray:_selectedImages];
        
        if ([a count] < 9) {
            NSDictionary *dicaaa = [a lastObject];
            
            if (![@"moments/tj.png"  isEqual: [dicaaa objectForKey:@"image"]]) {
                NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                     @"moments/tj.png", @"image",
                                     @"selectButton", @"imageType",
                                     @"", @"id",
                                     nil];
                [a addObject:dic];
            }
        }
        
        [_imageSelectView setImages:a elementWidth:65 gapWidth:10];
        _selectedImageNumber-- ;

//        [_imageSelectView setImages:_selectedImages elementWidth:65 gapWidth:10];
    }else if ([@"editHealth"  isEqual: _viewType]) {
        NSString *picId = [[_selectedImages objectAtIndex:tag] objectForKey:@"id"];
        
        if (![@""  isEqual: picId]) {
            [_editDeleteImageIdArray addObject:picId];
        }
        
//        if ([@"selectImageLocal"  isEqual: [[_selectedImages objectAtIndex:tag] objectForKey:@"imageType"]]) {
//            _selectedImageNumber-- ;
//        }

        NSString *editTag = [[_selectedImages objectAtIndex:tag] objectForKey:@"eidtTag"];

        if (nil != editTag) {
//            [_editImageArray removeObjectAtIndex:[editTag intValue]];
            [_editLoacalImageIdArray addObject:editTag];
        }
        
        [_selectedImages removeObjectAtIndex:tag];
//        [self.assetsAndImgs removeObjectAtIndex:tag];
//
        
        
        
        NSMutableArray *a = [[NSMutableArray alloc] initWithArray:_selectedImages];
        
        if ([a count] < 9) {
            NSDictionary *dic = [[NSDictionary alloc] initWithObjectsAndKeys:
                                 @"moments/tj.png", @"image",
                                 @"selectButton", @"imageType",
                                 @"", @"id",
                                 nil];
            [a addObject:dic];

        }

        [_imageSelectView setImages:a elementWidth:65 gapWidth:10];
        


    }
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    NSError *error;
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    
    NSString *result = [resultJSON objectForKey:@"result"];
    
    [Utilities dismissProcessingHud:self.view];
    if(true == [result intValue])
    {
        if ([@"submitHealth"  isEqual: _viewType]) {
            [ReportObject event:ID_ADD_BODY_RECORD];

            [Utilities showSuccessedHud:[resultJSON objectForKey:@"message"] descView:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHealthView" object:self userInfo:nil];

            [self.navigationController popViewControllerAnimated:YES];
        }else if ([@"editHealth"  isEqual: _viewType]) {
            [ReportObject event:ID_REEDIT_BODY_DETAIL];

            [Utilities showSuccessedHud:[resultJSON objectForKey:@"message"] descView:nil];
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHealthView" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHealthDetailView" object:self userInfo:nil];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadHealthHistoryView" object:self userInfo:nil];

            [self.navigationController popViewControllerAnimated:YES];

        }
    }else{
        [Utilities showTextHud:[resultJSON objectForKey:@"message"] descView:self.view];;
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
    self.navigationItem.rightBarButtonItem.enabled = YES;
    
    [Utilities dismissProcessingHud:self.view];
    [Utilities showTextHud:@"网络连接错误，请稍候再试" descView:self.view];
}

-(void)saveButtonImageToFile
{
    if ([@"submitHealth"  isEqual: _viewType]) {
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(_selectedImages.count > 0){
            
            //        for (int i=0; i<[self.assets count]; i++) {
            UIImage *image = nil;
            for (int i=0; i<[self.assetsAndImgs count]; i++) {// update 2015.04.13
                
                NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
                
                //            ALAsset *asset = [self.assets objectAtIndex:i];
                if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];// update 2015.04.13
                    //获取资源图片的详细资源信息
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    //获取资源图片的高清图
                    //[representation fullResolutionImage];
                    //获取资源图片的全屏图
                    //[representation fullScreenImage];
                    
                    image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    
                }else{
                    image = [self.assetsAndImgs objectAtIndex:i];
                    UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                    image = [Utilities fixOrientation:tempImage];
                    
                }
                
                
                
                UIImage *scaledImage;
                UIImage *updateImage;
                
                // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                if (image.size.width >= 480) {
                    float scaleRate = 480/image.size.width;
                    
                    float w = 480;
                    float h = image.size.height * scaleRate;
                    
                    scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                }
                
                if (scaledImage != Nil) {
                    updateImage = scaledImage;
                } else {
                    updateImage = image;
                }
                
                NSData *data;
                data = UIImageJPEGRepresentation(image, 0.3);
                
                UIImage *img = [UIImage imageWithData:data];
                
                [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                
                [_imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
            }
        }
    }else if ([@"editHealth"  isEqual: _viewType]) {
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoImageFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        if(_editImageArray.count > 0){
            
            //        for (int i=0; i<[self.assets count]; i++) {
            UIImage *image = nil;
            for (int i=0; i<[self.assetsAndImgs count]; i++) {
                
                NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i+1)]];
                
                //            ALAsset *asset = [self.assets objectAtIndex:i];
                if ([[self.assetsAndImgs objectAtIndex:i] isKindOfClass:ALAsset.class]) {
                    
                    ALAsset *asset = [self.assetsAndImgs objectAtIndex:i];
                    //获取资源图片的详细资源信息
                    ALAssetRepresentation* representation = [asset defaultRepresentation];
                    //获取资源图片的高清图
                    //[representation fullResolutionImage];
                    //获取资源图片的全屏图
                    //[representation fullScreenImage];
                    
                    image = [UIImage imageWithCGImage:[representation fullScreenImage]];
                    
                }else{
                    image = [self.assetsAndImgs objectAtIndex:i];
                    UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
                    image = [Utilities fixOrientation:tempImage];
                    
                }
                
                
                
                UIImage *scaledImage;
                UIImage *updateImage;
                
                // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
                if (image.size.width >= 480) {
                    float scaleRate = 480/image.size.width;
                    
                    float w = 480;
                    float h = image.size.height * scaleRate;
                    
                    scaledImage = [Utilities imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];
                }
                
                if (scaledImage != Nil) {
                    updateImage = scaledImage;
                } else {
                    updateImage = image;
                }
                
                NSData *data;
                data = UIImageJPEGRepresentation(image, 0.3);
                
                UIImage *img = [UIImage imageWithData:data];
                
                [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
                
                [_imageArray setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
            }
        }
    }
}

-(NSData *)imageToNsdata:(UIImage*)img
{
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    
    return data = UIImageJPEGRepresentation(img, 0.3);
}

@end
