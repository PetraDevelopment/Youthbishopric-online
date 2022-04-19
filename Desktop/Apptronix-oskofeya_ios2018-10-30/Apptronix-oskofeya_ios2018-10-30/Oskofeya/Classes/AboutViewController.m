
#import "AboutViewController.h"

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"المزيد", @"المزيد");
    }
    return self;
}

#pragma mark - Initialization Methods

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [[_viewAnbaMousa layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewAnbaMousa layer] setBorderWidth:.4];
    [[_viewAnbaMousa layer] setCornerRadius:8.0f];
    
    [[_viewAnbaRaphaeil layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewAnbaRaphaeil layer] setBorderWidth:.4];
    [[_viewAnbaRaphaeil layer] setCornerRadius:8.0f];
   
    [[_viewYouthBishopric layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewYouthBishopric layer] setBorderWidth:.4];
    [[_viewYouthBishopric layer] setCornerRadius:8.0f];
    
    [[_Keraza layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_Keraza layer] setBorderWidth:.4];
    [[_Keraza layer] setCornerRadius:8.0f];
    
    [[_viewTefoula layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewTefoula layer] setBorderWidth:.4];
    [[_viewTefoula layer] setCornerRadius:8.0f];
    
    [[_viewPrepServants layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewPrepServants layer] setBorderWidth:.4];
    [[_viewPrepServants layer] setCornerRadius:8.0f];
    
    [[_viewSecServants layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewSecServants layer] setBorderWidth:.4];
    [[_viewSecServants layer] setCornerRadius:8.0f];
    
    [[_viewUniServants layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewUniServants layer] setBorderWidth:.4];
    [[_viewUniServants layer] setCornerRadius:8.0f];
  
    [[_viewOnlineYouthBishopric layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewOnlineYouthBishopric layer] setBorderWidth:.4];
    [[_viewOnlineYouthBishopric layer] setCornerRadius:8.0f];

    [[_viewResom layer] setBorderColor:[[UIColor grayColor] CGColor]];
    [[_viewResom layer] setBorderWidth:.4];
    [[_viewResom layer] setCornerRadius:8.0f];
    
}

#pragma mark - Buttons Methods

// انبا موسى
- (IBAction)openAnbaMoussaTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/AnbaMoussa"]];
}

- (IBAction)openAnbaMoussaYouTube:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/anbamoussa"]];
}
// انبا رافائيل
- (IBAction)openBishopRaphaeilFacebook:(id)sender {
    

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/bishop.anbaraphael?fref=ts"]];
}

- (IBAction)openBishopRaphaeilTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/BishopRaphaeil"]];
}
//اسثقية الشباب
- (IBAction)openYouthBishopricFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/pages/Youth-Bishopric/317232255925"]];
}

- (IBAction)openYouthBishopricTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/youthbishopric"]];
}

- (IBAction)openYouthBishopricYouTube:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/youthbishopric"]];
}

- (IBAction)openYouthBishopricWebPage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.youthbishopric.com"]];
}
// online
- (IBAction)onlinefacebook:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/youthbishopriconline/"]];
}

- (IBAction)onlinetwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/YomByom"]];
}
- (IBAction)onlineyoutube:(id)sender {
     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCFq_11RF1PEPqbRHMtFaEjg"]];
}

- (IBAction)onlineWeb:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youthbishopriconline.com/"]];
}



//مهرجان الكرازه
- (IBAction)openKerazaFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/mahraganalkrazaelmorkosya?"]];
}

- (IBAction)openKerazaTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/mahraganalkraza"]];
}

- (IBAction)openKerazaYouTube:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/Mahraganalkraza"]];
}

- (IBAction)openKerazaWebPage:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://www.mahraganalkraza.com/"]];
}
//الرسوم المتحركه

- (IBAction)resomfacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/cartoongraphicYB/"]];
}

- (IBAction)resomyoutube:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.youtube.com/channel/UCUnwxcO2eezjM4qPNuLVy_A?view_as=subscriber"]];
}



- (IBAction)openTefoulaFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/135704353167466/"]];
}

- (IBAction)openPrepServantsFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[[NSString stringWithFormat:@"https://www.facebook.com/lagnate3dadi"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
}

- (IBAction)openSecServantsFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/lagnetsanawy/"]];
}

- (IBAction)openUniServantsFacebook:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://www.facebook.com/groups/356512411096711/"]];
}
- (IBAction)openUniServantsTwitter:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://twitter.com/shababtogether"]];
}

#pragma mark - Dismiss Method

- (IBAction)dismissAboutView:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark -

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end


