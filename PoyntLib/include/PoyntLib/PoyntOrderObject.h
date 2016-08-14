//
//  PoyntOrderObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@class PoyntPaymentAmountObject;
@interface PoyntOrderObject : NSObject <PoyntSerializedObject>
@property(nonatomic,copy) NSString *notes;
@property(nonatomic,copy) NSString *orderNumber;
@property(nonatomic,strong) PoyntPaymentAmountObject *amounts;
@property(nonatomic,strong) NSArray *discounts; //PoyntDiscountObject
@property(nonatomic,strong) NSArray *items; //PoyntOrderItemObject
@property(nonatomic,copy) NSString *orderId;

@end
