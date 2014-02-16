//
//  SWBTLEPeripheral.h
//  MoneyLaundering
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWBTLEPeripheralDelegate<NSObject>
-(void)dataTransfered:(NSData *)data;
@end

@interface SWBTLEPeripheral : NSObject

+ (SWBTLEPeripheral*)sharedInstance;
- (void)startAdvertising;
- (void)stopAdvertising;

@property(assign, nonatomic) id <SWBTLEPeripheralDelegate> delegate;
@end
