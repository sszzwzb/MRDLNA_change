//
//  AFNManagerRequest.m
//  QIANXIAOCHUAN3NEW
//
//  Created by kaiyi on 2017/4/21.
//  Copyright © 2017年 kaiyi. All rights reserved.
//

#import "AFNManagerRequest.h"


#define KUtilityError                       @"加载失败"  //后台更新，请稍后重试"
#define KUtilityName                        [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]

static AFNManagerRequest * setSharedInstance;

@interface AFNManagerRequest () <UIAlertViewDelegate>

@end

@implementation AFNManagerRequest

/**
 *  类方法
 */
+ (AFNManagerRequest *)sharedUtil {
    
    if(setSharedInstance==nil){
        static dispatch_once_t  onceToken;
        
        dispatch_once(&onceToken, ^{
            setSharedInstance = [[AFNManagerRequest alloc] init];
            
        });
    }
    return setSharedInstance;
}


/**
 * AF网络请求
 */
+(void)requestAFURL:(NSString *)URLString
         httpMethod:(NSInteger)method
         parameters:(id)parameters
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    
    //  0.网络链接失败
    if (![Utility isNetAvilible]) {
        [[ReachabilityUtility shareNetwork] up_isNetworAccess];  ///    重复，放在外面的单利
        return;
    }
    
    UIApplication *app=[UIApplication sharedApplication];
    //设置指示器的联网动画
    app.networkActivityIndicatorVisible=YES;  ///   有  NO  无
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置  30s
    manager.requestSerializer.timeoutInterval = 300;
    
    
    //证书绑定 样式（无） AFSSLPinningModeNone  ?????
    //            AFSecurityPolicy *policy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    //            policy.allowInvalidCertificates = YES;
    //            policy.validatesDomainName = NO;
    //            manager.securityPolicy = policy;
    
    
    // 5.选择请求方式 GET 或 POST
    switch (method) {
        case METHOD_GET:
        {
            [manager GET:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                UIApplication *app=[UIApplication sharedApplication];
                //设置指示器的联网动画
                app.networkActivityIndicatorVisible=NO;  ///   有  NO  无
                
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                if(succeed) {
                    succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
                }
                
                //                NSLog(@"\n 请求成功:%@\n\n",[AFNManagerRequest dictionaryWithJsonString:responseStr]);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                if(failure) {
                    failure(error);
                }
                
                NSLog(@"\n 请求失败:%@\n\n",error);
            }];
        }
            break;
            
        case METHOD_POST:
        {
            //  正常的 body form-data 请求
            [manager POST:URLString parameters:parameters progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
                
                UIApplication *app=[UIApplication sharedApplication];
                //设置指示器的联网动画
                app.networkActivityIndicatorVisible=NO;  ///   有  NO  无
                
                NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
                
                if(succeed) {
                    succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
                }
                
                //                NSLog(@"\n 请求成功:%@\n\n",[AFNManagerRequest dictionaryWithJsonString:responseStr]);
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
                if(failure) {
                    failure(error);
                }
                
                NSLog(@"\n 请求失败:%@\n\n",error);
                
            }];
        }
            break;
        case METHOD_POST_RAW:
        {
            
            //  body raw 请求
            NSError *parseError = nil;
            NSData *jsonData = [NSJSONSerialization dataWithJSONObject:parameters options:NSJSONWritingPrettyPrinted error:&parseError];
            
            
            AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
            
            NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:URLString parameters:nil error:nil];
            
            req.timeoutInterval= [[[NSUserDefaults standardUserDefaults] valueForKey:@"timeoutInterval"] longValue];
            [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
            [req setHTTPBody:jsonData];
            
            [[manager dataTaskWithRequest:req completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
                
                if (!error) {
                    UIApplication *app=[UIApplication sharedApplication];
                    //设置指示器的联网动画
                    app.networkActivityIndicatorVisible=NO;  ///   有  NO  无
                    
                    if(succeed) {
                        succeed(responseObject);
                    }
                    
                    //                    NSLog(@"成功: %@",responseObject);
                } else {
                    
                    if(failure) {
                        failure(error);
                    }
                    NSLog(@"Error: %@, %@, %@", error, response, responseObject);
                }
            }] resume];
        }
            break;
            
        default:
            break;
    }
}


