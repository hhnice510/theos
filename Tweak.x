#import <UIKit/UIKit.h>

%hook UIViewController

- (void)viewDidLoad {
    %orig;
    NSLog(@"[strava] UIViewController viewDidLoad: %@", self);
}

%end
