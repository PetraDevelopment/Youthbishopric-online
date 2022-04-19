#import "BibleChildViewController.h"

@implementation BibleChildViewController

@synthesize pageIndex;
@synthesize displayedPrayer;
@synthesize fontSize;
@synthesize bookid;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"AgpChild View", @"AgpChild View");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];

}

- (void)onLongPress:(UILongPressGestureRecognizer*) pGesture
{
    if (pGesture.state == UIGestureRecognizerStateBegan)
    {
        UITableViewCell *cell = (UITableViewCell *)[pGesture view];
        NSIndexPath *indexPath = [agpeyaTableView indexPathForCell:cell];
        NSString *s = [NSString stringWithFormat: @"%1d",indexPath.row + 1];
        CGRect rectOfCellInTableView = [agpeyaTableView rectForRowAtIndexPath: indexPath];
        CGRect rectOfCellInSuperview = [agpeyaTableView convertRect: rectOfCellInTableView toView: agpeyaTableView.superview];
        NSString *docsDir;
        NSArray *dirPaths;
        dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        docsDir = [dirPaths objectAtIndex:0];
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
        const char *dbpath = [databasePath UTF8String];
        sqlite3_stmt    *statement2;
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *querySQL2 = [NSString stringWithFormat: @"SELECT vc_comment FROM verse_comment WHERE vc_comment!='null' and vc_comment!='' and vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%@\" ", bookid, pageIndex + 1, s];
            
            const char *query_stmt2 = [querySQL2 UTF8String];
            if (sqlite3_prepare_v2(contactDB, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
            {
                if(sqlite3_step(statement2) == SQLITE_ROW)
                {
                    NSString *Comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2,0)];
                    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, rectOfCellInSuperview.origin.y - 40,self.view.bounds.size.width - 40,50)];
                    [btn setTitle:Comment forState:UIControlStateNormal];
                    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica" size:15];
                    btn.userInteractionEnabled = true;
                    btn.backgroundColor = [UIColor whiteColor];
                    [btn setTitleColor: [UIColor blackColor] forState:UIControlStateNormal];

                    [[btn layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
                    [[btn layer] setBorderWidth:.4];
                    [[btn layer] setCornerRadius:8.0f];
                    btn.titleLabel.adjustsFontSizeToFitWidth = YES;
                    btn.titleLabel.numberOfLines = 0;
                    btn.titleLabel.lineBreakMode = UILineBreakModeWordWrap;
                    [btn addTarget:self action:@selector(buttonPressed:)
                     forControlEvents:UIControlEventTouchUpInside];
                    [agpeyaTableView addSubview:btn];

                }
                sqlite3_finalize(statement2);
            }
            sqlite3_close(contactDB);
        }
    }
}

- (void)buttonPressed:(UIButton *)button {
    button.hidden = true;
}
- (void)viewWillAppear:(BOOL)animated {
    [self updateView];
}

- (void)setupView {
    // Set the agpeyaTableView
    agpeyaTableView.backgroundColor = [UIColor clearColor];
    agpeyaTableView.separatorColor = [UIColor clearColor];
    //  agpeyaTableView.allowsSelection = NO;
}

