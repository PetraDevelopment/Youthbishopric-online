//
//  YoumBeYoumViewController.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 6/11/15.
//  Copyright (c) 2015 Apptronix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Eshba3ViewController.h"
#import "EttamenViewController.h"
#import "EktanyViewController.h"
#import "Estamte3ViewController.h"
#import "Es2alViewController.h"
#import "E3rafViewController.h"
#import "E3rafWebService.h"


@interface YoumBeYoumViewController : UIViewController <E3rafWsDelegate> {
    Eshba3ViewController *eshba3ViewController;
    EttamenViewController *ettamenViewController;
    EktanyViewController *ektanyViewController;
    Estamte3ViewController *estamte3ViewController;
    Es2alViewController *es2alViewController;
    E3rafViewController *e3rafViewController;
    IBOutlet UIButton *btnE3raf;
    E3rafWebService *e3rafWebService;
    

    
}

@end


