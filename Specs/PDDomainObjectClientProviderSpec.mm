#import "CDRSpec.h"
#import "PDDomainObjectClient.h"
#import "PDRequester.h"
#import "PDDeserializer.h"
#import "PDRequestProvider.h"
#import "PDNetworkResource.h"
#import "PDRequestParametersSerializer.h"
#import "PDNetworkResourceProvider.h"
#import "KSDeferred.h"
#import "PSHKFakeOperationQueue.h"
#import "PDDomainObjectClientProvider.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDDomainObjectClientProviderSpec)

describe(@"PDDomainObjectClientProvder", ^{
    __block PDDomainObjectClientProvider *subject;
    
    beforeEach(^{
        subject = [[PDDomainObjectClientProvider alloc] init];
    });
    
    describe(@"providing a domain object client", ^{
        __block id<PDDomainObjectClient> domainObjectClient;
        __block NSURLSession *session;
        __block id<PDURLSessionClientDelegate> URLSessionClientDelegate;
        __block NSIndexSet *accetableHTTPStatusCodes;
        __block id<PDRequestProvider> requestProvider;
        __block PSHKFakeOperationQueue *queue;
        
        
        beforeEach(^{
            session = nice_fake_for([NSURLSession class]);
            URLSessionClientDelegate = nice_fake_for(@protocol(PDURLSessionClientDelegate));
            accetableHTTPStatusCodes = [NSIndexSet indexSetWithIndex:123];
            requestProvider = nice_fake_for(@protocol(PDRequestProvider));
            queue = [[PSHKFakeOperationQueue alloc] init];
            [queue setRunSynchronously:YES];
            
            domainObjectClient = [subject domainObjectClientWithURLSession:session
                                                  urlSessionClientDelegate:URLSessionClientDelegate
                                                 acceptableHTTPStatusCodes:accetableHTTPStatusCodes
                                                           requestProvider:requestProvider
                                                           httpErrorDomain:@"http.error.domain"
                                                           jsonErrorDomain:@"json.error.domain"
                                                                     queue:queue];
        });
        
        it(@"should create a domain object client", ^{
            [domainObjectClient conformsToProtocol:@protocol(PDDomainObjectClient)] should be_truthy;
        });
    });
    
//    describe(@"making a request with a network resource and request parameters", ^{
//        __block id<PDNetworkResource> networkResource;
//        __block id <PDRequestParametersSerializer> requestParametersSerializer;
//        __block id <PDDeserializer> deserializer;
//        __block NSDictionary *requestParameters;
//        __block NSURLRequest *request;
//        __block KSPromise *promise;
//        __block KSDeferred *deferred;
//        
//        beforeEach(^{
//            deferred = [KSDeferred defer];
//            request = nice_fake_for([NSURLRequest class]);
//            requestParameters = @{@"id": @"asdf"};
//            requestParametersSerializer = nice_fake_for(@protocol(PDRequestParametersSerializer));
//            deserializer = nice_fake_for(@protocol(PDDeserializer));
//            
//            PDNetworkResourceProvider *provider = [[PDNetworkResourceProvider alloc] init];
//            NSString * (^pathConfigurationBlock)(id) = ^NSString *(id someRequestParameters) {
//                NSDictionary *dictionaryParams = someRequestParameters;
//                NSString *identifier = dictionaryParams[@"id"];
//                return [NSString stringWithFormat:@"%@.json", identifier];
//            };
//            networkResource = [provider retrievalResourceWithPathConfigurationBlock:pathConfigurationBlock
//                                                        requestParametersSerializer:requestParametersSerializer
//                                                                       deserializer:deserializer];
//            
//            requestParametersSerializer stub_method(@selector(serialize:error:))
//            .with(requestParameters, Arguments::anything)
//            .and_return(@{@"request": @"params"});
//            
//            requestProvider stub_method(@selector(requestWithHTTPMethod:path:parameters:))
//            .with(@"GET", @"asdf.json", @{@"request": @"params"})
//            .and_return(request);
//            
//            requester stub_method(@selector(promiseWithRequest:))
//            .with(request)
//            .and_return(deferred.promise);
//            promise = [subject promiseWithNetworkResource:networkResource requestParameters:requestParameters];
//        });
//        
//        it(@"should serialize the request parameters", ^{
//            requestParametersSerializer should have_received(@selector(serialize:error:)).with(requestParameters, Arguments::anything);
//        });
//        
//        it(@"should get a request from the request provider", ^{
//            requestProvider should have_received(@selector(requestWithHTTPMethod:path:parameters:)).with(@"GET", @"asdf.json", @{@"request": @"params"});
//        });
//        
//        context(@"when the request succeeds", ^{
//            __block id deserializedObject;
//            beforeEach(^{
//                deserializedObject = nice_fake_for([NSObject class]);
//                deserializer stub_method(@selector(deserialize:error:)).with(@{@"name": @"spikey"}, Arguments::anything).and_return(deserializedObject);
//                [deferred resolveWithValue:@{@"name": @"spikey"}];
//            });
//            
//            it(@"should resolve the promise's deferred with the deserialized value", ^{
//                promise.value should be_same_instance_as(deserializedObject);
//            });
//        });
//        
//    });
});

SPEC_END
