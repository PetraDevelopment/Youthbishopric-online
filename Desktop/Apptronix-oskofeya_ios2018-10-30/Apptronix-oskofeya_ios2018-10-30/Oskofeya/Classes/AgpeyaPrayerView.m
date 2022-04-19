#import "AgpeyaPrayerView.h"
#import "AppDelegate.h"
#import "FMDB.h"


@implementation AgpeyaPrayerView

@synthesize bookid2;
@synthesize pageind;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"",@"");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self calculateNumberOfPages];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    // Set fontSize
    fontSize = 17.0;
    
    [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:pageind showTableView:showTableViewLastState withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    currentPageIndex = pageind;
    
}



- (void)setupView {
    // Set fontSize
    fontSize = 17.0;
    // Initialize pageController
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageController.dataSource = self;
    pageController.view.frame = CGRectMake(19, 80, self.view.bounds.size.width - 38, self.view.bounds.size.height - 150);
    pageController.view.backgroundColor = [UIColor clearColor];
    AgpPrayerChildViewControlle *initialViewController = [self viewControllerAtIndex:0 showTableView:NO withFontSize:fontSize];
    NSArray *viewControllers = [NSArray arrayWithObject:initialViewController];
    [pageController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    [self addChildViewController:pageController];
    [self.view addSubview:pageController.view];
    [pageController didMoveToParentViewController:self];
}


- (void)calculateNumberOfPages {
    
    //read from DB
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    numberofPagesInView = 0 ;
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs1 = [db executeQuery:@"select count(*) as c from prayers_content,prayers where prayers_content_id=prayers_content.id and prayer_id=?", bookid2];
        while ([rs1 next]) {
            numberofPagesInView = [rs1 intForColumn:@"c"];
            
        }
        
    }];
    
}


#pragma mark - pageViewController Methods

- (AgpPrayerChildViewControlle *)viewControllerAtIndex:(NSUInteger)pageIndex showTableView:(BOOL)boolVar withFontSize:(int)fontSizeVar {
    AgpPrayerChildViewControlle *childViewController = [[AgpPrayerChildViewControlle alloc] initWithNibName:@"AgpPrayerChildView" bundle:nil];
    [childViewController setAgpPrayerChildViewControlleDelegate:self];
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select prayers_content.id as id,prayers_content.id,pra_text,pra_title from prayers_content,prayers where prayers_content_id=prayers_content.id and prayer_id=? and prayers.`order`=?" , bookid2 , [NSString stringWithFormat: @"%lu",  pageIndex + 1]];
        if ([rs next]) {
            
            NSMutableDictionary *returnMutableDict = [[NSMutableDictionary alloc] init];
            [returnMutableDict setObject:[rs stringForColumn:@"pra_title"] forKey:@"title"];
            [returnMutableDict setObject:[rs stringForColumn:@"pra_text"] forKey:@"body"];
            [returnMutableDict setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            childViewController.displayedPrayer = returnMutableDict;
        }
        

    }];
    
    
   // childViewController.displayedPrayer = bookid2;
    childViewController.pageIndex = pageIndex;
    showTableViewLastState = boolVar;
    childViewController.showTableView = boolVar;
    childViewController.fontSize = fontSizeVar;
    return childViewController;
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(BibleChildViewController *)viewController pageIndex];
    if (pageIndex == 0) {
        return nil;
    }
    pageIndex--;
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
}

- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    NSUInteger pageIndex = [(BibleChildViewController *)viewController pageIndex];
    pageIndex++;
    if (pageIndex == numberofPagesInView) {
        return nil;
    }
    return [self viewControllerAtIndex:pageIndex showTableView:YES withFontSize:fontSize];
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



#pragma mark - B2kChildDelegate Method

- (void)b2kChildViewController:(BibleChildViewController *)b2kChildViewController hideCFW_Buttons:(BOOL)hideOrShow withPageIndex:(NSInteger)pageIndex {
    currentPageIndex = pageIndex;
}


- (IBAction)dismissBe2engylakView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
