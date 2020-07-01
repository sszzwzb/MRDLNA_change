//
//  NetworkUtility.m
//  MicroSchool
//
//  Created by zhanghaotian on 13-11-15.
//  Copyright (c) 2013年 jiaminnet. All rights reserved.
//

#import "NetworkUtility.h"

@implementation NetworkUtility

@synthesize delegate;

-(void)sendHttpReq:(HttpReqType)type andData:(NSDictionary*)data
{
    if(HttpReq_GetFile == type) {
        NSURL *url = [NSURL URLWithString:[data objectForKey:@"url"]];
        ASIHTTPRequest *_request = [ASIHTTPRequest requestWithURL:url];
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSString *imagePath = [imageDocPath stringByAppendingPathComponent:@"xxxx"];
        
        [_request setDownloadDestinationPath :imagePath];
        
        [_request setCompletionBlock :^{
            // 请求成功
            [self httpRequestDidSuccess:_request];
        }];
        [_request setFailedBlock :^{
            // 请求失败，返回错误信息
            [self httpRequestDidFailed:_request];
        }];
        
        // 开始异步请求
        [_request startAsynchronous];
        
    } else {
        // 写到请求url里面的uid
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

        // app_code
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        NSString *app_code = [infoDictionary objectForKey:@"CFBundleVersion"];
        // 设备型号 eg:iPhone 4S
        NSString *mobile_model = [Utilities getCurrentDeviceModel];
        // 去掉型号里面的空格
        mobile_model = [mobile_model stringByReplacingOccurrencesOfString:@" " withString:@""];

        // 手机系统版本 eg:8.0.2
        NSString *os_version = [[UIDevice currentDevice] systemVersion];

        NSString *newUrl;
        
        NSString *love = [NSString stringWithFormat:@"%d", [Utilities getRandomNumber:100000 to:999999]];
        NSString *token = [[NSUserDefaults standardUserDefaults] objectForKey:USER_LOGIN_TOKEN];
        if (nil == token) {
            token = @"";
        }

        NSString *key = [NSString stringWithFormat:@"%@%@%@%@", uid, G_SCHOOL_ID, love, token];
        key = [Utilities md5:key];
        
        NSString *api = [NSString stringWithFormat:@"%@_%@_%@_%@_%@_%@", G_SCHOOL_ID, uid, @"4", app_code, mobile_model, os_version];
        
        if ([[data objectForKey:@"url"]  isEqual: REQ_URL]) {
            newUrl = [NSString stringWithFormat:@"%@?__api=%@&love=%@&key=%@",[data objectForKey:@"url"], api, love, key];

//            newUrl = [NSString stringWithFormat:@"%@?__api=%@_%@_%@_%@_%@_%@_%@_%@",[data objectForKey:@"url"],G_SCHOOL_ID,uid,@"4", app_code, mobile_model, os_version, love, key];
        }else {
            newUrl = [NSString stringWithFormat:@"%@&__api=%@&love=%@&key=%@",[data objectForKey:@"url"], api, love, key];

//            newUrl = [NSString stringWithFormat:@"%@&__api=%@_%@_%@_%@_%@_%@_%@_%@",[data objectForKey:@"url"],G_SCHOOL_ID,uid,@"4",app_code, mobile_model, os_version, love, key];
        }
        
        NSURL *url = [NSURL URLWithString:newUrl];
        ASIFormDataRequest *_request = [ASIFormDataRequest requestWithURL:url];
        request1 = _request;
        _request.timeOutSeconds = 150;//update by kate 原来值是10秒，发送9张图片超时
        [_request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [_request setRequestMethod:@"POST"];
        
        [_request setCompletionBlock :^{
            // 请求成功
            [self requestDidSuccess:_request];
        }];
        [_request setFailedBlock :^{
            // 请求失败，返回错误信息
            [self requestDidFailed:_request];
        }];
        
        if(HttpReq_RegisterPersonalTea == type) {
            // 有可能不上传图片，这里做个判断
            if (![@""  isEqual: [data objectForKey:@"idfile"]]) {
                [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
                [_request setFile:[data objectForKey:@"idfile"] forKey:@"idfile"];
            }
        }else if(HttpReq_ResendTeacherReq == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            [_request setFile:[data objectForKey:@"idfile"] forKey:@"idfile"];
        }else if(HttpReq_Avatar == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            [_request setFile:[data objectForKey:@"avatar"] forKey:@"avatar"];
        }else if(HttpReq_HomeworkSubmit == type || HttpReq_ThreadMomentsSubmit == type || HttpReq_ThreadPhotoSubmit == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            
            NSMutableDictionary *imageArray = [data objectForKey:@"imageArray"];
            
            for (int i=0; i<[imageArray count]; i++) {
                NSString *image = [NSString stringWithFormat:@"png%d",i];
                [_request setFile:[imageArray objectForKey:image] forKey:image];
            }
            
        }else if (HttpReq_ThreadPhotoSubmitVideo == type){
            
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            if ((![@""  isEqualToString: [data objectForKey:@"mp0"]])) {
                [_request setFile:[data objectForKey:@"mp0"] forKey:@"mp0"];
            }
            
            if ((![@""  isEqualToString: [data objectForKey:@"png0"]])) {
                [_request setFile:[data objectForKey:@"png0"] forKey:@"png0"];
            }
            
        }else if (Http_ThreadMomentsSubmitVideo == type){
            
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            if ((![@""  isEqualToString: [data objectForKey:@"mp0"]])) {
                [_request setFile:[data objectForKey:@"mp0"] forKey:@"mp0"];
            }
            
            if ((![@""  isEqualToString: [data objectForKey:@"png0"]])) {
                [_request setFile:[data objectForKey:@"png0"] forKey:@"png0"];
            }
            
        }else if(HttpReq_ThreadReplyAudio == type || HttpReq_ClassThreadReplyAudio == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            [_request setFile:[data objectForKey:@"amr0"] forKey:@"amr0"];
        }else if(HttpReq_ThreadReplyPicture == type || HttpReq_ClassThreadReplyPicture == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            if (nil != [data objectForKey:@"png0"]) {
                [_request setFile:[data objectForKey:@"png0"] forKey:@"png0"];
            }
        }else if(HttpReq_ThreadSubmit == type || HttpReq_ClassThreadSubmit == type || HttpReq_CustomThreadSubmit == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];

            if (HttpReq_ThreadSubmit == type || HttpReq_ClassThreadSubmit == type) {
                // 是否有语音
                if ((![@""  isEqualToString: [data objectForKey:@"amr0"]])) {
                    [_request setFile:[data objectForKey:@"amr0"] forKey:@"amr0"];
                }
            }
            
            // 是否有图片
            NSMutableDictionary *imageArray = [data objectForKey:@"imageArray"];
            
            if (0 != [imageArray count]) {
                for (int i=0; i<[imageArray count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"png%d",i];
                    [_request setFile:[imageArray objectForKey:image] forKey:image];
                }
            }
        }else if (HttpReq_HomeworkSend == type || HttpReq_HomeworkModify == type){
            // 作业发布 作业修改
            // 是否有图片
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];

            NSMutableDictionary *imageArray = [data objectForKey:@"imageArray"];
            NSMutableDictionary *imageArray2 = [data objectForKey:@"imageArray2"];
            
            if (0 != [imageArray count]) {
                for (int i=0; i<[imageArray count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"qng%d",i];
                    NSString *a = [imageArray objectForKey:image];
                    [_request setFile:a forKey:image];
                }
            }
            if (0 != [imageArray2 count]) {
                for (int i=0; i<[imageArray2 count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"ang%d",i];
                    [_request setFile:[imageArray2 objectForKey:image] forKey:image];
                }
            }
        }else if (HttpReq_HomeworkStudentUpload == type){
            // 学生发布作业的回复
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];

            NSMutableDictionary *imageArray = [data objectForKey:@"imageArray"];
            
            if (0 != [imageArray count]) {
                for (int i=0; i<[imageArray count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"png%d",i];
                    [_request setFile:[imageArray objectForKey:image] forKey:image];
                }
            }
        }else if (HttpReq_RecipeUpload == type){
            // 上传菜谱
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            
            NSMutableDictionary *imageArray = [data objectForKey:@"imageArray"];
            
            if (0 != [imageArray count]) {
                for (int i=0; i<[imageArray count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"png%d",i];
                    NSString *a = [imageArray objectForKey:image];
                    [_request setFile:a forKey:image];
                }
            }
        }else if(HttpReq_MomentsSetUserBackground == type) {
            [_request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            if (nil != [data objectForKey:@"png0"]) {
                [_request setFile:[data objectForKey:@"png0"] forKey:@"png0"];
            }
        }

        NSEnumerator * enumerator = [data keyEnumerator];
        
        NSString *object;
        while(object = [enumerator nextObject])
        {
            //NSLog(@"键值为：%@",object);
            id objectValue = [data objectForKey:object];
            if(objectValue != nil)
            {
                NSLog(@"键值为：%@, 值为：%@",object, objectValue);
                [_request setPostValue:objectValue forKey:object];
            }
        }

        // 如果传入了sid，说明需要获取其他学校信息，这里就不用设置本校的信息了。
        NSString *sid = [data objectForKey:@"sid"];
        if (sid == nil) {
            [_request setPostValue:G_SCHOOL_ID forKey:@"sid"];
        }

        // 添加appVersion参数作为必填项
        [_request setPostValue:[Utilities getAppVersion] forKey:@"app"];

        // uid作为必填项，在这里做统一获取，以及异常处理
        if (HttpReq_GetCode == type ||
            HttpReq_VerifyCode == type ||
            HttpReq_Register == type ||
            HttpReq_Login == type ||
            HttpReq_GetSplash == type ||
            HttpReq_Version == type ||
            HttpReq_GetbackPasswordCode == type ||
            HttpReq_GetbackPasswordReset == type ||

            HttpReq_DataReportAction == type ||
            HttpReq_EduinspectorProfile == type ||
            HttpReq_DataReportGPS == type) {
            // 但是需要除去几个特殊的请求不需要uid
            // 获取督学信息时是特例，uid需要传入

            // 开始异步请求
            [_request startAsynchronous];
        }else {
            // 如果用户传入了uid，则表示需要用到uid这个字段
            NSString *uid = [data objectForKey:@"uid"];
            if ((uid == nil) || ([uid  isEqual: @""]) || ([uid  isEqual: @"0"])) {
                NSString *uniqueUid = [Utilities getUniqueUid];
                [_request setPostValue:uniqueUid forKey:@"uid"];
                
                if (uniqueUid != nil) {
                    // 开始异步请求
                    [_request startAsynchronous];
                }
            }else {
                [_request setPostValue:uid forKey:@"uid"];
                
                // 开始异步请求
                [_request startAsynchronous];
            }

        }
    }
}

