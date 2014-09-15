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
                                                                     queue:queue];
        });
        
        it(@"should create a domain object client", ^{
            [domainObjectClient conformsToProtocol:@protocol(PDDomainObjectClient)] should be_truthy;
        });
    });    
});

SPEC_END
