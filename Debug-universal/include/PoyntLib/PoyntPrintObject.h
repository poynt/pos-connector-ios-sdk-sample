//
//  PoyntPrintObject.h
//  PoyntLib
//
//  Created by Cheng Han Lee on 2/17/17.
//  Copyright © 2017 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"

@class  PoyntPrintObject;

@interface PoyntPrintObject : NSObject <PoyntSerializedObject>

@property(nonatomic,copy)NSString  *content;
@end