- (void)cancelCurrentRequest
{
     if (self->request1)
     {
         if (![self->request1 complete]) {
             [self->request1 clearDelegatesAndCancel];
         }
     }
 }

- (void)httpRequestDidSuccess:(ASIHTTPRequest *)request
{
    //获取头文件
    //NSDictionary *headers = [request responseHeaders];
    
    //获取http协议执行代码
    //NSLog(@"Code:%d",[request responseStatusCode]);
    
    NSError *error = [request error];
    
    //    NSData* jsondata = [request responseData];
    //    NSString* jsonString = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length]encoding:NSUTF8StringEncoding];
    //    NSLog(@"jsonString：%@",jsonString);
    //
    //    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
    //    HttpReqType protocolType = HttpReq_End;
    //
    //    NSString *test = [resultJSON objectForKey:@"protocol"];
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)request
{
    //获取错误数据
    NSError *error = [request error];
    
    [delegate reciveHttpDataError:error];
}

// 异步执行成功
- (void)requestDidSuccess:(ASIFormDataRequest *)request
{
    //获取头文件
    //NSDictionary *headers = [request responseHeaders];
    
    //获取http协议执行代码
    //NSLog(@"Code:%d",[request responseStatusCode]);
    
    NSError *error = [request error];

    NSData* jsondata = [request responseData];
    NSString* jsonString = [[NSString alloc]initWithBytes:[jsondata bytes]length:[jsondata length]encoding:NSUTF8StringEncoding];
    NSLog(@"jsonString：%@",jsonString);
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:jsondata options:kNilOptions error:&error];
    HttpReqType protocolType = HttpReq_End;
    
    //NSString *test = [resultJSON objectForKey:@"protocol"];
    NSLog(@"protocol:%@",[resultJSON objectForKey:@"protocol"]);
    
    if ([@"ClassForumThreadAction.comment" isEqualToString:[resultJSON objectForKey:@"protocol"]]) {
        protocolType = HttpReq_ClassThreadReply;
    }
    else if ([@"SchoolThreadAction.comment"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_ThreadReply;
    }
    else if ([@"ClassThreadAction.comment" isEqual:[resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_ThreadsReply;
    }
    else if ([@"do_class_others"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_GetClassOthers;
    }
    else if ([@"do_class_teacher"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_GetClassTeacher;
    }
    else if ([@"HomeworkAction.comment"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_HomeworkReply;
    }
    else if ([@"do_homework_deletethread"  isEqual: [resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_HomeworkDelete;
    }
    else if ([@"do_wiki_viewWikiThread" isEqualToString:[resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_WikiMySchoolDetail;
    }
    else if ([@"do_wiki_favorites" isEqualToString:[resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_WikiCollection;
    }
    else if ([@"do_wiki_follow" isEqualToString:[resultJSON objectForKey:@"protocol"]])
    {
        protocolType = HttpReq_WikiFollow;
    }
    else if ([@"do_class_out" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        protocolType = HttpReq_OutClass;
    }
    else if ([@"do_wiki_comment" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        protocolType = HttpReq_WikiComment;
    }
    else if ([@"do_profile_query" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        protocolType = HttpReq_Profile;
    }
    else if ([@"FriendAction.accept" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        protocolType = HttpReq_FriendAddAccept;
    }
    else if ([@"gpsAction.update" isEqualToString:[resultJSON objectForKey:@"protocol"]]){
        // gps上报不返回消息
//        return;
    }

    [delegate reciveHttpData:[request responseData] andType:protocolType];
}

//执行失败
- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    //获取错误数据
    NSError *error = [request error];
    
    [delegate reciveHttpDataError:error];
}

@end