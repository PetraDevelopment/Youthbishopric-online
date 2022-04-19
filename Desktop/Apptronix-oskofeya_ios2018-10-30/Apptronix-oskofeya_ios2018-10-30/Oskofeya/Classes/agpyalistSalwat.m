#import "agpyalistSalwat.h"
#import "AppDelegate.h"
#import "FMDB.h"



@implementation agpyalistSalwat

@synthesize contentid;
@synthesize contentName;


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
    
    agpeyaViewController = [[AgpeyaPrayerView alloc] initWithNibName:@"AgpeyaPrayerView_i5" bundle:nil];

    [self setupView];
}

- (void)setupView {
    
    prayers_contentTable.backgroundColor = [UIColor clearColor];
}

- (void)viewWillAppear:(BOOL)animated {
    
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
    lblHeader.text = contentName;
    self.title = contentName;
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select prayers_content.id as id,pra_title from prayers_content,prayers where prayers_content_id=prayers_content.id and prayer_id=?",contentid];
        
        while ([rs next]) {
            
            NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
            [tempMutableDict setObject:[rs stringForColumn:@"id"] forKey:@"id"]; // @"You have no saved notes"
            [tempMutableDict setObject:[rs stringForColumn:@"pra_title"] forKey:@"body"];
            [prayers_contentList addObject:tempMutableDict];
            
        }}];

      [prayers_contentTable reloadData];

}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [prayers_contentList count];
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
    [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[[prayers_contentList objectAtIndex:indexPath.row] objectForKey:@"body"]]];
    
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
    
    agpeyaViewController.bookid2 = contentid;
    agpeyaViewController.pageind = indexPath.row;
    [self showViewController:agpeyaViewController];
    [self performSelector:@selector(pushViewController:) withObject:agpeyaViewController afterDelay:0.5f];
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


