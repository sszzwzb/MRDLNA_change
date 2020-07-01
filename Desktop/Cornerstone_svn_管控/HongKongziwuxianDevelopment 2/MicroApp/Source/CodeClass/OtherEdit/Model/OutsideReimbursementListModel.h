//
//  OutsideReimbursementListModel.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/15.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface OutsideReimbursementListModel : NSObject



#pragma mark - 剩余油量

@property (nonatomic,strong) NSString *InfoID;  //  :21012,
@property (nonatomic,strong) NSString *orderName;  //  ":"香港-澳门",
@property (nonatomic,strong) NSString *airplaneType;  //  ":"N3333Q",
@property (nonatomic,strong) NSString *departureDate;  //  ":"2018-10-02 08:00",
@property (nonatomic,strong) NSString *PicUrl;  //  ":[     包含   InfoID   urlpath  的 json 数组
@property (nonatomic,strong) NSString *Memo;  //  ":"在线的",
@property (nonatomic,strong) NSString *oilnum;  //  ":"52"




#pragma mark - 外采报销
@property (nonatomic,strong) NSString *subsidiesamount;  




@end

NS_ASSUME_NONNULL_END
