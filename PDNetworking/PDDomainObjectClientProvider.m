#import "PDDomainObjectClientProvider.h"
#import "PDRequester.h"
#import "PDRequestProvider.h"
#import "PDNetworkResource.h"
#import "KSDeferred.h"
#import "PDDeserializer.h"
#import "PDURLSessionClient.h"
#import "PDHTTPClient.h"
#import "PDJSONClient.h"
#import "PDDomainObjectClient.h"
#import "PDRequestParametersSerializer.h"
#import "PDGenericDomainObjectClient.h"


@implementation PDDomainObjectClientProvider

- (id<PDDomainObjectClient>)domainObjectClientWithURLSession:(NSURLSession *)urlSession
                                    urlSessionClientDelegate:(id<PDURLSessionClientDelegate>)urlSessionClientDelegate
                                   acceptableHTTPStatusCodes:(NSIndexSet *)acceptableHTTPStatusCodes
                                             requestProvider:(id<PDRequestProvider>)requestProvider
                                             httpErrorDomain:(NSString *)httpErrorDomain
                                                       queue:(NSOperationQueue *)queue
{
    PDURLSessionClient *urlSessionClient = [[PDURLSessionClient alloc] initWithURLSession:urlSession queue:queue];
    urlSessionClient.delegate = urlSessionClientDelegate;
    id<PDRequester> httpClient = [[PDHTTPClient alloc] initWithRequester:urlSessionClient
                                                   acceptableStatusCodes:acceptableHTTPStatusCodes
                                                             errorDomain:httpErrorDomain];
    id<PDRequester> jsonClient = [[PDJSONClient alloc] initWithRequester:httpClient];
    id<PDDomainObjectClient> domainObjectClient = [[PDGenericDomainObjectClient alloc] initWithRequester:jsonClient
                                                                                         requestProvider:requestProvider
                                                                                                   queue:queue];
    return domainObjectClient;
}

@end