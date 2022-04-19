#import "YouTubeViewController.h"

@implementation YouTubeViewController

@synthesize youTubeLink;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"يوتيوب", @"يوتيوب");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated {
    [self setupView];
}

- (void)setupView {
    youTubeWebView.scrollView.scrollEnabled = NO;
    [self loadYouTubeVideo];
}

- (void)loadYouTubeVideo {
    NSArray *stringArray = [youTubeLink componentsSeparatedByString:@"https://www.youtube.com/watch?v="];
    if ([stringArray count] > 1) {
        NSString *youTubeToken = [stringArray objectAtIndex:1];
        youTubeLink = [NSString stringWithFormat:@"https://www.youtube.com/v/%@",youTubeToken];
        NSString *embedHTML;
            embedHTML = @"\
            <html><head>\
            <style type=\"text/css\">\
            body {\
            background-color:black; color:black;}\\</style>\\</head><body style=\"margin:0\">\\<embed webkit-playsinline id=\"yt\" src=\"%@\" type=\"application/x-shockwave-flash\" \\width=\"320\" height=\"568\"></embed>\\</body></html>";
        NSString *html = [NSString stringWithFormat:embedHTML,youTubeLink];
        [youTubeWebView loadHTMLString:html baseURL:nil];
    } else {
        [self performSelector:@selector(dismissYouTubeView:) withObject:nil afterDelay:1.0f];
    }
}

#pragma mark - Dismiss Method

- (IBAction)dismissYouTubeView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


