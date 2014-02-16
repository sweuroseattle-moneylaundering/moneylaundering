//
//  SWBTLECentral.h
//  LaundryMachine
//
//  Created by Anatoly Macarov on 1/25/14.
//  Copyright (c) 2014 sweuroseattle. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SWBTLECentralDelegate<NSObject>
-(void)dataTransfered:(NSData *)data;
@end

@interface SWBTLECentral : NSObject
@property(assign, nonatomic) id <SWBTLECentralDelegate> delegate;

+(SWBTLECentral*)sharedInstance;
- (void)startScan;
- (void)stopScan;
@end
