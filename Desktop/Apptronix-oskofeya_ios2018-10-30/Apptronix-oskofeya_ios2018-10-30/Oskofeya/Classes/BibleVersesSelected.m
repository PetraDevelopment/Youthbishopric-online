#import "BibleVersesSelected.h"
#import "AppDelegate.h"
#import "FMDB.h"

@implementation BibleVersesSelected
@synthesize contentid;

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
}

- (void)viewWillAppear:(BOOL)animated {
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *rowsExists = @"0";
    sqlite3_stmt    *statement;
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
    const char *dbpath = [databasePath UTF8String];
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT distinct vc_book_id,vc_chapter_id,vc_verse_id FROM verse_comment WHERE vc_color!='null' and vc_color!='Clear'" , nil];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            while (SQLITE_DONE!= sqlite3_step(statement))
            {
                [queue inDatabase:^(FMDatabase *db) {
                    
                    FMResultSet *rs2 = [db executeQuery:@"select text || ' ' || abbreviation || ' (' || verse || ':' || chapter || ')'  as text,book_id,chapter from verse,book where book_id=book.id and book_id=? and chapter=? and verse=?",[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)],[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,1)],[[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,2)]];
                    while ([rs2 next]) {
                        
                        NSMutableDictionary *tempMutableDict2 = [[NSMutableDictionary alloc] init];
                        [tempMutableDict2 setObject:[rs2 stringForColumn:@"text"] forKey:@"body"];
                        [tempMutableDict2 setObject:[rs2 stringForColumn:@"book_id"] forKey:@"id"];
                         [tempMutableDict2 setObject:[rs2 stringForColumn:@"chapter"] forKey:@"chapter"];
                        [prayers_contentList addObject:tempMutableDict2];
                    }
                }];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    prayers_contentTable.backgroundColor = [UIColor clearColor];
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
        cell.textLabel.textColor = [UIColor blackColor];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    BibleChaptersController = [[BibleChapters alloc] initWithNibName:@"BibleChaptersView" bundle:nil];
    BibleChaptersController.bookid2 = [NSString stringWithFormat:@"%@",[[prayers_contentList objectAtIndex:indexPath.row] objectForKey:@"id"]];
    BibleChaptersController.pageind = [[[prayers_contentList objectAtIndex:indexPath.row] objectForKey:@"chapter"] intValue] - 1;
    [self showViewController:BibleChaptersController];
    [self performSelector:@selector(pushViewController:) withObject:BibleChaptersController afterDelay:0.5f];

}

 


@end


