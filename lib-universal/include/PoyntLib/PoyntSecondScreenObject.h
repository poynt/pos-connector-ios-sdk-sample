//
//  PoyntSecondScreenObject.h
//  PoyntLib
//
//  Created by Cheng Han Lee on 2/19/17.
//  Copyright © 2017 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"

@class  PoyntSecondScreenObject;

@interface PoyntSecondScreenObject : NSObject <PoyntSerializedObject>

@property(nonatomic) NSInteger totalAmount;
@property(nonatomic,copy)NSString  *currency;
@property(nonatomic,strong) NSArray *items; //PoyntOrderItemObject

@end
