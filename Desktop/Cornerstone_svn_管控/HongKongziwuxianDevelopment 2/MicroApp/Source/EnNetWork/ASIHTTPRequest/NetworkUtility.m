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
    if(HttpReq_Get == type) {
        NSURL *url = [NSURL URLWithString:[data objectForKey:@"url"]];
        ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:url];
        
        //获取Documents文件夹目录
        NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [path objectAtIndex:0];
        //指定新建文件夹路径
        NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoFile"];
        //创建ImageFile文件夹
        [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
        
        NSString *imagePath = [imageDocPath stringByAppendingPathComponent:@"xxxx"];
        
        [request setDownloadDestinationPath :imagePath];
        
        [request setCompletionBlock :^{
            // 请求成功
            [self httpRequestDidSuccess:request];
        }];
        [request setFailedBlock :^{
            // 请求失败，返回错误信息
            [self httpRequestDidFailed:request];
        }];
        
        // 开始异步请求
        [request startAsynchronous];
        
    } else {
        
        
        // 手机系统版本 eg:8.0.2
        NSString *os_version = [[UIDevice currentDevice] systemVersion];
        
        NSString *newUrl = nil;
        
        if ([[data objectForKey:@"url"]isEqualToString: REQ_URL]) {
            newUrl = REQ_URL;
        }
        
        NSURL *url = [NSURL URLWithString:newUrl];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
        request1 = request;
        request.timeOutSeconds = 150;//update by kate 原来值是10秒，发送9张图片超时
        [request addRequestHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
        [request setRequestMethod:@"POST"];
        
        [request setCompletionBlock :^{
            // 请求成功
            [self requestDidSuccess:request httpReqType:type];
        }];
        [request setFailedBlock :^{
            // 请求失败，返回错误信息
            [self requestDidFailed:request];
        }];
        
        if (Http_Video == type){
            
            [request addRequestHeader:@"enctype" value:@"multipart/form-data;"];
            // 是否有语音
            if ([data objectForKey:@"amr0"]) {
                if ((![@""  isEqualToString: [data objectForKey:@"amr0"]])) {
                    [request setFile:[data objectForKey:@"amr0"] forKey:@"amr0"];
                }
            }
            // 是否有小视频
            if ([data objectForKey:@"mp0"]) {
                if ((![@""  isEqualToString: [data objectForKey:@"mp0"]])) {
                    [request setFile:[data objectForKey:@"mp0"] forKey:@"mp0"];
                }
            }
            
            // 是否有图片
            NSMutableDictionary *imageArrayDic = [data objectForKey:@"imageArrayDic"];
            
            if (0 != [imageArrayDic count]) {
                for (int i=0; i<[imageArrayDic count]; i++) {
                    NSString *image = [NSString stringWithFormat:@"png%d",i];
                    [request setFile:[imageArrayDic objectForKey:image] forKey:image];
                }
            }
            
            //   单张图片
            if (nil != [data objectForKey:@"png0"]) {
                [request setFile:[data objectForKey:@"png0"] forKey:@"png0"];
            }
            
        }
        
        
        NSEnumerator * enumerator = [data keyEnumerator];
        
        NSString *object;
        while(object = [enumerator nextObject])
        {
            id objectValue = [data objectForKey:object];
            if(objectValue != nil)
            {
                NSLog(@"键值为：%@, 值为：%@",object, objectValue);
                [request setPostValue:objectValue forKey:object];
            }
        }
        
        
        
        
        // 开始异步请求
        [request startAsynchronous];
        
        
        
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

#pragma mark - get
- (void)httpRequestDidSuccess:(ASIHTTPRequest *)request
{
    
}

- (void)httpRequestDidFailed:(ASIHTTPRequest *)request
{
    //获取错误数据
    NSError *error = [request error];
    
    [delegate reciveHttpDataError:error];
}

#pragma mark - post
// 异步执行成功  2017.11.06 添加 httpReqType
- (void)requestDidSuccess:(ASIFormDataRequest *)request httpReqType:(HttpReqType)httpReqType
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
    NSLog(@"resultJSON:%@",resultJSON);
    
    
    if (self.delegate && [delegate respondsToSelector:@selector(reciveHttpData:andType:)]) {  // 2017.08.21  ky
        [delegate reciveHttpData:[request responseData] andType:httpReqType];
    }
    
}

//执行失败
- (void)requestDidFailed:(ASIFormDataRequest *)request
{
    //获取错误数据
    NSError *error = [request error];
    
    if (self.delegate && [delegate respondsToSelector:@selector(reciveHttpDataError:)]) {  // 2017.08.21  ky
        [delegate reciveHttpDataError:error];
    }
}






/////////////////////////     保存图片    数组 UIimage 数组
-(void)setImgArr:(NSMutableArray *)arr
{
    [self saveButtonImageToFileWithArr:arr];
}

-(NSMutableDictionary *)saveButtonImageToFileWithArr:(NSMutableArray *)arr{
    NSMutableDictionary *imageArrayDic = [NSMutableDictionary dictionary];
    
    //获取Documents文件夹目录
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [path objectAtIndex:0];
    //指定新建文件夹路径
    NSString *imageDocPath = [documentPath stringByAppendingPathComponent:@"WeixiaoHomeworkOfTheTeacherJudgmentFile"];//@"WeixiaoRepairImageFile"
    //创建ImageFile文件夹
    [[NSFileManager defaultManager] createDirectoryAtPath:imageDocPath withIntermediateDirectories:YES attributes:nil error:nil];
    
    if([arr count] > 0)
    {
        for (int i = 0; i<[arr count]; i++)
        {
            
            UIImage *image = arr[i];
            
            NSString *imgPath = [imageDocPath stringByAppendingPathComponent:[NSString stringWithFormat:@"image%d.png",(i)]];
            
            UIImage *tempImage = [UIImage imageWithCGImage:image.CGImage scale:image.scale orientation:image.imageOrientation];
            image = [self fixOrientation:tempImage];  //  封装
            
            UIImage *scaledImage = nil;
            UIImage *updateImage = nil;
            
            // 如果宽度超过480，则按照比例进行缩放，把宽度固定在480
            if (image.size.width >= 480) {
                float scaleRate = 480/image.size.width;
                
                float w = 480;
                float h = image.size.height * scaleRate;
                
                scaledImage = [self imageWithImageSimple:image scaledToSize:CGSizeMake(w, h)];  //  封装
            }
            
            if (scaledImage != Nil) {
                updateImage = scaledImage;
            } else {
                updateImage = image;
            }
            
            NSData *data;
            data = UIImageJPEGRepresentation(image, 0.3);
            
            UIImage *img = [UIImage imageWithData:data];
            
            [[NSFileManager defaultManager] createFileAtPath:imgPath contents:[self imageToNsdata:img] attributes:nil];
            
            [imageArrayDic setValue:imgPath forKey:[@"png" stringByAppendingString:[NSString stringWithFormat:@"%d",i]]];
        }
    }
    return imageArrayDic;  //  输出图片地址
}

-(NSData *)imageToNsdata:(UIImage*)img
{
    //以下是保存文件到沙盒路径下
    //把图片转成NSData类型的数据来保存文件
    NSData *data;
    
    return data = UIImageJPEGRepresentation(img, 0.3);
    
}


- (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}


@end
