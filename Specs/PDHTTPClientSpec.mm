#import "CDRSpecHelper.h"
#import "PDHTTPClient.h"
#import "KSDeferred.h"
#import "KSNetworkClient.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDHTTPClientSpec)

describe(@"PDHTTPClient", ^{
    __block PDHTTPClient *subject;
    __block id<PDRequester> requester;

    beforeEach(^{
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:123];
        requester = nice_fake_for(@protocol(PDRequester));
        subject = [[PDHTTPClient alloc] initWithRequester:requester
                                    acceptableStatusCodes:indexSet
                                              errorDomain:@"my.special.domain"];
    });
    
    describe(@"as a requester", ^{
        __block NSURLRequest *request;
        __block KSDeferred *deferred;
        __block KSPromise *promise;
        
        beforeEach(^{
            deferred = [KSDeferred defer];
            request = nice_fake_for([NSURLRequest class]);
            requester stub_method(@selector(promiseWithRequest:))
                .with(request)
                .and_return(deferred.promise);
            promise = [subject promiseWithRequest:request];
        });
        
        it(@"should make a request", ^{
            requester should have_received(@selector(promiseWithRequest:));
        });
        
        context(@"when the request succeeds", ^{
            __block KSNetworkResponse *networkResponse;
            __block NSHTTPURLResponse *response;
            __block NSData *data;
            beforeEach(^{
                response = nice_fake_for([NSHTTPURLResponse class]);
                data = nice_fake_for([NSData class]);
                networkResponse = [KSNetworkResponse networkResponseWithURLResponse:response data:data];
            });
            
            context(@"with an acceptable status code", ^{
                beforeEach(^{
                    response stub_method(@selector(statusCode)).and_return((NSInteger)123);
                    [deferred resolveWithValue:networkResponse];
                });
                
                it(@"should resolve the promise's deferred with the value", ^{
                    promise.value should be_same_instance_as(data);
                });
            });
            
            context(@"with an unacceptable status code", ^{
                beforeEach(^{
                    response stub_method(@selector(statusCode)).and_return((NSInteger)122);
                    [deferred resolveWithValue:networkResponse];
                });
                
                it(@"should reject the promise's deferred with an error", ^{
                    NSError *error = promise.error;
                    error.code should equal(122);
                    error.domain should equal(@"my.special.domain");
                    error.userInfo[PDHTTPClientErrorDataKey] should be_same_instance_as(data);
                });
            });
        });
        
        context(@"when the request fails", ^{
            __block NSError *error;
            beforeEach(^{
                error = nice_fake_for([NSError class]);
                [deferred rejectWithError:error];
            });
            
            it(@"should reject the promise's deferred with an error", ^{
                promise.error should be_same_instance_as(error);
            });
        });
    });
});

SPEC_END
