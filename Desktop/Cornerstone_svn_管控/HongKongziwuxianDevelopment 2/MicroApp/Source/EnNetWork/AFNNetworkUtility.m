//
//  AFNNetworkUtility.m
//  CarHome
//
//  Created by kaiyi on 2017/12/19.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "AFNNetworkUtility.h"

@implementation AFNNetworkUtility

//添加
-(void)sendHttpReq:(HttpReqType)type andData:(NSDictionary*)data
{
    
    NSString *url = [NSString string];
    if ([data objectForKey:@"url"]) {
        url = [data objectForKey:@"url"];
    } else {
        url = REQ_URL;
    }
    
    
    if ([data objectForKey:@"url_stringByAppendingString"]) {
        url = [url stringByAppendingString:[data objectForKey:@"url_stringByAppendingString"]];
        NSLog(@"url = %@",url);
    }
    
    
    
    NSEnumerator * enumerator = [data keyEnumerator];
    NSString *object;
    while(object = [enumerator nextObject])
    {
        id objectValue = [data objectForKey:object];
        if(objectValue != nil)
        {
            NSLog(@"键值为：%@, 值为：%@",object, objectValue);
        }
    }
    
    
    ///  添加  app   appId   等
    data = [self addUserInfo:data];
    
    
    if (type == Http_Video) {
        
        //   上传单张图片
        if ([data objectForKey:@"png0"]) {
            
            NSData *imgData = [data objectForKey:@"png0"];
            
            [AFNManagerRequest requestAFURL:url parameters:data imageData:imgData succeed:^(id json) {
                [self requestDidSuccess:json httpReqType:type];
            } failure:^(NSError *error) {
                [self requestDidFailed:error];
            }];
            
        }
        
        
        //  图片压缩
        /**
         -(NSData *)imageToNsdata:(UIImage*)img
         {
         //以下是保存文件到沙盒路径下
         //把图片转成NSData类型的数据来保存文件
         NSData *data;
         
         return data = UIImageJPEGRepresentation(img, 0.3);
         
         }
         */
      
    } else if (type == HttpReq_FileUploadTS_ashx || type == HttpReq_FileUploadOil_ashx) {
        //  多图片上传
        
        NSArray *imgsArr0 = data[@"imgsArr"];
        
        [AFNManagerRequest requestAFURL:url parameters:data imageDataArray:imgsArr0 succeed:^(id json) {
            [self requestDidSuccess:json httpReqType:type];
        } failure:^(NSError *error) {
            [self requestDidFailed:error];
        }];
        
    } else if (type == HttpReq_FileUpload_ashx) {
        //  多图片上传  DIY
        
        NSArray *imgsArr0 = data[@"imgsArr0"];
        NSArray *imgsArr1 = data[@"imgsArr1"];;
        NSArray *imgsArr2 = data[@"imgsArr2"];;
        
        
        [AFNManagerRequest requestAFURL:url parameters:data imageDataArray0:imgsArr0 imageDataArray1:imgsArr1 imageDataArray2:imgsArr2 succeed:^(id json) {
            [self requestDidSuccess:json httpReqType:type];
        } failure:^(NSError *error) {
            [self requestDidFailed:error];
        }];
        
    } else if (type >= HttpReq_Get && type < HttpReq_Post) {
        
        //  正常的get请求
        [AFNManagerRequest requestAFURL:url httpMethod:METHOD_GET parameters:data succeed:^(id json) {
            [self requestDidSuccess:json httpReqType:type];
        } failure:^(NSError *error) {
            [self requestDidFailed:error];
        }];
    } else {
        
        //  正常的post请求
        [AFNManagerRequest requestAFURL:url httpMethod:METHOD_POST parameters:data succeed:^(id json) {
            [self requestDidSuccess:json httpReqType:type];
        } failure:^(NSError *error) {
            [self requestDidFailed:error];
        }];
    }
}


//执行成功
- (void)requestDidSuccess:(id)request httpReqType:(HttpReqType)httpReqType
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reciveHttpData:andType:)])
    {
        [self.delegate reciveHttpData:request andType:httpReqType];
    }
}

//执行失败
- (void)requestDidFailed:(NSError *)error
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(reciveHttpDataError:)])
    {
        [self.delegate reciveHttpDataError:error];
    }
}


-(NSDictionary *)addUserInfo:(NSDictionary *)dic
{
    /**
     app  移动端应用版本号（每个接口都传）    1.0.0
     appId   区分移动端应用名称（每个接口都传）    香港子午线：0
     app_code  手机型号版本     iphone 6 什么的
     app_way   区分Android，iOS，PC 途径     Android 0，iOS 1，PC 2 或其他
     */
    
    NSMutableDictionary *testDic = [NSMutableDictionary dictionaryWithDictionary:dic];
    
    //  版本号
    if (!dic[@"app"]) {
        [testDic setValue:[Utilities replaceNull:G_APP_VERSION] forKey:@"app"];
    }
    
    
    //  区分号
    if (!dic[@"appId"]) {
        [testDic setValue:G_APPID_VERSION forKey:@"appId"];
    }
    
    
    //  手机版本
    if (!dic[@"app_way"]) {
        [testDic setValue:@"1" forKey:@"app_way"];
    }
    
    return [NSDictionary dictionaryWithDictionary:testDic];
}

@end

