#import "PDHTTPClient.h"
#import "KSDeferred.h"
#import "PDRequester.h"
#import "KSNetworkClient.h"


@interface PDHTTPClient ()

@property (nonatomic) id<PDRequester> requester;
@property (nonatomic) NSIndexSet *acceptableStatusCodes;
@property (nonatomic, copy) NSString *errorDomain;

@end


NSString *const PDHTTPClientErrorDataKey = @"PDHTTPClientErrorDataKey";


@implementation PDHTTPClient

- (instancetype)initWithRequester:(id<PDRequester>)requester
            acceptableStatusCodes:(NSIndexSet *)acceptableStatusCodes
                      errorDomain:(NSString *)errorDomain
{
    self = [super init];
    if (self) {
        self.requester = requester;
        self.acceptableStatusCodes = acceptableStatusCodes;
        self.errorDomain = errorDomain;
    }
    return self;
}

#pragma mark - <PDRequester>

- (KSPromise *)promiseWithRequest:(NSURLRequest *)request
{
    KSDeferred *deferred = [KSDeferred defer];
    KSPromise *requestPromise = [self.requester promiseWithRequest:request];
    [requestPromise then:^id(KSNetworkResponse *networkResponse) {
        NSData *data = networkResponse.data;
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)networkResponse.response;
        NSInteger statusCode = httpResponse.statusCode;
        if ([self.acceptableStatusCodes containsIndex:statusCode]) {
            [deferred resolveWithValue:data];
        }
        else {
            NSDictionary *userInfo = @{PDHTTPClientErrorDataKey: data};
            NSError *error = [NSError errorWithDomain:self.errorDomain code:statusCode userInfo:userInfo];
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
