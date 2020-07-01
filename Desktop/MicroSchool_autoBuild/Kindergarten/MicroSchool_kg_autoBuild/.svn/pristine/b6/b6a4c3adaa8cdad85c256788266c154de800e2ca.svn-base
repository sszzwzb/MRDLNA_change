//
//  FRNetPoolUtils.m
//  FriendNew
//
//  Created by smc on 12-6-4.
//  Copyright (c) 2014年 . All rights reserved.
//

#import "FRNetPoolUtils.h"
//#import "JSONKit.h"
#import "NetworkUtility.h"
#import "Utilities.h"
#import "PublicConstant.h"
#import "ChatListObject.h"
#import "DBDao.h"
#import "ReportObject.h"
#import "REportDBDao.h"

#import "MicroSchoolAppDelegate.h"

@implementation FRNetPoolUtils

@synthesize statusDelegate;
//@synthesize curLat,curLog,curPhone,curUserID,curCookie;
 
- (id)init
{
    self = [super init];
    if (self) {
           
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

// 获取群聊头像
+(UIImage*)getImage:(NSString*)url{
    
    
    UIImage *image = nil;
    
    ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:url]];
    [requestForm setRequestMethod:@"GET"];
    [requestForm setDelegate:self];
    [requestForm setTimeOutSeconds:150];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    
    if (data) {
        image = [UIImage imageWithData: data];
    }
    
    return image;
    
}

//  教育局下属单位列表 定制
+(NSDictionary*)getSchoolListForBureau{
    
    /**
     * 教育局下属学校列表
     * @author luke
     * @date 2015.05.21
     * @args
     *  ac=Bureau, v=2, op=schools, sid=, uid=
     */
    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Bureau" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"schools" forKey:@"op"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    if (data) {
        result = [data objectFromJSONData];
        NSLog(@"学校列表For教育局返回:%@",result);
    }
    return result;
}

//  发现TAB自定义模块列表
+(NSDictionary*)getMoments{
    /**
     * 发现TAB自定义模块列表
     * @author luke
     * @date 2015.05.13
     * @args
     *  ac=Module, v=3, op=foundModules, sid=, uid=, device=[3:android, 4:iOS], version=[5,6,7: only for ios just now]
     */
   
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Module" forKey:@"ac"];
    [requestForm setPostValue:@"3" forKey:@"v"];
    [requestForm setPostValue:@"foundModules" forKey:@"op"];
    [requestForm setPostValue:@"4" forKey:@"device"];
    [requestForm setPostValue:@"5" forKey:@"version"];
    
    NSString *currentVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    [requestForm setPostValue:currentVersion forKey:@"app"];

    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    if (data) {
        result = [data objectFromJSONData];
        NSLog(@"发现TAB自定义模块列表返回:%@",result);
    }
    return result;
}

// 教育局下属单位科室列表
+(NSMutableArray*)getSubordinateList{
    
    /**
     * 教育局下属单位列表
     * @author luke
     * @date 2015.05.05
     * @args
     *  ac=bureau, v=2, op=subordinate, sid=, uid=
     */
    
    NSMutableArray *list = nil;
    //NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
   // NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"bureau" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"subordinate" forKey:@"op"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"教育局下属单位科室列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    
    [requestForm release];
    
    return list;
    
}

// 教育局本单位科室列表
+(NSMutableArray*)getDepartmentList{
    
    /*
     * 教育局科室列表
     * @author luke
     * @date 2015.05.05
     * @args
     *  ac=bureau, v=2, op=departments, sid=, uid=
     */
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Contact" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"groups" forKey:@"op"];
    
    [requestForm setPostValue:uid forKey:@"uid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"教育局本单位科室列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

}

// 校园订阅 订阅文章详情
+(NSDictionary*)getSubsribeArticleDetail:(NSString*)aid width:(NSString*)width{
    
    /**
     * 订阅文章详情
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=viewArticle, sid=, uid=, aid=, width=
     */
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolSubscription" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"viewArticle" forKey:@"op"];
    
    [requestForm setPostValue:aid forKey:@"aid"];
    [requestForm setPostValue:width forKey:@"width"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校园订阅文章详情result:%@",result);
//        if (result) {
//            if([[result objectForKey:@"result"] integerValue]==1 ){
//                dic = [result objectForKey:@"message"];
//            }else{
//                dic = nil;
//                [Utilities showAlert:@"错误" message:[result objectForKey:@"message"] cancelButtonTitle:@"确定" otherButtonTitle:nil];
//            }
//        }else{
//            dic = nil;
//             [Utilities showAlert:@"错误" message:@"网络异常，请稍后再试" cancelButtonTitle:@"确定" otherButtonTitle:nil];
//        }
        
        dic = result;
        
    }
    [requestForm release];
    
    return dic;

}

// 校园订阅号认证详情
+(NSDictionary*)getCertificateDetail:(NSString*)number{
    
    /**
     * 订阅号详情
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=profile, sid=, uid=, number=订阅号
     */
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
   
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolSubscription" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"profile" forKey:@"op"];
    
    [requestForm setPostValue:number forKey:@"number"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校园订阅号认证详情result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];

    return dic;
}

// 校园订阅文章列表
+(NSMutableArray*)getSubscribeArticles:(NSString*)page size:(NSString*)size number:(NSString*)number{
    
    /**
     * 订阅文章列表
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=articles, sid=, uid=, $page, $size=, number=订阅号ID
     */
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolSubscription" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"articles" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    [requestForm setPostValue:number forKey:@"number"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校园订阅文章列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

}

// 校园订阅号列表
+(NSMutableArray*)getSubscribeNumList:(NSString*)page size:(NSString*)size lasts:(NSString*)lasts{
    
    /**
     * 学校订阅号列表
     * @author luke
     * @date
     *  2015.04.21
     * @args
     *  op=numbers, sid=, uid=, page=, size=, lasts=[number:lastId,...]
     */
    
    /*
     list =         (
     {
     article =                 {
     count = 0;
     dateline = 1429677323;
     title = "\U6d4b\U8bd5\U6807\U98982";
     };
     "auth_desc" = "\U6211\U662f\U63cf\U8ff0";
     "auth_status" = 1;
     name = "\U77e5\U6821";
     number = 1;
     pic = "http://test.5xiaoyuan.cn/ucenter/data/avatar/000/06/32/35_avatar_middle.jpg";
     type = 2;
     }
     );
     */
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolSubscription" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"numbers" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    [requestForm setPostValue:lasts forKey:@"lasts"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校园订阅号列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];;
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
    
}

// 校校通取消收藏学校
+(NSString*)cancelCollectSchool:(NSString*)collectSid{
    
    /**
     * 取消收藏
     * @author luke
     * @args
     *  op=remove, sid=, uid=, school=收藏的学校ID
     */
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"OtherSchool" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"remove" forKey:@"op"];
    
    [requestForm setPostValue:collectSid forKey:@"school"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校校通取消收藏学校:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 校校通收藏学校
+(NSString*)collectSchool:(NSString*)collectSid{
    
    /**
     * 添加收藏
     * @author luke
     * @args
     *  op=add, sid=, uid=, school=收藏的学校ID
     */
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"OtherSchool" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"add" forKey:@"op"];
    
    [requestForm setPostValue:collectSid forKey:@"school"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校校通收藏学校:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 校校通城市选择列表
+(NSMutableArray*)getSToSRegions{
    /*
     * 搜索省市区域
     * @author luke
     * @date 2015.04.14
     * @args
     *  op=regions, sid=, uid=, v=2, ac=OtherSchool
     */
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"OtherSchool" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"regions" forKey:@"op"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校校通省市result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
    
}

// 校校通其他学校模块列表
+(NSDictionary*)getOtherSchoolModules:(NSString*)otherSid andsSpecial:(NSString *)special
{
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Module" forKey:@"ac"];
    [requestForm setPostValue:@"3" forKey:@"v"];
    [requestForm setPostValue:@"otherSchoolModules" forKey:@"op"];
    
    NSString *app = [Utilities getAppVersion];
    [requestForm setPostValue:app forKey:@"app"];
    
    NSString *schoolType = [[NSUserDefaults standardUserDefaults]objectForKey:@"schoolType"];
    if ([schoolType isEqualToString:@"bureau"]) {
        if (nil != special) {
            NSDictionary *user = [GlobalSingletonUserInfo.sharedGlobalSingleton getUserDetailInfo];
            
            NSString *role_id = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_id"]];
            NSString *role_checked = [NSString stringWithFormat:@"%@", [user objectForKey:@"role_checked"]];
            
            // 只有认证的老师或者督学或者管理员才能看到讨论区
            if([@"7"  isEqual: role_id]) {
                if ([@"1"  isEqual: role_checked]) {
                    [requestForm setPostValue:@"1" forKey:@"special"];
                }
            }else if ([@"2"  isEqual: role_id] || [@"9"  isEqual: role_id]){
                [requestForm setPostValue:@"1" forKey:@"special"];
            }
        }else {
            [requestForm setPostValue:@"0" forKey:@"special"];
        }
    }else {
        [requestForm setPostValue:@"0" forKey:@"special"];
    }

    [requestForm setPostValue:otherSid forKey:@"other"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校校通其他学校模块列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
            
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    return dic;
}

// 校校通通过城市筛选学校列表
+(NSMutableArray*)getSchool:(NSString*)cid keyword:(NSString*)keyword page:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"OtherSchool" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"search" forKey:@"op"];
    
    [requestForm setPostValue:cid forKey:@"city"];
    [requestForm setPostValue:keyword forKey:@"keyword"];
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"校校通通过城市筛选学校列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
           
        }else{
            list = nil;
        }
    }
    [requestForm release];
    return list;
}

// 知识库模块取消收藏
+(NSString*)cancelCollection:(NSString*)kid{
    /*
     v=2, ac=MyWiki
     * 取消收藏知识库条目
     * @author luke
     * @date 2015.02.04
     * @args
     *  op=delFavoriteWiki, sid=, uid=, kid=知识库条目ID
     */
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"delFavoriteWiki" forKey:@"op"];
    
    [requestForm setPostValue:kid forKey:@"kid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"知识库模块取消收藏:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 知识库类别列表每个类别的数量
+(NSDictionary*)getKnowledgeTypeCount:(NSString*)last{
    
    /*
     {
     "protocol": "MyWikiAction.home",
     "result": true,
     "message": {
     "subscribedWikiCount": "20312",
     "subscriberCount": 0
     }
     }
     */
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"home" forKey:@"op"];
    
    [requestForm setPostValue:last forKey:@"last"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"知识库类别列表每个类别的数量result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;
    
}

// 我的课程
+(NSMutableArray*)getMySubjects:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"publishedWiki" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"我的课程列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

}

