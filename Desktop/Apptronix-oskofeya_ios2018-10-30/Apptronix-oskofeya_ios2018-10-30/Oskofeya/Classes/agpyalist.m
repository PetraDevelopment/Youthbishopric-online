#import "agpyalist.h"
#import "AppDelegate.h"
#import "FMDB.h"

@implementation agpyalist

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"الأجبية المقدسة", @"الأجبية المقدسة");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    // Initialize writeNoteViewController
    
    agpyalistSalwatView = [[agpyalistSalwat alloc] initWithNibName:@"agpyalistSalwatView_i5" bundle:nil];

    //read from DB
    prayers_namesList = [[NSMutableArray alloc] initWithObjects:nil];

    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from prayers_names"];
        while ([rs next]) {
            
            NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
            [tempMutableDict setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            [tempMutableDict setObject:[rs stringForColumn:@"pray_name_ar"] forKey:@"body"];
            [prayers_namesList addObject:tempMutableDict];
            
        }}];
    [self setupView];
}

- (void)setupView {
    // Set the notesHistoryTable
    prayersNamesTable.backgroundColor = [UIColor clearColor];
}

/*- (void)viewWillAppear:(BOOL)animated {
    // Get notesMessages

}*/


#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayers_namesList count];
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
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[[prayers_namesList objectAtIndex:indexPath.row] objectForKey:@"body"]]];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    agpyalistSalwatView.contentid = [[prayers_namesList objectAtIndex:indexPath.row] objectForKey:@"id"];
    agpyalistSalwatView.contentName = [[prayers_namesList objectAtIndex:indexPath.row] objectForKey:@"body"];;
    [self showViewController:agpyalistSalwatView];
    [self performSelector:@selector(pushViewController:) withObject:agpyalistSalwatView afterDelay:0.5f];

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


