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
    SKPaymentTransaction *fakeTransaction = [%c(SKPaymentTransaction) alloc];
    object_setInstanceVariable(fakeTransaction, "_transactionState", (void *)SKPaymentTransactionStatePurchased);
    [[SKPaymentQueue defaultQueue] finishTransaction:fakeTransaction];
}

%end
