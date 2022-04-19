//
//  RegistrationWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/23/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol RegistrationWsDelegate;

@interface RegistrationWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <RegistrationWsDelegate> registrationWsDelegate;

- (void)registerWithUsername:(NSString *)username andPassword:(NSString *)password andEmail:(NSString *)email andAge:(int)age andFbFlag:(int)fbFlag;

@end

@protocol RegistrationWsDelegate <NSObject>
@optional
- (void)registrationWebService:(RegistrationWebService *)registrationWebService errorMessage:(NSString *)errorMsg;
- (void)registrationWebService:(RegistrationWebService *)registrationWebService returnMessage:(NSDictionary *)returnMsg;

@end


