//
//  NetDataEngine.h
//  FoodFamily
//
//  Created by qianfeng on 15/12/21.
//  Copyright © 2015年 杜卫国. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef void(^SuccessBlockType) (id responsData);
typedef void(^FaileBlockType) (NSError *error);
@interface NetDataEngine : NSObject
@property (nonatomic) NSString *url;
+ (instancetype)sharedInstance;
- (void)requestFirstPageDataWithPage:(NSInteger)page withSuccess:(SuccessBlockType)successBlock withFaileBlock:(FaileBlockType)faileBlock;
- (void)requestThirdPageDataWithPage:(NSInteger)page withSuccess:(SuccessBlockType)successBlock withFaileBlock:(FaileBlockType)faileBlock;

@end
