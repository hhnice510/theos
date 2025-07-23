#import <UIKit/UIKit.h>

// Hook OIDIDToken to fake expiresAt
%hook OIDIDToken

- (void)setExpiresAt:(NSDate *)date {
    NSLog(@"[HOOK] OIDIDToken::setExpiresAt: original=%@", date);
    NSDate *farFuture = [NSDate dateWithTimeIntervalSince1970:4102444800]; // Year 2099
    %orig(farFuture);
}

%end

// Hook STRVWatchSetupCompleteViewController to force isPremium = YES
%hook STRVWatchSetupCompleteViewController

- (void)setIsPremium:(BOOL)value {
    NSLog(@"[HOOK] STRVWatchSetupCompleteViewController::setIsPremium: original=%d", value);
    %orig(YES);
}

%end

// Hook CheckoutContainerViewModel to force recurring = YEARLY
%hook CheckoutContainerViewModel

- (NSString *)recurring {
    NSLog(@"[HOOK] CheckoutContainerViewModel::recurring called");
    return @"YEARLY";
}

%end

// Optional: Hook sku if needed
%hook BranchContentMetadata

- (NSString *)sku {
    NSLog(@"[HOOK] BranchContentMetadata::sku called");
    return @"com.strava.ios.pricetest.subscription.yearly.control.version.2022.06.08";
}

%end
