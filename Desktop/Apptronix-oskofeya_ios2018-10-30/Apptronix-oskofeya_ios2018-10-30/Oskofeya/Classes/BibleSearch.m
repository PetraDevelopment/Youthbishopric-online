#import "BibleSearch.h"
#import "AppDelegate.h"
#import "FMDB.h"



@implementation BibleSearch

@synthesize searchTxt;


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
    [[btn_Search layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[btn_Search layer] setBorderWidth:.4];
    [[btn_Search layer] setCornerRadius:8.0f];
    prayers_contentTable.backgroundColor = [UIColor clearColor];
     searchtext.text = searchTxt;
}


- (void)viewWillAppear:(BOOL)animated {
    
  
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
   
    
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
    
        FMResultSet *rs2 = [db executeQuery:@"select book_id, replace(replace(replace(replace(replace(replace(replace (replace (text,'ّ',''),'ْ',''),'ٍ','') ,'ِ','')  ,'ٌ','')  ,'ُ','' ) , 'ً','' ),'َ','') || '(' || abbreviation || ' ' || chapter || ' : ' || verse || ')' as VText from verse ,book where book.id=book_id  ",nil];
      

        while ([rs2 next]) {
            
            
            NSMutableDictionary *tempMutableDict2 = [[NSMutableDictionary alloc] init];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"VText"] forKey:@"body"];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"book_id"] forKey:@"id"];
            [prayers_contentList addObject:tempMutableDict2];
        }
        
        
    
    }];

 
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"body CONTAINS[cd] %@",
                              searchTxt];
     filteredArray = [prayers_contentList filteredArrayUsingPredicate:predicate];
    prayers_contentTable.backgroundColor = [UIColor clearColor];
    [prayers_contentTable reloadData];

}
- (IBAction)searchEvent:(id)sender {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"body CONTAINS[cd] %@",
                              searchtext.text];
    filteredArray = [prayers_contentList filteredArrayUsingPredicate:predicate];
    prayers_contentTable.backgroundColor = [UIColor clearColor];
    [prayers_contentTable reloadData];
}


#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [filteredArray count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        /*[[cell textLabel] setText:[NSString stringWithFormat:@"%@",[[prayers_contentList objectAtIndex:indexPath.row] objectForKey:@"body"]]];*/

     //[[cell textLabel] setText:[NSString stringWithFormat:@"%@",filteredArray[indexPath.row]]];
    
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[[filteredArray objectAtIndex:indexPath.row] objectForKey:@"body"]]];
    
    
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:18];
        cell.textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        cell.textLabel.textAlignment = NSTextAlignmentRight;
        cell.textLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 0.3;
        cell.layer.cornerRadius = 0;
        cell.clipsToBounds = true;
        return cell;
}





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



@end


