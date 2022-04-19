

#import <UIKit/UIKit.h>

@interface SidebarMenuViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//use to provide view controllers to launch when a user taps a menu item name
@property (nonatomic, strong) NSArray *menuItemViewControllers;

//use to declare user-friendly sidebar menu items (independent of ViewController titles)
@property (nonatomic, strong) NSArray *menuItemNames;

//use to declare the name of the image for the sidebar button (for toggling the sidebar opened/closed)
@property (nonatomic, copy) NSString *sideBarButtonImageName;

//the container controller (which is a UINavigationController)
@property (nonatomic, strong) UINavigationController *containerController;

//for presenting the sidebar menu items in a scrollable list (i.e. tableview)
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/*!
 * @description For managing user selection of SidebarMenut Items (which launch and/or remove other view controllers).
 * @param index The index for the target ViewController to launch.
 * @return void
 */
- (void)addTargetViewControllerForIndex:(NSUInteger)index;

/*!
 * @description For removing the ViewController that is in the main content area (i.e. its view hierarchy is currently visible).
 * @return void
 */
- (void)removeTargetViewController;

/*!
 * @description For styling the container view controller.
 * @param viewController The target ViewController that will be styled with a shadow.
 * @return void
 */
- (void)addShadowToViewController:(UIViewController *)viewController;

/*!
 * @description For adding a sidebar button as the left bar button item of the navigation bar.
 * @param viewController The target ViewController that the sidebar button will be added to.
 * return void
 */
- (void)addSidebarButtonForViewController:(UIViewController *)viewController;

/*!
 * @descriptoin For toggling the targetViewController open/closed to shop/hide the sidebar menu.
 * @param obj The object invoking this action (i.e. button)
 * @return void
 */
- (void)toggleSidebar:(id)obj;

@end
