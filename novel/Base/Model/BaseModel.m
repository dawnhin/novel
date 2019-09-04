//
//  BaseModel.m
//  novel
//
//  Created by 黎铭轩 on 15/7/2019.
//  Copyright © 2019 黎铭轩. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel
+ (NSData *)archivedDataForData:(id)data{
    NSData *resData;
    @try {
        resData=[NSKeyedArchiver archivedDataWithRootObject:data];
    } @catch (NSException *exception) {
        NSLog(@"%s,%d,%@",__func__,__LINE__,exception.description);
        resData=nil;
    } @finally {
        
    }
    return resData;
}
+ (id)unarchiveForData:(NSData *)data{
    id resObject;
    @try {
        resObject=[NSKeyedUnarchiver unarchiveObjectWithData:data];
    } @catch (NSException *exception) {
        NSLog(@"%s,%d,%@",__func__,__LINE__,exception.description);
        resObject=nil;
    } @finally {
        
    }
    return resObject;
}
@end
