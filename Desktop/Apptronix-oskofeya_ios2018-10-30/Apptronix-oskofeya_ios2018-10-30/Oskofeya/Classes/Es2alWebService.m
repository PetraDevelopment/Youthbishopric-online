//
//  Es2alWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/4/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "Es2alWebService.h"

@implementation Es2alWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize es2alMessages
    es2alMessages = [[NSMutableArray alloc] init];
    return self;
}

- (void)getEs2alMessagesForPresentAndFuture:(BOOL)isPresent {
    int apiFilter = (isPresent ? 1 : 2);
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.130.87/api/questions?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/api/questions?access_token=%@&filter=%d",[defaults objectForKey:@"authToken"], apiFilter]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.es2alWsDelegate es2alWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    es2alMessages = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    // NSLog(@"es2alMessages = %@",es2alMessages);
    [self.es2alWsDelegate es2alWebService:self returnMessages:es2alMessages];
}

@end


