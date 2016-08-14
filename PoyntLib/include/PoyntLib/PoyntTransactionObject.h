//
//  PoyntTransactionObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoyntSerializedObject.h"

@interface PoyntTransactionObject : NSObject <PoyntSerializedObject>
@property(nonatomic,strong) NSString *poyntRequestId;
@property(nonatomic,strong) NSString *transactionId;
@property(nonatomic,strong) NSString *status;
@property(nonatomic,strong) NSString *action;
@property(nonatomic,strong) NSArray *amounts;
@property(nonatomic,strong) NSArray *fundingSource;
@property(nonatomic,strong) NSDictionary *context;
@property(nonatomic,strong) NSDictionary *references;


-(id)initWithDictionary:(NSDictionary *)data;
@end
