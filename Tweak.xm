#import <StoreKit/StoreKit.h>
#import <Foundation/Foundation.h>

%ctor {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (NSClassFromString(@"SKPaymentQueue")) {
            NSLog(@"[FakePurchaseTweak] StoreKit detectado. Hooks serão aplicados.");
        } else {
            NSLog(@"[FakePurchaseTweak] StoreKit NÃO encontrado. Nenhum hook será aplicado.");
            return;
        }

        %init();
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
    // Não chama o original pra evitar refresh de recibo real
}

%end

%hook SKPaymentQueue

- (void)addPayment:(SKPayment *)payment {
    NSLog(@"[FakePurchaseTweak] Interceptando addPayment para: %@", payment.productIdentifier);

    // Simular uma transação "comprada"
    SKPaymentTransaction *fakeTransaction = [[NSClassFromString(@"SKPaymentTransaction") alloc] init];
    [fakeTransaction setValue:@(SKPaymentTransactionStatePurchased) forKey:@"transactionState"];

    // Simular queue
    NSArray *transactions = @[fakeTransaction];
    [self performSelector:@selector(paymentQueue:updatedTransactions:)
               withObject:self
               withObject:transactions];

    NSLog(@"[FakePurchaseTweak] Transação fake enviada.");
}

%end
