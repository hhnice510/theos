
// 引入必要的头文件
#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>

// 声明我们要 hook 的类
@interface EXInAppPurchasesModule
- (void)handlePurchase:(SKPaymentTransaction *)transaction;
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions;
@end

// 使用 %hook 指令来指定要 hook 的类
%hook EXInAppPurchasesModule

// Hook paymentQueue:updatedTransactions: 方法
- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray<SKPaymentTransaction *> *)transactions {
    NSLog(@"[MyAwesomeTweak] Hooked paymentQueue:updatedTransactions:");

    for (SKPaymentTransaction *transaction in transactions) {
        // 我们可以根据 transaction 的状态进行不同的处理
        // transaction.transactionState
        // SKPaymentTransactionStatePurchasing,  // 正在购买
        // SKPaymentTransactionStatePurchased,   // 购买成功
        // SKPaymentTransactionStateFailed,      // 购买失败
        // SKPaymentTransactionStateRestored,    // 恢复购买
        // SKPaymentTransactionStateDeferred     // 交易延迟 (例如需要家长批准)

        if (transaction.transactionState == SKPaymentTransactionStatePurchased || transaction.transactionState == SKPaymentTransactionStateRestored) {
            NSLog(@"[MyAwesomeTweak] Found a purchased or restored transaction. Handling it as a success.");
            
            // 直接调用原始的成功处理逻辑
            // 这里的 self 是 EXInAppPurchasesModule 的实例
            [self handlePurchase:transaction];

            // 注意：原始的 handlePurchase 可能会与苹果服务器验证收据。
            // 如果想完全绕过，可能需要进一步 hook handlePurchase 方法，
            // 或者在这里伪造一个成功的 block 回调。

            // 另一种更激进的方法是，不调用原始的 %orig，
            // 而是自己构造一个成功的回调，直接发给 JS 端。
            // 这需要更深入地分析 -[resolvePromise:value:] 等方法的调用方式。

        } else if (transaction.transactionState == SKPaymentTransactionStateFailed) {
            NSLog(@"[MyAwesomeTweak] Transaction failed. We could potentially turn this into a success.");
            
            // 在这里，我们可以“反转”失败的交易，把它变成一个成功的交易来处理
            // 这是一个高级技巧，需要伪造一个 SKPaymentTransaction 对象或修改其状态，
            // 但更简单的方法是直接调用成功的处理逻辑。
            [self handlePurchase:transaction]; // 尝试将失败的交易也按成功处理

        } else {
            // 对于其他状态，比如 SKPaymentTransactionStatePurchasing，
            // 我们暂时不处理，让原始逻辑继续运行
            %orig(queue, transactions);
        }
    }
}

// 你也可以 hook handlePurchase 方法来进一步控制逻辑
- (void)handlePurchase:(SKPaymentTransaction *)transaction {
    NSLog(@"[MyAwesomeTweak] Hooked handlePurchase for transaction: %@", transaction.transactionIdentifier);

    // 在这里，你可以完全接管购买处理逻辑。
    // 例如，不管三七二十一，直接认为购买成功，并通知 JS 端。
    // 你需要找到 `resolvePromise` 相关的方法并调用它。
    
    // 这是一个示例，实际代码需要根据 EXInAppPurchasesModule 的具体实现来调整
    // 假设 'purchase' promise 存在
    // [self resolvePromise:@"purchase" value:@{@"status": @"success", @"fake": @YES}];

    // 为了安全起见，我们还是可以调用原始逻辑，或者根据需要选择性调用
    %orig(transaction);
}

%end
