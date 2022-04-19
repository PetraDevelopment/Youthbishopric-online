//
//  EttamenWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/13/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "EttamenWebService.h"

@implementation EttamenWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize ettamenMessages
    ettamenMessages = [[NSMutableArray alloc] init];
    return self;
}

- (void)getEttamenMessages {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    // NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://107.170.130.87/api/reassures?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/api/reassures?access_token=%@",[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.ettamenWebServiceDelegate ettamenWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSArray *receivedMessages;
    NSError *myError = nil;
    receivedMessages = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    for (NSDictionary *tempDict in receivedMessages) {
        NSMutableDictionary *tempMutableDict;
        tempMutableDict = [tempDict mutableCopy];
        [tempMutableDict setObject:@"None" forKey:@"publish_date"];
        [ettamenMessages addObject:tempMutableDict];
    }
    // NSLog(@"ettamenMessages = %@",ettamenMessages);
    [self.ettamenWebServiceDelegate ettamenWebService:self returnMessages:ettamenMessages];
}

@end


