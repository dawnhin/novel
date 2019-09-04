//
//  NovelNetManager.h
//  novel
//
//  Created by 黎铭轩 on 18/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
typedef void(^Success)(id object);
typedef void(^Error)(NSString *error);
@interface NovelNetManager : NSObject
+(void)rankSuccess:(Success)success failure:(Error)failure;
+ (void)homeHot:(NSString *)rankId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;

+ (void)homeClass:(NSString *)group success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
+ (void)homeClssItem:(NSString *)key major:(NSString *)major page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//搜索
+ (void)homeSearch:(NSString *)hotWord page:(NSInteger)page success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//书籍详情
+ (void)bookDetail:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//推荐列表
+ (void)bookCommend:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//推荐书单
+ (void)bookListCommend:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//推荐书单详情
+ (void)bookListDetail:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//书源
+ (void)bookSummary:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//章节列表
+ (void)bookChapters:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//章节内容
+ (void)bookContent:(NSString *)linkUrl success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
//更新内容
+ (void)updateContent:(NSString *)bookId success:(void(^)(id object))success failure:(void(^)(NSString *error))failure;
@end

NS_ASSUME_NONNULL_END
