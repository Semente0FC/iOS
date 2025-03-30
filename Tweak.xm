#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

%hook SKPaymentTransaction

- (SKPaymentTransactionState)transactionState {
    return SKPaymentTransactionStatePurchased;
}

%end

%hook SKReceiptRefreshRequest

- (void)start {
    NSLog(@"[FakePurchaseTweak]: SKReceiptRefreshRequest interceptado.");
}

%end

%hook SKPaymentQueue

- (void)addPayment:(SKPayment *)payment {
    NSLog(@"[FakePurchaseTweak]: Pagamento interceptado para produto: %@", payment.productIdentifier);
    
    SKPaymentTransaction *fakeTransaction = [[SKPaymentTransaction alloc] init];
    [fakeTransaction setValue:@(SKPaymentTransactionStatePurchased) forKey:@"transactionState"];
    
    [[SKPaymentQueue defaultQueue] finishTransaction:fakeTransaction];
}

%end
