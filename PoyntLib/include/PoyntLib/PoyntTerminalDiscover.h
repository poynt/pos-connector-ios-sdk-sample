//
//  PoyntTerminalDiscover.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PoyntTerminal;

/**
 @header PoyntTerminalDiscover
 @description Base class for finding terminals on the same WIFI network
 **/
typedef void(^OnTerminalsFound)(NSArray *terminal) ;

@interface PoyntTerminalDiscover : NSObject
/**
 @brief list of PoyntTerminal currently known on the network
 **/
@property(nonatomic,strong) NSArray *terminals;
/**
 @brief callback called upon finding the device(s) on the WIFI.
 @description This callback is called only one time. If you need to refresh the search, you must call findTerminals:complete again
 **/
@property(nonatomic,copy) OnTerminalsFound onTerminalsFound;
/**
 @brief Boolean value decalaring if the object is searching or is done searching
 **/
@property (nonatomic) BOOL searching;


/**
 @brief find terminals on the same WIFI network
 @description pass an OnTerminalsFound block to get a list of terminals currently known on the network.
 **/
-(void)findTerminals:(OnTerminalsFound)complete;
@end
