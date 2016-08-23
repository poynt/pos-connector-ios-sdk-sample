//
//  PoyntPaymentObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@class PoyntOrderObject;
@class PoyntPaymentAmountObject;
@interface PoyntPaymentObject : NSObject <PoyntSerializedObject>
@property(nonatomic)NSInteger amount;
@property(nonatomic,strong) PoyntPaymentAmountObject *amounts;
@property(nonatomic)NSInteger cashback;
@property(nonatomic)BOOL cashOnly;
@property(nonatomic,copy)NSString  *currency;
@property(nonatomic)BOOL debit;
@property(nonatomic)BOOL disableCash;
@property(nonatomic)BOOL disableDebitCards;
@property(nonatomic)BOOL disableTip;
@property(nonatomic)BOOL multiTender;
@property(nonatomic)BOOL nonReferencedCredit;
@property(nonatomic,strong) PoyntOrderObject *order;
@property(nonatomic,copy)NSString  *orderId;
@property(nonatomic,copy)NSString  *referenceId;
@property(nonatomic,copy)NSString  *transactionId;
@property(nonatomic)BOOL skipReceiptScreen;
@property(nonatomic)NSInteger tipAmount;
@property(nonatomic,strong) NSArray *transactions; //PoyntTransactionObject

@property(nonatomic,readonly) NSInteger absoluteDiscountTotal;
@property(nonatomic,readonly) NSInteger absoulteTaxTotal;
@property(nonatomic,readonly) NSInteger absoluteTotal;


-(void)update;
@end