- (void)updateView {
    testArray = [[displayedPrayer objectForKey:@"body"] componentsSeparatedByString:@";;"];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection: 0];
    [agpeyaTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [agpeyaTableView reloadData];
    // [self.BibleChildViewControllerDelegate agpChildViewControllerResetViewModification:self];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    CGRect sectionHeaderRect = CGRectMake(20, 0, 100, 0);
    UILabel *sectionHeader = [[UILabel alloc] initWithFrame:sectionHeaderRect];
    sectionHeader.text = [displayedPrayer objectForKey:@"title"];
    sectionHeader.font = [UIFont fontWithName:@"Helvetica-Bold" size:(fontSize + 3)];
    sectionHeader.adjustsFontSizeToFitWidth = YES;
    sectionHeader.textColor = [UIColor darkTextColor];
    sectionHeader.textAlignment = NSTextAlignmentRight;
    sectionHeader.numberOfLines = 0;
    [sectionHeader setBackgroundColor:[UIColor colorWithRed:241.0/255.0f green:240.0/255.0f blue:241.0/255.0f alpha:1.0]];
    return sectionHeader;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if(testArray.count > 0)
    {
        return testArray.count - 1;
    }
    else
    {
        return  1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    
    cell.textLabel.numberOfLines = 0;
    cell.textLabel.textColor = [UIColor blackColor];
    
    cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    if(testArray.count > indexPath.row)
    {
        cell.textLabel.text =  [[testArray objectAtIndex: indexPath.row] stringByReplacingOccurrencesOfString:@"," withString:@""]  ;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.backgroundColor = [UIColor clearColor];
    UIImageView *imv = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.bounds.size.width - 80,20,10,10)];////[[UIImageView alloc]initWithFrame:CGRectMake(2,self.view.bounds.size.width - 5,15,20)]
    imv.image= nil;
    imv.image=[UIImage imageNamed:@"empty"];
    imv.alpha = 0;
    imv.tag = 150;
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement;
    sqlite3_stmt    *statement2;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL = [NSString stringWithFormat: @"SELECT vc_color FROM verse_comment WHERE vc_color!='null' and vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\" ", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                NSString *color = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement,0)];
                if([color isEqualToString: @"Red"])
                {
                   
                    
                    //255,128,128
                    //cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:125.0/255.0f blue:128.0/255.0f alpha:1.0];// [UIColor redColor];
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0f green:125.0/255.0f blue:128.0/255.0f alpha:1.0] range:highLightAt];
                    cell.textLabel.attributedText = string;
                }
                else if([color isEqualToString: @"Yellow"])
                {
                   // cell.backgroundColor = [UIColor yellowColor];
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:highLightAt];
                    cell.textLabel.attributedText = string;
                }
                else if([color isEqualToString: @"Green"])
                {
                    //cell.backgroundColor = [UIColor colorWithRed:133.0/255.0f green:224.0/255.0f blue:133.0/255.0f alpha:1.0]; //[UIColor greenColor];
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0f green:224.0/255.0f blue:133.0/255.0f alpha:1.0] range:highLightAt];
                    cell.textLabel.attributedText = string;
                }
                else if([color isEqualToString: @"Blue"])
                {
                    //0099FF
                    //cell.backgroundColor = [UIColor colorWithRed:00.0/255.0f green:191.0/255.0f blue:255.0/255.0f alpha:1.0]; //[UIColor greenColor];
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:00.0/255.0f green:191.0/255.0f blue:255.0/255.0f alpha:1.0] range:highLightAt];
                    cell.textLabel.attributedText = string;
                }
                else if([color isEqualToString: @"Orange"])
                {
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0f green:160.0/255.0f blue:122.0/255.0f alpha:1.0] range:highLightAt];
                    cell.textLabel.attributedText = string;
                    ///cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:160.0/255.0f blue:122.0/255.0f alpha:1.0]; //[UIColor greenColor];
                }
                else if([color isEqualToString: @"Clear"])
                {
                    //cell.backgroundColor = [UIColor clearColor];
                    NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);
                    NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
                    [string addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:highLightAt];
                    cell.textLabel.attributedText = string;
                }
            }
            sqlite3_finalize(statement);
        }
        
        NSString *querySQL2 = [NSString stringWithFormat: @"SELECT vc_comment FROM verse_comment WHERE vc_comment!='null' and vc_comment!='' and vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\" ", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement2) == SQLITE_ROW)
            {
                NSString *Comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2,0)];
                imv.image=[UIImage imageNamed:@"pen2"];
                
                
            }
            sqlite3_finalize(statement2);
        }
        
        
        sqlite3_close(contactDB);
    }
    UILongPressGestureRecognizer* longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onLongPress:)];
    [cell addGestureRecognizer:longPressRecognizer];
    
    [cell addSubview:imv];
    return cell;
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *imv;
    if ([cell viewWithTag:150])
    {
        imv = (UIImageView*)[cell viewWithTag:150];
    }
    imv.image = nil;
    imv.image=[UIImage imageNamed:@"empty"];
    imv.alpha = 0;
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
    const char *dbpath = [databasePath UTF8String];
    sqlite3_stmt    *statement2;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL2 = [NSString stringWithFormat: @"SELECT vc_comment FROM verse_comment WHERE vc_comment!='null' and vc_comment!='' and vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\" ", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement2) == SQLITE_ROW)
            {
                NSString *Comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2,0)];
                imv.image=[UIImage imageNamed:@"pen2"];
                imv.alpha = 1;
            }
            sqlite3_finalize(statement2);
        }
        sqlite3_close(contactDB);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIAlertController * alert= [UIAlertController alertControllerWithTitle:@"" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* select = [UIAlertAction actionWithTitle:@"تظليل / إلغاء التظليل" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){[self selectverse : indexPath];}];
    UIAlertAction* cancel = [UIAlertAction actionWithTitle:@"تعليق" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        [self writecomment : indexPath];
    }];
    UIAlertAction* share = [UIAlertAction actionWithTitle:@"مشاركة" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action){
        UITableViewCell *cell = [agpeyaTableView cellForRowAtIndexPath: indexPath];
        NSString *str = [NSString stringWithFormat : @"%@%@",cell.textLabel.text , @"\n\nتطبيق أسقفية الشباب أونلاين\nللأندرويد:https://goo.gl/tgnvEs\nللاّيفون: https://goo.gl/jvl0Xp"];
        NSArray* sharedObjects=[NSArray arrayWithObjects:str,  nil];
        UIActivityViewController *activityViewController = [[UIActivityViewController alloc]                                                                initWithActivityItems:sharedObjects applicationActivities:nil];
        activityViewController.popoverPresentationController.sourceView = self.view;
        [self presentViewController:activityViewController animated:YES completion:nil];
        
    }];
    UIAlertAction* copy = [UIAlertAction  actionWithTitle:@"نسخ" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * action){
        UITableViewCell *cell = [agpeyaTableView cellForRowAtIndexPath: indexPath];
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = cell.textLabel.text ;
    }];
    UIAlertAction*  close = [UIAlertAction  actionWithTitle:@"إغلاق" style:UIAlertActionStyleDefault   handler:^(UIAlertAction * action){
        
    }];
    [alert addAction:select];
    [alert addAction:cancel];
    [alert addAction:share];
    [alert addAction:copy];
    [alert addAction:close];
    [self presentViewController:alert animated:YES completion:nil];
}


