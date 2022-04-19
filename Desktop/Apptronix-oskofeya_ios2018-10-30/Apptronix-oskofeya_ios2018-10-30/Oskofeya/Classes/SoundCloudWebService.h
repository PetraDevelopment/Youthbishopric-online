//
//  SoundCloudWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/17/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SoundCloudWsDelegate;

@interface SoundCloudWebService : NSObject {
    NSMutableData *receivedData;
    NSMutableDictionary *scReturnMsg;
}

@property (nonatomic, retain) id <SoundCloudWsDelegate> soundCloudWsDelegate;

- (void)resolveSoundCloudTrackIDfromURL:(NSString *)soundCloudURL;

@end

@protocol SoundCloudWsDelegate <NSObject>
@optional
- (void)soundCloudWebService:(SoundCloudWebService *)soundCloudWebService errorMessage:(NSString *)errorMsg;
- (void)soundCloudWebService:(SoundCloudWebService *)soundCloudWebService returnMessages:(NSMutableDictionary *)returnMsgs;

@end