// 我收藏的文章
+(NSMutableArray*)getMyCollectedArticles:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"favoriteWiki" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"我收藏的文章列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
    
}

// 我订阅的教师
+(NSMutableArray*)getMySubscribedTeachers:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"subscribedTeachers" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"我订阅的教师列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

    
}

// 我订阅的文章
+(NSMutableArray*)getMySubscribedArticles:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MyWiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"subscribedWiki" forKey:@"op"];
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"我订阅的文章列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [[result objectForKey:@"message"] objectForKey:@"list"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

}

// 作者空间/教师详情
+(NSDictionary*)getTeacherDetail:(NSString*)tid page:(NSString*)page size:(NSString*)size{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"teacher" forKey:@"op"];
    
    [requestForm setPostValue:tid forKey:@"tid"];
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"作者空间/教师详情result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;

}

// 获取学校列表
+(NSMutableArray*)getSchool:(NSString*)rid{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"schools" forKey:@"op"];
    
    [requestForm setPostValue:rid forKey:@"rid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"学校列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
    
}

// 获取省市
+(NSMutableArray*)getRegions{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"regions" forKey:@"op"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"省市result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
}

// 条目列表/知识点搜索
+(NSDictionary*)getItems:(NSString*)keyword category:(NSString*)category course:(NSString*)course grade:(NSString*)grade page:(NSString*)page size:(NSString*)size{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"wikiItems" forKey:@"op"];
    
    [requestForm setPostValue:keyword forKey:@"keyword"];
    [requestForm setPostValue:category forKey:@"category"];
    [requestForm setPostValue:course forKey:@"course"];
    [requestForm setPostValue:grade forKey:@"grade"];
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"条目列表/知识点搜索result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;
}

// 教师列表/搜索/筛选
+(NSDictionary*)getTeacherList:(NSString*)keyWord ownsid:(NSString*)ownsid page:(NSString*)page size:(NSString*)size{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"teachers" forKey:@"op"];
    
    
    [requestForm setPostValue:keyWord forKey:@"keyword"];
    [requestForm setPostValue:ownsid forKey:@"school"];
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"教师列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;

}

// 知识库首页列表
+(NSDictionary*)getKnowlegeHomePageList:(NSString*)last{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Wiki" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"home" forKey:@"op"];
    
    
    [requestForm setPostValue:last forKey:@"last"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"知识库首页列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;

}

// 清空我发表的全部动态
+(NSString*)deleteMyMoments:(NSString*)last{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"clearMessages" forKey:@"op"];
    
    
    [requestForm setPostValue:last forKey:@"last"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"清空我发表的全部动态:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 删除我的某条动态
+(NSString*)deleteMyMomentsById:(NSString*)tid{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"deleteMessage" forKey:@"op"];
    
    
    [requestForm setPostValue:tid forKey:@"mid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"删除我的某条动态:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
}

// 自定义tab标签
+(NSMutableArray*)getTabTitle{
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
  
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    [requestForm setPostValue:@"Configuration" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"tabs" forKey:@"op"];
    [requestForm setPostValue:uid forKey:@"uid"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"自定义tab标签result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
}

// 发现中内容模块
+(NSString *)getFoundConfiguration{
    
    NSString *name = @"";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    [requestForm setPostValue:@"Configuration" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"found" forKey:@"op"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"found result:%@",result);
        
        if([[result objectForKey:@"result"] integerValue]==1 ){
            name = [result objectForKey:@"message"];
        }else{
            name = @"未知";
        }
    }
    [requestForm release];
    
    return name;
}

// 设置某动态的可见范围（权限）
+(NSString*)setMySingleMomentViewType:(NSString*)tid privilege:(NSString*)privilege cids:(NSString*)cids{
    
    /*
     * @args
     *  op=setCirclePrivilege, sid=, uid=, tid=, privilege=, cids=选择班级可见时的班级列表
     * @example:
     *  privilege =
     * const TABLE_NAME = 'app_circle_privilege';
     * const ONLY_SELF = 1; //自己可见
     * const STUDENT = 2; //学生可见
     * const PARENT = 4; //家长可见
     * const TEACHER = 8; //教师可见
     * const CLASSES = 16; //某些班级可见
     * const SCHOOL = 32; //学校可见
     *  cids=6075,8000,...
     */
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setCirclePrivilege" forKey:@"op"];
    
    
    [requestForm setPostValue:tid forKey:@"tid"];
    [requestForm setPostValue:privilege forKey:@"privilege"];
    if (cids!=nil) {
        [requestForm setPostValue:cids forKey:@"cids"];
    }
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"设置某条我的动态查看权限设置:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 个人动态查看权限设置
+(NSString*)setMomentsViewType:(NSString*)privilege{
    
    //op=setBrowserPrivilege, sid=, uid=, privilege=, cids=选择班级可见时的班级列表
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setBrowserPrivilege" forKey:@"op"];
    
    
    [requestForm setPostValue:privilege forKey:@"privilege"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"个人动态查看权限设置:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
}

// 获取动态权限类型
+(NSDictionary*)getPrivilege{
    
    /*
     @args
     *  op=getBrowserPrivilege, sid=, uid=
     * @example:
     *
     * {"protocol":"CircleAction.getBrowserPrivilege","result":true,"message":{"privilege":"1","cids":"6075"}}
     */
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"getBrowserPrivilege" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"获取动态设置权限result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;
}

// 程序主页menu红点
+(NSMutableArray*)checkNewForSchool:(NSString*)moudles numbers:(NSString*)numbers{
    
    //op=check4school, sid=, uid=, modules=name:last,...
    NSMutableArray *list = nil;
    NSString *uid= [Utilities getUniqueUidWithoutQuit];
    
//    ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    
    
    [requestForm setPostValue:@"Module" forKey:@"ac"];
    [requestForm setPostValue:@"1" forKey:@"v"];
    [requestForm setPostValue:@"check4school" forKey:@"op"];
    
    if (uid != nil && ![uid  isEqual: @""] && ![uid  isEqual: @"0"]) {
        [requestForm setPostValue:uid forKey:@"uid"];
    }
    
    [requestForm setPostValue:moudles forKey:@"modules"];
    [requestForm setPostValue:numbers forKey:@"numbers"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"程序主页menu红点result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
}

//点赞的人列表
+(NSMutableArray*)getLikerList:(NSString*)tid{
    
   //op=loveTimeline, sid=, uid=, tid=
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
   // ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"loveTimeline" forKey:@"op"];
    
    
    [requestForm setPostValue:tid forKey:@"tid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"点赞的人result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;

}

// 个人动态消息列表
+(NSDictionary*)getSelfNewsList:(NSString*)page size:(NSString*)size{
    // op=messages, sid=, uid=, page=, size=
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Circle" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"messages" forKey:@"op"];
    
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"个人动态消息列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;
}

// 班级主页红点
+(NSMutableArray*)checkNewForClass:(NSString*)cid moudles:(NSString*)moudles{
    
    // op=batchCheck&sid=&cid=&uid=&modules=mid:last,...
    // v=1&ac=Module&op=batchCheck&uid=63237&sid=3151&cid=5271&modules=7:1,13:1

    //  op=check4class, sid=, uid=, cid=, modules=type:last,...
    
    NSMutableArray *list = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Module" forKey:@"ac"];
    [requestForm setPostValue:@"1" forKey:@"v"];
    //[requestForm setPostValue:@"batchCheck" forKey:@"op"];
    [requestForm setPostValue:@"check4class" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:moudles forKey:@"modules"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"班级主页红点result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            list = [result objectForKey:@"message"];
        }else{
            list = nil;
        }
    }
    [requestForm release];
    
    return list;
}

// 通过二维码查看个人资料
+(NSDictionary*)getPersonalInfoByCode:(NSString*)code{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Friend" forKey:@"ac"];
    [requestForm setPostValue:@"1" forKey:@"v"];
    [requestForm setPostValue:@"viewByCode" forKey:@"op"];
    
    
    [requestForm setPostValue:code forKey:@"code"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"通过二维码查看个人资料result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;

}

// 父母绑定孩子
+(NSString*)BindForParenthood:(NSString*)childId{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Parenthood" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"pair" forKey:@"op"];
    
    
    [requestForm setPostValue:childId forKey:@"child"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"父母绑定孩子返回:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 解除父母与孩子的绑定
+(NSString*)UnbindForParenthood:(NSString*)childId{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Parenthood" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"remove" forKey:@"op"];
    
    
    [requestForm setPostValue:childId forKey:@"child"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"解除父母与孩子的绑定返回:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

    
}

// 家长的亲子关系绑定列表
+(NSMutableArray*)getParenthoodListForParents{
    
    NSMutableArray *array = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Parenthood" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"children" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"家长的亲子关系绑定列表返回:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            
            array = [result objectForKey:@"message"];
            
            
        }else{
            array = nil;
        }
    }else{
        array = nil;
    }
    [requestForm release];
    return array;

}

// 孩子的亲子关系列表
+(NSMutableArray*)getParenthoodListForChild{
    
    /*
     {
     message =     (
     {
     avatar = "http://182.92.212.178/ucenter/avatar.php?uid=6308&size=middle&type=&timestamp=1414490567";
     child = 63156;
     dateline = 1415685953;
     name = ppp;
     note = "";
     parent = 6308;
     pid = 8;
     sid = 5303;
     status = 1;
     uid = 6308;
     updatetime = 1414490567;
     }
     );
     protocol = "ParenthoodAction.parent";
     result = 1;
     }
     */
    
    NSMutableArray *array = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Parenthood" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"parent" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"孩子的亲子关系列表返回:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            
            array = [result objectForKey:@"message"];
            
            
        }else{
            array = nil;
        }
    }else{
        array = nil;
    }
    [requestForm release];
    return array;

}

// 孩子获取自己的二维码
+(NSString*)getQRCodeForChild{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Parenthood" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"code" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"孩子获取自己的二维码返回:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                
                flag = [result objectForKey:@"message"];

            }else{
            
                flag = nil;
            }
            
        }else{
            
            flag = nil;
        }
        
    }else{
        
        flag = nil;
    }
    [requestForm release];
    return flag;
}

// 意见与反馈红点拉取接口
+(NSString*)isNewForFeedbackMsg:(NSString*)lastId{
    
    /*weixiao/api.php
      ac=Feedback&op=check&sid=&uid=&last=最新一条消息ID
     */
    NSString *flag = @"0";
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Feedback" forKey:@"ac"];
    [requestForm setPostValue:@"check" forKey:@"op"];
    [requestForm setPostValue:lastId forKey:@"last"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"检查是否有新的意见反馈消息:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = [result objectForKey:@"message"];
            }else{
                flag = @"0";
            }
            
        }else{
            
            flag = @"0";
        }
        
    }
    [requestForm release];
    return flag;
}

