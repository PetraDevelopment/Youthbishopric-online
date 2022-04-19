//
//  Es2alQuestionWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/18/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol Es2alQuestionWsDelegate;

@interface Es2alQuestionWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <Es2alQuestionWsDelegate> es2alQuestionWsDelegate;

- (void)postQuestion:(NSString *)questionBody;

@end

@protocol Es2alQuestionWsDelegate <NSObject>
@optional
- (void)es2alQuestionWebService:(Es2alQuestionWebService *)es2alQuestionWebService errorMessage:(NSString *)errorMsg;
- (void)es2alQuestionWebService:(Es2alQuestionWebService *)es2alQuestionWebService returnMessage:(NSDictionary *)returnMsg;

@end


