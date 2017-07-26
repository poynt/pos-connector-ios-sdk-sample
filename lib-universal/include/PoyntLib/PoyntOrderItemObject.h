//
//  PoyntOrderItemObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"

/*!
 @header PoyntOrderItemObject

 @description The order item object depicts each item in an order and the details attached to it.
 
 @note all numeric properties default to 0
*/



typedef enum {
    EACH,
    HOURS,
    DAYS,
    SECONDS,
    CRATE_OF_12,
    SIX_PACK,
    GALLON,
    LITRE,
    INCH,
    FOOT,
    MILLIMETER,
    CENTIMETER,
    METER,
    SQUARE_METER,
    CUBIC_METER,
    GRAM,
    KG,
    POUND,
    ANNUAL,
    DEGREE_CELCIUS,
    DEGREE_FARENHEIT
}UnitOfMeasure;


/**
 @header PoyntOrderItemObject
 @description order items are essential for the makeup of a PoyntPaymentObject. All order items declare their amount (in cents) and other details attached to accurately describe payments
 
 @code
 PoyntOrderItemObject *item  = [[PoyntOrderItemObject alloc] initWithSku:"unique.sku.name" unitPrice:200 quantity:2.1];
 @endcode
 */
@interface PoyntOrderItemObject : NSObject <PoyntSerializedObject>
/**
 @brief merchant notes for human readablity
 @description the notes field can be used to document information that is not imperative, but useful to merchants
 **/
@property(nonatomic,copy) NSString *clientNotes;
/**
 @brief array of PoyntDiscountObject objects
 @description items can have multiple discounts for various reasons. Store them here
 **/
@property(nonatomic,strong) NSArray *discounts;

@property(nonatomic,strong) NSArray *fees;

/**
 @brief human friendly name for this item.
 @description The name can be any string and does not need to be unique
 **/
@property(nonatomic,copy) NSString *name;
/**
 @brief Quantity purchased.
 @description  Note this could be in decimals, e.g. 2.3 Kgs.
 **/
@property(nonatomic) float quantity;
/**
 @brief sku
 @description Sku of the item. 
 **/
@property(nonatomic,copy) NSString *sku;
/**
 @brief Status of the item
 @description this is traditionaly set by the system and is likely 'ORDERED', 'FULFILLED', 'RETURNED'
 **/
@property(nonatomic,copy) NSString *status;
/**
 @brief Total tax amount applied on this group of items (not just 1 unit).
 @description If not specified, but the taxes array is present the server will automatically sum up the amounts in taxes array and populate this. If not specified and taxes array is empty, this will default to 0.
 **/
@property(nonatomic,readonly) NSInteger tax;
/**
 @brief array of PoyntOrderItemTax objects
 @description like discounts, various taxes may be applied to an item
 **/
@property(nonatomic,strong) NSArray *taxes;
/**
 @brief UnitOfMeasure
 @description Unit of measure for the quantity.
 **/
@property(nonatomic) UnitOfMeasure unitOfMeasure;
/**
 @brief price per item in cents
 **/
@property(nonatomic) NSInteger unitPrice;



@property(nonatomic) NSInteger discount;
@property(nonatomic) NSInteger fee;

/**
 @brief initialization that will set the sku , unitPrice and quantity
 **/
-(id)initWithSku:(NSString*)sku unitPrice:(NSInteger)unitPrice quantity:(float)quantity;

@end