// 发送反馈意见
+(NSString*)sendFeedback:(NSString*)msg{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Feedback" forKey:@"ac"];
    [requestForm setPostValue:@"admin" forKey:@"op"];
    
    
    [requestForm setPostValue:msg forKey:@"message"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"发送反馈意见返回:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
            
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 意见与反馈消息列表
+(NSMutableArray*)getFeedbackMessageList{
    
    /*ac=Feedback&op=messages&uid=63228&sid=3151*/
    
    /*
     message =     (
     {
     dateline = 1414997473;
     delstatus = 0;
     folder = inbox;
     fromappid = 1;
     message = "\U4f60";
     msgfrom = "\U5317\U4eac202\U4e2d\U5b66";
     msgfromid = 53683;
     msgtoid = 1;
     new = 1;
     pmid = 910;
     related = 1;
     subject = "\U4f60";
     }
     );
     protocol = "FeedbackAction.messages";
     result = 1;
     */
    
    NSMutableArray *array = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Feedback" forKey:@"ac"];
    [requestForm setPostValue:@"messages" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"意见与反馈消息列表返回:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            
            array = [result objectForKey:@"message"];
            
            
        }else{
            array = nil;
        }
    }else{
        array = nil;
    }
    [requestForm release];
    return array;
    
}



// 设置个人隐私
+(NSString*)setPrivacyWay:(NSString*)type subType:(NSString*)subtype way:(NSString*)way{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Profile" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setPrivacy" forKey:@"op"];
    
    
    [requestForm setPostValue:type forKey:@"type"];
    [requestForm setPostValue:subtype forKey:@"subtype"];
    [requestForm setPostValue:way forKey:@"friend"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"设置个人隐私返回:%@",result);
        if(result){
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
            
        }else{
           
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    NSLog(@"flag:%@",flag);
    return flag;
    
}

// 查看个人隐私
+(NSMutableArray*)viewMyPrivacy{
    
    /*
     2014-10-27 16:44:29.443 东方高中[4482:600f] 查看个人隐私返回:{
     message =     (
     {
     fields =             (
     {
     field = birthcity;
     friend = 0;
     id = 16939;
     title = "\U51fa\U751f\U5730";
     },
     {
     field = residecity;
     friend = 0;
     id = 16940;
     title = "\U5c45\U4f4f\U5730";
     }
     );
     title = "\U57fa\U672c\U4fe1\U606f";
     type = base;
     }
     );
     protocol = "ProfileAction.viewPrivacy";
     result = 1;
     }
     */
    
    NSMutableArray *array = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Profile" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"viewPrivacy" forKey:@"op"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"查看个人隐私返回:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            
            array = [result objectForKey:@"message"];
            
            
        }else{
            array = nil;
        }
    }else{
        array = nil;
    }
    [requestForm release];
    return array;

}

// 督学更新个人资料 update 2015.09.14
+(NSString*)updateProfile:(NSString*)phone job:(NSString*)job company:(NSString*)company duty:(NSString*)duty photoPath:(NSString*)photo email:(NSString*)email{
    
    NSString *flag = nil;
    //NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    //NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolInspector" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"updateProfile" forKey:@"op"];
    
    if([phone length]!=0){
        [requestForm setPostValue:phone forKey:@"tel"];
    }
    if([job length]!=0){
        [requestForm setPostValue:job forKey:@"job"];
    }
    if ([company length]!=0) {
        [requestForm setPostValue:company forKey:@"company"];
    }
    if ([duty length]!=0) {
        [requestForm setPostValue:duty forKey:@"duty"];
    }
    if ([email length]!=0) {
        [requestForm setPostValue:email forKey:@"email"];
    }
    if ([photo length]!=0) {//2015.09.14
        [requestForm setFile:photo forKey:@"photo"];
    }
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"督学更新个人资料返回:%@",result);
        
        if (result) {
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 督学回答问题
+(NSString*)answerQ:(NSString*)rid message:(NSString*)message aid:(NSString*)aid{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolInspector" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"answer" forKey:@"op"];
    
    
    [requestForm setPostValue:aid forKey:@"aid"];
    [requestForm setPostValue:rid forKey:@"rid"];
    [requestForm setPostValue:message forKey:@"message"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"督学回答提问返回:%@",result);
        
        if (result) {
            
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
           flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 督学登录待回答问题列表
+(NSMutableArray*)getToReplyAnswerList:(NSString*)page size:(NSString*)size{
    
    NSMutableArray *listArray = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"SchoolInspector" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"unansweredQuestions" forKey:@"op"];
    
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"督学登录待回答问题列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            listArray = [result objectForKey:@"message"];
        }else{
            listArray = nil;
        }
    }
    [requestForm release];
    return listArray;

}

// 设置/取消管理员
+(NSString*)setAdmin:(NSString*)cid oUid:(NSString*)oUid type:(NSString*)type{
    
    /*
     op=classAdmin, sid=(Integer,学校ID),uid=(Integer,用户ID),cid=(Integer,班级ID),oUid=(Integer,变更教师uid),type=(Integer,1->指定管理员,2->取消管理员)
     */
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"School" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"classAdmin" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:oUid forKey:@"oUid"];
    [requestForm setPostValue:type forKey:@"type"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"设置管理员权限返回:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
}

// 获取学校管理员登陆的成员列表-教师列表
+(NSMutableDictionary*)getTeachers:(NSString*)cid role:(NSString*)role page:(NSString*)startIndex size:(NSString*)size{
    
    /*
     args
     op=teachers, sid=(Integer,学校ID),uid=(Integer,用户ID),cid=(Integer,班级ID),grade=(Integer,不传递->全部,-1->未加入班级教师,0->已经加入班级老师并且是成员,9->已经加入班级老师并且是管理员),page=(Integer,起始行数),size=(Integer,取多少条记录)
     
     "list": [
     {
     "uid": "53751",
     "name": "",
     "grade": "-1", (-1->未加入班级教师,0->已经加入班级老师并且是成员,9->已经加入班级老师并且是管理员)
     "avatar": "http://127.0.0.1/ucenter/avatar.php?uid=53751&size=middle&type="
     }
     ]
     */
    
    NSMutableDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"School" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"teachers" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    if([role length]!=0){
       [requestForm setPostValue:role forKey:@"grade"];
    }
    [requestForm setPostValue:startIndex forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"老师成员管理列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    return dic;
 
    
}

// 设置好友添加权限
+(NSString*)setFriendJoinPerm:(NSString*)authority{
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Profile" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setFriendAuthority" forKey:@"op"];
    
    
    [requestForm setPostValue:authority forKey:@"authority"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"str:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"设置好友权限返回:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
           flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
}

// 我的班级红点
+(NSMutableDictionary*)checkMyClass:(NSString*)cids{

// op=checkMyClass,sid=(Integer,学校ID),cid=(Integer,班级ID),uid=(Integer,用户ID),cids=(String,"cid=1&hw=1&ns=1,cid=2&hw=2&ns=2",(cid:班级id,hw:最后作业id,ns:最后班级公告id))
    
// op=checkMyClass,sid=(Integer,学校ID),cid=(Integer,班级ID),uid=(Integer,用户ID),cids=(String,"cid=1&hw=1&ns=1&fm=1,cid=2&hw=2&ns=2,cid=3&hw=3&ns=",(cid:班级id,hw:最后作业id,ns:最后班级公告id,fm:最后讨论区ID))
    
    // cid=0， modules=cid:type:last,...
//ac=Module&v=1&op=batchCheck&sid=3151&uid=49439&cid=0&modules=6087:8:0,6087:13:0,6087:14:,6087:18:,6087:7:,6081:8:0

    //NSLog(@"cids:%@",cids);
    NSMutableDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Module" forKey:@"ac"];
    [requestForm setPostValue:@"1" forKey:@"v"];
    [requestForm setPostValue:@"batchCheck" forKey:@"op"];
    
    
    [requestForm setPostValue:@"" forKey:@"cid"];
    [requestForm setPostValue:cids forKey:@"modules"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    //NSLog(@"classPushStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"我的班级红点result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;

}

// 获取编辑资料页的详细
+(NSDictionary*)getClassSetting:(NSString*)cid{
    
    NSDictionary *dic = nil;
    NSLog(@"cid:%@",cid);
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"getClassSetting" forKey:@"op"];
    [requestForm setPostValue:cid forKey:@"cid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"编辑资料页的详细result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    
    return dic;
}

// 编辑资料--设置班级简介
+(NSString*)setClassNote:(NSString*)cid note:(NSString*)note{
    
    /*op=setClassNote, sid=, cid=, uid=, note={班级简介}*/
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setClassNote" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:note forKey:@"note"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"编辑资料--设置班级简介result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 编辑资料--设置方式
+(NSString*)setClassJoinPerm:(NSString*)cid perm:(NSString*)perm{
    
    /*
     op=setClassJoinPerm, sid=, cid=, uid=, perm={0允许任何人加入,1需消息验证,2只可邀请加入}*/
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setClassJoinPerm" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:perm forKey:@"perm"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"编辑资料--设置方式result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 编辑资料--设置头像
+(NSString*)setClassAvatar:(NSString*)cid{
    
    /*op=setClassAvatar, sid=, cid=, uid=, avatar={头像文件}*/
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm addRequestHeader:@"enctype" value:@"multipart/form-data;"];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"setClassAvatar" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    requestForm.delegate = self;
  
    NSString *imgPath = [[Utilities SystemDir] stringByAppendingPathComponent:@"tempImgForClass.png"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:imgPath]) {
        UIImage *myImage = [UIImage imageWithContentsOfFile:imgPath];
        if (myImage) {
            
            [requestForm setFile:imgPath forKey:@"avatar"];
        }
    }
    
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"编辑资料--设置头像result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}

// 管理员移除成员
+(NSString*)removeMember:(NSString*)rid cid:(NSString*)cid{
    
    /*
     op=remove, sid=, cid=, uid=, rid={要移除成员用户ID}
     */
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"remove" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:rid forKey:@"rid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"管理员移除该成员result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
           flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;

}


// 退出班级
+(NSString*)quitFromClass:(NSString*)cid{
    
    /*
     op=quit, sid=,cid={班级ID},uid=
     */
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"quit" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"退出班级result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
                GlobalSingletonUserInfo* g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
                
                NSMutableDictionary *userDetail = [g_userInfo getUserDetailInfo];
                NSString *usertype = [NSString stringWithFormat:@"%@",[userDetail objectForKey:@"role_id"]];
                if ([usertype intValue]!= 7 && [usertype intValue]!= 2 && [usertype intValue]!= 9) {
                    
                    [userDetail setObject:@"0" forKey:@"role_cid"];
                    [userDetail setObject:@"" forKey:@"role_classname"];
                }
                
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 管理员班级审批接口 同意或拒绝
+(NSString*)agreeOrReject:(NSString*)approveID type:(NSString*)type{
    
    /*
     op=audit, sid=(Integer,学校ID),uid=(Integer,用户ID),appId=(Integer,申请记录ID),agree=(Integer,1:同意,0不同意)
     */
    
    NSString *flag = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"audit" forKey:@"op"];
    
    
    [requestForm setPostValue:approveID forKey:@"appId"];
    [requestForm setPostValue:type forKey:@"agree"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"同意或拒绝result:%@",result);
        
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
 
        }
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    

}

// 班级成员管理列表
+(NSMutableArray*)getMembers:(NSString*)cid role:(NSString*)role{
    
    /*
     op=members, sid=, cid=, uid=, role={筛选条件：[-1:all|0:学生|6:家长|7:老师]}
     */
    NSMutableArray *listArray = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    //NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"members" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:role forKey:@"role"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"班级成员管理列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            listArray = [result objectForKey:@"message"];
        }else{
            listArray = nil;
        }
    }
    [requestForm release];
    return listArray;
    
}

