//
//  PoyntOrderItemTax.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@interface PoyntOrderItemTax : NSObject <PoyntSerializedObject>
@property(nonatomic,copy) NSString *orderItemTaxId;
@property(nonatomic,copy) NSString *type;
@property(nonatomic) NSInteger amount;

-(id)initWithAmount:(NSInteger)amount type:(NSString*)type;

@end
