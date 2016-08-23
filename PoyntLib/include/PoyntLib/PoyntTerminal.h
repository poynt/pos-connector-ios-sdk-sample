//
//  PoyntTerminal.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/12/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PoyntTerminal : NSObject
@property(nonatomic,strong) NSString *name;
@property(nonatomic,strong) NSString *ip;
@property(nonatomic,strong) NSURL *url;
@property(nonatomic,strong)NSNetService *service;
-(id)initWithService:(NSNetService*)service;
@end