-(void)customAlertTitle:(NSString*)title message:(NSString*)message{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:nil delegate:nil cancelButtonTitle:@"NO" otherButtonTitles:@"YES", nil];
    UIView *subView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 80)];
    
    UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 270, 50)];
    titleLabel.text = title;
    titleLabel.font = [UIFont boldSystemFontOfSize:20];
    titleLabel.numberOfLines = 2;
    titleLabel.textColor = [UIColor redColor];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [subView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 30, 270, 50)];
    messageLabel.text = message;
    messageLabel.font = [UIFont systemFontOfSize:18];
    messageLabel.numberOfLines = 2;
    messageLabel.textColor = [UIColor redColor];
    messageLabel.textAlignment = NSTextAlignmentCenter;
    
    [subView addSubview:messageLabel];
    
    [alertView setValue:subView forKey:@"accessoryView"];
    [alertView show];
}
NSIndexPath *colorindexPath;
UIAlertController * alertcolor;
- (void) selectverse: (NSIndexPath*) indexPath
{
     alertcolor =   [UIAlertController alertControllerWithTitle:@"تظليل" message:@"\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];

    
    UIButton *red1 = [[UIButton alloc] initWithFrame:CGRectMake(10,80,40,40)];
    [red1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:125.0/255.0f blue:128.0/255.0f alpha:1.0]];
    [red1 addTarget:self action:@selector(saveRed) forControlEvents:UIControlEventTouchUpInside];
    red1.showsTouchWhenHighlighted = YES;
    red1.layer.cornerRadius = 20;
    [alertcolor.view addSubview:red1];
    
    UIButton *green1 = [[UIButton alloc] initWithFrame:CGRectMake(60,80,40,40)];
    [green1 setBackgroundColor:[UIColor colorWithRed:133.0/255.0f green:224.0/255.0f blue:133.0/255.0f alpha:1.0]];
    colorindexPath = indexPath;
    [green1 addTarget:self action:@selector(saveGreen) forControlEvents:UIControlEventTouchUpInside];
    green1.showsTouchWhenHighlighted = YES;
    green1.layer.cornerRadius = 20;
    [alertcolor.view addSubview:green1];
    //yellow
    
    UIButton *yellow1 = [[UIButton alloc] initWithFrame:CGRectMake(110,80,40,40)];
    [yellow1 setBackgroundColor:[UIColor yellowColor]];
    [yellow1 addTarget:self action:@selector(saveYellow) forControlEvents:UIControlEventTouchUpInside];
    yellow1.showsTouchWhenHighlighted = YES;
    yellow1.layer.cornerRadius = 20;
    [alertcolor.view addSubview:yellow1];
    
  //blue
    UIButton *blue1 = [[UIButton alloc] initWithFrame:CGRectMake(160,80,40,40)];
    [blue1 setBackgroundColor:[UIColor colorWithRed:00.0/255.0f green:191.0/255.0f blue:255.0/255.0f alpha:1.0]];
     [blue1 addTarget:self action:@selector(saveBlue) forControlEvents:UIControlEventTouchUpInside];
    blue1.showsTouchWhenHighlighted = YES;
    blue1.layer.cornerRadius = 20;
    [alertcolor.view addSubview:blue1];

    
    UIButton *orange1 = [[UIButton alloc] initWithFrame:CGRectMake(210,80,40,40)];
    [orange1 setBackgroundColor:[UIColor colorWithRed:255.0/255.0f green:160.0/255.0f blue:122.0/255.0f alpha:1.0]];
     [orange1 addTarget:self action:@selector(saveOrange) forControlEvents:UIControlEventTouchUpInside];
    orange1.showsTouchWhenHighlighted = YES;
    orange1.layer.cornerRadius = 20;
    
    [alertcolor.view addSubview:orange1];
    UIAlertAction* Clear = [UIAlertAction actionWithTitle:@"إلغاء التظليل" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
        [agpeyaTableView deselectRowAtIndexPath:indexPath animated:false];
        UITableViewCell *cell = [agpeyaTableView cellForRowAtIndexPath: indexPath];
        cell.backgroundColor = [UIColor clearColor];
        [self saveColor :indexPath,@"Clear"];
    }];
    [alertcolor addAction:Clear];
    [self presentViewController:alertcolor animated:YES completion:nil];
}

