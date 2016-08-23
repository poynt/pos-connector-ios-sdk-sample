//
//  PoyntDiscountObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@interface PoyntDiscountObject : NSObject <PoyntSerializedObject>
@property(nonatomic)NSInteger amount;
@property(nonatomic,copy) NSString *customName;

-(id)initWithAmount:(NSInteger)amount customName:(NSString*)customName;
@end
