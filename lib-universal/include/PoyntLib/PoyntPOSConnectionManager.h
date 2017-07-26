//
//  PoyntPOSConnectionManager.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/11/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntTransaction.h"
@class PoyntTransactionObject;
@class PoyntTransactionAmounts;
@class PoyntPaymentObject;
@class PoyntTransactionResponseObject;
@class PoyntPrintObject;
@class PoyntSecondScreenObject;

/*!
 @brief The available type of actions for the `PoyntPOSConnectionManager`
 @discussion after calling an action on connection manager, the `OnTransactionResponse` or `OnError` block will be calledback. These callbacks contain the action type enum to help identify which action is being returned values in the event multiple requests were made.
 */

typedef enum {
    Undefined,
    AuthorizeCapture,
    AuthorizeCompletion,
    AuthorizePair,
    AuthorizePairWithKey,
    AuthorizePreSales,
    AuthorizePartialCompletion,
    AuthorizePartialRefund,
    AuthorizeRefund,
    AuthorizeSales,
    AuthorizeSettlement,
    AuthorizeVoid,
    AuthorizeVoidPreSales,
    AuthorizeAdjustment,
    Print,
    ShowItems,
    Ping
} PoyntActionType;

/*!
 @brief The current pairing/connection status of a `PoyntPOSConnectionManager`  
 */
typedef enum{
    UnPaired,
    Pairing,
    Paired
} PoyntPOSPairingStatus;

typedef void(^OnTransactionResponse)(PoyntTransactionResponseObject *data, PoyntActionType type) ;
typedef void(^OnError)(NSError *error, PoyntActionType type) ;
/*!
 @header The connection manager is the gateway class to communicating with the Poynt terminal.
 @description This object handles all things from pairing to transaction / payment specific requests
*/

@interface PoyntPOSConnectionManager : NSObject
/*!
 @brief optional property for displaying/references a name for the device implementing the PoyntLib SDK

 @discussion When Poynt terminal pairs with an iOS client, it will display the name of the client and the pairingCode used to make the connection.

 @return string for a human readable client name on the Poynt terminal
 */
@property(nonatomic,strong) NSString *clientName;
/*!
 @brief required property for pairing an iOS client with the Poynt terminal

 @discussion Poynt terminal requires both a url and pairingCode to establish a connection for passing data.
 
 @note: This property is being deprecated. Setting the pairingCode should happen automatically, as of v.0.0.2- See `attemptPairing` method.

 @return string an alpha numeric code for pairing.
 */
#define DEPRECATED_ATTRIBUTE        __attribute__((deprecated))
@property(nonatomic,strong) NSString *pairingCode;

/*!
 @brief required property for pairing an iOS client with the Poynt terminal

 @discussion Poynt terminal requires both a url and pairingCode to establish a connection for passing data. The url can be discovered by using the PoyntTerminalDiscover object for discovery over WiFi

 @return string for an ip address, including port if necessary.
 
 @code 
    self.paymentManager.url = @"10.0.2.21:55555"
 @endcode
 
 @see PoyntTerminalDiscover.h
 */
@property(nonatomic,strong) NSString *url;

/*!
 @brief optional property for setting the timeout for PoyntPOSConnectionManager requests.

 @discussion Timout is understood in milliseconds by the Poynt terminal. The timeout can be set previous to making a request, depending on what suits best for the client application. Setting a new timeout value is persitant until reset to a new value. The default value is 60000 ( = one minute)

 @return NSInteger
 */
@property(nonatomic) NSInteger timeout;

/*!
 @brief readonly property for understanding the current pairing state of the PoyntPOSConnectionManager

 @return enum
 */
@property(nonatomic,readonly) PoyntPOSPairingStatus pairingStatus;

/*!
 @brief use the OnTransactionResponse block to capture the response from the Poynt terminal after a successful request completes

 @discussion the block will contain a PoyntTransactionResponseObject object and PoyntActionType enum to clarify from which method is being calledback
 
 @note While receiving this callback does mean that there were not errors in the request, it is not a guarantee that all results were as expected. It is important to verify results from the `PoyntTransactionResponseObject` that is returned in this callback.
 
 @code
 [paymentManager setOnTransactionResponse:^void(PoyntTransactionResponseObject *data,PoyntActionType actionType){
    if(actionType == AuthorizePair){
        // ... handle this case
    }else{
        NSLog(@"success for %@",data);
    }
 }];
 [paymentManager authorizeCapture:transactionObject]
 @endcode
 
 */
@property (readwrite,copy) OnTransactionResponse onTransactionResponse;
/*!
 @brief use the OnError block to capture the fail state response from the Poynt terminal in the event of an error

 @discussion the block will contain an NSError object and `PoyntActionType` enum
 
 @code
 [paymentManager setOnError:^void(NSError *error, PoyntActionType actionType){

 }];
 [paymentManager authorizeCapture:transactionObject]
 @endcode
 */
@property (readwrite,copy) OnError onError;


