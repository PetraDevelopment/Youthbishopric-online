//
//  AgpeyaWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/17/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AgpeyaWsDelegate;

@interface AgpeyaWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableDictionary *agpeyaPrayers;
}

@property (nonatomic, retain) id <AgpeyaWsDelegate> agpeyaWsDelegate;

- (void)getAgpeyaPrayersIn:(NSString *)prayerName;

@end

@protocol AgpeyaWsDelegate <NSObject>
@optional
- (void)agpeyaWebService:(AgpeyaWebService *)agpeyaWebService errorMessage:(NSString *)errorMsg;
- (void)agpeyaWebService:(AgpeyaWebService *)agpeyaWebService returnMessages:(NSMutableDictionary *)returnMsgs;

@end


