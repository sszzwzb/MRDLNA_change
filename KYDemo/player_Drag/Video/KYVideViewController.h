//
//  KYVideViewController.h
//  player_Drag
//
//  Created by kaiyi on 2021/8/11.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface KYVideViewController : UIViewController

@property (nonatomic,strong) NSString *videoUrl;
@property (nonatomic,strong) NSString *videoCover;
@property (nonatomic,assign) NSInteger curLastVideoTime;  //  最长播放时间 s

@end

NS_ASSUME_NONNULL_END
