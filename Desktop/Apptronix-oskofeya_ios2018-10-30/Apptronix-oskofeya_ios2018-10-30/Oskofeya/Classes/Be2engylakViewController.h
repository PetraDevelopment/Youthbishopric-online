//
//  Be2engylakViewController.h
//  أسقفية الشباب
//
//  Created by Botros Rafik on 5/30/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "B2kChildViewController.h"
#import "B2kHistoryViewController.h"
#import "EngylakWebService.h"
#import "DateIndexObject.h"

@interface Be2engylakViewController : UIViewController <UIPageViewControllerDataSource,B2kHistoryDelegate,B2kChildDelegate,EngylakWsDelegate> {
    B2kHistoryViewController *b2kHistoryViewController;
    B2kChildViewController *b2kChildViewController;
    EngylakWebService *engylakWebService;
    IBOutlet UIButton *btnCopy;
    IBOutlet UIButton *btnFb;
    IBOutlet UIButton *btnWhtsp;
    UIPageViewController *pageController;
    IBOutlet UIView *aiView;
    IBOutlet UILabel *aiMsg;
    NSMutableArray *engylakMessages;
    NSMutableDictionary *displayedMessage;
    BOOL showTableViewLastState;
    IBOutlet UIButton *btnIncFont;
    IBOutlet UIButton *btnDecFont;
    float fontSize;
    NSInteger currentPageIndex;
    UIDocumentInteractionController *documentInteractionController;
    IBOutlet UIButton *btnShare;
}

@property (assign, nonatomic) int todayMsgIndex;

@end


