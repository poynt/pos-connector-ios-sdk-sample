//
//  PoyntOrderItemTax.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
/**
 @header PoyntOrderItemTax
 @description tax object associated to an item
 **/
@interface PoyntOrderItemTax : NSObject <PoyntSerializedObject>
/**
 @brief string representing this id
 **/
@property(nonatomic,copy) NSString *orderItemTaxId;
/**
 @brief string value representing the type of tax
 **/
@property(nonatomic,copy) NSString *type;
/**
 @brief the amount of tax in cents
 **/
@property(nonatomic) NSInteger amount;
/**
 @brief only use initWithAmount:type to create these objects to ensure the obligatory fields are populated
 **/
-(id)initWithAmount:(NSInteger)amount type:(NSString*)type;

@end
