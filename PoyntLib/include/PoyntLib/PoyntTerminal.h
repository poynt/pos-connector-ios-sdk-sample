//
//  PoyntTerminal.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 @header PoyntTerminal
 @description PoyntTerminal objects are useful during ther terminal discovery phase when on the same WIFI network.
 **/
@interface PoyntTerminal : NSObject
/**
 @brief the name of the terminal
 **/
@property(nonatomic,strong) NSString *name;
/**
 @brief the ip of the terminal
 @description In the event the terminal identifies an explicit port for pairing, it will be found here
 **/
@property(nonatomic,strong) NSString *ip;
/**
 @brief the url object for connecting with this terminal
 **/
@property(nonatomic,strong) NSURL *url;
/**
 @brief PoyntLib SDK utilized bonjour over WIFI to detect terminals. The service object is engaged when we reach for pairing the device to client
 @description Use PoyntTerminalDiscover to find the service
 **/
@property(nonatomic,strong)NSNetService *service;

/**
 @brief only use initWithService to create a PoyntTerminal object 
 **/
-(id)initWithService:(NSNetService*)service;
@end