// 管理员的班级申请列表
+(NSDictionary*)getClassNotifications:(NSString*)page size:(NSString*)size{
   
    /*
    op=classApply, sid=(Integer,学校ID),uid=(Integer,用户ID),page=(Integer,起始行数),size=(Integer,取多少条记录)
     */
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"classApply" forKey:@"op"];
    
    
    [requestForm setPostValue:page forKey:@"page"];
    [requestForm setPostValue:size forKey:@"size"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"管理员的班级申请列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    return dic;
    
}

// 加入班级申请接口
+(NSString*)applyAddClass:(NSString*)cid reason:(NSString*)reason{
    
    NSString *flag = nil;
    // op=joinClass, sid=(Integer,学校ID),cid=(Integer,班级ID),uid=(Integer,用户ID),reason=(String,申请原因)
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"joinClass" forKey:@"op"];
    
    
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:reason forKey:@"reason"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"加入班级申请result:%@",result);
        if (result) {
            if([[result objectForKey:@"result"] integerValue]==1 ){
                flag = nil;
            }else{
                flag = [result objectForKey:@"message"];
            }
        }else{
            flag = @"网络异常，请稍后再试";
        }
        
    }else{
        
        flag = @"网络异常，请稍后再试";
    }
    [requestForm release];
    return flag;
    
}

// 新版加入班级
+(NSDictionary*)addClass:(NSString*)cid reason:(NSString *)reason{
    
    //NSDictionary *dic = nil;
    /**
     * 新版加入班级接口
     * @author luke
     * @date 2015.05.14
     * @args
     *  ac=Class, v=2, op=join, sid=, uid=, cid=, reason=
     */
    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"join" forKey:@"op"];
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:reason forKey:@"reason"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"加入班级申请result:%@",result);
        
    }
    [requestForm release];
    return result;
}

// 获取班级筛选条件列表
+(NSMutableArray*)getFilterList{
    
    NSMutableArray *listArray = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"getYeargrade" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
     NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"获取学校班级列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            listArray = [result objectForKey:@"message"];
        }else{
            listArray = nil;
        }
    }
    [requestForm release];
    return listArray;
    
}

// 获取我的班级列表
+(NSDictionary*)getMyClassList{
    
    NSDictionary *dic = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"getMyClass" forKey:@"op"];
    
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        //NSLog(@"获取我的班级列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            dic = [result objectForKey:@"message"];
        }else{
            dic = nil;
        }
    }
    [requestForm release];
    return dic;
}

// 获取该校所有班级
+(NSMutableArray*)getClassList:(NSString*)yeargrade{
    
    NSMutableArray *listArray = nil;
    NSDictionary *userInfo = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"weixiao_userDetailInfo"]];
    NSString *uid= [userInfo objectForKey:@"uid"];//后续需要修改从单例里面取 kate
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"getAllClass" forKey:@"op"];
    
    
    [requestForm setPostValue:yeargrade forKey:@"yeargrade"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    // NSLog(@"classStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"获取学校班级列表result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            listArray = [result objectForKey:@"message"];
        }else{
            listArray = nil;
        }
    }
    [requestForm release];
    return listArray;

}

// 绑定推送接口
+(BOOL)bindServer:(NSString*)uid sid:(NSString*)sid cid:(NSString*)cid clientId:(NSString*)clientId channelId:(NSString*)channelId type:(NSString*)type token:(NSString*)token{
    
//    NSLog(@"uid:%@",uid);
//    NSLog(@"sid:%@",sid);
//    NSLog(@"cid:%@",cid);
//    NSLog(@"clientid:%@",clientId);
//    NSLog(@"channelid:%@",channelId);
    BOOL flag = NO;
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    [requestForm setPostValue:@"PushService" forKey:@"ac"];
    [requestForm setPostValue:@"bind" forKey:@"op"];
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:clientId forKey:@"client_id"];
    [requestForm setPostValue:channelId forKey:@"channel_id"];
    //[requestForm setPostValue:type forKey:@"type"];
    [requestForm setPostValue:@"4" forKey:@"device_type"];
    [requestForm setPostValue:uid forKey:@"uid"];
    [requestForm setPostValue:G_BINDCERVERSION forKey:@"appcert"];
    [requestForm setPostValue:token forKey:@"token"];//add by kate
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
//    NSString *str = [requestForm responseString];
//    NSLog(@"绑定str:%@",str);
//    NSLog(@"data:%@",data);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"推送绑定result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            flag = YES;
        }
    }
    [requestForm release];
    return flag;

}

// 解除推送接口
+(BOOL)unBindServer:(NSString*)uid sid:(NSString*)sid cid:(NSString*)cid clientId:(NSString*)clientId channelId:(NSString*)channelId type:(NSString*)type{
   
//    NSLog(@"uid:%@",uid);
//    NSLog(@"sid:%@",sid);
//    NSLog(@"cid:%@",cid);
//    NSLog(@"clientid:%@",clientId);
//    NSLog(@"channelid:%@",channelId);
  
    BOOL flag = NO;
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    [requestForm setTimeOutSeconds:60];
    [requestForm setPostValue:@"PushService" forKey:@"ac"];
    [requestForm setPostValue:@"unbind" forKey:@"op"];
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:clientId forKey:@"client_id"];
    [requestForm setPostValue:channelId forKey:@"channel_id"];
    //[requestForm setPostValue:type forKey:@"type"];
    [requestForm setPostValue:@"4" forKey:@"device_type"];
    [requestForm setPostValue:uid forKey:@"uid"];
    [requestForm setPostValue:G_BINDCERVERSION forKey:@"appcert"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
//    NSString *str = [requestForm responseString];
//    NSLog(@"解除str:%@",str);
//    NSLog(@"data:%@",data);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"解除推送绑定result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            flag = YES;
        }
    }
    [requestForm release];
    
    return flag;
}

//----update by kate 2015.05.05--------------------------------------
// 是否被T
+(NSDictionary*)isUnBind{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *clientId = [userDefaults objectForKey:@"Baidu_UserID"];
    
   // BOOL flag = NO;
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"PushService" forKey:@"ac"];
    [requestForm setPostValue:@"check" forKey:@"op"];
    
    if ([@"5303"  isEqual: G_SCHOOL_ID] || [@"8802"  isEqual: G_SCHOOL_ID]) {
        [requestForm setPostValue:clientId forKey:@"client_id"];
    }else {
        NSString *appleToken = [userDefaults objectForKey:@"appleToken"];
        [requestForm setPostValue:appleToken forKey:@"client_id"];
    }
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
//    if (nil != data) {
//        result = [data objectFromJSONData];
//        NSLog(@"是否被T绑定result:%@",result);
//        if([[result objectForKey:@"result"] integerValue]==1 ){//返回Yes是没有被T
//            flag = YES;
//        }
//    }else {
//        flag = YES;
//    }
    if (nil!=data) {
         result = [data objectFromJSONData];
        NSLog(@"是否被T绑定result:%@",result);
    }
    [requestForm release];
    return result;
}
//------------------------------------------------------------------------------

// 我的消息检查红点 add by kate 2014.12.03 ------------------------------------------------
+(int)checkNewsForMsg:(NSString*)lastId{
    /*
     params.put("ac", "MessageCenter");
     params.put("v", "2");
     params.put("op", "check");
     params.put("last", id + "");
     params.put("uid", ConfigDao.getInstance().getUID() + "");
     params.put("sid", MainConfig.sid);
     */
    int newCount = 0;
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"MessageCenter" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"check" forKey:@"op"];
    
    [requestForm setPostValue:lastId forKey:@"last"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"消息检查红点result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            newCount = [[result objectForKey:@"message"] intValue];
        }
    }
    [requestForm release];
    return newCount;
    
}
//---------------------------------------------------------------------------------------

// 获取班级详情接口 update 2014.01.12
+(NSDictionary*)getMyclassDetail:(NSString*)cid{
    
    // v=2&ac=Class op=profile, sid=, cid=, uid=
    /*
     * 新版班级页面, for 1.8+
     * @args
     * op=profile, sid=, cid=, uid=, announcements=[1,0]
     */

    NSDictionary *listDic = nil;
    NSLog(@"cid:%@",cid);
    
    //ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Class" forKey:@"ac"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:@"profile" forKey:@"op"];
    [requestForm setPostValue:cid forKey:@"cid"];
    [requestForm setPostValue:@"1" forKey:@"announcements"];//for v1.8+
    [requestForm setTimeOutSeconds:60];
    NSString *app = [Utilities getAppVersion];
    [requestForm setPostValue:app forKey:@"app"];

    requestForm.delegate = self;
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    NSLog(@"classDetailStr:%@",[requestForm responseString]);
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"获取班级详情result:%@",result);
        if([[result objectForKey:@"result"] integerValue]==1 ){
            listDic = [result objectForKey:@"message"];
        }
    }
    [requestForm release];
    return listDic;
}

