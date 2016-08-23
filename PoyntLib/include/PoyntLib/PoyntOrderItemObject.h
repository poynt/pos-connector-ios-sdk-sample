//
//  PoyntOrderItemObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
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


@interface PoyntOrderItemObject : NSObject <PoyntSerializedObject>
@property(nonatomic,copy) NSString *clientNotes;
@property(nonatomic,strong) NSArray *discounts;
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *sku;
@property(nonatomic,copy) NSString *status;
@property(nonatomic,strong) NSArray *taxes;
@property(nonatomic) UnitOfMeasure unitOfMeasure;
@property(nonatomic) NSInteger unitPrice;
@property(nonatomic) float quantity;
@property(nonatomic,readonly) NSInteger tax;
-(id)initWithSku:(NSString*)sku unitPrice:(NSInteger)unitPrice quantity:(float)quantity;

@end
