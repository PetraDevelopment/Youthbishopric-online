#import "CFWObject.h"
#import "AppDelegate.h"

@implementation CFWObject

#pragma mark - CFW Related Methods

- (void)copyContent:(NSString *)string {
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = string;
    [AppDelegate showAlertView:@"تم النسخ بنجاح"];
}

- (void)facebookShareContent:(NSString *)content fromViewController:(UIViewController *)controller {
    SLComposeViewController *mySLComposerSheet;
    BOOL facebookServiceIsAvailable = NO;
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"fb://"]]) {
        facebookServiceIsAvailable = YES;
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        float deviceSystemVerion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (deviceSystemVerion < 8.00) {
            [mySLComposerSheet setInitialText:content];
        } else {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = content;
            // @"Due to Facebook latest policy changes, please click paste in the dialog box"
            [AppDelegate showAlertView:@"برجاء لصق المحتوى في المساحة المخصصة\nPlease click paste in the dialog box"];
        }
        [mySLComposerSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/youthbishopriconline?"]];
        [controller presentViewController:mySLComposerSheet animated:YES completion:nil];
    /*} else {
        [AppDelegate showAlertView:@"برجاء تفعيل حساب الفيسبوك من إعدادات الهاتف"];
    }*/
    //if (facebookServiceIsAvailable) {
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *postResult;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    postResult = @"تم الإلغاء";
                    break;
                case SLComposeViewControllerResultDone:
                    postResult = @"تمت المشاركة بنجاح";
                    break;
                    
                default:
                    postResult = @"برجاء المحاولة مرة أخرى";
                    break;
            }
            [AppDelegate showAlertView:[NSString stringWithFormat:@"%@",postResult]];
        }];
    }
        else {
            [AppDelegate showAlertView:[NSString stringWithFormat:@"من فضلك حمل تطبيق الفيس بوك"]];
        }
    //}
}

- (void)facebookShareContent:(NSString *)content fromViewController:(UIViewController *)controller withImage:(NSData *)mediaData {
    SLComposeViewController *mySLComposerSheet;
    BOOL facebookServiceIsAvailable = NO;
    //if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook]) {
        facebookServiceIsAvailable = YES;
        mySLComposerSheet = [[SLComposeViewController alloc] init];
        mySLComposerSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
        float deviceSystemVerion = [[[UIDevice currentDevice] systemVersion] floatValue];
        if (deviceSystemVerion < 8.00) {
            [mySLComposerSheet setInitialText:content];
        } else {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = content;
            // @"Due to Facebook latest policy changes, please click paste in the dialog box"
            [AppDelegate showAlertView:@"برجاء لصق المحتوى في المساحة المخصصة\nPlease click paste in the dialog box"];
        }
        [mySLComposerSheet addImage:[UIImage imageWithData:mediaData]];
        // [mySLComposerSheet addURL:[NSURL URLWithString:@"https://www.facebook.com/youthbishopriconline?"]];
        [controller presentViewController:mySLComposerSheet animated:YES completion:nil];
   /* } else {
        [AppDelegate showAlertView:@"برجاء تفعيل حساب الفيسبوك من إعدادات الهاتف"];
    }*/
    //if (facebookServiceIsAvailable) {
        [mySLComposerSheet setCompletionHandler:^(SLComposeViewControllerResult result) {
            NSString *postResult;
            switch (result) {
                case SLComposeViewControllerResultCancelled:
                    postResult = @"تم الإلغاء";
                    break;
                case SLComposeViewControllerResultDone:
                    postResult = @"تمت المشاركة بنجاح";
                    break;
                default:
                    postResult = @"برجاء المحاولة مرة أخرى";
                    break;
            }
            [AppDelegate showAlertView:[NSString stringWithFormat:@"%@",postResult]];
        }];
   // }
}

- (void)whatsAppShareURL:(NSURL *)url {
    if ([[UIApplication sharedApplication] canOpenURL: url]) {
        [[UIApplication sharedApplication] openURL: url];
    } else {
        [AppDelegate showAlertView:[NSString stringWithFormat:@"برجاء تحميل برنامج الواتس اب "]];
    }
}

@end


