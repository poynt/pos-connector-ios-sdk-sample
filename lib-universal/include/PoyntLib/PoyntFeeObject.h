//
//  PoyntFeeObject.h
//  PoyntLib
//
//  Created by Cheng Han Lee on 2/20/17.
//  Copyright © 2017 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"

@interface PoyntFeeObject : NSObject <PoyntSerializedObject>
@property(nonatomic)NSInteger amount;
@property(nonatomic,copy) NSString *name;
-(id)initWithAmount:(NSInteger)amount name:(NSString*)name;
@end
