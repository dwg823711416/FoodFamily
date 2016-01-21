//
//  NetDataEngine.m
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import "NetDataEngine.h"
@interface NetDataEngine ()
@property (nonatomic)AFHTTPRequestOperationManager *httpManager;

@end
@implementation NetDataEngine
//+(instancetype)allocWithZone:(struct _NSZone *)zone{
//    
//    static NetDataEngine *s_instance = nil;
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        s_instance = [super allocWithZone:zone];
//    });
//    return s_instance;
//}
//
//+ (instancetype)sharedInstance{
//    
//    return [[self alloc]init];
//}
- (instancetype)init
{
    self = [super init];
    if (self) {
        _httpManager = [[AFHTTPRequestOperationManager alloc]init];
    }
    return self;
}

+ (instancetype)sharedInstance{
    static NetDataEngine * s_dataEngine = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        s_dataEngine = [[NetDataEngine alloc]init];
    });
  return s_dataEngine;
}

- (void)requestFirstPageDataWithPage:(NSInteger)page withSuccess:(SuccessBlockType)successBlock withFaileBlock:(FaileBlockType)faileBlock{
    NSString *url = [NSString stringWithFormat:URL_Food_First,page];
    [self get:url parameters:nil success:successBlock failed:faileBlock];
    }
- (void)requestThirdPageDataWithPage:(NSInteger)page withSuccess:(SuccessBlockType)successBlock withFaileBlock:(FaileBlockType)faileBlock{
    NSString *url = [NSString stringWithFormat:_url,page];
    [self get:url parameters:nil success:successBlock failed:faileBlock];

}

- (void) get:(NSString *)url parameters:(NSDictionary *)dic success:(SuccessBlockType)successBlock failed:(FaileBlockType)failedBlock{

    [_httpManager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (successBlock) {
            successBlock(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@",error);
    }];


}


@end
