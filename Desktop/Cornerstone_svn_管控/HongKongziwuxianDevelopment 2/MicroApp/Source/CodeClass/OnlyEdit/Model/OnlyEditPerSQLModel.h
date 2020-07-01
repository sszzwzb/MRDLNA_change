//
//  OnlyEditPerSQLModel.h
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "JKDBModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface OnlyEditPerSQLModel : JKDBModel



#pragma mark - 机型
@property (nonatomic, copy) NSString *InfoID;  //  :4640,
@property (nonatomic, copy) NSString *airplaneType;  //  ":"B3367",
@property (nonatomic, copy) NSString *city;  //  ":"天津",
@property (nonatomic, copy) NSString *state;  //  ":"适航",
@property (nonatomic, copy) NSString *chinaname;  //  ":"挑战者850",
@property (nonatomic, copy) NSString *englishname;  //  ":"CL85",
@property (nonatomic, copy) NSString *personcount;  //  ":"14",
@property (nonatomic, copy) NSString *wxamount;  //  ":"40000/小时+机场费用",
@property (nonatomic, copy) NSString *lowamount;  //  ":"35000/小时+机场费用"


#pragma mark - 选择好的机型
//"InfoID":20992,
//"airplaneType":"N3333Q",
@property (nonatomic, copy) NSString *orderName;   //  "澳门-大连",
@property (nonatomic, copy) NSString *departureDate;   //  "2018-10-02 17:30"

@property (nonatomic,strong) NSString *selectForCell;   //  自己添加的字段
@property (nonatomic,strong) NSString *selectIsNo;   //  自己添加的字段  禁止点击的效果


#pragma mark - 已完成列表
@property (nonatomic,strong) NSString *PicUrl;  //  json格式的图片



#pragma mark - DB 存储数据
@property (nonatomic,strong) NSString *selectDateStr;  //  选择的日期
@property (nonatomic,strong) NSString *selectAirPlaneType;  //  选择的日期
@property (nonatomic,strong) NSString *selectAirPlaneTypeInfoId;  //  选择的日期 infoId

@property (nonatomic,strong) NSString *selectDateForSection0Model_orderName;  //  选择的名字
@property (nonatomic,strong) NSString *selectDateForSection0Model_airplaneType;  //  选择的飞机航段
@property (nonatomic,strong) NSString *selectDateForSection0Model_departureDate;  //  选择的状态
@property (nonatomic,strong) NSString *selectDateForSection0Model_selectForCell;  //  选择的状态  只有  YES
@property (nonatomic,strong) NSString *dataArrForSection0ToJsonStr;   //   所有数据的json格式

@property (nonatomic,strong) NSString *imgsDic0PathName;  //   图片只有名字  的json格式
@property (nonatomic,strong) NSString *imgsDic1PathName;
@property (nonatomic,strong) NSString *imgsDic2PathName;

@property (nonatomic,strong) NSString *imgsTextDic0;  //  图片对应的文字
@property (nonatomic,strong) NSString *imgsTextDic1;
@property (nonatomic,strong) NSString *imgsTextDic2;

@property (nonatomic,strong) NSString *saveState;  //  保存状态  草稿0   待上传1   完成（删除）2


@property (nonatomic,assign) NSInteger primaryKey;  //  当前页面的主键




+(instancetype)shareDB;


//  插入
+(void)insertDataWithselectDateStr:(NSString *)selectDateStr
                selectAirPlaneType:(NSString *)selectAirPlaneType
selectDateForSection0Model_orderName:(NSString *)selectDateForSection0Model_orderName
selectDateForSection0Model_airplaneType:(NSString *)selectDateForSection0Model_airplaneType
selectDateForSection0Model_departureDate:(NSString *)selectDateForSection0Model_departureDate
selectDateForSection0Model_selectForCell:(NSString *)selectDateForSection0Model_selectForCell
       dataArrForSection0ToJsonStr:(NSString *)dataArrForSection0ToJsonStr
                  imgsDic0PathName:(NSString *)imgsDic0PathName
                  imgsDic1PathName:(NSString *)imgsDic1PathName
                  imgsDic2PathName:(NSString *)imgsDic2PathName
                      imgsTextDic0:(NSString *)imgsTextDic0
                      imgsTextDic1:(NSString *)imgsTextDic1
                      imgsTextDic2:(NSString *)imgsTextDic2
                         saveState:(NSString *)saveState
          selectAirPlaneTypeInfoId:(NSString *)selectAirPlaneTypeInfoId;

//  更新
+(void)upDataWithselectDateStr:(NSString *)selectDateStr
            selectAirPlaneType:(NSString *)selectAirPlaneType
selectDateForSection0Model_orderName:(NSString *)selectDateForSection0Model_orderName
selectDateForSection0Model_airplaneType:(NSString *)selectDateForSection0Model_airplaneType
selectDateForSection0Model_departureDate:(NSString *)selectDateForSection0Model_departureDate
selectDateForSection0Model_selectForCell:(NSString *)selectDateForSection0Model_selectForCell
   dataArrForSection0ToJsonStr:(NSString *)dataArrForSection0ToJsonStr
              imgsDic0PathName:(NSString *)imgsDic0PathName
              imgsDic1PathName:(NSString *)imgsDic1PathName
              imgsDic2PathName:(NSString *)imgsDic2PathName
                  imgsTextDic0:(NSString *)imgsTextDic0
                  imgsTextDic1:(NSString *)imgsTextDic1
                  imgsTextDic2:(NSString *)imgsTextDic2
                     saveState:(NSString *)saveState
      selectAirPlaneTypeInfoId:(NSString *)selectAirPlaneTypeInfoId
                    primaryKey:(int)primaryKey;

//  删除
-(void)removeData;

//   查
-(OnlyEditPerSQLModel *)executeData;


//   查询是否新建过
+(BOOL)executeDataiIsHaveForModel:(OnlyEditPerSQLModel *)model;

//   分页查
-(NSArray *)executeDataForPage:(NSInteger)page saveState:(NSString *)saveState;

@end

NS_ASSUME_NONNULL_END
