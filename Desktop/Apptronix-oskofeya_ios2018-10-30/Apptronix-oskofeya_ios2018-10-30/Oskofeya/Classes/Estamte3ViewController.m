//
//  Estamte3ViewController.m
//  أسقفية الشباب
//
//  Created by Botros Rafik on 10/26/14.
//  Copyright (c) 2014 Apptronix. All rights reserved.
//

#import "Estamte3ViewController.h"

@implementation Estamte3ViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Estamte3 View", @"Estamte3 View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize esma3ViewController
  //  if ([[UIScreen mainScreen] bounds].size.height == 568) {
        esma3ViewController = [[Esma3ViewController alloc] initWithNibName:@"Esma3View_i5" bundle:nil];
    /*} else {
        esma3ViewController = [[Esma3ViewController alloc] initWithNibName:@"Esma3View" bundle:nil];
    }
    // Initialize shoufViewController
    if ([[UIScreen mainScreen] bounds].size.height == 568) {*/
        shoufViewController = [[ShoufViewController alloc] initWithNibName:@"ShoufView_i5" bundle:nil];
   /* } else {
        shoufViewController = [[ShoufViewController alloc] initWithNibName:@"ShoufView" bundle:nil];
    }*/
    
    
}

#pragma mark - Buttons Methods

- (IBAction)loadEsma3View:(id)sender {
    esma3ViewController.todayMsgIndex = 1000;
    [self showViewController:esma3ViewController];
    [self performSelector:@selector(pushViewController:) withObject:esma3ViewController afterDelay:0.5f];
}

- (IBAction)loadShoufView:(id)sender {
    shoufViewController.todayMsgIndex = 1000;
    [self showViewController:shoufViewController];
    [self performSelector:@selector(pushViewController:) withObject:shoufViewController afterDelay:0.5f];
}

#pragma mark - View Loading Methods

- (void)showViewController:(UIViewController *)viewController {
    viewController.view.frame = [[UIScreen mainScreen] bounds];
    [viewController.view setAlpha:0];
    [self.navigationController.view addSubview:viewController.view];
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    [UIView setAnimationDelegate:self];
    viewController.view.alpha = 1;
    [UIView commitAnimations];
}

- (void)pushViewController:(UIViewController *)viewController {
    [viewController.view removeFromSuperview];
    [self.navigationController pushViewController:viewController animated:NO];
}

#pragma mark - Dismiss Method

- (IBAction)dismissEshba3View:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


