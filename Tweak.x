#import <UIKit/UIKit.h>

%hook STRVWatchSetupCompleteViewController

- (instancetype)initWithAnalyticsStore:(id)arg2 isPremium:(BOOL)arg3 factory:(id)arg4 {
    NSLog(@"[HOOK] STRVWatchSetupCompleteViewController initWithAnalyticsStore:isPremium:factory: called. Force isPremium=YES");
    
    // 调用原方法，强制把 arg3 改为 YES
    return %orig(arg2, YES, arg4);
}

%end
