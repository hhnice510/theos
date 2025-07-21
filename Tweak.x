#import <Foundation/Foundation.h>

%hook NSURLSession

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                           completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {

    NSURL *url = [request URL];
    NSString *urlStr = [url absoluteString];

    if ([urlStr containsString:@"https://api2.mubu.com/v3/api/user/current_user"]) {

        NSLog(@"[MubuTweak] Matched URL: %@", urlStr);

        void (^newCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {
            if (data) {
                NSError *jsonError;
                NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (!jsonError && [obj isKindOfClass:[NSDictionary class]]) {

                    NSMutableDictionary *vipInfo = [@{
                        @"level": @(2),
                        @"vipEndDate": @"2999-01-01"
                    } mutableCopy];

                    NSMutableDictionary *dataField = [obj[@"data"] mutableCopy];
                    if (dataField) {
                        for (NSString *key in vipInfo) {
                            dataField[key] = vipInfo[key];
                        }
                        obj[@"data"] = dataField;

                        NSData *newData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
                        completionHandler(newData, response, error);
                        return;
                    }
                }
            }
            // 如果失败就走原始
            completionHandler(data, response, error);
        };

        return %orig(request, newCompletionHandler);
    }

    return %orig(request, completionHandler);
}

%end