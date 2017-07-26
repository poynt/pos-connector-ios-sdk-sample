//
//  PoyntPaymentObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
#import "PoyntTransaction.h"
@class PoyntOrderObject;
@class PoyntPaymentAmountObject;

/*!
 @header PoyntPaymentObject

 @brief The PoyntPaymentObject is the required parameter for many sale and presales requests. The object can be built before making requests to the terminal.
 @note While the transactionId is a required field, the PoyntPaymentObject will autocreate a unique uuid on init. This can be overwritten if a known transactionId is desired
 @code
 NSString *orderId = [[NSUUID UUID] UUIDString];
 self.paymentObject = [[PoyntPaymentObject alloc] init];
 self.paymentObject.transactionId = orderId; //optional
 self.paymentObject.referenceId = orderId;
 self.paymentObject.currency = @"USD";
 self.paymentObject.tipAmount = 0;
 self.paymentObject.disableTip = YES;
 self.paymentObject.multiTender = NO;

 PoyntOrderObject* poyntOrder = [[PoyntOrderObject alloc] init];
 poyntOrder.notes = @"i am a note";
 self.paymentObject.order = poyntOrder;

 PoyntOrderItemObject* orderItem = [[PoyntOrderItemObject alloc] init];
 orderItem.sku = @"ASKU";
 orderItem.unitPrice = 100;
 orderItem.quantity = 1;
 orderItem.name = @"ANAME";
 orderItem.unitOfMeasure = EACH;
 orderItem.status = @"ORDERED";

 PoyntDiscountObject* discounts = [[PoyntDiscountObject alloc] initWithAmount:0 customName:@"discounts"];
 orderItem.discounts = @[discounts];

 PoyntOrderItemTax* taxes = [[PoyntOrderItemTax alloc] initWithAmount:0 type:@"taxes"];
 orderItem.taxes = @[taxes];

 poyntOrder.items = @[orderItem];
 poyntOrder.orderId = orderId;

 if(poyntOrder.amounts)
 {
  poyntOrder.amounts.currency = @"USD";
 }

 [self.paymentObject update];

 [self.paymentManager authorizeSales:self.paymentObject];
 @endcode


 */

@interface PoyntPaymentObject : NSObject <PoyntSerializedObject,PoyntTransaction>

/**
 @brief if isDumb, wont perform any amount calculations and everything will be taken as passed in
 @returns boolean
 **/
@property(nonatomic)BOOL isDumb;
/**
 @brief readonly property of calculated discount totals.
 
 Use update to refresh this field
 
 **/
@property(nonatomic,readonly) NSInteger absoluteDiscountTotal;
/**
 @brief readonly property of calculated tax totals.
 
 Use update to refresh this field
 
 **/
@property(nonatomic,readonly) NSInteger absoulteTaxTotal;

/**
 @brief readonly property of the calculated total.
 
 Use update to refresh this field
 
 **/
@property(nonatomic,readonly) NSInteger absoluteTotal;

/**
 @brief action label human readable string
 
 **/
@property(nonatomic,copy)NSString *actionLabel;
/**
 @brief if the payment was cash only
 @returns boolean
 **/
@property(nonatomic)BOOL adjustToAddCharges;
/** 
 @brief the total amount of this object
 @description The amount field should only be explicitly set when requesting a partial refund or partial completion. Otherwise this field is calculated from an attached PoyntOrderObject
**/
@property(nonatomic)NSInteger amount;
/**
 @brief a summary object for understanding details of an amount
 @description The object is most closely related to orders, but can also be found in the PoyntPaymentObject
 **/
@property(nonatomic,strong) PoyntPaymentAmountObject *amounts;
/**
 @brief  representation for the card session id 
 **/
@property(nonatomic,copy)NSString  *cardSessionId;
/**
 @brief representation of amount cashback in payment
 @description The value that is returned (in cents) for a payment transaction.
 **/
@property(nonatomic)NSInteger cashback;
/**
 @brief if the payment was cash only
 @returns boolean
 **/
@property(nonatomic)BOOL cashOnly;
/**
 @brief if the payment uses only credit
 @returns boolean
 **/
@property(nonatomic)BOOL creditOnly;
/**
 @brief  representation for the currency of this payment
 @return string - ISO specific currency code
 **/
@property(nonatomic,copy)NSString  *currency;
/**
 @brief if the payment uses debit
 @returns boolean
 **/
@property(nonatomic)BOOL debit;
/**
 @brief if the payment uses only debit
 @returns boolean
 **/
@property(nonatomic)BOOL debitOnly;

