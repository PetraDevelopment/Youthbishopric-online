//
//  LoginWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/22/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LoginWebServiceDelegate;

@interface LoginWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <LoginWebServiceDelegate> loginWebServiceDelegate;

- (void)loginWithEmail:(NSString *)email andPassword:(NSString *)password andFbFlag:(int)fbFlag;

@end

@protocol LoginWebServiceDelegate <NSObject>
@optional
- (void)loginWebService:(LoginWebService *)loginWebService errorMessage:(NSString *)errorMsg;
- (void)loginWebService:(LoginWebService *)loginWebService returnMessage:(NSDictionary *)returnMsg;

@end


