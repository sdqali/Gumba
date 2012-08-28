#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UIPopoverControllerDelegate, UISearchBarDelegate>
@property (nonatomic,strong) NSMutableArray *quadrantViews;
@property (nonatomic,strong) NSString *searchTerm;
@property (nonatomic,strong) UIBarButtonItem *selectedButton;
@property (nonatomic,strong) UIColor *barButtonColor;
-(IBAction) adopt:(UIBarButtonItem *)barButtonItem;
-(IBAction) trial:(UIBarButtonItem *)barButtonItem;
-(IBAction) assess:(UIBarButtonItem *)barButtonItem;
-(IBAction) hold:(UIBarButtonItem *)barButtonItem;
-(IBAction) all:(UIBarButtonItem *)barButtonItem;
@end