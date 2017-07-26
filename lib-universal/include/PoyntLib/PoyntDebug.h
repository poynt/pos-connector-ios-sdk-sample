//
//  PoyntDebug.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/13/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @header PoyntDebug
 @description PoyntLib logs most requests , responses and errors. Use this class to see what your missing
 **/
@interface PoyntDebug : NSObject
/**
 @brief singleton property
 **/
+ (PoyntDebug*)sharedDebugger;
/**
 @brief set to true to see the magic, set to false to make your console look blank
 **/
@property(nonatomic) BOOL verbose;

/**
 @brief the log: method allows devlopers to take advantage of conditional verbose logging, sending your own message

 **/
+(void) log:(NSString*)message;

@end
