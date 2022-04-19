//
//  SoundCloudWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/17/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import "SoundCloudWebService.h"

@implementation SoundCloudWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize scReturnMsg
    scReturnMsg = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)resolveSoundCloudTrackIDfromURL:(NSString *)soundCloudURL {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://api.soundcloud.com/resolve.json?url=%@&client_id=ac49616664ca1f9c03baa38fef74a60c",soundCloudURL]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [NSMutableData data];
    } else {
        NSLog(@"NSURLConnection initWithRequest: Failed to return a connection.");
    }
}

#pragma mark - Connection Methods

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"connection didFailWithError: %@ %@", error.localizedDescription, [error.userInfo objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [self.soundCloudWsDelegate soundCloudWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    scReturnMsg = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    // NSLog(@"scReturnMsg = %@",scReturnMsg);
    [self.soundCloudWsDelegate soundCloudWebService:self returnMessages:scReturnMsg];
}

@end


