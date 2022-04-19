#import <UIKit/UIKit.h>
#import "CFWObject.h"

@protocol AgpPrayerChildViewControlleDelegate;

@interface AgpPrayerChildViewControlle : UIViewController <UITableViewDataSource,UITableViewDelegate> {
    IBOutlet UITableView *agpeyaTableView;
}

@property (nonatomic, retain) id <AgpPrayerChildViewControlleDelegate> AgpPrayerChildViewControlleDelegate;
@property (assign, nonatomic) NSInteger pageIndex;
@property (nonatomic, strong) NSMutableDictionary *displayedPrayer;
@property (assign, nonatomic) BOOL showTableView;
@property (assign, nonatomic) int fontSize;

@end

@protocol AgpPrayerChildViewControlleDelegate <NSObject>



@end


