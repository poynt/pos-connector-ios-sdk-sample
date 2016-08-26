//
//  PoyntTransactionObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
#import "PoyntTransaction.h"
@interface PoyntTransactionObject : NSObject <PoyntSerializedObject, PoyntTransaction>
/**
 @brief UUIDString representing this object
 **/
@property(nonatomic,copy) NSString *poyntRequestId;
/**
 @brief UUIDString representing a Poynt transaction id
 **/
@property(nonatomic,copy) NSString *transactionId;
/**
 @brief current status of this object. Mostly commonly set server side: 'CREATED', 'SAVED', 'AUTHORIZED', 'PARTIALLY_CAPTURED', 'CAPTURED', 'DECLINED', 'PARTIALLY_CAPTURED_AND_PARTIALLY_REFUNDED', 'PARTIALLY_REFUNDED', 'REFUNDED', 'VOIDED'
 **/
@property(nonatomic,copy) NSString *status;
/**
 @brief action of this object
 @description 'AUTHORIZE', 'CAPTURE', 'OFFLINE_AUTHORIZE', 'REFUND', 'SALE', most commonly set by server
 **/
@property(nonatomic,copy) NSString *action;
/**
 @brief collection of PoyntTransactionAmounts objects
 **/
@property(nonatomic,strong) NSArray *amounts;
/**
 @description collection of funding source objects used for funding this transaction.
 @todo at current, we are not populating this field. Developers have access to the data in PoyntTransactionResponseObject.rawJson propety
 **/
@property(nonatomic,strong) NSArray *fundingSource;
/**
 @description Contains context about the transaction.
 **/
@property(nonatomic,strong) NSDictionary *context;
/**
 @brief References to orders/invoices that this transaction is for.
 **/
@property(nonatomic,strong) NSDictionary *references;

/**
 @description create a PoyntTransactionObject using an appropriate formated dictionary object
 **/
-(id)initWithDictionary:(NSDictionary *)data;
@end
