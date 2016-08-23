//
//  PoyntTransactionAmounts.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@class PoyntOrderObject;
@interface PoyntTransactionAmounts : NSObject <PoyntSerializedObject>
@property(nonatomic) NSInteger orderAmount;
@property(nonatomic) NSInteger tipAmount;
@property(nonatomic) NSInteger cashbackAmount;
@property(nonatomic) NSInteger transactionAmount;
@property(nonatomic,strong) NSString *currency;

-(id)initWithAmount:(NSInteger)orderAmount tipAmount:(NSInteger)tipAmount cashbackAmount:(NSInteger)cashbackAmount;
-(id)initWithData:(NSDictionary *)data ;
-(void)calculate:(PoyntOrderObject*)order;
@end
