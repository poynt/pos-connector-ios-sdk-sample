//
//  PoyntPaymentAmountObject.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/13/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"
@class  PoyntOrderObject;
@interface PoyntPaymentAmountObject : NSObject <PoyntSerializedObject>
@property(nonatomic) NSInteger subTotal;
@property(nonatomic) NSInteger discountTotal;
@property(nonatomic) NSInteger taxTotal;
@property(nonatomic,strong) NSString *currency;
-(void)calculate:(PoyntOrderObject*)order;
@end
