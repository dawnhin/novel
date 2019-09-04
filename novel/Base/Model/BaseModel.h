//
//  BaseModel.h
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface BaseModel : NSObject
+(NSData *)archivedDataForData:(id)data;
+(id)unarchiveForData:(NSData *)data;
@end

NS_ASSUME_NONNULL_END
