# pos-connector-ios-sdk-sample
Sample demonstrating the usage of Poynt POS Connector SDK for iOS

##Installation
* drop the `PoyntLib` directory into your project. `PoyntLib` should contain the following
	* `PoyntLib.a` static lib
	* header files found in `include/PoyntLib/{headerfiles}`
* Be sure you project app target bulid settings has:	
	* `-ObjC` in `Other Linker Flags` 
	* `$SRCROOT/PoyntLib/include/PoyntLib` in Header Search Paths



##Updates

* 8-15-2016 - removed pods, made static PoyntLib.a making all updates from 8-01 irrelevant!

* 8-01-2016
	* <del>Amplitude (this will go away, but necessary for now)
	* XCode with iOS Simulator or correct path for CommonCrypto - see `{projectdir}/CommonCrypto/module.map`
	* CommonCrypto import to project - `Build Settings-> Swift Compilier Build Paths -> Import Paths` add `$(PROJECT_DIR)/CommonCrypto`


