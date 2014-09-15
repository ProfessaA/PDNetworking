#import "CDRSpecHelper.h"
#import "PDNetworkClientProvider.h"
#import "PDDomainObjectClient.h"
#import "PDCreationClient.h"
#import "PDRequestParametersSerializer.h"
#import "PDDeserializer.h"
#import "KSDeferred.h"
#import "PDNetworkResource.h"
#import "PDRetrievalClient.h"
#import <objc/message.h>
#import "PDUpdateClient.h"
#import "PDDeletionClient.h"


using namespace Cedar::Matchers;
using namespace Cedar::Doubles;


SPEC_BEGIN(PDNetworkClientProviderSpec)

describe(@"PDNetworkClientProvider", ^{
    __block PDNetworkClientProvider *subject;
    __block id<PDNetworkResource> networkResource;
    __block id<PDDomainObjectClient> domainObjectClient;
    __block id<PDRequestParametersSerializer> requestParametersSerializer;
    __block id<PDDeserializer> deserializer;
    
    beforeEach(^{
        domainObjectClient = nice_fake_for(@protocol(PDDomainObjectClient));
        networkResource = nice_fake_for(@protocol(PDNetworkResource));
        requestParametersSerializer = nice_fake_for(@protocol(PDRequestParametersSerializer));
        deserializer = nice_fake_for(@protocol(PDDeserializer));
        subject = [[PDNetworkClientProvider alloc] init];
    });
    
    void (^itShouldReturnAtNetworkClient)(NSString *, Protocol *, SEL);
    itShouldReturnAtNetworkClient = ^(NSString *HTTPMethod, Protocol *protocol, SEL selector) {
        describe([NSString stringWithFormat:@"providing a %@ client", HTTPMethod], ^{
            __block id client;
            
            beforeEach(^{
                networkResource stub_method(@selector(HTTPMethod)).and_return(HTTPMethod);
                client = [subject networkClientWithNetworkResource:networkResource
                                                domainObjectClient:domainObjectClient];
            });
            
            it(@"should conform to the correct protocol", ^{
                [client conformsToProtocol:protocol] should be_truthy;
            });
            
            describe([NSString stringWithFormat:@"as a %@ client", HTTPMethod], ^{
                __block KSDeferred *deferred;
                __block KSPromise *promise;
                __block id requestParameters;
                
                beforeEach(^{
                    deferred = [KSDeferred defer];
                    requestParameters = nice_fake_for([NSObject class]);
                    domainObjectClient stub_method(@selector(promiseWithNetworkResource:requestParameters:))
                    .with(networkResource, requestParameters)
                    .and_return(deferred.promise);
                    promise = objc_msgSend(client, selector, requestParameters);
                });
                
                it(@"should send the request parameters to the domain object client", ^{
                    domainObjectClient should have_received(@selector(promiseWithNetworkResource:requestParameters:))
                    .with(networkResource, requestParameters);
                });
                
                context(@"when the request is succeessful", ^{
                    __block id responseObject;
                    beforeEach(^{
                        responseObject = nice_fake_for([NSObject class]);
                        [deferred resolveWithValue:responseObject];
                    });
                    
                    it(@"should resolve the promise's deferred with the response object", ^{
                        promise.value should be_same_instance_as(responseObject);
                    });
                });
            });
        });
    };
    
    itShouldReturnAtNetworkClient(@"GET",
                                  @protocol(PDRetrievalClient),
                                  @selector(retrievalPromiseWithRequestParameters:));
    
    itShouldReturnAtNetworkClient(@"POST",
                                  @protocol(PDCreationClient),
                                  @selector(creationPromiseWithRequestParameters:));
    
    itShouldReturnAtNetworkClient(@"PUT",
                                  @protocol(PDUpdateClient),
                                  @selector(updatePromiseWithRequestParameters:));
    
    itShouldReturnAtNetworkClient(@"DELETE",
                                  @protocol(PDDeletionClient),
                                  @selector(deletionPromiseWithRequestParameters:));
});

SPEC_END
