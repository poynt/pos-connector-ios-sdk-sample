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
/**
 @header PoyntTransactionAmounts
 @brief the transaction amounts in a PoyntTransactionObject amounts collection

 **/
@interface PoyntTransactionAmounts : NSObject <PoyntSerializedObject>
/**
 @brief required field representing amount
 @description  The portion of transactionAmount that went towards the item/service being purchased.
 **/
@property(nonatomic) NSInteger orderAmount;
/**
 @description The portion of transactionAmount that went towards tip. Defaults to 0 if not provided.
 **/
@property(nonatomic) NSInteger tipAmount;
/**
 @description The portion of transactionAmount that will be returned as cashback (mainly applicable for cash or debit-card tenders). Defaults to 0 if not provided.
 **/
@property(nonatomic) NSInteger cashbackAmount;
/**
 @brief required amount field
 @description The total amount to be charged on the tender. This equals orderAmount + tipAmount + cashbackAmount.
 **/
@property(nonatomic) NSInteger transactionAmount;
/**
 @description  Currency following the ISO-4217 format (http://en.wikipedia.org/wiki/ISO_4217).
 **/
@property(nonatomic,strong) NSString *currency;

/**
 @brief sets the order amount, tip amount, and cashback amount at initialization
 **/
-(id)initWithAmount:(NSInteger)orderAmount tipAmount:(NSInteger)tipAmount cashbackAmount:(NSInteger)cashbackAmount;
/**
 @brief creates a transaction amount with an appropriate dictionary representation
 **/
-(id)initWithData:(NSDictionary *)data ;
/**
 @brief called on an order object to update the properties attached to this object
 **/
-(void)calculate:(PoyntOrderObject*)order;
@end
