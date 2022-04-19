#import <UIKit/UIKit.h>
#import "Eshba3ViewController.h"
#import "SalatyViewController.h"
#import "MoreViewController.h"
#import "PushTokenWebService.h"
#import "DateIndexObject.h"
#import "EktanyViewController.h"
#import "Esma3ViewController.h"
#import "Estamte3ViewController.h"
#import "ShoufViewController.h"
#import "EttamenViewController.h"
#import "Es2alViewController.h"
#import "E3rafViewController.h"
#import "EttamenMsgViewController.h"


@interface MainViewController : UIViewController <PushTokenWsDelegate> {
    Eshba3ViewController *eshba3ViewController;
    SalatyViewController *salatyViewController;
    MoreViewController *moreViewController;
    PushTokenWebService *pushTokenWebService;
    EktanyViewController *ektanyViewController;
    Esma3ViewController *esma3ViewController;
    EttamenViewController *ettamenViewController;
    ShoufViewController *shoufViewController;
    Es2alViewController *es2alViewController;
    E3rafViewController *e3rafViewController;
    EttamenMsgViewController *ettamenMsgViewController;
}

@end


