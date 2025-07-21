#import <UIKit/UIKit.h>

%hook NSURLSession

// Hook 所有 dataTaskWithRequest:completionHandler:
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData * _Nullable, NSURLResponse * _Nullable, NSError * _Nullable))completionHandler {

    NSURL *url = [request URL];
    NSString *urlStr = [url absoluteString];

    if ([urlStr containsString:@"https://app-api.yangjibao.com/account"]) {
        // 包装原始回调
        void (^newCompletionHandler)(NSData *, NSURLResponse *, NSError *) = ^(NSData *data, NSURLResponse *response, NSError *error) {

            if (data) {
                NSError *jsonError;
                NSMutableDictionary *obj = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&jsonError];
                if (!jsonError && [obj isKindOfClass:[NSDictionary class]]) {
                    NSMutableDictionary *dataField = [obj[@"data"] mutableCopy];
                    if (dataField) {
                        dataField[@"vip_label"] = @(YES);
                        dataField[@"is_pay"] = @(YES);
                        dataField[@"vip_expiry_date"] = @"2099-04-07";
                        dataField[@"open_free_vip_sign"] = @(YES);
                        //dataField[@"has_fund_hold"] = @(YES);
                        //dataField[@"has_fund_option"] = @(YES);
                        //dataField[@"has_stock_hold"] = @(YES);
                        //dataField[@"has_stock_option"] = @(YES);
                        dataField[@"is_visitor"] = @(YES);
                        dataField[@"show_bkxh"] = @(YES);

                        obj[@"data"] = dataField;

                        NSData *newData = [NSJSONSerialization dataWithJSONObject:obj options:0 error:nil];
                        completionHandler(newData, response, error);
                        return;
                    }
                }
            }
            // 如果解析失败，走原始
            completionHandler(data, response, error);
        };

        return %orig(request, newCompletionHandler);
    }

    // 不匹配，走原始
    return %orig(request, completionHandler);
}

%end
