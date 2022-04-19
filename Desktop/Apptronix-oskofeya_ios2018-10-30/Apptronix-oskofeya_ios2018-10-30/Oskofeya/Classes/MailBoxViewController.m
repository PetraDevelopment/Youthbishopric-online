#import "MailBoxViewController.h"

#define ROW_HEIGHT 50

@implementation MailBoxViewController

@synthesize mailBoxMessages;
@synthesize shouldHideActivityIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"صندوق الوارد", @"صندوق الوارد");
    }
    mailBoxMessages = [[NSMutableOrderedSet alloc] initWithObjects:nil];
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[btn_send layer] setBorderColor:[[UIColor lightGrayColor] CGColor]];
    [[btn_send layer] setBorderWidth:.4];
    [[btn_send layer] setCornerRadius:8.0f];
    // Initialize msgViewController
    msgViewController = [[MsgViewController alloc] initWithNibName:@"MsgView_i5" bundle:nil];
    [msgViewController setMsgViewDelegate:self];
    // Initialize ektebLanaViewController
    ektebLanaViewController = [[EktebLanaViewController alloc] initWithNibName:@"EktebLanaView_i5" bundle:nil];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateView];
}

- (void)setupView {
    // Set the mailBoxTableView
    mailBoxTableView.backgroundColor = [UIColor clearColor];
    mailBoxTableView.separatorColor = [UIColor colorWithRed:0.9137 green:0.808 blue:0.604 alpha:1]; // Light Orange
}

- (void)updateView {
    if (shouldHideActivityIndicator) {
        [self hideActivityIndicator];
    } else {
        [self showActivityIndicatorWithMessage:@"جاري التحـمـيل"];
        if ([mailBoxMessages count] == 0) {
            [self showActivityIndicatorWithMessage:@"برجاء التأكد من الاتصال بالانترنت"];
            [self performSelector:@selector(hideActivityIndicator) withObject:nil afterDelay:10.0f];
        }
    }
    [mailBoxTableView reloadData];
}

#pragma mark - tableView Methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [mailBoxMessages count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if ([[[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"visibility"] isEqualToString: @"hidden"]) {
        [cell setHidden:YES];
        return 0;
    } else {
        return ROW_HEIGHT;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
    cell.textLabel.textAlignment = NSTextAlignmentRight;
    cell.textLabel.numberOfLines = 0;
    [[cell textLabel] setText:[[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"title"]];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    if (![[[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"visibility"] isEqualToString: @"hidden"]) {
        if ([[[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"status"] isEqualToString: @"unread"]) {
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:17];
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
            [[cell imageView] setImage:[UIImage imageNamed:@"close_msg"]];
        } else {
            cell.textLabel.font = [UIFont fontWithName:@"Helvetica" size:17];
            cell.detailTextLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
            [[cell imageView] setImage:[UIImage imageNamed:@"open_msg"]];
        }
        [[cell detailTextLabel] setText:[[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"date"]];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    cell.layer.borderColor = [UIColor lightGrayColor].CGColor;
    cell.layer.borderWidth = 1.2;
    cell.layer.cornerRadius = 10;
    cell.clipsToBounds = true;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSMutableDictionary *tempMutableDict = [[mailBoxMessages objectAtIndex:indexPath.row] mutableCopy];
    [tempMutableDict setObject:@"read" forKey:@"status"];
    [mailBoxMessages setObject:tempMutableDict atIndex:indexPath.row];
    [self saveMailBoxMessagesInUserDefaults];
    [mailBoxTableView reloadData];
    msgViewController.msgIndexPathRow = indexPath.row;
    msgViewController.msgTitleStr = [[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"title"];
    msgViewController.msgSubjectStr = [[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"body"];
    msgViewController.msgMedia = [[mailBoxMessages objectAtIndex:indexPath.row] objectForKey:@"photo"];
    [self showViewController:msgViewController];
    [self performSelector:@selector(pushViewController:) withObject:msgViewController afterDelay:0.5f];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSMutableDictionary *tempMutableDict = [[mailBoxMessages objectAtIndex:indexPath.row] mutableCopy];
        [tempMutableDict setObject:@"hidden" forKey:@"visibility"];
        [mailBoxMessages setObject:tempMutableDict atIndex:indexPath.row];
        [self saveMailBoxMessagesInUserDefaults];
    }
    [tableView reloadData];
}

#pragma mark - Save MailBoxMessages Method

- (void)saveMailBoxMessagesInUserDefaults {
    // Save updated mailBoxMessages
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *mailBoxMessagesArray = [mailBoxMessages array];
    NSMutableArray *mailBoxMessagesMutableArray = [mailBoxMessagesArray mutableCopy];
    [defaults setObject:mailBoxMessagesMutableArray forKey:@"mailBoxMessages"];
    [defaults synchronize];}

#pragma mark - MsgViewDelegate Method

- (void)msgViewController:(MsgViewController *)msgViewController deleteMsgWithIndexPathRow:(int)indexPathRow {
    NSMutableDictionary *tempMutableDict = [[mailBoxMessages objectAtIndex:indexPathRow] mutableCopy];
    [tempMutableDict setObject:@"hidden" forKey:@"visibility"];
    [mailBoxMessages setObject:tempMutableDict atIndex:indexPathRow];
    [self saveMailBoxMessagesInUserDefaults];
}

#pragma mark - Buttons Methods

- (IBAction)refreshMailBoxMessages:(id)sender {
    [self showActivityIndicatorWithMessage:@"جاري تحديث الرسائل"];
    [self.mailBoxViewDelegate mailBoxViewController:self];
}

- (IBAction)loadEktebLanaView:(id)sender {
    [self showViewController:ektebLanaViewController];
    [self performSelector:@selector(pushViewController:) withObject:ektebLanaViewController afterDelay:0.5f];
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

#pragma mark - Activity Indicator Methods

- (void)showActivityIndicatorWithMessage:(NSString *)message {
    // Display Message
    aiView.hidden = NO;
    [aiMsg setFrame:CGRectMake(0, 180, 320, 160)];
    [aiMsg setText:message];
    aiMsg.font = [UIFont fontWithName:@"Noteworthy-Bold" size:20];
    aiMsg.lineBreakMode = NSLineBreakByWordWrapping;
    aiMsg.numberOfLines = 4;
}

- (void)hideActivityIndicator {
    [aiMsg setText:@""];
    aiView.hidden = YES;
}

#pragma mark - Dismiss Methods

- (IBAction)dismissMailBoxView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