//-----------------------------------------
//* action: 通过Url从服务器获取图片（头像，缩略图，大图）
//* add date: 2014.01.28
//* update date:
//* author: kate
//------------------------------------------
+ (BOOL)getPicWithUrl:(NSString *)url picType:(NSInteger)type userid:(long long)cid msgid:(long long)msg_id
{
    ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:url]];
    [requestForm setRequestMethod:@"GET"];
    [requestForm setDelegate:self];
    [requestForm setTimeOutSeconds:150];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    
    BOOL rc = NO;
    if (nil != data) {
        
        if (type == 0) {
            NSString *headImagePath = [Utilities getHeadImagePath:cid];
            
            if ([data writeToFile:headImagePath atomically:YES]) {
                rc = YES;
                NSLog(@"receive head pic writeToFile:%@", headImagePath);
            }
        }else{
            
            long long user_id = cid;
            
            if (type == PIC_TYPE_HEAD) {
                NSString *headImagePath = [Utilities getHeadImagePath:user_id imageName:[url lastPathComponent]];
                
                // 创建聊天缩略图片，并写入本地
                if ([data writeToFile:headImagePath atomically:YES]) {
                    rc = YES;
                    NSLog(@"receive head pic writeToFile:%@", headImagePath);
                }
                
            } else if (type == PIC_TYPE_THUMB) {
                // 取得msgID
                NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
                
                NSString *thumbImageDir = [Utilities getChatPicThumbDir:user_id];
                NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
                NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
                //NSString *imagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, msgid, FILE_JPG_EXTENSION];
                
                // 创建聊天缩略图片，并写入本地
                if ([data writeToFile:thumbImagePath atomically:YES]) {
                    rc = YES;
                    //NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
                }
                
            } else if (type == PIC_TYPE_ORIGINAL) {
                // 取得msgID
                NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
                
                NSString *originalImageDir = [Utilities getChatPicOriginalDir:user_id];
                NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
                NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
                
                // 创建聊天大图片，并写入本地
                if ([data writeToFile:originalImagePath atomically:YES]) {
                    rc = YES;
                    NSLog(@"receive original pic writeToFile:%@", originalImagePath);
                }
            }

        }
        
    }
    
    return  rc;
    
    /*NSURL *URL = [NSURL URLWithString:url];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSString *filePath = @"";
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.inputStream   = [NSInputStream inputStreamWithURL:URL];
    
    if (type == 0) {
        
        filePath = [Utilities getHeadImagePath:cid];
        
    }else{
        
        long long user_id = cid;
        
        if (type == PIC_TYPE_HEAD) {
            filePath = [Utilities getHeadImagePath:user_id imageName:[url lastPathComponent]];
            
        } else if (type == PIC_TYPE_THUMB) {
            // 取得msgID
            NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
            
            NSString *thumbImageDir = [Utilities getChatPicThumbDir:user_id];
            NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
            NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
            //NSString *imagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, msgid, FILE_JPG_EXTENSION];
            filePath = thumbImagePath;
           
            
        } else if (type == PIC_TYPE_ORIGINAL) {
            // 取得msgID
            NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
            
            NSString *originalImageDir = [Utilities getChatPicOriginalDir:user_id];
            NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
            NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
            
            filePath = originalImagePath;
            
        }
        
    }
    
    operation.outputStream  = [NSOutputStream outputStreamToFileAtPath:filePath append:NO];
    
    __block BOOL rc = NO;
    
    //已完成下载
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSData *data = [NSData dataWithContentsOfFile:filePath];
        
        if (nil!= data) {
            rc = NO;
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
    
    [operation start];
   

    return rc;*/
}



//-----------------------------------------
//* action: 通过url获取语音
//* add date: 2014.09.25
//* update date:
//* author: kate
//------------------------------------------
+(BOOL)getAudioFromServer:(NSString*)url userid:(long long)uid msgid:(long long)msg_id{
    
    ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:url]];
    [requestForm setRequestMethod:@"GET"];
    [requestForm setDelegate:self];
    [requestForm setTimeOutSeconds:150];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    
    BOOL rc = NO;
    if (nil != data) {
        
         long long user_id = uid;
        // 取得msgID
        NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
        
        NSString *originalImageDir = [Utilities getChatAudioDir:user_id];
        NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"%@", FILE_AMR_EXTENSION];
        NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
        
        //创建源文件，并写入本地成功
        if ([data writeToFile:originalImagePath atomically:YES]) {
           // NSLog(@"receive Audio writeToFile:%@", originalImagePath);
            rc = YES;
        }
        
    }
    
    return  rc;
}

+(UIImage*)getClassmatePic:(NSString*)url{
    
    UIImage *image = nil;
    ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:url]];
    [requestForm setRequestMethod:@"GET"];
    [requestForm setDelegate:self];
    //[requestForm setTimeOutSeconds:150];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    
    if (nil != data) {
        
        image = [UIImage imageWithData:data];
        
    }
   
    return image;
}


//-----------------------------------------
//* action: 转发聊天消息
//* add date: 2015.03.25
//* update date:
//* author: kate
//------------------------------------------
+(NSString*)transpondMsg:(ChatDetailObject*)chatDetail receivers:(NSString*)receivers{
    
    /*
     * 聊天消息转发接口
     * @author luke
     * @date 2015.03.23
     * @args
     *  op=forward, sid=, uid=, mid=转发消息的messageID, receivers=uid:msgid,....
     *
     */
    
    
    //ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    //op=send&uid=from&fuid=to&type=&msgid=&message=&file=
    [requestForm setPostValue:@"Message" forKey:@"ac"];
    [requestForm setPostValue:@"forward" forKey:@"op"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.msg_id] forKey:@"mid"];
    
    [requestForm setPostValue:receivers forKey:@"receivers"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSString *rc = @"NO";
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"转发消息result:%@",result);
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            
            //rc = @"YES";
            NSDictionary *dic = [result objectForKey:@"message"];
            rc = [NSString stringWithFormat:@"YES%@",[dic objectForKey:@"timestamp"]];
           
        } else if ([[result objectForKey:@"result"] integerValue] == 0) {
            
            rc = @"NO";
            NSLog(@"转发消息失败message:%@", [result objectForKey:@"message"]);
        }
    }
    NSLog(@"transpond message responseStatusCode:%d responseStatusMessage:%@ --- transpond result:%@", [requestForm responseStatusCode], [requestForm responseStatusMessage], rc);
    [requestForm release];
    return rc;
}

//-----------------------------------------
//* action: 发送新版聊天消息
//* add date: 2016.01.20
//* update date:
//* author: kate
//------------------------------------------
+ (NSDictionary *)sendMsgForMix:(MixChatDetailObject *)chatDetail{
    
    /**
     * 聊天消息发送接口
     * 后端根据gid判断聊天类型: 0 单聊, >0 群聊
     * 1. 单聊时 friend: 对方UID
     * 2. 群聊时 friend: 暂定0
     * @author luke
     * @date 2016.01.20
     * @args
     *  v=3, ac=Message, op=send, sid=, uid=, friend=, gid=, msgid=, type=, message=, file=图片或者语音, size=语音长度
     */
    
    NSString *friend = [NSString stringWithFormat:@"%lli", chatDetail.user_id];
    
    if (chatDetail.groupid == 0) {//单聊
        
        friend = [NSString stringWithFormat:@"%lli:%@",chatDetail.schoolID,friend];//对方的sid
        
    }

    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"Message" forKey:@"ac"];
    [requestForm setPostValue:@"send" forKey:@"op"];
    [requestForm setPostValue:@"3" forKey:@"v"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld", (long)chatDetail.msg_type] forKey:@"type"];
    [requestForm setPostValue:friend forKey:@"friend"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.groupid] forKey:@"gid"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.msg_id] forKey:@"msgid"];
    [requestForm setPostValue:chatDetail.msg_content forKey:@"message"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld",(long)chatDetail.audioSecond] forKey:@"size"];
    
    if (chatDetail.msg_type == MSG_TYPE_PIC || chatDetail.msg_type == MSG_TYPE_Audio) {
        [requestForm setFile:chatDetail.msg_file forKey:@"file"];
    }
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSString *rc = @"NO";
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"发送消息result:%@",result);
//        if ([[result objectForKey:@"result"] integerValue] == 1) {
//            //rc = @"YES";
//            NSDictionary *dic = [result objectForKey:@"message"];
//            rc = [NSString stringWithFormat:@"YES%@",[dic objectForKey:@"timestamp"]];
//            
//            //NSLog(@"bbb:%@",[rc substringFromIndex:3]);
//        } else if ([[result objectForKey:@"result"] integerValue] == 0) {
//            
//            rc = @"NO";
//            NSLog(@"发送消息失败message:%@", [result objectForKey:@"message"]);
//        }
    }
    NSLog(@"send message responseStatusCode:%d responseStatusMessage:%@ --- send result:%@", [requestForm responseStatusCode], [requestForm responseStatusMessage], rc);
    [requestForm release];
    return result;
    
}

//-----------------------------------------
//* action: 发送群聊聊天消息
//* add date: 2014.05.04
//* update date:
//* author: kate
//------------------------------------------
+ (NSString *)sendMsgForGroup:(GroupChatDetailObject *)chatDetail{
    
    /*
     * 发送聊天消息
     * @author luke
     * @date    2015.05.26
     * @args
     *  op=send, sid=, uid=, gid=, msgid=, type=, message=, png0=图片, arm0=语音
     */
  
    ASIFormDataRequest *requestForm = [self initNewRequest];
    [requestForm setPostValue:@"GroupChat" forKey:@"ac"];
    [requestForm setPostValue:@"send" forKey:@"op"];
    [requestForm setPostValue:@"2" forKey:@"v"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld", (long)chatDetail.msg_type] forKey:@"type"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.groupid] forKey:@"gid"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.msg_id] forKey:@"msgid"];
    [requestForm setPostValue:chatDetail.msg_content forKey:@"message"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld",(long)chatDetail.audioSecond] forKey:@"size"];
  
    if (chatDetail.msg_type == MSG_TYPE_PIC || chatDetail.msg_type == MSG_TYPE_Audio) {
        [requestForm setFile:chatDetail.msg_file forKey:@"file"];
    }
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSString *rc = @"NO";
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"发送消息result:%@",result);
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            //rc = @"YES";
            NSDictionary *diction = [result objectForKey:@"message"];
            NSDictionary *dic = [diction objectForKey:@"message"];
            rc = [NSString stringWithFormat:@"YES%@",[dic objectForKey:@"dateline"]];
          
            //NSLog(@"bbb:%@",[rc substringFromIndex:3]);
        } else if ([[result objectForKey:@"result"] integerValue] == 0) {
            
            rc = @"NO";
            NSLog(@"发送消息失败message:%@", [result objectForKey:@"message"]);
        }
    }
    NSLog(@"send message responseStatusCode:%d responseStatusMessage:%@ --- send result:%@", [requestForm responseStatusCode], [requestForm responseStatusMessage], rc);
    [requestForm release];
    return rc;
    
}