/**
 * 上传单张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
          imagePath:(NSString *)imagePath
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    
    
    //  -1.网络链接失败
    if (![Utility isNetAvilible]) {
        [[ReachabilityUtility shareNetwork] up_isNetworAccess];
        return;
    }
    
    UIApplication *app=[UIApplication sharedApplication];
    //设置指示器的联网动画
    app.networkActivityIndicatorVisible=YES;  ///   有  NO  无
    
    
    // 0.设置API地址
    //    URLString = [NSString stringWithFormat:@"%@%@",HOST_IP,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    NSLog(@"\n POST上传单张图片参数列表:%@\n\n%@\n",parameters,[AFNManagerRequest URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置  15s
    manager.requestSerializer.timeoutInterval = 300;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        NSLog(@"上传成功");
        
        // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
        // 要解决此问题，
        // 可以在上传时使用当前的系统事件作为文件名
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";   // 设置时间格式
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
        
        
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:imagePath] name:@"avatar" fileName:fileName mimeType:@"image/png" error:nil];
        
        //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/  imgFile  是服务器的名字
        //        [formData appendPartWithFileData:imageData name:@"avatar" fileName:fileName mimeType:@"image/png"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        UIApplication *app=[UIApplication sharedApplication];
        
        NSLog(@"上传进度");
        
        //设置指示器的联网动画
        app.networkActivityIndicatorVisible=NO;  ///   有  NO  无
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
    
}


/**
 * 上传多张图片
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
     imageDataArray:(NSArray *)imageDataArray
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    
    
    //  -1.网络链接失败
    if (![Utility isNetAvilible]) {
        [[ReachabilityUtility shareNetwork] up_isNetworAccess];
        return;
    }
    
    
    
    // 0.设置API地址
    //    URLString = [NSString stringWithFormat:@"%@%@",HOST_IP,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    //    NSLog(@"\n POST上传多张图片参数列表:%@\n\n%@\n",parameters,[AFNManagerRequest URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 300;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        for (int i = 0; i<imageDataArray.count; i++){
            
//            NSData *imageData = imageDataArray[i];
            
            // 在网络开发中，上传文件时，是文件不允许被覆盖，文件重名
            // 要解决此问题，
            // 可以在上传时使用当前的系统事件作为文件名
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            // 设置时间格式
            formatter.dateFormat = @"yyyyMMddHHmmssSSS";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            NSString *fileName = [NSString stringWithFormat:@"%@.png", str];
            NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
            
            //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名    fileName 上传的名字，服务器接到的名字  */
            
            //  NSData 的方式
//            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
            
            //  url 的方式
            [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageDataArray[i]] name:name fileName:fileName mimeType:@"image/png" error:nil];
        }
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}


/**
 * 上传多张图片   不可复用DIY
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
    imageDataArray0:(NSArray *)imageDataArray0
    imageDataArray1:(NSArray *)imageDataArray1
    imageDataArray2:(NSArray *)imageDataArray2
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    
    
    //  -1.网络链接失败
    if (![Utility isNetAvilible]) {
        [[ReachabilityUtility shareNetwork] up_isNetworAccess];
        return;
    }
    
    
    
    // 0.设置API地址
    //    URLString = [NSString stringWithFormat:@"%@%@",HOST_IP,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    //    NSLog(@"\n POST上传多张图片参数列表:%@\n\n%@\n",parameters,[AFNManagerRequest URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 1500;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        if (imageDataArray0.count > 0) {
            for (int i = 0; i<imageDataArray0.count; i++){
                

                
                //  截取字符串， 最后一个 / 后面的为上传名字    28 位不变
                NSString *pathUrl = imageDataArray0[i];
                
                NSString *fileName = [NSString stringWithFormat:@"%@", [pathUrl substringWithRange:NSMakeRange([pathUrl length] - 28, 28)]];
                NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
                
                //将得到的二进制图片拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名    fileName 上传图片的名字，服务器接到的名字  */
                
                //                NSData *imageData = imageData[i];
                //  NSData 的方式
                //            [formData appendPartWithFileData:imageData name:name fileName:fileName mimeType:@"image/png"];
                
                //  url 的方式
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageDataArray0[i]] name:name fileName:fileName mimeType:@"image/png" error:nil];
            }
        }
        
        if (imageDataArray1.count > 0) {
            for (int i = 0; i<imageDataArray1.count; i++){
                NSString *pathUrl = imageDataArray1[i];
                NSString *fileName = [NSString stringWithFormat:@"%@", [pathUrl substringWithRange:NSMakeRange([pathUrl length] - 28, 28)]];
                NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
                
                //  url 的方式
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageDataArray1[i]] name:name fileName:fileName mimeType:@"image/png" error:nil];
            }
        }
        if (imageDataArray2.count > 0) {
            for (int i = 0; i<imageDataArray2.count; i++){
                NSString *pathUrl = imageDataArray2[i];
                NSString *fileName = [NSString stringWithFormat:@"%@", [pathUrl substringWithRange:NSMakeRange([pathUrl length] - 28, 28)]];
                NSString *name = [NSString stringWithFormat:@"image_%d.png",i ];
                
                //  url 的方式
                [formData appendPartWithFileURL:[NSURL fileURLWithPath:imageDataArray2[i]] name:name fileName:fileName mimeType:@"image/png" error:nil];
            }
        }
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}