- (void) saveRed
{
    [self saveColor :colorindexPath,@"Red"];
}

- (void) saveGreen
{
    [self saveColor :colorindexPath,@"Green"];
}

- (void) saveBlue
{
    [self saveColor :colorindexPath,@"Blue"];
}

- (void) saveYellow
{
    [self saveColor :colorindexPath,@"Yellow"];
}

- (void) saveOrange
{
    [self saveColor :colorindexPath,@"Orange"];
}

- (void) writecomment: (NSIndexPath*) indexPath
{
    UIAlertController * alert=   [UIAlertController alertControllerWithTitle:@"اكتب تعليق"
                                                                     message:@"\n\n\n\n\n\n\n\n" preferredStyle:UIAlertControllerStyleAlert];
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectZero];
    textView.translatesAutoresizingMaskIntoConstraints = NO;
    textView.tag = 250;
    textView.textAlignment = NSTextAlignmentRight;
    textView.layer.cornerRadius = 5.0;
    textView.clipsToBounds = YES;
    [[textView layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[textView layer] setBorderWidth:.4];
    textView.delegate = self;
    NSLayoutConstraint *leadConstraint = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeLeading multiplier:1.0 constant:-8.0];
    NSLayoutConstraint *trailConstraint = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTrailing multiplier:1.0 constant:8.0];
    NSLayoutConstraint *topConstraint = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeTop multiplier:1.0 constant:-64.0];
    NSLayoutConstraint *bottomConstraint = [NSLayoutConstraint constraintWithItem:alert.view attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:textView attribute:NSLayoutAttributeBottom multiplier:1.0 constant:64.0];
    [alert.view addSubview:textView];
    [NSLayoutConstraint activateConstraints:@[leadConstraint, trailConstraint, topConstraint, bottomConstraint]];
    
    
    NSString *docsDir;
    NSArray *dirPaths;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    docsDir = [dirPaths objectAtIndex:0];
    NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
    const char *dbpath = [databasePath UTF8String];
    
    sqlite3_stmt    *statement2;
    if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
    {
        NSString *querySQL2 = [NSString stringWithFormat: @"SELECT vc_comment FROM verse_comment WHERE vc_comment!='null' and vc_comment!='' and vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\" ", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt2 = [querySQL2 UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt2, -1, &statement2, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement2) == SQLITE_ROW)
            {
                NSString *Comment = [[NSString alloc] initWithUTF8String:(const char *) sqlite3_column_text(statement2,0)];
                
                textView.text = Comment;
            }
            sqlite3_finalize(statement2);
        }
        sqlite3_close(contactDB);
    }
    
    
    UIAlertAction* save = [UIAlertAction  actionWithTitle:@"حفظ" style:UIAlertActionStyleCancel   handler:^(UIAlertAction * action){
        NSArray * textfields = alert.textFields;
        // UITextField * commentfield = textfields[0];
        if(textView.text.length != 0)
        {
            [self saveComment :indexPath,textView.text];
            [agpeyaTableView deselectRowAtIndexPath:indexPath animated:false];
            UITableViewCell *cell = [agpeyaTableView cellForRowAtIndexPath: indexPath];
            UIImageView *imv;
            if ([cell viewWithTag:150])
            {
                imv = (UIImageView*)[cell viewWithTag:150];
            }
            imv.image=[UIImage imageNamed:@"pen2"];
            imv.alpha = 1;
        }
        
    }];
    [alert addAction:save];
    [self presentViewController:alert animated:YES completion:nil];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

