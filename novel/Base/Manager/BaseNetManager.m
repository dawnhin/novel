//
//  BaseNetManager.m
//  novel
//
//  Created by 黎铭轩 on 18/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseNetManager.h"
#import "BaseNetModel.h"
#import "BaseNetCache.h"
static BOOL AFRequest = YES;
@implementation BaseNetManager
+ (NSURLSessionDataTask *)method:(HttpMethod)method urlString:(NSString *)urlString params:(NSDictionary *)params success:(Success)success failure:(Error)failure{
    return [BaseNetManager method:method urlString:urlString params:params cache:NO success:success failure:failure];
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method urlString:(NSString *)urlString params:(NSDictionary *)params cache:(BOOL)cache success:(Success)success failure:(Error)failure{
    NSString *key=[NSString stringWithFormat: @"%@%@%@",urlString,params?@"?":@"",AFQueryStringFromParameters(params)];
    __block NSURLSessionDataTask *task;
    void(^NetManager)(void)=^{
        task=[self method:method serializer:HttpSerializeDefault urlString:urlString params:params success:^(id  _Nonnull object) {
            BaseNetModel *model=[BaseNetModel successModel:object urlString:urlString params:params headParams:nil];
            if ([model isDataSuccess]) {
                !success ?: success(model.resultset);
            }
            else{
                !failure ?: failure(model.msg);
            }
        } failure:^(NSString * _Nonnull error) {
            !failure ?: failure(error);
        }];
    };
    if (cache) {
        [BaseNetCache objectForKey:key completion:^(NSString * _Nonnull key, id<NSCoding>  _Nullable object) {
            if (object) {
                !success ?: success(object);
            }
            else{
                NetManager();
            }
        }];
    }
    else{
        NetManager();
    }
    return task;
}
+(NSURLSessionDataTask *)method:(HttpMethod)method serializer:(HttpSerializer)serializer urlString:(NSString *)urlString params:(nonnull NSDictionary *)params success:(Success)success failure:(Error)failure{
    return [BaseNetManager method:method serializer:serializer urlString:urlString params:params timeOut:10.0 success:success failure:failure];
}
+ (NSURLSessionDataTask *)method:(HttpMethod)method serializer:(HttpSerializer)serializer urlString:(NSString *)urlString params:(NSDictionary *)params timeOut:(NSTimeInterval)timeOut success:(Success)success failure:(Error)failure{
    if (AFRequest) {
        return [AFRequestTool method:method serializer:serializer urlString:urlString params:params timeOut:timeOut success:^(id  _Nonnull object) {
            NSDictionary *dictionary=[BaseNetModel analysisData:object];
            dispatch_async(dispatch_get_main_queue(), ^{
                !success ?: success(dictionary);
            });
        } failure:^(NSError * _Nonnull error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                !failure ?: failure([BaseNetModel analysisError:error]);
            });
        }];
    }
    return [SectionTool method:method serializer:serializer urlString:urlString params:params timeOut:timeOut success:^(id  _Nonnull object) {
        NSDictionary *dictionary=[BaseNetModel analysisData:object];
        dispatch_async(dispatch_get_main_queue(), ^{
            !success ?: success(dictionary);
        });
    } failure:^(NSError * _Nonnull error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            !failure ?: failure([BaseNetModel analysisError:error]);
        });
    }];
}
@end
