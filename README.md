# pos-connector-ios-sdk-sample
Sample demonstrating the usage of Poynt POS Connector SDK for iOS

##Installation
### COCOAPOD

Beta feature, but you can apply the library w/ cocoapods.<sup>[1](#myfootnote1)</sup>
 
```
use_frameworks!
target 'iOStoPOSExample' do
  pod 'PoyntLib', :git => 'https://github.com/mcconkiee/poyntsdk.git'
end
```	
<a name="myfootnote1">1</a>: A note about `ONLY_ACTIVE_ARCH` (AKA "Build Active Architecture Only": if your original project has different values for `Debug` to `Release`, be sure the pod target matches.


###MANUALLY
* drop the `PoyntLib` directory into your project. `PoyntLib` should contain the following
	* `PoyntLib.a` static lib
	* header files found in `include/PoyntLib/{headerfiles}`
* Be sure you project app target bulid settings has:	
	* `-ObjC` in `Other Linker Flags` 
	* `$SRCROOT/PoyntLib/include/PoyntLib` in Header Search Paths

##Using the SDK

###Concepts:

The `PoyntPOSConnectionManager` handles all requests and responses. See the header for available requests.

* **DISCOVERY**: use `PoyntTerminalDiscover`  to find local terminals on the same WIFI network. Currently this is the only way for an iOS client to communicate with a Poynt terminal.

```
self.discovery = [[PoyntTerminalDiscover alloc] init];
[self.discovery setOnTerminalsFound:^(NSArray *terminal){
    //...populate a table view, or take the first one!
    NSLog(@"array of terminals %@",terminal);
}];
```

	
	
* **PAIRING**: Use the `PoyntPOSConnectionManager` to establish a pair with a `PoyntTerminal Object`. The connection manager will remember the pairing configuration for next time, even if the application process is cancelled. 

```
[self.paymentManager setOnError:^void(NSError *error,PoyntActionType type){
	// :(
}];

[self.paymentManager setOnTransactionResponse:^void(PoyntTransactionResponseObject *data,PoyntActionType api){
   //paired....do some transactions!
}];
self.paymentManager.url = discoveredTerminal.url.absoluteURL;
[self.paymentManager authorizePairing:@"ABC123"];
```

* **REQUESTS**: Requests are made from PoyntPOSConnectionManager. Responses are handled by the call back (see RESPONSES section below). Some request examples:

```
PoyntPaymentObject *payment = [[PoyntPaymentObject alloc] init];
PoyntOrderObject *order = [[PoyntOrderObject alloc] init];
order.items = @[
    [[PoyntOrderItemObject alloc ]initWithSku:@"testSku" unitPrice:100 quantity:1.3]
];
[payment setOrder:order];
[self.paymentManager authorizeSales:payment];
// or [self.paymentManager authorizePreSales:payment];

```
Some requests require objects subscribing to the `PoyntTransaction` protocol. These objects require a `transactionId` if you plan to modify a past transaction. If you don't feel like rollign your own class, you can use the `PoyntTransactionObject` to achieve the same thing:

```
PoyntTransactionObject *transaction = [[PoyntTransactionObject alloc] init];
transaction.transactionId = oldTransactionIdFromLocalDB;// e.g: @"084583D0-7198-4751-A49F-47A6DF447254";
[self.paymentManager authorizeVoid:transaction];
```

* **RESPONSES**: All responses come from the `PoyntPOSConnectionManager` callbacks. 


```
[self.paymentManager setOnError:^void(NSError *error,PoyntActionType type){

}];

[self.paymentManager setOnTransactionResponse:^void(PoyntTransactionResponseObject *data,PoyntActionType api){
   
}];
```


##Updates
* 9-2-2016
	* cocoapod friendly
	* removed empty order object from payments where not explicitly attached
* 8-26-2016 - 
	* documentation in code for public classes
	* remove dependency for the PoyntTransactionObject in favor of the PoyntTransaction protocol (requires `transactionId`)
* 8-15-2016 - 
	* removed pods, made static PoyntLib.a making all updates from 8-01 irrelevant!


* 8-01-2016
	* <del>Amplitude (this will go away, but necessary for now)
	* XCode with iOS Simulator or correct path for CommonCrypto - see `{projectdir}/CommonCrypto/module.map`
	* CommonCrypto import to project - `Build Settings-> Swift Compilier Build Paths -> Import Paths` add `$(PROJECT_DIR)/CommonCrypto`


