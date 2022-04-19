#import "BibleNewList.h"
#import "AppDelegate.h"
#import "FMDB.h"



@implementation BibleNewList

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
    BibleChaptersController = [[BibleChapters alloc] initWithNibName:@"BibleChaptersView" bundle:nil];
    chapters = [[NSMutableArray alloc] initWithObjects:nil];
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
    [self readbookmark];
    if(contentid == @"1")
    {
        [btn_Header setTitle:@"سفر التكوين" forState:UIControlStateNormal];
        selectedbook = @"1";
        bookHeader.text = @"العهد القديم";
    }
    else
    {
        [btn_Header setTitle:@"إنجيل متى" forState:UIControlStateNormal];
        selectedbook = @"40";
        bookHeader.text = @"العهد الجديد";
    }
}


- (void)readbookmark
{
    bookIdMark = 0;
    chapterIdMark = 0;
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
            bookIdMark = [testArray objectAtIndex:0];
            chapterIdMark = [testArray objectAtIndex:1];
        }
    }
    
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    documentDir = [dirPaths objectAtIndex:0];
    filePath = [documentDir stringByAppendingPathComponent:@"oskofianew.txt"];
    
    fileManagaer = [NSFileManager defaultManager];
    if([fileManagaer fileExistsAtPath:filePath])
    {
        newxmlString = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
        NSArray *testArray = [newxmlString componentsSeparatedByString:@","];
        
        if([testArray count] > 0)
        {
            newbookIdMark = [testArray objectAtIndex:0];
            newchapterIdMark = [testArray objectAtIndex:1];
        }
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    chapters = [[NSMutableArray alloc] initWithObjects:nil];
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
    NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                         ofType:@"db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs = [db executeQuery:@"select id,name from book where testament_id=?",contentid];
        while ([rs next]) {
            NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
            [tempMutableDict setObject:[rs stringForColumn:@"id"] forKey:@"id"];
            [tempMutableDict setObject:[rs stringForColumn:@"name"] forKey:@"body"];
            [chapters addObject:tempMutableDict];
        }
    
        FMResultSet *rs2 = [db executeQuery:@"select DISTINCT 'إصحاح' || ' ' || chapter as CName,chapter from verse where book_id=?",selectedbook];
        while ([rs2 next]) {
            
            NSMutableDictionary *tempMutableDict2 = [[NSMutableDictionary alloc] init];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"CName"] forKey:@"body"];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"chapter"] forKey:@"id"];
            [prayers_contentList addObject:tempMutableDict2];
            
        }
       
    
    }];
    [tableChapters reloadData];
    prayers_contentTable.backgroundColor = [UIColor clearColor];
    [prayers_contentTable reloadData];
}
/**/
/*- (void)readbookmar
{
    prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
//    NSFileManager *fileManagaer = [NSFileManager defaultManager];
    
    NSArray *dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDir = [dirPaths objectAtIndex:0];
    NSString *filePath = [documentDir stringByAppendingPathComponent:@"oskofiabookMark.db"];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:filePath];
    [queue inDatabase:^(FMDatabase *db) {
        
        FMResultSet *rs2 = [db executeQuery:@"select chapterid,bookmark from book_chapters where bookid=?",selectedbook];
        while ([rs2 next]) {
            
            NSMutableDictionary *tempMutableDict2 = [[NSMutableDictionary alloc] init];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"chapterid"] forKey:@"chapterid"];
            [tempMutableDict2 setObject:[rs2 stringForColumn:@"bookmark"] forKey:@"bookmark"];
            [bookMarkList addObject:tempMutableDict2];
            printf("test");
            
            
        }
    }];
}*/
#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(tableView == tableChapters)
        return [chapters count];
    else
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
    if(tableView == tableChapters)
    {
        static NSString *CellIdentifier = @"Cell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        [[cell textLabel] setText:[NSString stringWithFormat:@"%@",[[chapters objectAtIndex:indexPath.row] objectForKey:@"body"]]];
       
        cell.contentView.backgroundColor = [UIColor whiteColor];
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
    else
    {
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
        
     /*   UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
        test.backgroundColor = [UIColor lightGrayColor];
        [cell addSubview:test];*/
        
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
        cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.layer.borderWidth = 0.3;
        cell.layer.cornerRadius = 0;
        cell.clipsToBounds = true;
        
        if([selectedbook intValue] < 40)
        {
            if([bookIdMark intValue] == [selectedbook intValue])
            {
                if([chapterIdMark intValue] == indexPath.row)
                {
                    cell.textLabel.textColor = [UIColor colorWithRed:1.0/255.0f green:156.0/255.0f blue:186.0/255.0f alpha:1.0];
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
                    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
                    test.backgroundColor = [UIColor colorWithRed:216.0/255.0f green:194.0/255.0f blue:4.0/255.0f alpha:1.0];
                    [cell addSubview:test];
                    
                }
            }
        }
        else
        {
            if([newbookIdMark intValue] == [selectedbook intValue])
            {
                if([newchapterIdMark intValue] == indexPath.row)
                {
                    cell.textLabel.textColor = [UIColor colorWithRed:1.0/255.0f green:156.0/255.0f blue:186.0/255.0f alpha:1.0];
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
                    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
                    test.backgroundColor = [UIColor colorWithRed:216.0/255.0f green:194.0/255.0f blue:4.0/255.0f alpha:1.0];
                    [cell addSubview:test];
                    
                }
            }
        }
        
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if(tableView == tableChapters)
    {
        
    }else{
        cell.textLabel.textColor = [UIColor blackColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.backgroundColor = [UIColor clearColor];
        
        UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
        test.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"cellbg"]];//cellbg
        [cell addSubview:test];
        
        if([selectedbook intValue] < 40)
        {
            if([bookIdMark intValue] == [selectedbook intValue])
            {
                if([chapterIdMark intValue] == indexPath.row)
                {
                    cell.textLabel.textColor = [UIColor colorWithRed:1.0/255.0f green:156.0/255.0f blue:186.0/255.0f alpha:1.0];
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
                    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
                    test.backgroundColor = [UIColor colorWithRed:216.0/255.0f green:194.0/255.0f blue:4.0/255.0f alpha:1.0];
                    [cell addSubview:test];
                }
            }
        }
        else
        {
            if([newbookIdMark intValue] == [selectedbook intValue])
            {
                if([newchapterIdMark intValue] == indexPath.row)
                {
                    cell.textLabel.textColor = [UIColor colorWithRed:1.0/255.0f green:156.0/255.0f blue:186.0/255.0f alpha:1.0];
                    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:20];
                    UILabel *test = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetWidth([[UIScreen mainScreen] bounds]) - 10,0,10,100.0)];
                    test.backgroundColor = [UIColor colorWithRed:216.0/255.0f green:194.0/255.0f blue:4.0/255.0f alpha:1.0];
                    [cell addSubview:test];
                    
                }
            }
        }
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if(tableView == tableChapters)
    {
        prayers_contentList = [[NSMutableArray alloc] initWithObjects:nil];
        
        selectedbook = [[chapters objectAtIndex:indexPath.row] objectForKey:@"id"];
        
        NSString *sqLiteDb = [[NSBundle mainBundle] pathForResource:@"oskofia"
                                                             ofType:@"db"];
        FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:sqLiteDb];
        [queue inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select DISTINCT 'إصحاح' || ' ' || chapter as CName,chapter from verse where book_id=?",[[chapters objectAtIndex:indexPath.row] objectForKey:@"id"]];
            
            while ([rs next]) {
                
                NSMutableDictionary *tempMutableDict = [[NSMutableDictionary alloc] init];
                [tempMutableDict setObject:[rs stringForColumn:@"CName"] forKey:@"body"];
                [tempMutableDict setObject:[rs stringForColumn:@"chapter"] forKey:@"id"];
                [prayers_contentList addObject:tempMutableDict];
                
            }}];
        [btn_Header setTitle:[[chapters objectAtIndex:indexPath.row] objectForKey:@"body"] forState:UIControlStateNormal];

        [prayers_contentTable reloadData];
        [tableChapters setHidden:YES];
    }
    else
    {
        BibleChaptersController.bookid2 = selectedbook;
        //
        BibleChaptersController.pageind = indexPath.row;
        [self showViewController:BibleChaptersController];
        [self performSelector:@selector(pushViewController:) withObject:BibleChaptersController afterDelay:0.5f];
    }
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

- (IBAction)show_chapter_list:(id)sender {
    if(tableChapters.isHidden)
        [tableChapters setHidden:NO];
    else
        [tableChapters setHidden:YES];

}

@end


