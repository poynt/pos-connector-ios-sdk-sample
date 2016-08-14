//
//  PoyntTerminalDiscover.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>
@class PoyntTerminal;
typedef void(^OnTerminalsFound)(NSArray *terminal) ;
@interface PoyntTerminalDiscover : NSObject
@property(nonatomic,strong) NSNetServiceBrowser *serviceBrowser;
@property(nonatomic,strong) NSArray* netServices;
@property(nonatomic,strong) NSArray *terminals;
@property(nonatomic,copy) OnTerminalsFound onTerminalsFound;
@property (nonatomic) BOOL searching;

-(void)findTerminals:(OnTerminalsFound)complete;
@end