/*!
 @brief automatically pair the client application with the Poynt Termainal in a secure exchange.
 
 @discussion The SDK will automatically handle the secure exchange and pair the client and device if this call is successful. Upon success/fail the block will execute with the result of the exchange. If successful, future request signing can be handled by the SDK
 
 @param  block, executed on complete pairing or failed result. flag = boolean value of pairing status. If flag is true, error will be nil
 
 */
-(void)attemptPairing:(void(^)(BOOL flag,NSError *err))block;
/*!
 @brief sends an adjustment request to the Poynt terminal
 
 @discussion This expects a PoyntPaymentObject. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler. The payment object must have an amount associated, and optional tipAmount (if a tip is included)
 
 @param  PoyntPaymentObject
 */
-(void)authorizeAdjustment:(PoyntPaymentObject*)payment;


/*!
 @brief sends a captured sale request to the Poynt terminal

 @discussion This expects a valid PoyntTransactionObject. 
 Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  PoyntTransactionObject - transactionId is required

 */
-(void)authorizeCapture:(PoyntTransactionObject *)transaction;
    

/*!
 @brief sends raw json...better know what you're doing
 
 @discussion This expects a valid json object and an valid endpoint
 
 @param  NSString
 
 */
-(void)authorizeJson:(NSString *)json endPoint:(NSString*)endpoint;
-(void)authorizeJson:(NSString *)json endPoint:(NSString*)endpoint callback:(void(^)(id responseData, NSError *error ))callback;

/*!
 @brief attempts to pair the iOS client with the Poynt terminal
 
 @discussion An iOS client creates a pair after establishing a correct url and pairing code to make the request. The PoyntTerminalDiscover object can find terminals on the same network, revelaing their ip address, or you can manually address the ip if you already know it. The PoyntLib SDK will try to re-establish a connection with the last set credentials even after application termination. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler
 
 @code
 self.paymentManager.url = @"10.0.1.23:55555";
 self.paymentManager.clientName = @"Happy iPad";
 [self.paymentManager authorizePairing:self.textFieldCode.text];
 @endcode
 
 @param  string representing the pairing code
 
 */
#define DEPRECATED_ATTRIBUTE        __attribute__((deprecated))
-(void)authorizePairing:(NSString *)code;

/*!
 @brief sends a captured sale request to the Poynt terminal

 @discussion This expects a valid PoyntPaymentObject. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  PoyntPaymentObject (where transactionId is required)

 */
-(void)authorizePartialCompletion:(PoyntPaymentObject *)payment;
/*!
 @brief sends a partial refund request to the Poynt terminal

 @discussion This expects a valid PoyntPaymentObject. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  PoyntPaymentObject (where transactionId is required)

 */
-(void)authorizePartialRefund:(PoyntPaymentObject *)payment;

/*!
 @brief sends an authOnly sale request to the Poynt terminal

 @discussion This expects a PoyntPaymentObject. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  PoyntPaymentObject 

 */
-(void)authorizePreSales:(PoyntPaymentObject *)payment;
/*!
 @brief sends a refund request to the Poynt terminals

 @discussion This method expects a valid object subscribing to the PoyntTransaction protocol. The transactionId must be in reference of a valid transaction. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  an object that subscribes to the PoyntTransaction protocol  - transactionId is required
 */
-(void)authorizeRefund:(id <PoyntTransaction>)transaction ;
/*!
 @brief sends a sale request for capture to the Poynt terminal

 @discussion This expects a PoyntPaymentObject. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  PoyntPaymentObject

 */
-(void)authorizeSales:(PoyntPaymentObject *)payment ;

/*!
 @brief sends a settlement request  to the Poynt terminal
 
 @discussion TBD
 
 
 */
-(void)authorizeSettlement;

/*!
 @brief sends a void request to the Poynt terminals

 @discussion This method expects a valid object subscribing to the PoyntTransaction protocol. The transactionId must be in reference of a transaction. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  an object that subscribes to the PoyntTransaction protocol  - transactionId is required
 */
-(void)authorizeVoid:(id <PoyntTransaction>)transaction;

/*!
 @brief sends a void request to the Poynt terminals

 @discussion This method expects a valid object subscribing to the PoyntTransaction protocol. The transactionId must be in reference of an @cAUTHORIZED transaction. Upon terminal response the paymentManager will receive either the onTransactionResponse or onError handler

 @param  an object that subscribes to the PoyntTransaction protocol  - transactionId is required
 */
-(void)authorizeVoidPreSales:(id <PoyntTransaction>)transaction ;
/*!
 @brief this method is idealy used to check the client - terminal pairing status
 
 @discussion After an initial pairing, the client and terminal can remian paired and renew session. (aka, you can power off, etc). While there is a `pairedStatus` property, ping allows for a more real time check of the current status.
 
 @param  block, executed on complete pairing or failed result. flag = boolean value of pairing status. If flag is true, error will be nil
 
 */
-(void)ping:(void(^)(BOOL isPaired,NSError *err))block;

-(void)printNormal:(PoyntPrintObject*)data;

-(void)showItems:(PoyntSecondScreenObject*)data;

-(void)reset;

@end
