#import "CDRSpecHelper.h"
#import "PDJSONClient.h"
#import "PDRequester.h"
#import "KSDeferred.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDJSONClientSpec)

describe(@"PDJSONClient", ^{
    __block PDJSONClient *subject;
    __block id<PDRequester> requester;

    beforeEach(^{
        requester = nice_fake_for(@protocol(PDRequester));
        subject = [[PDJSONClient alloc] initWithRequester:requester];
    });
    
    describe(@"getting a promise with a request", ^{
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
            requester should have_received(@selector(promiseWithRequest:)).with(request);
        });
        
        context(@"when the request succeeds with valid json", ^{
            beforeEach(^{
                NSData *data = [@"{\"testing\": 123}" dataUsingEncoding:NSUTF8StringEncoding];
                [deferred resolveWithValue:data];
            });
            
            it(@"should resolve the promise's deferred with deserialized JSON", ^{
                promise.value should equal(@{@"testing": @123});
            });
        });
        
        context(@"when the request succeeds with invalid json", ^{
            beforeEach(^{
                NSData *data = [@":(" dataUsingEncoding:NSUTF8StringEncoding];
                [deferred resolveWithValue:data];
            });
            
            it(@"should reject the promise's deferred with an error", ^{
                NSError *error = promise.error;
                error.domain should equal(NSCocoaErrorDomain);
                error.code should equal(3840);
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