/**
 * 上传文件
 */
+(void)requestAFURL:(NSString *)URLString
         parameters:(id)parameters
           fileData:(NSData *)fileData
            succeed:(void (^)(id))succeed
            failure:(void (^)(NSError *))failure
{
    
    //  -1.网络链接失败
    if (![Utility isNetAvilible]) {
        [[ReachabilityUtility shareNetwork] up_isNetworAccess];
        return;
    }
    
    
    //    // 0.设置API地址
    //    URLString = [NSString stringWithFormat:@"%@%@",HOST_IP,[URLString stringByReplacingOccurrencesOfString:@" " withString:@"%20"]];
    
    //    NSLog(@"\n POST上传文件参数列表:%@\n\n%@\n",parameters,[Utilit URLEncryOrDecryString:parameters IsHead:false]);
    
    // 1.创建请求管理者
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    // 2.申明返回的结果是二进制类型
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    // 3.如果报接受类型不一致请替换一致text/html  或者 text/plain
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/plain", nil];
    
    // 4.请求超时，时间设置
    manager.requestSerializer.timeoutInterval = 50;
    
    // 5. POST数据
    [manager POST:URLString  parameters:parameters  constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        //将得到的二进制数据拼接到表单中 /** data,指定上传的二进制流;name,服务器端所需参数名*/
        [formData appendPartWithFileData :fileData name:@"file" fileName:@"audio.MP3" mimeType:@"audio/MP3"];
        
    }progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        NSString *responseStr =  [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        succeed([AFNManagerRequest dictionaryWithJsonString:responseStr]);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        failure(error);
    }];
}


/*json
 * @brief 把格式化的JSON格式的字符串转换成字典
 * @param jsonString JSON格式的字符串
 * @return 返回字典
 */
+(NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&error];
    if(error) {
        NSLog(@"json解析失败：%@",error);
        return nil;
    }
    return dic;
}


/*json
 * @brief 把字典转换成字符串
 * @param jsonString JSON格式的字符串
 * @return 返回字符串
 */
+(NSString*)URLEncryOrDecryString:(NSDictionary *)paramDict IsHead:(BOOL)_type
{
    
    NSArray *keyAry =  [paramDict allKeys];
    NSString *encryString = @"";
    for (NSString *key in keyAry)
    {
        NSString *keyValue = [paramDict valueForKey:key];
        encryString = [encryString stringByAppendingFormat:@"&"];
        encryString = [encryString stringByAppendingFormat:@"%@",key];
        encryString = [encryString stringByAppendingFormat:@"="];
        encryString = [encryString stringByAppendingFormat:@"%@",keyValue];
    }
    
    return encryString;
}


@end







@interface ReachabilityUtility ()

@end

#define KUtilityTitle                       @"无法连接网络"
#define KUtilityMessage                     [NSString stringWithFormat:@"请确认您已经连接互联网，并且打开%@“无线数据”访问权限。如果无法看到“无线数据”选项，则遇到iOS系统Bug，解决方案：请在设置中选择其他任意一个有“无线数据”选项的app，更改一下“无线数据选项”，再改回来。回到%@即可。",KUtilityName,KUtilityName]

static ReachabilityUtility *dbhandler = nil;

@implementation ReachabilityUtility

+ (instancetype)shareNetwork
{
    if(dbhandler==nil){
        static dispatch_once_t once_token;
        dispatch_once(&once_token, ^{
            dbhandler=[[ReachabilityUtility alloc]init];
        });
    }
    return dbhandler;
}

- (void)up_isNetworAccess
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:KUtilityError message:KUtilityMessage delegate:self cancelButtonTitle:@"设置权限" otherButtonTitles: @"取消",nil];
    [alert show];
}

//  UIAlertView  代理
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        NSLog(@"1  取消");
    }
    if (buttonIndex == 0) {
        
        //   进入设置权限
        NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        
        if([[UIApplication sharedApplication] canOpenURL:url]) {
            
            NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if (@available(iOS 10.0, *)) {
                [[UIApplication sharedApplication] openURL:url options:@{} completionHandler:nil];
            } else {
                // Fallback on earlier versions
                [[UIApplication sharedApplication] openURL:url];
            }
            
        }
        
    }
}

@end

