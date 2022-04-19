//
//  Ma3refaWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 5/30/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "Ma3refaWebService.h"

@implementation Ma3refaWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize ma3refaMessages
    ma3refaMessages = [[NSMutableArray alloc] init];
    return self;
}

- (void)getMa3refaMessagesForPresentAndFuture:(BOOL)isPresent {
    int apiFilter = (isPresent ? 1 : 2);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.130.87/api/posts?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/api/posts?access_token=%@&filter=%d",[defaults objectForKey:@"authToken"], apiFilter]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.ma3refaWsDelegate ma3refaWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    ma3refaMessages = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    // NSLog(@"ma3refaMessages = %@",ma3refaMessages);
    [self.ma3refaWsDelegate ma3refaWebService:self returnMessages:ma3refaMessages];
}

@end


