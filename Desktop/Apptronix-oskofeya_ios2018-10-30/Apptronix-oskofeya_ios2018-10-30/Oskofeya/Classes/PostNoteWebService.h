//
//  PostNoteWebService.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 7/9/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PostNoteWsDelegate;

@interface PostNoteWebService : NSObject {
    NSMutableData *receivedData;
    NSDictionary *returnMsg;
}

@property (nonatomic, retain) id <PostNoteWsDelegate> postNoteWsDelegate;

- (void)postNote:(NSString *)noteBody;

@end

@protocol PostNoteWsDelegate <NSObject>
@optional
- (void)postNoteWebService:(PostNoteWebService *)postNoteWebService errorMessage:(NSString *)errorMsg;
- (void)postNoteWebService:(PostNoteWebService *)postNoteWebService returnMessage:(NSDictionary *)returnMsg;

@end


