//
//  TSNetworking.m
//  MicroSchool
//
//  Created by jojo on 15/3/3.
//  Copyright (c) 2015年 jiaminnet. All rights reserved.
//

#import "TSNetworking.h"

#import "Utilities.h"

@implementation TSNetworking


#if 0
+ (TSNetworking *)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HttpMethod)httpMethod
                             successBlock:(HTTPRequestSuccessBlock)successReqBlock
                              failedBlock:(HTTPRequestFailedBlock)failedReqBlock
{
    
    return [self requestWithBaseURLStr:URLString params:params httpMethod:httpMethod userInfo:nil successBlock:successReqBlock failedBlock:failedReqBlock];
}

+ (TSNetworking *)requestWithBaseURLStr:(NSString *)URLString
                                   params:(NSDictionary *)params
                               httpMethod:(HttpMethod)httpMethod
                                 userInfo:(NSDictionary*)userInfo
                             successBlock:(HTTPRequestSuccessBlock)successReqBlock
                              failedBlock:(HTTPRequestFailedBlock)failedReqBlock
{
    TSNetworking *httpV2 =  [[TSNetworking alloc] init];
    httpV2.userInfo = userInfo;

    CGFloat  sysVersion = [[UIDevice currentDevice].systemVersion floatValue];
    if (sysVersion < 7.0) {
        AFHTTPRequestOperationManager   *httpClient = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:nil];
        if (httpMethod == HttpMethodGet) {
            
            [httpClient GET:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
        }else if (httpMethod == HttpMethodPost){
            
            
            [httpClient POST:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
        }else if (httpMethod == HttpMethodDelete){
            
            
            [httpClient DELETE:URLString parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
        }
        
    }else{
        AFHTTPSessionManager   *httpClient = [[AFHTTPSessionManager alloc] initWithBaseURL:nil];
        if (httpMethod == HttpMethodGet) {
            
            [httpClient GET:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
        }else if (httpMethod == HttpMethodPost){
//            httpClient.responseSerializer = [AFJSONResponseSerializer serializer];
//            httpClient.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
//            httpClient.requestSerializer.timeoutInterval = 100;


            [httpClient POST:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
        }else if (httpMethod == HttpMethodDelete){
            
            [httpClient DELETE:URLString parameters:params success:^(NSURLSessionDataTask *task, id responseObject) {
                if (successReqBlock) {
                    successReqBlock(httpV2, responseObject);
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                if (failedReqBlock) {
                    failedReqBlock(httpV2, error);
                }
            }];
            
            
        }
        
    }
    
    return httpV2;
}

+ (void)cancelAllRequest
{
//    [[APIClient sharedClient].operationQueue cancelAllOperations];
}
#endif














+ (instancetype)sharedClient
{
    static TSNetworking *_shared = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _shared = [[self alloc] init];
    });
    
    return _shared;
}

- (instancetype)init
{
    if (self = [super initWithBaseURL:[NSURL URLWithString:API_BASE]]) {
    }
    return self;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                            completionHandler:(void (^)(NSURLResponse *, id, NSError *))completionHandler
{
    NSMutableURLRequest *mutableRequest = [request mutableCopy];
    mutableRequest.timeoutInterval = 75.0;
    [mutableRequest setHTTPMethod:@"POST"];
    [mutableRequest addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];

    if (NetworkingReqTypePost == _reqType) {
        // nothing to do
    }else if (NetworkingReqTypePostWithFile == _reqType) {
        [mutableRequest addValue:@"multipart/form-data;" forHTTPHeaderField:@"enctype"];
    }

    return [super dataTaskWithRequest:mutableRequest completionHandler:completionHandler];
}

- (void)requestWithBaseURLAndParams:(NSDictionary *)params
                       successBlock:(HTTPRequestSuccessBlock)successReqBlock
                        failedBlock:(HTTPRequestFailedBlock)failedReqBlock
{
    _reqType = NetworkingReqTypePost;
    
    // 先拼接url，添加上uid，version等字段
    NSString *reqUrl = [self dealWithReqUrl:API_URL];
    
    // 添加通用的请求key，比如uid，sid等。
    NSMutableDictionary *reqParam = [NSMutableDictionary dictionaryWithDictionary:params];
    [self setCommonParams:reqParam];
    
//    NSLog(@"params == %@",reqParam);
    
    [self POST:reqUrl parameters:reqParam success:^(NSURLSessionDataTask *task, id responseObject) {
        if (successReqBlock) {
            NSDictionary *responseDic = (NSDictionary*)responseObject;

            // 这里简单做一个容错，如果返回结构体为空或者message字段为空，就认为是数据问题
            if ((nil != responseDic) && (nil != [responseDic objectForKey:@"message"])) {
                successReqBlock(self, responseObject);
            }else {
                // 数据问题
                failedReqBlock(self, ReqErrorCannotDecodeContentData);
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        if (failedReqBlock) {
            NSLog(@"TSNetworking request err code is = %ld.", (long)error.code);

            if (NSURLErrorCancelled == error.code) {
                // we cancel task ourself，
                // so nothing to do.
            }else if (NSURLErrorTimedOut == error.code) {
                // req timeout
                failedReqBlock(self, ReqErrorTimeOut);
            }else if (NSURLErrorNotConnectedToInternet == error.code){
                // network issue, could not connect server.
                failedReqBlock(self, ReqErrorNotConnectedToInternet);
            }else if (NSURLErrorCannotDecodeContentData == error.code){
                // the data from server can not be analyze,
                // eg: server sql error.
                failedReqBlock(self, ReqErrorCannotDecodeContentData);
            }else if (NSURLErrorBadServerResponse == error.code){
                // the data from server bad response
                failedReqBlock(self, ReqErrorBadServerResponse);
            }else {
                // unkonwn error.
                failedReqBlock(self, ReqErrorOther);
            }
        }
    }];
}

- (void)requestGetFileWithCustomizeURL:(NSString *)urlString
                                params:(NSDictionary *)params
                          successBlock:(HTTPRequestSuccessBlock)successReqBlock
                           failedBlock:(HTTPRequestFailedBlock)failedReqBlock;
{
    _reqType = NetworkingReqTypeGetFile;
    
    NSMutableDictionary *reqParam = [NSMutableDictionary dictionaryWithDictionary:params];
    [self setCommonParams:reqParam];

//    NSProgress *progress;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];

    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:nil destination: ^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        
        successReqBlock(self, [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);

        
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
        
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        NSLog(@"File downloaded to: %@", filePath);
    }];
    
    [downloadTask resume];
    
    
    
//    NSURLSessionDownloadTask *downloadTask = [self downloadTaskWithRequest:request progress:&progress destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        // …
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        [progress removeObserver:self forKeyPath:@"fractionCompleted" context:NULL];
//        // …
//    }];
//    
//    [downloadTask resume];
    
    
    
    
    
}

- (void)requestWithCustomizeURL:(NSString *)urlString
                         params:(NSDictionary *)params
                   successBlock:(HTTPRequestSuccessBlock)successReqBlock
                    failedBlock:(HTTPRequestFailedBlock)failedReqBlock
{
    _reqType = NetworkingReqTypePostWithFile;
    
    // 先拼接url，添加上uid，version等字段
    NSString *reqUrl = [self dealWithReqUrl:urlString];

    // 添加通用的请求key，比如uid，sid等。
    NSMutableDictionary *reqParam = [NSMutableDictionary dictionaryWithDictionary:params];
    [self setCommonParams:reqParam];
    
    [self POST:reqUrl parameters:reqParam constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        // 如果有传files，遍历array取出key与value，并且设置到请求中。
        NSArray *filesArr = [params objectForKey:@"files"];
        if (0 != [filesArr count]) {
            for(id obj in filesArr) {
                NSDictionary *fileDic = (NSDictionary *)obj;
                NSEnumerator * enumerator = [fileDic keyEnumerator];
                
                // 取出相应的key与value
                NSString *key = [enumerator nextObject];
                NSString *value = [fileDic objectForKey:key];

                if ([@"png"  isEqual: [params objectForKey:@"fileType"]]) {
                    // 图片
                    // 这里需不需要再次压缩tbd一下
                    NSData *imageData = UIImageJPEGRepresentation([UIImage imageWithContentsOfFile:value], 0.6);
                    [formData appendPartWithFileData:imageData name:key fileName:@"fileName.jpg" mimeType:@"image/jpeg"];
                }else if ([@"amr"  isEqual: [params objectForKey:@"fileType"]]) {
                    // 语音
                    NSData *amrData = [NSData dataWithContentsOfFile:value];
                    [formData appendPartWithFileData:amrData name:key fileName:@"fileName.amr" mimeType:@"audio/amr"];
                }else if ([@"file"  isEqual: [params objectForKey:@"fileType"]]) {
                    // 文件
                }
            }
        }
    }
       success:^(NSURLSessionDataTask *task, id responseObject) {
           NSDictionary *responseDic = (NSDictionary*)responseObject;
           
           // 这里简单做一个容错，如果返回结构体为空或者message字段为空，就认为是数据问题
           if ((nil != responseDic) && (nil != [responseDic objectForKey:@"message"])) {
               successReqBlock(self, responseObject);
           }else {
               // 数据问题
               failedReqBlock(self, ReqErrorCannotDecodeContentData);
           }
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           NSLog(@"TSNetworking request err code is = %ld.", (long)error.code);
           
           if (NSURLErrorCancelled == error.code) {
               // we cancel task ourself，
               // so nothing to do.
           }else if (NSURLErrorTimedOut == error.code) {
               // req timeout
               failedReqBlock(self, ReqErrorTimeOut);
           }else if (NSURLErrorNotConnectedToInternet == error.code){
               // network issue, could not connect server.
               failedReqBlock(self, ReqErrorNotConnectedToInternet);
           }else if (NSURLErrorCannotDecodeContentData == error.code){
               // the data from server can not be analyze,
               // eg: server sql error.
               failedReqBlock(self, ReqErrorCannotDecodeContentData);
           }else if (NSURLErrorBadServerResponse == error.code){
               // the data from server bad response
               failedReqBlock(self, ReqErrorBadServerResponse);
           }else {
               // unkonwn error.
               failedReqBlock(self, ReqErrorOther);
           }
       }];
}

- (void)cancelAll
{
    NSArray *tasks = self.tasks;
    NSArray *dataTasks = self.dataTasks;

    for (NSURLSessionTask *task in tasks) {
//        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
//        if (range.location != NSNotFound) {
            [task cancel];
//        }
    }

    
//    [self.operationQueue cancelAllOperations];
}

- (void)cancelTasksInArray:(NSArray *)tasksArray withPath:(NSString *)path
{
    for (NSURLSessionTask *task in tasksArray) {
        NSRange range = [[[[task currentRequest]URL] absoluteString] rangeOfString:path];
        if (range.location != NSNotFound) {
            [task cancel];
        }
    }
}

- (NSString *)dealWithReqUrl:(NSString *)apiUrl
{
    // 写到请求url里面的uid，默认为""
    NSString *uid = @"";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    if (nil != userInfo) {
        // 单例里面有值的话，用单例里的值。
        uid = [userInfo objectForKey:@"uid"];
        if (nil == uid) {
            // 单例里值为空的话，把uid置""
            uid = @"";
        }
    }
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    
    // 运行版本号
    NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
    
    // 设备型号 eg:iPhone 4S
    NSString *mobile_model = [Utilities getCurrentDeviceModel];
    // 去掉型号里面的空格
    mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    // 手机系统版本 eg:8.0.2
    NSString *os_version = [[UIDevice currentDevice] systemVersion];
    
    NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
    NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
    if (nil == token) {
        token = @"";
    }
    
    NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
    key = [Utilities md5:key];
    
    NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
    
    NSString *newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@",apiUrl, api, love, key];

    return newUrl;

#if 0
    if ([[data objectForKey:@"url"]  isEqual: REQ_URL]) {
        newUrl = [NSString stringWithFormat:@"%@?__api=%@_%@_%@_%@_%@_%@",[data objectForKey:@"url"],G_SCHOOL_ID,uid,@"4", app_code, mobile_model, os_version];
    }else {
        newUrl = [NSString stringWithFormat:@"%@&__api=%@_%@_%@_%@_%@_%@",[data objectForKey:@"url"],G_SCHOOL_ID,uid,@"4",app_code, mobile_model, os_version];
    }
#endif
}

- (void)setCommonParams:(NSMutableDictionary *)reqParam
{
    // 添加统一的参数，sid
    // 如果传入了sid，则用传入的
    if (nil == [reqParam objectForKey:@"sid"]) {
        [reqParam setValue:G_SCHOOL_ID forKey:@"sid"];
    }else {
        [reqParam setValue:[reqParam objectForKey:@"sid"] forKey:@"sid"];
    }
    
    // 添加appVersion参数作为必填项
    [reqParam setValue:[Utilities getAppVersion] forKey:@"app"];

    BOOL needsUid = [self isReqNeedsUid:reqParam];
    
    // uid作为必填项，在这里做统一获取，以及异常处理
    if (needsUid) {
        NSString *uid = [reqParam objectForKey:@"uid"];
        if ((uid == nil) || ([uid  isEqual: @""]) || ([uid  isEqual: @"0"])) {
            // 用户没有传入uid，则表示需要用当前的uid
            NSString *uniqueUid = [Utilities getUniqueUid];
            [reqParam setValue:uniqueUid forKey:@"uid"];
        }else {
            // 如果用户传入了uid，则表示需要用到uid这个字段
            [reqParam setValue:uid forKey:@"uid"];
        }
    }
}

- (BOOL)isReqNeedsUid:(NSDictionary *)params
{
    BOOL isNeedsUid = YES;
    
    NSString *ac = [params objectForKey:@"ac"];
    NSString *op = [params objectForKey:@"op"];

    // 以下这些请求不需要uid字段。
    if ((([@"Register"  isEqual: ac]) && ([@"code"  isEqual: op])) ||
        (([@"Register"  isEqual: ac]) && ([@"verify"  isEqual: op])) ||
        (([@"Register"  isEqual: ac]) && ([@"desmd5code"  isEqual: op])) ||
        (([@"Register"  isEqual: ac]) && ([@"register"  isEqual: op])) ||
        (([@"Login"  isEqual: ac]) && ([@"unique"  isEqual: op])) ||
        (([@"Splash"  isEqual: ac]) && ([@"fetch"  isEqual: op])) ||
        (([@"Version"  isEqual: ac]) && ([@"check"  isEqual: op])) ||
        (([@"AppReport"  isEqual: ac]) && ([@"log"  isEqual: op])) ||
        (([@"Password"  isEqual: ac]) && ([@"forget"  isEqual: op])) ||
        (([@"Password"  isEqual: ac]) && ([@"forgets"  isEqual: op])) ||
        (([@"Password"  isEqual: ac]) && ([@"resetting"  isEqual: op])) ||
        (([@"Eduinspector"  isEqual: ac]) && ([@"profile"  isEqual: op])) ||
        (([@"School"  isEqual: ac]) && ([@"check"  isEqual: op]))) {
        
        isNeedsUid = NO;
    }
    
    return  isNeedsUid;
}



#if 0

// 调用通常api接口时的标准调用

NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                      @"",@"ac",
                      @"2",@"v",
                      @"", @"op",
                      nil];

[[TSNetworking sharedClient] requestWithBaseURLAndParams:data successBlock:^(TSNetworking *request, id responseObject) {
    [Utilities dismissProcessingHud:self.view];
    
    NSDictionary *respDic = (NSDictionary*)responseObject;
    NSString *result = [respDic objectForKey:@"result"];
    
    if(true == [result intValue]) {

    } else {
        UIAlertView* alert = [[UIAlertView alloc]initWithTitle:@"错误"
                                                       message:@"获取信息错误，请稍候再试"
                                                      delegate:nil
                                             cancelButtonTitle:@"确定"
                                             otherButtonTitles:nil];
        [alert show];
    }
    
} failedBlock:^(TSNetworking *request, TSNetworkingErrType error) {
    [Utilities doHandleTSNetworkingErr:error descView:self.view];
}];


#endif
@end
