//
//  BaseNetManager.h
//  novel
//
//  Created by 黎铭轩 on 18/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseNetTool.h"
NS_ASSUME_NONNULL_BEGIN

@interface BaseNetManager : NSObject
+(NSURLSessionDataTask *)method:(HttpMethod)method urlString:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Error)failure;
+(NSURLSessionDataTask *)method:(HttpMethod)method urlString:(NSString *)urlString params:(NSDictionary *)params cache:(BOOL)cache success:(Success)success failure:(Error)failure;
+(NSURLSessionDataTask *)method:(HttpMethod)method serializer:(HttpSerializer)serializer urlString:(NSString *)urlString params:(nonnull NSDictionary *)params timeOut:(NSTimeInterval)timeOut success:(Success)success failure:(Error)failure;
@end

NS_ASSUME_NONNULL_END
