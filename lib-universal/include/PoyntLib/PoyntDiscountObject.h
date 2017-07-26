//
//  PoyntDiscountObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
/**
 @header PoyntDiscountObject
 @description discounts are encapsulated in an object to more easily identify their meaning.
 
 @code
 PoyntDiscountObject *discount  = [[PoyntDiscountObject alloc] initWithAmount:200 customName:@"Customer Loyalty"];
 @endcode
 **/
@interface PoyntDiscountObject : NSObject <PoyntSerializedObject>
/**
 @brief the amount in cents describing this discount
 **/
@property(nonatomic)NSInteger amount;
/**
 @brief a human readable name for identifiying the meaning of this discount
 **/
@property(nonatomic,copy) NSString *customName;
/**
 @brief initialize discount objects using the initWithAmount or init.
 @note Iniitializing with init will default amount to 0 and customName to an empty string
 **/
-(id)initWithAmount:(NSInteger)amount customName:(NSString*)customName;
@end