- (void) saveComment: (NSIndexPath*) indexPath,NSString* comment
{
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
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT vc_comment,vc_color FROM verse_comment WHERE vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\"", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                rowsExists = @"1";
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    if([rowsExists  isEqual: @"1"])
    {
        sqlite3_stmt    *statement;
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat: @"update verse_comment set vc_comment=\"%@\"  where vc_book_id=\"%@\" and vc_chapter_id = \"%ld\" and vc_verse_id=\"%d\" ", comment,bookid, pageIndex + 1, indexPath.row + 1];
            
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"update");
            }
            else
            {
                NSLog(@"Failed to add contact");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
        }
    }
    else
    {
        sqlite3_stmt    *statement;
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO verse_comment (vc_book_id, vc_chapter_id ,vc_verse_id,vc_comment) VALUES (\"%@\", \"%ld\", \"%d\", \"%@\")", bookid, pageIndex + 1, indexPath.row + 1,comment];
            
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"save");
            }
            else
            {
                NSLog(@"Failed to add contact");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
        }
    }
}


- (void) saveColor: (NSIndexPath*) indexPath,NSString* color
{
     [agpeyaTableView deselectRowAtIndexPath:indexPath animated:false];
    UITableViewCell *cell = [agpeyaTableView cellForRowAtIndexPath: indexPath];
    if([color isEqualToString:@"Red"])
    {
        NSInteger *i = 0;
        
        
        /*if ([cell.textLabel.text rangeOfString:@"\n\n"].location == NSNotFound) {
            i = 0;
            
        }else{
            NSLog(@"string contain \n\n");
            NSArray *brokenByLines=[cell.textLabel.text componentsSeparatedByString:@"\n\n"];
            NSLog(@"%@", brokenByLines.count);
            NSString *x = [brokenByLines objectAtIndex: 0];
            i = x.length + 2;
        }*/
         NSRange highLightAt = NSMakeRange(i,cell.textLabel.text.length - 1);
      //  NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0f green:125.0/255.0f blue:128.0/255.0f alpha:1.0] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
    else if([color isEqualToString:@"Green"])
    {
        //cell.backgroundColor = [UIColor colorWithRed:133.0/255.0f green:224.0/255.0f blue:133.0/255.0f alpha:1.0];
        NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:133.0/255.0f green:224.0/255.0f blue:133.0/255.0f alpha:1.0] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
    else if([color isEqualToString:@"Blue"])
    {
       // cell.backgroundColor = [UIColor colorWithRed:00.0/255.0f green:191.0/255.0f blue:255.0/255.0f alpha:1.0];
        NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value: [UIColor colorWithRed:00.0/255.0f green:191.0/255.0f blue:255.0/255.0f alpha:1.0] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
    else if([color isEqualToString:@"Yellow"])
    {
       // cell.backgroundColor = [UIColor yellowColor];
        NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor yellowColor] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
    else if([color isEqualToString:@"Orange"])
    {
       /* cell.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:160.0/255.0f blue:122.0/255.0f alpha:1.0];*/
        NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor colorWithRed:255.0/255.0f green:160.0/255.0f blue:122.0/255.0f alpha:1.0] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
    else{
      //  cell.backgroundColor = [UIColor clearColor];
        NSRange highLightAt = NSMakeRange(0,cell.textLabel.text.length - 1);  //based on the text in
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:cell.textLabel.text];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor clearColor] range:highLightAt];
        cell.textLabel.attributedText = string;
    }
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
        
        NSString *querySQL = [NSString stringWithFormat: @"SELECT vc_comment,vc_color FROM verse_comment WHERE vc_book_id=\"%@\" and vc_chapter_id=\"%ld\" and vc_verse_id=\"%ld\"", bookid, pageIndex + 1, indexPath.row + 1];
        
        const char *query_stmt = [querySQL UTF8String];
        if (sqlite3_prepare_v2(contactDB, query_stmt, -1, &statement, NULL) == SQLITE_OK)
        {
            if(sqlite3_step(statement) == SQLITE_ROW)
            {
                rowsExists = @"1";
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(contactDB);
    }
    
    if([rowsExists  isEqual: @"1"])
    {
        sqlite3_stmt    *statement;
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat: @"update verse_comment set vc_color=\"%@\"  where vc_book_id=\"%@\" and vc_chapter_id = \"%ld\" and vc_verse_id=\"%ld\" ", color,bookid, pageIndex + 1, indexPath.row + 1];
            
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"update");
            }
            else
            {
                NSLog(@"Failed to add contact");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
        }
    }
    else
    {
        sqlite3_stmt    *statement;
        NSString *databasePath = [[NSString alloc] initWithString: [docsDir stringByAppendingPathComponent: @"oskofiacomment.db"]];
        const char *dbpath = [databasePath UTF8String];
        
        if (sqlite3_open(dbpath, &contactDB) == SQLITE_OK)
        {
            
            NSString *insertSQL = [NSString stringWithFormat: @"INSERT INTO verse_comment (vc_book_id, vc_chapter_id ,vc_verse_id,vc_color) VALUES (\"%@\", \"%ld\", \"%ld\", \"%@\")", bookid, pageIndex + 1, indexPath.row + 1,color];
            
            const char *insert_stmt = [insertSQL UTF8String];
            
            sqlite3_prepare_v2(contactDB, insert_stmt, -1, &statement, NULL);
            if (sqlite3_step(statement) == SQLITE_DONE)
            {
                NSLog(@"save");
            }
            else
            {
                NSLog(@"Failed to add contact");
            }
            
            sqlite3_finalize(statement);
            sqlite3_close(contactDB);
        }
    }
    [alertcolor dismissViewControllerAnimated:YES completion:nil];

}

@end