/**
 @brief if the payment will allow cash

 Default is false

 @returns boolean
 **/
@property(nonatomic)BOOL disableCash;
/**
 @brief if the payment will disable ability to change amount
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableChangeAmount;
/**
 @brief if the payment will disable checks
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableCheck;
/**
 @brief if the payment will disable debit cards

 Default is false

 @returns boolean
 **/
@property(nonatomic)BOOL disableDebitCards;
/**
 @brief if the payment will disable EBT cash benefits
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableEbtCashBenefits;
/**
 @brief if the payment will disable EBT voucher
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableEbtVoucher;
/**
 @brief if the payment will disable EBT food stamps
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableEbtFoodStamps;
/**
 @brief if the payment will disable EMVCT
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableEMVCT;
/**
 @brief if the payment will disable EMVCL
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableEMVCL;
/**
 @brief if the payment will disable DCC
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableDCC;
/**
 @brief if the payment will disable MSR
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableMSR;

/**
 @brief if the payment will disable manual
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableManual;
/**
 @brief if the payment will disable other
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableOther;
/**
 @brief if the payment should disable payment options
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disablePaymentOptions;
/**
 @brief if the payment will allow a tip
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL disableTip;

/**
 @brief if the payment is an inquiry to the balance
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL isBalanceInquiry;

/**
 @brief if the payment uses multiple tenders to complete the transaction

 Default is false

 @description in some cases a payment can be fulfilled using multiple methods of payment. IE a user may pay 1/2 with a credit card and the other half with cash
 @returns boolean
 **/
@property(nonatomic)BOOL multiTender;

/**
 @brief if the payment is from manual entry
 
 @returns boolean
 **/
@property(nonatomic)BOOL manualEntry;
/**
 @brief if the payment of no referenced credit

 Default is false

 @returns boolean
 **/
@property(nonatomic)BOOL nonReferencedCredit;

/**
 @brief attach a human readable note to the payment
 
 **/
@property(nonatomic,copy)NSString *notes;
/**
 @brief to invoke offline authorized transaction set offlineAuth=true and offlineApprovalCode set.
 @returns boolean
 **/
@property(nonatomic)BOOL offlineAuth;
@property(nonatomic,copy)NSString  *offlineApprovalCode;
/**
 @brief the attached order object
 @description The PoyntOrderObject is an essential piece of a payment object as it contains the items and calculation components for understanding a payments values
 @see PoyntOrderObject for more details
 **/
@property(nonatomic,strong) PoyntOrderObject *order;
/**
 @brief the order id
 @description The payment object will auto generate an order id at init. The value of this can be kept of explicitly declared
 **/
@property(nonatomic,copy)NSString  *orderId;
/**
 @brief the reference id
 @description The payment object will auto generate a reference id at init. The value of this can be kept of explicitly declared
 **/
@property(nonatomic,copy)NSString  *referenceId;
/**
 @brief the transaction id
 @description The payment object will auto generate a transaction id at init. The value of this can be kept of explicitly declared. It is most common to explictly set this for partial actions (ie: AuthorizePartialRefund or AuthorizePartialCapture)
 **/
@property(nonatomic,copy)NSString  *transactionId;
/**
 @brief should the payment read only the card data
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL readCardDataOnly;
/**
 @brief should the payment skip the signature screen on the terminal after processing.
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL skipPaymentConfirmationScreen;
/**
 @brief should the payment skip the receipt screen on the terminal after processing.
 
 Default is false

 @returns boolean
 **/
@property(nonatomic)BOOL skipReceiptScreen;
/**
 @brief should the payment skip the signature screen on the terminal after processing.
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL skipSignatureScreen;
/**
 @brief the amount being tipped (if any)
 @description If there is a tip, it should be set here (in cents)
 
 @code
 paymentObject.tip = 100; // == $1.00
 @endcode
 
 Default is 0
 

 **/
@property(nonatomic)NSInteger tipAmount;

/**
 @brief collection of PoyntTransactionObject
 @description A payment can consist of many transactions.
 **/
@property(nonatomic,strong) NSArray *transactions; //PoyntTransactionObject


/**
 @brief if the payment should verify only
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL verifyOnly;

/**
 @brief if the payment has a voucher
 
 Default is false
 
 @returns boolean
 **/
@property(nonatomic)BOOL voucher;

/**
 @brief a method used to refresh the payment object
 @description This method is most commonly run when the objec it about to send to terminal. It can be manually updated at anytime to refresh the absolute calculations
 **/
-(void)update;
@end
