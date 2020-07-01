//
//  TSBaseModel.m
//  MicroSchool
//
//  Created by CheungStephen on 7/22/16.
//  Copyright © 2016 jiaminnet. All rights reserved.
//

#import "TSBaseModel.h"

// runtime
#import <objc/runtime.h>

@implementation TSBaseModel

- (id)initWithCoder:(NSCoder *)coder {
//    NSLog(@"%s",__func__);
    Class cls = [self class];
    while (cls != [NSObject class]) {
        // 判断是自身类还是父类
        BOOL bIsSelfClass = (cls == [self class]);
        unsigned int iVarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int sharedVarCount = 0;
        // 变量列表，含属性以及私有变量
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;
        
        // 属性列表
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
        
        for (int i = 0; i < sharedVarCount; i++) {
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            id varValue = [coder decodeObjectForKey:key];
            if (varValue) {
                [self setValue:varValue forKey:key];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    Class cls = [self class];
    while (cls != [NSObject class]) {
        // 判断是自身类还是父类
        BOOL bIsSelfClass = (cls == [self class]);
        unsigned int iVarCount = 0;
        unsigned int propVarCount = 0;
        unsigned int sharedVarCount = 0;
        // 变量列表，含属性以及私有变量
        Ivar *ivarList = bIsSelfClass ? class_copyIvarList([cls class], &iVarCount) : NULL;
        
        // 属性列表
        objc_property_t *propList = bIsSelfClass ? NULL : class_copyPropertyList(cls, &propVarCount);
        sharedVarCount = bIsSelfClass ? iVarCount : propVarCount;
        
        for (int i = 0; i < sharedVarCount; i++) {
            const char *varName = bIsSelfClass ? ivar_getName(*(ivarList + i)) : property_getName(*(propList + i));
            NSString *key = [NSString stringWithUTF8String:varName];
            // valueForKey只能获取本类所有变量以及所有层级父类的属性，不包含任何父类的私有变量(会崩溃)
            id varValue = [self valueForKey:key];
            if (varValue) {
                [coder encodeObject:varValue forKey:key];
            }
        }
        free(ivarList);
        free(propList);
        cls = class_getSuperclass(cls);
    }
}

// 重写debugDescription, 而不是description
- (NSString *)debugDescription {
    // 声明一个字典
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    // 得到当前class的所有属性
    uint count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    // 循环并用KVC得到每个属性的值
    for (int i = 0; i<count; i++) {
        objc_property_t property = properties[i];
        NSString *name = @(property_getName(property));
        
        // 默认值为nil字符串
        id value = [self valueForKey:name]?:@"nil";
        // 装载到字典里
        [dictionary setObject:value forKey:name];
    }
    
    // 释放
    free(properties);
    
    return [NSString stringWithFormat:@"<%@: %p> -- %@",[self class],self,dictionary];
}

- (instancetype)initWithDic:(NSDictionary*)dic {
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    if (self = [super init]) {
        for (NSString *key in [dic allKeys]) {
            id value = dic[key];
            if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]) {
                // 处理对象类型和数组类型
                [self setValue:value forKeyPath:key];
            }
            else if ([value isKindOfClass:[NSNull class]]) {
                // 处理空类型:防止出现unRecognized selector exception
                [self setValue:@"" forKey:[NSString stringWithFormat:@"%@",key]];
            }
            else{
                // 处理其他类型：包括数字，字符串，布尔，全部使用NSString来处理
                [self setValue:[NSString stringWithFormat:@"%@",value] forKeyPath:[NSString stringWithFormat:@"%@",key]];
            }
        }
    }
    return self;
}

#pragma mark KVC 安全设置
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//    NSLog(@"%s",__func__);
}

- (void)setNilValueForKey:(NSString *)key {
//    NSLog(@"%s",__func__);
}

//+ (NSMutableDictionary *)AvatarDictionary {
//    NSMutableDictionary *userDic = [NSMutableDictionary dictionary];
//    unsigned int count = 0;
//    objc_property_t *properties = class_copyPropertyList([TSBaseModel class], &count);
//    for (int i = 0; i < count; i++) {
//        const char *name = property_getName(properties[i]);
//        
//        NSString *propertyName = [NSString stringWithUTF8String:name];
//        id propertyValue = [self valueForKey:propertyName];
//        if (propertyValue) {
//            [userDic setObject:propertyValue forKey:propertyName];
//        }
//        
//    }
//    free(properties);
//    
//    return userDic;
//}

@end