//-----------------------------------------
//* action: 发送聊天消息
//* add date: 2014.05.04
//* update date:
//* author: kate
//------------------------------------------
+ (NSString *)sendMsg:(ChatDetailObject *)chatDetail{
    //ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", REQ_URL]]];
    
    NSLog(@"chatDetail.msg_content:%@",chatDetail.msg_content);
    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    //op=send&uid=from&fuid=to&type=&msgid=&message=&file=
    [requestForm setPostValue:@"Message" forKey:@"ac"];
    [requestForm setPostValue:@"send" forKey:@"op"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld", (long)chatDetail.msg_type] forKey:@"type"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.user_id] forKey:@"fuid"];
    //[requestForm setPostValue:[Utilities timeIntervalToDate:chatDetail.timestamp timeType:7 compareWithToday:NO] forKey:@"cTime"];
    [requestForm setPostValue:chatDetail.msg_content forKey:@"message"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", chatDetail.msg_id] forKey:@"msgid"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%ld",(long)chatDetail.audioSecond] forKey:@"size"];//2015.11.03 2.9.1新需求
    //add by kate 2014.01.20 加入sid
    if (chatDetail.msg_type == MSG_TYPE_PIC || chatDetail.msg_type == MSG_TYPE_Audio) {
        [requestForm setFile:chatDetail.msg_file forKey:@"file"];
    }
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSString *rc = @"NO";
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"发送消息result:%@",result);
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            //rc = @"YES";
            NSDictionary *dic = [result objectForKey:@"message"];
            rc = [NSString stringWithFormat:@"YES%@",[dic objectForKey:@"timestamp"]];
            //NSLog(@"aaa:%@",[rc substringToIndex:3]);
            NSLog(@"bbb:%@",[rc substringFromIndex:3]);
        } else if ([[result objectForKey:@"result"] integerValue] == 0) {
//            if ([[result objectForKey:@"code"] integerValue] == 603) {
//                rc = [NSString stringWithFormat:@"%@", [result objectForKey:@"message"]];
//            }
            rc = @"NO";
            NSLog(@"发送消息失败message:%@", [result objectForKey:@"message"]);
        }
    }
    NSLog(@"send message responseStatusCode:%d responseStatusMessage:%@ --- send result:%@", [requestForm responseStatusCode], [requestForm responseStatusMessage], rc);
    [requestForm release];
    return rc;
    
}

//-----------------------------------------
//* action: 收取聊天消息
//* add date: 2014.05.04
//* update date:
//* author: kate
//------------------------------------------
/*+ (NSInteger)getMsg{
   
    //ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequest];
    GlobalSingletonUserInfo* userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;;
    NSDictionary *message_info = [userInfo getUserDetailInfo];
//    NSString* userid = [Utilities getUniqueUidWithoutQuit];

    [requestForm setPostValue:@"Message" forKey:@"ac"];
    [requestForm setPostValue:@"unread" forKey:@"op"];
    [requestForm setPostValue:@"4" forKey:@"device"];

    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSInteger cnt = 0;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"收消息result:%@",result);
        
//         收消息result:{
//         message =     (
//         {
//         description = "\U597d";
//         fuid = 52352;6
//         msgid = 224819937241600;
//         title = "\U8001\U5e080004:";
//         type = 0;
//         uid = 52344;
//         url = "";
//         },
        
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            NSArray *message = [result objectForKey:@"message"];
            cnt = [message count];
            for (int i = 0; i < cnt; i++) {
                NSDictionary *msg = [message objectAtIndex:i];
                long long userid = [[msg objectForKey:@"fuid"] longLongValue];
                NSLog(@"userid:%lli",userid);
                ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
                // 消息的msgID
                chatDetail.msg_id = [[msg objectForKey:@"msgid"] longLongValue];
                chatDetail.user_id = userid;
                // 消息的发送(0)接收(1)区分
                chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                //消息类型-文本
                chatDetail.msg_type = [[msg objectForKey:@"type"] integerValue];
                // 消息状态：发送，已读，未读，失败等
                chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
                // 消息内容
                if (chatDetail.msg_type == MSG_TYPE_PIC) {
                    chatDetail.msg_content = @"[图片]";
                    // 原始图片文件的HTTP-URL地址
                    chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
                }else if(chatDetail.msg_type == MSG_TYPE_Audio){
                    chatDetail.msg_content = @"[语音]";
                    chatDetail.audio_url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                }
                else {
                    chatDetail.msg_content = [Utilities replaceNull:[msg objectForKey:@"description"]];
                }
                //NSLog(@"content:%@",chatDetail.msg_content);
                
                // 文件名（语音，图片，涂鸦）
                chatDetail.msg_file = @"";
                
               
                #if 1
                
                NSString *url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                chatDetail.pic_url_thumb = [NSString stringWithFormat:@"%@%@",url,@"@240w_1l.png"];
                chatDetail.pic_url_original = url;
                
                #else
                
                chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
                
                #endif
                
                NSString *timestampStr = [Utilities replaceNull:[msg objectForKey:@"timestamp"]];
                //chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
                chatDetail.timestamp = [timestampStr longLongValue]*1000;
                //NSLog(@"timestamp:%lli",chatDetail.timestamp);
                [chatDetail updateToDB];
                
                ChatListObject *chatList = [[ChatListObject alloc] init];
                chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", userid];
                chatList.is_recieved = MSG_IO_FLG_RECEIVE;
                //最后一条消息ID
                chatList.last_msg_id= chatDetail.msg_id;
                // 聊天的最后一条消息的类型
                chatList.last_msg_type= chatDetail.msg_type;
                // 聊天的最后一条消息内容
                chatList.last_msg = chatDetail.msg_content;
                //该条消息状态
                chatList.msg_state = MSG_RECEIVED_SUCCESS;
                chatList.user_id = userid;
                chatList.mid = [msg objectForKey:@"mid"];//add 2015.01.25
                
                UserObject *user = [UserObject getUserInfoWithID:userid];
                if (user) {
                    if ([user.name length] > 0) {
                        chatList.title = user.name;
                    } else {
                        chatList.title = NO_NAME_USER;
                    }
                } else {
                    NSLog(@"userid1:%lli",userid);
                    // ac=Profile&op=view&uid=227
                    if (userid!=0) {
                        user = [FRNetPoolUtils getSalesmenWithID:userid];
                        if (user.user_id != 0) {
                            if ([user.name length] > 0) {
                                chatList.title = user.name;
                            } else {
                                chatList.title = NO_NAME_USER;
                            }
                        } else {
                            chatList.title = NO_NAME_USER;
                        }
                    }
                    
                }
                //时间戳
                chatList.timestamp = chatDetail.timestamp;
                [chatList updateToDB];
                
                // 如果有图片资源此处需要开线程下载图片，此时先拉取缩略图，点击查看大图时再拉取大图
                if ([chatDetail.pic_url_thumb length] > 0) {
                    
                   [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:chatDetail.user_id msgid:chatDetail.msg_id];
//                    if (isSaved) {
//                        //----------updaet by kate 2015.03.27--------------------------------------------------------
//                        NSString *thumbImageDir = [Utilities getChatPicThumbDir:chatDetail.user_id];// updaet by kate 2015.03.27
//                        NSString *thumbImagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, chatDetail.msg_id,FILE_JPG_EXTENSION];
////                        NSString *msgIDKey = [[NSNumber numberWithLongLong:chatDetail.msg_id] stringValue];
////                        NSString *thumbImageDir = [Utilities getChatPicThumbDir:chatDetail.user_id];
////                        NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
////                        NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
//                        //----------------------------------------------------------------------------
//                        // 文件名（语音，图片，涂鸦）
//                        chatDetail.msg_file = thumbImagePath;
//                       
//                    }
//                     放在这更新数据库收消息收不到
//                    [chatDetail updateToDB];
//                    [chatList updateToDB];
                }
                if([chatDetail.audio_url length] > 0){
                    
                   BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                    //---update 2015.07.07---------------------------------------
                    if (isGot) {
                        
                        RecordAudio *recordAudio = [[RecordAudio alloc] init];

                        NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                        NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                        
                        NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                        NSInteger audioSecond = [recordAudio dataDuration:fileData];
                        chatDetail.audioSecond = audioSecond;
                        [chatDetail updateAudio];
                        
                    }
                    //------------------------------------------------------------
                    
                }
                
                [chatDetail release];
                [chatList release];
            }
           
        }
    }
    
    [requestForm release];
    return cnt;

}*/

/*
 * 获取消(man)息(you), 根据客户端上传的last（ID）
 * @author luke
 * @date 2015.08.24
 * @args 收消息新接口 发送最后一条id：mid uid和fuid判断是收消息类型或发消息类型
 *  v=1, ac=Message, op=receive, sid=, uid=, last=消息ID
 */
