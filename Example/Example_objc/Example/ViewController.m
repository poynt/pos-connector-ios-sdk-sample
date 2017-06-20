//
//  ViewController.m
//  Example
//
//  Created by Eric McConkie on 3/16/17.
//  Copyright © 2017 Poynt. All rights reserved.
//

#import "ViewController.h"
#import <PoyntLib/PoyntLib.h>
@interface ViewController ()
@property PoyntTerminalDiscover *discover;
@property PoyntPOSConnectionManager *manager;
@end

@implementation ViewController
- (IBAction)onPairTest:(id)sender {
    
    [self.discover findTerminals:^(NSArray *terminals) {
        NSLog(@"TERMINALS: %@",terminals);
        PoyntTerminal *terminal = [terminals objectAtIndex:0];
        NSURL *terminalUrl = terminal.url;
        NSLog(@"url = %@",terminalUrl);
        NSString *ipService = [NSString stringWithFormat:@"%@:%ld",terminal.ip, (long)terminal.service.port];
        [self pairWithIp:ipService];
    }];
}

- (void)pairWithIp:(NSString*)ipService{
    self.manager = [[PoyntPOSConnectionManager alloc] init];
    [self.manager setUrl:ipService];
    [self.manager setTimeout:6000];
    [self.manager setClientName:@"ohHai!"];
    [self.manager setOnTransactionResponse:^(PoyntTransactionResponseObject *data, PoyntActionType type){
        NSLog(@"OnTransactionResonse! %@",data);
    }];
    
    [self.manager setOnError:^(NSError *error,PoyntActionType actionType){
        NSLog(@"ERROR! %@",error);
    }];
    [self.manager attemptPairing:^(BOOL flag, NSError *err) {
        if(flag){
            NSLog(@"CONNECTED!");
        }else{
            NSLog(@"NOT CONNECTED!: %@",err);
        }
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.discover = [[PoyntTerminalDiscover alloc] init];
    // Do any additional setup after loading the view, typically from a nib.
}
@end
