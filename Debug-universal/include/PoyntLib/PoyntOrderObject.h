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

/**
 @header PoyntOrderObject
 @description Order objects are most commonly found attached to a PoyntPaymentObject. The order contains important information identifying itself in the system as well as items attached, discounts, and amounts
 **/
@interface PoyntOrderObject : NSObject <PoyntSerializedObject>

/**
 @brief merchant notes for human readablity
 @description the notes field can be used to document information that is not imperative, but useful to merchants
 **/
@property(nonatomic,copy) NSString *notes;
/**
 @brief merchant friendly number identifier
 @description Stores often use a human readable order number to hand out to customers. Such numbers could be passed here.
 **/
@property(nonatomic,copy) NSString *orderNumber;
/**
 @brief object store for tracking specifics about the amounts in payment
 @description This object stores and calculates the pertant data that comprises the total, discount and tax of the order
 **/
@property(nonatomic,strong) PoyntPaymentAmountObject *amounts;
/**
 @brief array of PoyntDiscountObjects
 @description The amounts object will use this collection in its calculations for describing totals associated to this order object
 **/
@property(nonatomic,strong) NSArray *discounts; //PoyntDiscountObject


@property(nonatomic,strong) NSArray *fees; //PoyntFeeObject


/**
 @brief array of PoyntOrderItemObject
 @description Orders contain at least one (or more) items. The amounts object will use this collection in its calculations for describing totals associated to this order object
 **/
@property(nonatomic,strong) NSArray *items; //PoyntOrderItemObject
/**
 @brief system identifier for this object
 @description The id of the order created. If provided in the request, it will be used as the order ID. If not provided, id will be generated internally.
 **/
@property(nonatomic,copy) NSString *orderId;

@end