+ (NSInteger)getMsg{
    
    // 单独存放最后一条消息mid，每次接收消息更新它
    NSString *myUserId = [Utilities getUniqueUidWithoutQuit];
    NSString *last = [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
    if (!last) {
        last = @"0";
    }
    
    long long tempLast = [last longLongValue];
    
    ASIFormDataRequest *requestForm = [self initNewRequest];
    
    [requestForm setPostValue:@"Message" forKey:@"ac"];
    [requestForm setPostValue:@"receive" forKey:@"op"];
    [requestForm setPostValue:@"1" forKey:@"v"];
    [requestForm setPostValue:last forKey:@"last"];
    
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    NSInteger cnt = 0;
    if (nil != data) {
        
        result = [data objectFromJSONData];
        NSLog(@"收消息result:%@",result);
        
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            NSArray *message = [result objectForKey:@"message"];
            cnt = [message count];
            
            if(cnt > 0){//2015.11.19 更新主页单聊数字
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"addNewCountForMsg" object:nil];
            }
            
            for (int i = 0; i < cnt; i++) {
                
                NSDictionary *msg = [message objectAtIndex:i];
                long long userid = [[msg objectForKey:@"fuid"] longLongValue];
                //NSLog(@"userid:%lli",userid);
                long long uid = [[msg objectForKey:@"uid"] longLongValue];
                //NSLog(@"userid:%lli",uid);
                long long myUid = [[Utilities getUniqueUidWithoutQuit] longLongValue];
                long long lastMid = [[msg objectForKey:@"mid"] longLongValue];
                NSString *audioSize = [Utilities replaceNull:[NSString stringWithFormat:@"%@",[msg objectForKey:@"size"]]];//add 2015.11.03
                
#if 0
                if (lastMid > [last longLongValue]) {
                    
                    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                    [defaults setObject:[NSString stringWithFormat:@"%lli",lastMid] forKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
                    [defaults synchronize];
                }
#endif
                
                if (lastMid > tempLast) {
                    tempLast = lastMid;
                }
                
                ChatDetailObject *chatDetail = [[ChatDetailObject alloc] init];
                // 消息的msgID
                chatDetail.msg_id = [[msg objectForKey:@"msgid"] longLongValue];
                if (myUid == userid) {//如果相同那么userid就是自己 fuid收信人
                    chatDetail.user_id = uid;
                    // 消息的发送(0)接收(1)区分
                    chatDetail.is_recieved = MSG_IO_FLG_RECEIVE;
                    
                    if ([last isEqualToString:@"0"]) {
                        chatDetail.msg_state = MSG_READ_FLG_READ;
                        
                    }else{
                        // 消息状态：发送，已读，未读，失败等
                        chatDetail.msg_state = MSG_RECEIVED_SUCCESS;
 
                    }

                }else if(myUid == uid){//如果相同那么uid就是自己
                    chatDetail.user_id = userid;
                    // 消息的发送(0)接收(1)区分
                    chatDetail.is_recieved = MSG_IO_FLG_SEND;
                   
                    if ([last isEqualToString:@"0"]) {
                        chatDetail.msg_state = MSG_READ_FLG_READ;
                       
                        
                    }else{
                        // 消息状态：发送，已读，未读，失败等
                        chatDetail.msg_state = MSG_SEND_SUCCESS;
                    }
                }else{
                    continue;
                }
                
                //消息类型-文本
                chatDetail.msg_type = [[msg objectForKey:@"type"] integerValue];
                
                // 消息内容
                if (chatDetail.msg_type == MSG_TYPE_PIC) {
                    chatDetail.msg_content = @"[图片]";
                    // 原始图片文件的HTTP-URL地址
                    chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
                }else if(chatDetail.msg_type == MSG_TYPE_Audio){
                    chatDetail.msg_content = @"[语音]";
                    chatDetail.audio_url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                    chatDetail.audioSecond = [audioSize integerValue];//add 2015.11.03
                    
                }
                else {
                    chatDetail.msg_content = [Utilities replaceNull:[msg objectForKey:@"description"]];
                }
                //NSLog(@"content:%@",chatDetail.msg_content);
                
                // 文件名（语音，图片，涂鸦）
                chatDetail.msg_file = @"";
                
                
#if 1
                
                NSString *url = [Utilities replaceNull:[msg objectForKey:@"url"]];
                chatDetail.pic_url_thumb = [NSString stringWithFormat:@"%@%@",url,@"@240w_1l.png"];
                chatDetail.pic_url_original = url;
                
#else
                
                chatDetail.pic_url_thumb = [Utilities replaceNull:[msg objectForKey:@"url"]];
                chatDetail.pic_url_original = [Utilities replaceNull:[msg objectForKey:@"url"]];
                
#endif
                
                NSString *timestampStr = [Utilities replaceNull:[msg objectForKey:@"timestamp"]];
                //chatDetail.timestamp = [[NSDate date] timeIntervalSince1970]*1000;
                chatDetail.timestamp = [timestampStr longLongValue]*1000;
                //NSLog(@"timestamp:%lli",chatDetail.timestamp);
                [chatDetail updateToDB];
                if ([last isEqualToString:@"0"]){
                    if (chatDetail.msg_type == MSG_TYPE_Audio){
                        chatDetail.msg_state_audio = MSG_READ_FLG_READ_AUDIO;
                        [chatDetail updateAudioState];
                    }
                }
                
                ChatListObject *chatList = [[ChatListObject alloc] init];
                chatList.msg_table_name = [NSString stringWithFormat:@"msgInfo_%lli", userid];
                chatList.is_recieved = chatDetail.is_recieved;
                //最后一条消息ID
                //chatList.last_msg_id = chatDetail.msg_id;
                if (chatDetail.msg_id > chatList.last_msg_id) {
                   chatList.last_msg_id = chatDetail.msg_id;
                    // 聊天的最后一条消息内容
                    chatList.last_msg = chatDetail.msg_content;
                }
                // 聊天的最后一条消息的类型
                chatList.last_msg_type = chatDetail.msg_type;
                //该条消息状态
                chatList.msg_state = chatDetail.msg_state;
                chatList.user_id = chatDetail.user_id;
                chatList.mid = [msg objectForKey:@"mid"];//add 2015.01.25
                
                
                //UserObject *user = [UserObject getUserInfoWithID:userid];
                UserObject *user = [UserObject getUserInfoWithID:chatDetail.user_id];
                if (user) {
                    if ([user.name length] > 0) {
                        chatList.title = user.name;
                    } else {
                        chatList.title = NO_NAME_USER;
                    }
                } else {
                    //NSLog(@"userid1:%lli",userid);
                    // ac=Profile&op=view&uid=227
                    if (userid!=0) {
                        user = [FRNetPoolUtils getSalesmenWithID:userid];
                        if (user.user_id != 0) {
                            if ([user.name length] > 0) {
                                chatList.title = user.name;
                            } else {
                                chatList.title = NO_NAME_USER;
                            }
                        } else {
                            chatList.title = NO_NAME_USER;
                        }
                    }
                    
                }
                //时间戳
                chatList.timestamp = chatDetail.timestamp;
                [chatList updateToDB];
                
                // 如果有图片资源此处需要开线程下载图片，此时先拉取缩略图，点击查看大图时再拉取大图
                if ([chatDetail.pic_url_thumb length] > 0) {
                    
                    [FRNetPoolUtils getPicWithUrl:chatDetail.pic_url_thumb picType:PIC_TYPE_THUMB userid:chatDetail.user_id msgid:chatDetail.msg_id];
                 
                }
                if([chatDetail.audio_url length] > 0){
                    
                    BOOL isGot = [FRNetPoolUtils getAudioFromServer:chatDetail.audio_url userid:chatDetail.user_id msgid:chatDetail.msg_id];
                    //---update 2015.07.07---------------------------------------------------------------
                    if (isGot) {
                        
                        if ([audioSize length] >0 && [audioSize integerValue]!=0) {//update 2015.11.03
                            
                        }else{
                            RecordAudio *recordAudio = [[RecordAudio alloc] init];
                            
                            NSString *audioDir = [Utilities getChatAudioDir:chatDetail.user_id];
                            NSString *audioPath = [NSString stringWithFormat:@"%@/%lli%@", audioDir, chatDetail.msg_id, FILE_AMR_EXTENSION];
                            
                            NSData *fileData = [NSData dataWithContentsOfFile:audioPath];
                            NSInteger audioSecond = [recordAudio dataDuration:fileData];
                            chatDetail.audioSecond = audioSecond;
                            [chatDetail updateAudio];
                        }
                        
                       
                        
                    }
                    //---------------------------------------------------------------------------------
                    
                }
                
                [chatDetail release];
                [chatList release];
            }
            
           
                NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:[NSString stringWithFormat:@"%lli",tempLast] forKey:[NSString stringWithFormat:@"lastMid_%@",myUserId]];
                [defaults synchronize];
                
            
        }
    }
    
    [requestForm release];
    return cnt;
    
}


//-----------------------------------------
//* action: 获取对方个人信息
//* add date: 2014.02.26
//* update date:
//* author: kate
//------------------------------------------
+ (UserObject *)getSalesmenWithID:(long long)user_id
{
    /// ac=Profile&op=view&uid=227
    UserObject *userObject = [[UserObject alloc] init];
    //ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    //NSLog(@"user_id:%lli",user_id);
    [requestForm setPostValue:@"Profile" forKey:@"ac"];
    [requestForm setPostValue:@"view" forKey:@"op"];
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", user_id] forKey:@"uid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        NSLog(@"获取对方的个人信息result:%@",result);
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            NSDictionary *user = [result objectForKey:@"message"];
            userObject.user_id = [[Utilities replaceNull:[NSString stringWithFormat:@"%@",[user objectForKey:@"uid"]]] longLongValue];
            userObject.name = [Utilities replaceNull:[user objectForKey:@"name"]];
            userObject.headimgurl = [Utilities replaceNull:[user objectForKey:@"avatar"]];
            [userObject updateToDB];
            
            NSString *uid = [Utilities getUniqueUidWithoutQuit];
            // 更改聊天列表的title
            NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where uid = %lli and user_id = %lli and gid = 0", userObject.name,[uid longLongValue],userObject.user_id];
            [[DBDao getDaoInstance] executeSql:updateListSql];
        }
    }
    
    [requestForm release];
    return [userObject autorelease];
}

// 获取个人信息接口 新 done:新接口
+ (UserObject *)getSalesmenWithID:(long long)user_id sid:(long long)sid
{
    UserObject *userObject = [[UserObject alloc] init];
    //ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", REQ_URL]]];
    ASIFormDataRequest *requestForm = [self initNewRequestWithoutUid];
    //NSLog(@"user_id:%lli",user_id);
    [requestForm setPostValue:@"Profile" forKey:@"ac"];
    [requestForm setPostValue:@"view" forKey:@"op"];
    
    if (sid > 0) {
        [requestForm setPostValue:[NSString stringWithFormat:@"%lli", sid] forKey:@"sid"];
    }
    [requestForm setPostValue:[NSString stringWithFormat:@"%lli", user_id] forKey:@"uid"];
    requestForm.delegate = self;
    [requestForm startSynchronous];
    
    NSData *data = [requestForm responseData];
    NSDictionary *result = nil;
    if (nil != data) {
        result = [data objectFromJSONData];
        //NSLog(@"获取对方的个人信息result:%@",result);
        if ([[result objectForKey:@"result"] integerValue] == 1) {
            
            NSDictionary *user = [result objectForKey:@"message"];
            // 2016.07.11
            if ([[Utilities replaceNull:[NSString stringWithFormat:@"%@",[user objectForKey:@"uid"]]] length] > 0) {
                userObject.user_id = [[user objectForKey:@"uid"] longLongValue];
            }else{
                userObject.user_id = user_id;
            }
            
            userObject.name = [Utilities replaceNull:[user objectForKey:@"name"]];
            userObject.headimgurl = [Utilities replaceNull:[user objectForKey:@"avatar"]];
            [userObject updateToDB];
            
            NSLog(@"user:%@",user);
            
            // 更改聊天列表的title
            NSString *updateListSql =[NSString stringWithFormat: @"update msgListMix set title = '%@' where user_id = %lli and uid = %lli and gid = 0 and sid = %lli", userObject.name, userObject.user_id,[Utilities getUniqueUid].longLongValue,sid];
            [[DBDao getDaoInstance] executeSql:updateListSql];
        }
    }
    
    [requestForm release];
    return [userObject autorelease];
}

