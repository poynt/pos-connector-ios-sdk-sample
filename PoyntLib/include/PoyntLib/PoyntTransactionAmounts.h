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
@property(nonatomic,strong) NSString *currency;

-(id)initWithName:(NSInteger)orderAmount tipAmount:(NSInteger)tipAmount cashbackAmount:(NSInteger)cashbackAmount ;
-(void)calculate:(PoyntOrderObject*)order;
@end
