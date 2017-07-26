//
//  PoyntTransaction.h
//  PoyntLib
//
//  Created by Eric McConkie on 8/25/16.
//  Copyright © 2016 com.poynt. All rights reserved.
//
/*!
 @header PoyntTransaction.h
 @brief Interface that guarantees a `transactionId`. Object subscribing to this protocol are often (most likely) in reference to a previously existing transaction. When in doubt (or lazy) default to a PoyntTransactionObject. In cases where it is optimal to keep clear seperation, subscribe to PoyntTransaction . The transactionId property and dictionaryObject method are required
 */
NS_ASSUME_NONNULL_BEGIN

@protocol PoyntTransaction <NSObject>

/*!
 @brief required property representing a transactionId from past terminal requests, or a new transactionId for creating transaction (eg sale or preSale)

 @discussion Poynt terminal requires both a url and pairingCode to establish a connection for passing data.

 @return string - commonly in the format of @c[[NSUUID UUID] UUIDString]
 */
@property (nonatomic, copy) NSString *transactionId;

/*!
 @brief dictionary representation of this object

 @discussion the dictionary object is most commonly used in cases to serialize data for making requests.

 @return dictionary
 */
- (NSDictionary*)dictionaryObject;

@end

NS_ASSUME_NONNULL_END
