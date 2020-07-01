//
//  TeacherMomentsViewController.m
//  MicroSchool
//
//  Created by CheungStephen on 15/12/30.
//  Copyright © 2015年 jiaminnet. All rights reserved.
//

#import "TeacherMomentsViewController.h"

@interface TeacherMomentsViewController ()

@end

@implementation TeacherMomentsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self doShowContents];
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

- (void)doShowContents
{
    NSArray *segmentedArray = [[NSArray alloc]initWithObjects:@"全部",@"我的班级",nil];
    
    //初始化UISegmentedControl
    _segmentControl = [[UISegmentedControl alloc]initWithItems:segmentedArray];
    _segmentControl.frame = CGRectMake(10.0, 8.0, 302.0, 29.0);
    _segmentControl.selectedSegmentIndex = 0;
    _segmentControl.segmentedControlStyle = UISegmentedControlStylePlain;
    _segmentControl.momentary = NO;
    
    [_segmentControl addTarget:self action:@selector(didClicksegmentedControlAction:)forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:_segmentControl];
    
//    MomentsViewController *commentList  = [[MomentsViewController alloc]init];
//    commentList.titleName = name;
//    commentList.fromName = @"school";
//    commentList.cid = @"0";

}

- (void)didClicksegmentedControlAction:(UISegmentedControl *)Seg{
    NSInteger Index = Seg.selectedSegmentIndex;
    NSLog(@"Index %i", Index);
    switch (Index) {
        case 0:
            //            [self selectmyView1];
            break;
        case 1:
            //            [self selectmyView2];
            break;
        default:
            break;
    }
}

@end
