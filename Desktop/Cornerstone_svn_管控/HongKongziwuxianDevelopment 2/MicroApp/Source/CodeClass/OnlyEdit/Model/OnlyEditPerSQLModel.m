//
//  OnlyEditPerSQLModel.m
//  MicroApp
//
//  Created by kaiyi on 2018/10/8.
//  Copyright © 2018年 kaiyi. All rights reserved.
//

#import "OnlyEditPerSQLModel.h"

static OnlyEditPerSQLModel *dbhandler = nil;

@interface OnlyEditPerSQLModel ()


@end

@implementation OnlyEditPerSQLModel


-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

+(instancetype)shareDB{
    if(dbhandler==nil){
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            dbhandler=[[OnlyEditPerSQLModel alloc]init];
        });
    }
    return dbhandler;
}



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
          selectAirPlaneTypeInfoId:(NSString *)selectAirPlaneTypeInfoId
{
    dispatch_queue_t q1 = dispatch_queue_create("queue1", NULL);
    dispatch_async(q1, ^{
        
        OnlyEditPerSQLModel *user = [OnlyEditPerSQLModel new];
        
        user.selectDateStr = [Utilities replaceNull:selectDateStr];
        user.selectAirPlaneType = [Utilities replaceNull:selectAirPlaneType];
        user.selectDateForSection0Model_orderName = [Utilities replaceNull:selectDateForSection0Model_orderName];
        user.selectDateForSection0Model_airplaneType = [Utilities replaceNull:selectDateForSection0Model_airplaneType];
        user.selectDateForSection0Model_departureDate = [Utilities replaceNull:selectDateForSection0Model_departureDate];
        user.selectDateForSection0Model_selectForCell = [Utilities replaceNull:selectDateForSection0Model_selectForCell];
        user.dataArrForSection0ToJsonStr = [Utilities replaceNull:dataArrForSection0ToJsonStr];
        user.imgsDic0PathName = [Utilities replaceNull:imgsDic0PathName];
        user.imgsDic1PathName = [Utilities replaceNull:imgsDic1PathName];
        user.imgsDic2PathName = [Utilities replaceNull:imgsDic2PathName];
        user.imgsTextDic0 = [Utilities replaceNull:imgsTextDic0];
        user.imgsTextDic1 = [Utilities replaceNull:imgsTextDic1];
        user.imgsTextDic2 = [Utilities replaceNull:imgsTextDic2];
        user.saveState = [Utilities replaceNull:saveState];
        user.selectAirPlaneTypeInfoId = [Utilities replaceNull:selectAirPlaneTypeInfoId];
        [user save];
    });
}

//  更新单个数据
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
                    primaryKey:(int)primaryKey
{
        
    OnlyEditPerSQLModel *user = [OnlyEditPerSQLModel new];
        
    user.pk = primaryKey;  //  主键查找
        
    user.selectDateStr = [Utilities replaceNull:selectDateStr];
    user.selectAirPlaneType = [Utilities replaceNull:selectAirPlaneType];
    user.selectDateForSection0Model_orderName = [Utilities replaceNull:selectDateForSection0Model_orderName];
    user.selectDateForSection0Model_airplaneType = [Utilities replaceNull:selectDateForSection0Model_airplaneType];
    user.selectDateForSection0Model_departureDate = [Utilities replaceNull:selectDateForSection0Model_departureDate];
    user.selectDateForSection0Model_selectForCell = [Utilities replaceNull:selectDateForSection0Model_selectForCell];
    user.dataArrForSection0ToJsonStr = [Utilities replaceNull:dataArrForSection0ToJsonStr];
    user.imgsDic0PathName = [Utilities replaceNull:imgsDic0PathName];
    user.imgsDic1PathName = [Utilities replaceNull:imgsDic1PathName];
    user.imgsDic2PathName = [Utilities replaceNull:imgsDic2PathName];
    user.imgsTextDic0 = [Utilities replaceNull:imgsTextDic0];
    user.imgsTextDic1 = [Utilities replaceNull:imgsTextDic1];
    user.imgsTextDic2 = [Utilities replaceNull:imgsTextDic2];
    user.saveState = [Utilities replaceNull:saveState];
    user.selectAirPlaneTypeInfoId = [Utilities replaceNull:selectAirPlaneTypeInfoId];
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [user update];
    });
    
}

//  删除
-(void)removeData
{
    [OnlyEditPerSQLModel deleteObjectsWithFormat:@"Where %@ < %d",@"pk",10];
}


//   单查
-(OnlyEditPerSQLModel *)executeData
{
    OnlyEditPerSQLModel *user = [OnlyEditPerSQLModel findFirstWithFormat:@" WHERE %@ = %d ",@"pk",3];
    if (!user)  return [OnlyEditPerSQLModel new];
    return user;
}


//   查询是否新建过
+(BOOL)executeDataiIsHaveForModel:(OnlyEditPerSQLModel *)model
{
    if (model) {
        OnlyEditPerSQLModel *modelDB = [OnlyEditPerSQLModel findFirstWithFormat:@" WHERE selectDateForSection0Model_orderName = '%@' and selectDateForSection0Model_departureDate = '%@' and selectDateForSection0Model_airplaneType = '%@'", model.orderName, model.departureDate, model.airplaneType];
        
        if (modelDB) {
            if ([modelDB.orderName isEqualToString:model.orderName]) {
                return NO;
            } else {
                return YES;
            }
        } else {
            return NO;
        }
    }
    return NO;
}

//   分页查
-(NSArray *)executeDataForPage:(NSInteger)page saveState:(NSString *)saveState
{
    int pk = (int)page * 10;
    //   @" WHERE pk > %d  AND saveState = %@ limit 10"     查找  saveState = 什么的 正序排序 ， 每次加载10个
    //   倒序排列  order by pk desc
    NSArray *array = [OnlyEditPerSQLModel findByCriteria:[NSString stringWithFormat:@" WHERE pk > %d  AND saveState = %@ order by pk desc limit 10", pk, saveState]];
    pk = ((OnlyEditPerSQLModel *)[array lastObject]).pk;
//    [self.data addObjectsFromArray:array];
    return array;
}

@end
