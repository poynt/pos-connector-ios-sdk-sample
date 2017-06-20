//
//  PoyntSerializedObject.h
//  sdk_example_swift
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//
#import <Foundation/Foundation.h>

/**
 @header PoyntSerializedObject
 @description all objects that are sent to the Poynt terminal subscribe to this protocol to verify proper json creation
 **/
@protocol PoyntSerializedObject <NSObject>
-(NSDictionary*)dictionaryObject;
@end