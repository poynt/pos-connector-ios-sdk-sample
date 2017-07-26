//
//  PoyntPaymentAmountObject.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/13/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@class  PoyntOrderObject;
/**
 @header PoyntPaymentAmountObject
 @description the payment amount storage object responsible for calculating totals , taxes and discounts for a PoyntOrderObject
 **/
@interface PoyntPaymentAmountObject : NSObject <PoyntSerializedObject>
/**
 @brief total sum of unitPrice * quantity for each item in and order
 **/
@property(nonatomic) NSInteger subTotal;
/**
 @brief total sum of discounts for each item in and order plus sum of discounts applied to the order itself
 **/
@property(nonatomic) NSInteger discountTotal;
/**
 @brief total sum of tax for each item in and order
 **/
@property(nonatomic) NSInteger taxTotal;
/**
 @brief currency of this payment amount
 @description this field defaults to USD. When attached to an order descended from a payment, it will inherit currency from the order's payment object
 **/
@property(nonatomic,strong) NSString *currency;
/**
 @brief call the calculate method to refresh the properites of this object. The SDK occasionly calls calculate on this object, and will always call for a fresh calculation immediately before sending a request to the terminal. 
 **/
-(void)calculate:(PoyntOrderObject*)order;
@end
