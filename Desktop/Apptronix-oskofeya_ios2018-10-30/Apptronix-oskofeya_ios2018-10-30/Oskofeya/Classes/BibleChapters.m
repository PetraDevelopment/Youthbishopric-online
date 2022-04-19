#import "BibleChapters.h"
#import "AppDelegate.h"
#import "FMDB.h"

@implementation BibleChapters

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
    [self readbookmark];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    // Set fontSize
    fontSize = 17.0;

    [pageController setViewControllers:[NSArray arrayWithObject:[self viewControllerAtIndex:pageind showTableView:showTableViewLastState withFontSize:fontSize]] direction:UIPageViewControllerNavigationDirectionForward animated:NO completion:nil];
    currentPageIndex = pageind;
  
}

- (void)readbookmark
{
    [BookMark setBackgroundImage: [UIImage imageNamed:@"gold"] forState:UIControlStateNormal];
    bookmarkvalue = 0;
    if([bookid2 intValue] < 40)
    {
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [dirPaths objectAtIndex:0];
        NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofia.txt"];
        NSFileManager *fileManagaer = [NSFileManager defaultManager];
        if([fileManagaer fileExistsAtPath:filePath])
        {
            xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            NSArray *testArray = [xmlString componentsSeparatedByString:@","];
            
            if([testArray count] > 0)
            {
                if([bookid2 isEqualToString:[testArray objectAtIndex:0]])
                {
                    if([chapterid intValue] == [[testArray objectAtIndex:1] intValue])
                    {
                        
                        [BookMark setBackgroundImage: [UIImage imageNamed:@"goldfill"] forState:UIControlStateNormal];
                        bookmarkvalue = 1;
                    }
                }
            }
        }
    }
    else
    {
        NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDir = [dirPaths objectAtIndex:0];
        NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofianew.txt"];
        
        NSFileManager *fileManagaer = [NSFileManager defaultManager];
        if([fileManagaer fileExistsAtPath:filePath])
        {
            xmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
            NSArray *testArray = [xmlString componentsSeparatedByString:@","];
            
            if([testArray count] > 0)
            {
                if([bookid2 isEqualToString:[testArray objectAtIndex:0]])
                {
                    if([chapterid intValue] == [[testArray objectAtIndex:1] intValue])
                    {
                        
                        [BookMark setBackgroundImage: [UIImage imageNamed:@"goldfill"] forState:UIControlStateNormal];
                        bookmarkvalue = 1;
                    }
                }
            }
        }
    }
}

- (void)setupView {
    // Set fontSize
    fontSize = 17.0;
    // Initialize pageController
    pageController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    pageController.dataSource = self;
    pageController.view.frame = CGRectMake(5, 80, self.view.bounds.size.width - 10, self.view.bounds.size.height - 150);
    pageController.view.backgroundColor = [UIColor clearColor];
    BibleChildViewController *initialViewController = [self viewControllerAtIndex:0 showTableView:NO withFontSize:fontSize];
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
       
        FMResultSet *rs1 = [db executeQuery:@"select count(distinct chapter) as c from verse where book_id=?", bookid2];
        while ([rs1 next]) {
            numberofPagesInView = [rs1 intForColumn:@"c"];
            
        }
        
    }];
    
}


- (IBAction)BookMarkEvent:(id)sender {
    if(bookmarkvalue == 0)
    {
        [BookMark setBackgroundImage: [UIImage imageNamed:@"goldfill"] forState:UIControlStateNormal];
        bookmarkvalue = 1;
        if([bookid2 intValue] < 40)
        {
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDir = [dirPaths objectAtIndex:0];
            NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofia.txt"];
            
            NSFileManager *fileManagaer = [NSFileManager defaultManager];
            if([fileManagaer fileExistsAtPath:filePath])
            {
                
                NSString * zStr = [[NSString alloc]init];
                
                zStr = [zStr stringByAppendingFormat:@"%d,%d\n",[bookid2 intValue],[chapterid intValue]];
                xmlString = zStr;
                [zStr writeToFile:filePath
                       atomically:YES
                         encoding:NSUTF8StringEncoding error:NULL];
            }
        }
        else{
            NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentDir = [dirPaths objectAtIndex:0];
            NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofianew.txt"];
            
            NSFileManager *fileManagaer = [NSFileManager defaultManager];
            if([fileManagaer fileExistsAtPath:filePath])
            {
                
                NSString * zStr = [[NSString alloc]init];
                
                zStr = [zStr stringByAppendingFormat:@"%d,%d\n",[bookid2 intValue],[chapterid intValue]];
                xmlString = zStr;
                [zStr writeToFile:filePath
                       atomically:YES
                         encoding:NSUTF8StringEncoding error:NULL];
            }
        }
    }
    else
    {
        [BookMark setBackgroundImage: [UIImage imageNamed:@"gold"] forState:UIControlStateNormal];
        bookmarkvalue = 0;
    }
}

#pragma mark - pageViewController Methods

- (BibleChildViewController *)viewControllerAtIndex:(NSUInteger)pageIndex showTableView:(BOOL)boolVar withFontSize:(int)fontSizeVar {
    BibleChildViewController *childViewController = [[BibleChildViewController alloc] initWithNibName:@"BiblePrayerChildView" bundle:nil];
    [childViewController setBibleChildViewControllerDelegate:self];
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select 'إصحاح' || ' ' || chapter as CName,chapter,GROUP_CONCAT(case when text like '%\n%' then '' else verse end || ' ' || replace(text, '\n', '\n\n' || verse)  || ';;') as text2 from verse where book_id=? and chapter=? order by verse " , bookid2 , [NSString stringWithFormat: @"%lu",  pageIndex + 1]];
        if ([rs next]) {
            
            NSMutableDictionary *returnMutableDict = [[NSMutableDictionary alloc] init];
            [returnMutableDict setObject:[rs stringForColumn:@"CName"] forKey:@"title"];
            [returnMutableDict setObject:[rs stringForColumn:@"text2"] forKey:@"body"];
            childViewController.displayedPrayer = returnMutableDict;
            chapterid = [NSString stringWithFormat: @"%lu",  pageIndex];
        }
    }];
    NSArray *testArray = [xmlString componentsSeparatedByString:@","];
    [BookMark setBackgroundImage: [UIImage imageNamed:@"gold"] forState:UIControlStateNormal];
    bookmarkvalue = 0;
    if([testArray count] > 0)
    {
        if([bookid2 isEqualToString:[testArray objectAtIndex:0]])
        {
            if([chapterid intValue] == [[testArray objectAtIndex:1] intValue])
            {
                
                [BookMark setBackgroundImage: [UIImage imageNamed:@"goldfill"] forState:UIControlStateNormal];
                bookmarkvalue = 1;
            }
        }
    }
    
    childViewController.bookid = bookid2;
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


