#import "PDJSONClient.h"
#import "KSDeferred.h"


@interface PDJSONClient ()

@property (nonatomic) id<PDRequester> requester;

@end


@implementation PDJSONClient

- (instancetype)initWithRequester:(id<PDRequester>)requester
{
    self = [super init];
    if (self) {
        self.requester = requester;
    }
    return self;
}

#pragma mark - <PDRequester>

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    KSPromise *promise = [self.requester promiseWithRequest:request];
    
    [promise then:^id(NSData *data) {
        NSError *error = nil;
        id jsonObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
        if (jsonObject) {
            [deferred resolveWithValue:jsonObject];
        }
        else {
            [deferred rejectWithError:error];
        }
        return nil;
    } error:^id(NSError *error) {
        [deferred rejectWithError:error];
        return nil;
    }];
    return deferred.promise;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end
