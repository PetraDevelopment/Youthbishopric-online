#import <Foundation/Foundation.h>

@interface CFWObject : NSObject

- (void)copyContent:(NSString *)string;
- (void)facebookShareContent:(NSString *)content fromViewController:(UIViewController *)controller;
- (void)facebookShareContent:(NSString *)content fromViewController:(UIViewController *)controller withImage:(NSData *)mediaData;
- (void)whatsAppShareURL:(NSURL *)url;

@end


