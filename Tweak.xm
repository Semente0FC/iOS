#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (NSClassFromString(@"SKPaymentQueue")) {
            NSLog(@"[FakePurchaseTweak] StoreKit detectado. Hooks serão aplicados.");
            %init();
        } else {
            NSLog(@"[FakePurchaseTweak] StoreKit NÃO encontrado. Nenhum hook será aplicado.");
        }
    });
}

%hook SKPaymentTransaction

- (SKPaymentTransactionState)transactionState {
    NSLog(@"[FakePurchaseTweak] Interceptado transactionState - respondendo como 'purchased'");
    return SKPaymentTransactionStatePurchased;
}

%end

%hook SKReceiptRefreshRequest

- (void)start {
    NSLog(@"[FakePurchaseTweak] Interceptado start de SKReceiptRefreshRequest.");
}

%end

%hook SKPaymentQueue

- (void)addPayment:(SKPayment *)payment {
    NSLog(@"[FakePurchaseTweak] Interceptando addPayment para: %@", payment.productIdentifier);

    SKPaymentTransaction *fakeTransaction = [[NSClassFromString(@"SKPaymentTransaction") alloc] init];
    [fakeTransaction setValue:@(SKPaymentTransactionStatePurchased) forKey:@"transactionState"];

    NSArray *transactions = @[fakeTransaction];

    if ([self respondsToSelector:@selector(paymentQueue:updatedTransactions:)]) {
        [self performSelector:@selector(paymentQueue:updatedTransactions:)
                   withObject:self
                   withObject:transactions];
        NSLog(@"[FakePurchaseTweak] Transação fake enviada com sucesso.");
    } else {
        NSLog(@"[FakePurchaseTweak] Falha ao enviar transação fake.");
    }
}

%end
