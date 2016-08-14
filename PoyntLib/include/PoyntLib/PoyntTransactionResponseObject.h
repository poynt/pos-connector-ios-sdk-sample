//
//  PoyntTransactionResponseObject.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/13/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class  PoyntTransactionObject;
@interface PoyntTransactionResponseObject : NSObject
@property(nonatomic,copy) NSString *status;
@property(nonatomic,strong) NSArray *transactions; //PoyntTransactionObject
@property (nonatomic,strong) NSDictionary *order;
@property (nonatomic,readonly) NSDictionary *rawJson;
-(id)initWithData:(NSData*)data;
@end
