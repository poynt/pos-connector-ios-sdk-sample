//
//  PoyntTransactionResponseObject.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/13/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  PoyntTransactionObject;

/*!
 @header PoyntTransactionResponseObject
 @brief A PoyntTransactionResponseObject is the response from a succesful terminal request. It is not a guarantee that the intended request has the results desired (see `responseError`) and can be further understood by its properties
 */
@interface PoyntTransactionResponseObject : NSObject

/**
 @brief this field will only be populated if there was an error in the request. Most commonly, the error will be descriptive of the problem.
 */
@property(nonatomic,readonly) NSError *responseError;
/**
 @parameter if successful, will be a value of "COMPLETED" or "SUCCESS"
 */
@property(nonatomic,copy) NSString *status;

/**
 @parameter a collection of PoyntTransactionObject objects attached to this transaction request.
 */
@property(nonatomic,strong) NSArray *transactions; //PoyntTransactionObject
/**
 @parameter if successful, will be a value of "COMPLETED" or "SUCCESS"
 */
@property(nonatomic,copy) NSString *poyntTransactionId;
/**
 @parameter dictionary representation of PoyntOrderObject
 @note This is an optional field an often not dependable (ie: not populated)
 */
@property (nonatomic,strong) NSDictionary *order;

/**
 @parameter all PoyntTransactionResponseObject will contain their `rawJson` which can often be useful for attaching more dynamic key/value representations of the response. It is not uncommon for objects to differ in property count or general inheritance
 */
@property (nonatomic,readonly) NSDictionary *rawJson;


/**
 This initialization is generally reserved for the SDK , however remains exposed in the event a developer needs to create their own response object

 @param data formatted from a PoyntServices response
 @return a valid PoyntTransactionResponseObject
 */
-(id)initWithData:(NSData*)data;
@end
