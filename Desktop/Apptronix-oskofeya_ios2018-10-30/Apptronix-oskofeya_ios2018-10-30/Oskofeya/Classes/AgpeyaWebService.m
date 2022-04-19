//
//  AgpeyaWebService.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/17/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import "AgpeyaWebService.h"

@implementation AgpeyaWebService

#pragma mark - Initialization Method

- (id)init {
    // Initialize agpeyaPrayers
    agpeyaPrayers = [[NSMutableDictionary alloc] init];
    return self;
}

- (void)getAgpeyaPrayersIn:(NSString *)prayerName {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://oskofeya.com/agpeya/api/%@_prayer?access_token=%@",prayerName,[defaults objectForKey:@"authToken"]]] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:30.0];
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
    [self.agpeyaWsDelegate agpeyaWebService:self errorMessage:error.localizedDescription];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSLog(@"Succeeded! Received %d Bytes of data",[receivedData length]);
    NSError *myError = nil;
    agpeyaPrayers = [NSJSONSerialization JSONObjectWithData:receivedData options:NSJSONReadingMutableLeaves error:&myError];
    // NSLog(@"agpeyaPrayers = %@",agpeyaPrayers);
    [self.agpeyaWsDelegate agpeyaWebService:self returnMessages:agpeyaPrayers];
}

@end