//-----------------------------------------
//* action: 通过Url从服务器获取图片（头像，缩略图，大图）
//* add date: 2014.05.04
//* update date:
//* author: kate
//------------------------------------------
+ (BOOL)getImgWithUrl:(NSString *)url
              picType:(NSInteger)type
               userid:(long long)user_id
                msgid:(long long)msg_id{
    
    ASIFormDataRequest * requestForm = [[ASIFormDataRequest alloc ] initWithURL:[[NSURL alloc] initWithString:url]];
    [requestForm setRequestMethod:@"GET"];
    [requestForm setDelegate:self];
    [requestForm setTimeOutSeconds:150];
    [requestForm addRequestHeader:@"Content-Type" value:@"application/json"];
    [requestForm startSynchronous];
    NSData *data = [requestForm responseData];
    BOOL rc = NO;
    if (nil != data) {
        if (type == PIC_TYPE_HEAD) {
            NSString *headImagePath = [Utilities getHeadImagePath:user_id imageName:[url lastPathComponent]];
            
            // 创建聊天缩略图片，并写入本地
            if ([data writeToFile:headImagePath atomically:YES]) {
                rc = YES;
                NSLog(@"receive head pic writeToFile:%@", headImagePath);
            }
            
        } else if (type == PIC_TYPE_THUMB) {
            // 取得msgID
            NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
            
            NSString *thumbImageDir = [Utilities getChatPicThumbDir:user_id];
            NSString *thumbFilename = [msgIDKey stringByAppendingFormat:@"_thumb%@", FILE_JPG_EXTENSION];
            NSString *thumbImagePath = [thumbImageDir stringByAppendingPathComponent:thumbFilename];
            //NSString *imagePath = [NSString stringWithFormat:@"%@/%lli_thumb%@", thumbImageDir, msgid, FILE_JPG_EXTENSION];
            
            // 创建聊天缩略图片，并写入本地
            if ([data writeToFile:thumbImagePath atomically:YES]) {
                rc = YES;
                //NSLog(@"receive thumb pic writeToFile:%@", thumbImagePath);
            }
            
        } else if (type == PIC_TYPE_ORIGINAL) {
            // 取得msgID
            NSString *msgIDKey = [[NSNumber numberWithLongLong:msg_id] stringValue];
            
            NSString *originalImageDir = [Utilities getChatPicOriginalDir:user_id];
            NSString *originalFilename = [msgIDKey stringByAppendingFormat:@"_original%@", FILE_JPG_EXTENSION];
            NSString *originalImagePath = [originalImageDir stringByAppendingPathComponent:originalFilename];
            
            // 创建聊天大图片，并写入本地
            if ([data writeToFile:originalImagePath atomically:YES]) {
                rc = YES;
                NSLog(@"receive original pic writeToFile:%@", originalImagePath);
            }
        }
    }
    
    return  rc;

}

//-----------------------------------------
//* action: 安装上报
//* add date: 2013.03.19
//* update date:
//* author: Kate
//------------------------------------------
+ (BOOL)uploadInstallationReport:(NSString *)reportString
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString *installReport = [Utilities replaceNull:reportString];
    
    if ([installReport length] == 0) {
        
        NSString *myUserID = [Utilities getUniqueUidWithoutQuit];
        if ([myUserID length] == 0) {
            myUserID = @"0";
        }
        NSString *softVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *buidVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
        NSString *UUID = [Utilities getDeviceUUID];//相当于imei
        NSString *deviceVersion = [Utilities deviceVersion];
        NSString *OSVersion = [UIDevice currentDevice].systemVersion;
        //安装上报
        // “上报点id（1001）|时间戳（秒）|学校id|用户id|imei|平台id|build号|版本号|经度|纬度|手机品牌|手机型号|OS版本号"
        
        long long  timeInterval = [[NSDate date] timeIntervalSince1970];
        
        installReport  = [NSString stringWithFormat:@"1001|%lli|%@|%@|%@|4|%@|%@|%@|%@|apple|%@|%@",timeInterval, G_SCHOOL_ID,myUserID,UUID,buidVersion,softVersion,@"0",@"0",deviceVersion,OSVersion];
    }
    
    BOOL flag = NO;
    
    if (installReport != nil && [installReport length] > 0) {
        
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",Report_URL]]];
        [requestForm setPostValue:installReport forKey:@"d"];
        requestForm.delegate = self;
        [requestForm startSynchronous];
        
        //NSData *data = [requestForm responseData];
        int code = [requestForm responseStatusCode];
        if (code == 200) {//上报成功
            flag = YES;
            [userDefaults setObject:@"" forKey:@"InstallReportString"];
        }else{
            [userDefaults setObject:installReport forKey:@"InstallReportString"];

        }
        
        [requestForm release];
    }
    [userDefaults synchronize];
    return  flag;
}

//-----------------------------------------
//* action: 其他后台上报
//* add date: 2015.06.23
//* update date:
//* author: kate
//------------------------------------------
+ (BOOL)uploadDailyReport:(NSString*)type
{
    /**
     * Class AppReportAction
     * @author luke
     * @date 2014.10.29
     * @args
     *  ac=AppReport, v=2
     */
    // class AppReportAction extends BaseAction{
        /**
         * 上报接口
         * @author luke
         * @args
         *  op=log, data=上报数据【a|b|c】
         */
    
    /**
     * @param $fields
     * [protocol_version|action|sid|uid|app_id|app_code|app_version|mobile_brand|mobile_model|os_name|os_version|IMEI]
     protocol_version: 10
     action: [login|register|bind]
     app_id:[3, 4]
     */
//***********以下为现在用的上报*******************************************************************************
//    if (MainConfig.isTestService) {
//        url = "http://182.92.8.28:8082/log/";
//    } else {
//        url = "http://182.92.8.28:8092/log/";
//    }
    
    NSMutableArray *reportArray = [[ReportDBDao getDaoInstance] getAllData];
    if ([reportArray count] == 0) {
        return NO;
    }
    
    BOOL flag = NO;
    NSMutableArray *infoArr = [[NSMutableArray alloc] initWithCapacity:[reportArray count]];
    for (ReportObject *report in reportArray) {
        NSString *reportContent = [self getReportContent:report type:type];
        if (reportContent != nil && [reportContent length] > 0) {
            [infoArr addObject:reportContent];
        }
    }
    
//    NSMutableString *reportString = [[NSMutableString alloc] init];
//    int cnt = [infoArr count];
//    for (int i = 0; i < cnt; i++) {
//        [reportString appendString:[infoArr objectAtIndex:i]];
//        
//        if (i < cnt - 1) {
//            [reportString appendString:@","];
//        }
//    }
    
   // if ([reportString length] > 0) {
    
    if ([infoArr count] >0) {
        
        ASIFormDataRequest *requestForm = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@", Report_URL]]];
        for (int i = 0; i<[infoArr count]; i++) {
             [requestForm addPostValue:[infoArr objectAtIndex:i] forKey:@"d"];
        }
       
        requestForm.delegate = self;
        [requestForm startSynchronous];

        int code = [requestForm responseStatusCode];
        if (code == 200) {//上报成功
            [[ReportDBDao getDaoInstance] deleteAllData];
            flag = YES;
        }else{
            flag = NO;
        }
        [requestForm release];
    }
    //[reportString release];
    [infoArr release];
    infoArr = nil;
    return flag;
}

//-----------------------------------------
//* action: 取得上报字符串
//* add date: 2014.11.21
//* update date:
//* author: kate
//------------------------------------------
+ (NSString *)getReportContent:(ReportObject *)report type:(NSString*)reportType
{
    
    NSString *myUserID = [Utilities getUniqueUidWithoutQuit];
    NSString *softVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
    NSString *buidVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString *UUID = [Utilities getDeviceUUID];//相当于imei
    NSString *deviceVersion = [Utilities deviceVersion];
    if ([myUserID length] == 0) {
        myUserID = @"0";
    }
    
    NSString *OSVersion = [UIDevice currentDevice].systemVersion;
    
    /*sbf.append(type).append('|')
     .append(date).append('|')
     .append(MainConfig.sid).append('|')
     .append(uid).append('|')
     .append(imei).append('|')
     .append(appId).append('|')
     .append(version).append('|')
     .append(versionName).append('|')
     .append(longitude).append('|')
     .append(latitude).append('|')
     .append(newsType);
     if (type == UsageConstant.ID_FIRST_OPEN_APP) {
     sbf.append(AppUtils.getVendor()).append('|')
     .append(AppUtils.getDevice()).append('|')
     .append(AppUtils.getOSVersion());
     }*/
    
    
    /*安装上报
    “上报点id（1001）|时间戳（秒）|学校id|用户id|imei|平台id|build号|版本号|经度|纬度|手机品牌|手机型号|OS版本号"
     
     设备类型：3 android  4 IOS
     
     其他上报
    //“上报点id|时间戳（秒）|学校id|用户id|imei|平台id|build号|版本号|经度|纬度|新闻模块标题（可不填)"*/
    
    NSString *dailyReport = nil;
    if ([reportType intValue] == 1) {// 安装上报
        
        dailyReport = [NSString stringWithFormat:@"1001|%@|%@|%@|%@|4|%@|%@|%@|%@|apple|%@|%@",report.timestamp, G_SCHOOL_ID,myUserID,UUID,buidVersion,softVersion,report.longitude,report.latitude,deviceVersion,OSVersion];
        //NSLog(@"安装上报:%@",dailyReport);
        
    }else if ([reportType intValue] == 2){// 其他上报
        
        dailyReport = [NSString stringWithFormat:@"%@|%@|%@|%@|%@|4|%@|%@|%@|%@|%@",report.eventNo,report.timestamp, G_SCHOOL_ID,myUserID,UUID,buidVersion,softVersion,report.longitude,report.latitude,report.newsModuleName];
        //NSLog(@"其他上报:%@",dailyReport);
    }
    
    return dailyReport;
    
}

+(ASIFormDataRequest*)initNewRequest{
    
    NSString *newUrlStr = [Utilities newUrl];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",newUrlStr]]];
    
    NSString *uniqueUid = [Utilities getUniqueUid4FRNetPool];
    NSLog(@"uid = %@", uniqueUid);
    if (uniqueUid != nil) {
        [request setPostValue:uniqueUid forKey:@"uid"];
    }
    [request setPostValue:G_SCHOOL_ID forKey:@"sid"];
    
    // 添加appVersion参数作为必填项
    [request setPostValue:[Utilities getAppVersion] forKey:@"app"];

    return request;
}

+(ASIFormDataRequest*)initNewRequestWithoutUid{
    
    NSString *newUrlStr = [Utilities newUrl];
    
    ASIFormDataRequest *request = [[ASIFormDataRequest alloc] initWithURL:[[NSURL alloc] initWithString:[NSString stringWithFormat:@"%@",newUrlStr]]];
    
    [request setPostValue:G_SCHOOL_ID forKey:@"sid"];
    
    // 添加appVersion参数作为必填项
    [request setPostValue:[Utilities getAppVersion] forKey:@"app"];
    
    return request;
}

@end
