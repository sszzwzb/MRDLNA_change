//
//  DataReport.m
//  MicroSchool
//
//  Created by jojo on 14-8-26.
//  Copyright (c) 2014年 jiaminnet. All rights reserved.
//

#import "DataReport.h"

@implementation DataReport

+(DataReport*)sharedGlobalSingletonDataReport
{
    static DataReport *sharedGlobalSingleton;
    @synchronized(self)
    {
        if (!sharedGlobalSingleton)
            sharedGlobalSingleton = [[DataReport alloc] init];
        return sharedGlobalSingleton;
    }
}

-(void)dataReportGPStype:(NSString *)type
{
    typeReport = type;
    
    if (_locationManager) {
        
    }else{
         _locationManager = [[CLLocationManager alloc] init];//创建位置管理器
    }
    
    _locationManager.delegate=self;
    _locationManager.desiredAccuracy=kCLLocationAccuracyBest;
    
    // 4.请求用户权限：分为：?只在前台开启定位?在后台也可定位，
    //注意：建议只请求?和?中的一个，如果两个权限都需要，只请求?即可，
    //??这样的顺序，将导致bug：第一次启动程序后，系统将只请求?的权限，?的权限系统不会请求，只会在下一次启动应用时请求?
    if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
        [_locationManager requestAlwaysAuthorization];
    }
    
    // 5.iOS9新特性：将允许出现这种场景：同一app中多个location manager：一些只能在前台定位，另一些可在后台定位（并可随时禁止其后台定位）。
//    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 9) {
//        _locationManager.allowsBackgroundLocationUpdates = YES;
//    }
    
    
    // 设置定位精度
    // kCLLocationAccuracyNearestTenMeters:精度10米
    // kCLLocationAccuracyHundredMeters:精度100 米
    // kCLLocationAccuracyKilometer:精度1000 米
    // kCLLocationAccuracyThreeKilometers:精度3000米
    // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
    // kCLLocationAccuracyBestForNavigation:导航情况下最高精度，一般要有外接电源时才能使用
    _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
    // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
    _locationManager.distanceFilter = 100000.0f; // 如果设为kCLDistanceFilterNone，则每秒更新一次;
    
    //启动位置更新
    [_locationManager startUpdatingLocation];
}

-(void)dataReportActiontype:(NSString *)type
{
    NetworkUtility *network = [[NetworkUtility alloc] init];
    network.delegate = self;
    
    NSString *dataStr = [Utilities getDataReportStr:type];
    
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"AppReport", @"ac",
                          @"log", @"op",
                          @"2", @"v",
                          dataStr, @"data",
                          nil];
    
    [network sendHttpReq:HttpReq_DataReportAction andData:data];
}

- (void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    switch (status) {
        case kCLAuthorizationStatusNotDetermined:
            if ([_locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
                if([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0) {
                    [_locationManager requestAlwaysAuthorization];
                }
            }
            break;
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *currentLocation = [locations lastObject];
    
    CLLocationCoordinate2D coor = currentLocation.coordinate;
    double latitude =  coor.latitude;
    NSString *la = [NSString stringWithFormat:@"%f", latitude];
    
    double longitude = coor.longitude;
    NSString *lo = [NSString stringWithFormat:@"%f", longitude];
    
#if 0
    // 获取详细地理信息
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation: currentLocation completionHandler:^(NSArray *array, NSError *error) {
        if (array.count > 0) {
            
            CLPlacemark *placemark = [array objectAtIndex:0];
            NSString *name = placemark.name;
            NSString *subThoroughfare = placemark.subThoroughfare;
            NSString *administrativeArea = placemark.administrativeArea;
            NSString *postalCode = placemark.postalCode;
            NSString *ISOcountryCode = placemark.ISOcountryCode;
            NSString *inlandWater = placemark.inlandWater;
            NSString *ocean = placemark.ocean;
            NSString *thoroughfare = placemark.thoroughfare;
            NSString *locality = placemark.locality;
            NSString *areasOfInterest = placemark.areasOfInterest;
            NSString *subLocality = placemark.subLocality;
            NSString *country = placemark.ISOcountryCode;
            NSString *city = placemark.locality;

            NSLog(@"--- location %@",name);
        }
    }];
#endif
    
    g_userInfo = GlobalSingletonUserInfo.sharedGlobalSingleton;
    
    NetworkUtility *network = [[NetworkUtility alloc] init];
    network.delegate = self;
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

    // app build版本
    NSString *app_build = [infoDictionary objectForKey:@"CFBundleVersion"];

    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          REQ_URL, @"url",
                          @"gps", @"ac",
                          @"update", @"op",
                          @"gps", @"report_type",
                          @"action", @"report_mode",
                          typeReport, @"report_act",
                          la, @"latitude",
                          lo, @"longitude",
                          @"4", @"appid",
                          app_build, @"code",
                          G_APP_VERSION, @"version",
                          nil];
    
    [network sendHttpReq:HttpReq_DataReportGPS andData:data];
    
    [self.locationManager stopUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error {
	
    if (error.code == kCLErrorDenied) {
        // 提示用户出错原因，可按住Option键点击 KCLErrorDenied的查看更多出错信息，可打印error.code值查找原因所在
    }
    // 获取gps失败
    NSLog(@"--------get location failed-------- %ld", (long)error.code);
}

#pragma mark -
#pragma mark http Req reciver Methods
- (void)reciveHttpData:(NSData*)data andType:(HttpReqType)type
{
    NSError *error;
    
    NSDictionary *resultJSON = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSString *result = [resultJSON objectForKey:@"result"];
    
    if(true == [result intValue])
    {
        // 上报成功
        NSLog(@"--------gps report success-------- %@", typeReport);
    }
    else
    {
        // 上报失败
        NSLog(@"--------gps report failed-------- %@", typeReport);
    }
}

-(void)reciveHttpDataError:(NSError*)err
{
}

@end
