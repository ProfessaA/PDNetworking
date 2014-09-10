#import "PDNetworkClientProvider.h"
#import "PDNetworkResource.h"
#import "PDRequestProvider.h"
#import "PDRequester.h"
#import "PDDomainObjectClient.h"
#import "KSPromise.h"
#import "PDCreationClient.h"
#import "PDRetrievalClient.h"
#import "PDDeletionClient.h"
#import "PDUpdateClient.h"


@class KSPromise;


@interface _PDBaseClient : NSObject

@property (nonatomic) id <PDNetworkResource> networkResource;
@property (nonatomic) PDDomainObjectClient *domainObjectClient;

@end


@interface _PDCreationClient : _PDBaseClient <PDCreationClient>

- (KSPromise *)creationPromiseWithRequestParameters:(id)requestParameters;

@end


@interface _PDRetreivalClient : _PDBaseClient <PDRetrievalClient>

- (KSPromise *)retrievalClientPromiseWithRequestParameters:(id)requestParameters;

@end


@interface _PDDeletionClient : _PDBaseClient <PDDeletionClient>

- (KSPromise *)deletionPromiseWithRequestParameters:(id)requestParameters;

@end


@interface _PDUpdateClient : _PDBaseClient <PDUpdateClient>

- (KSPromise *)updatePromiseWithRequestParameters:(id)requestParameters;

@end


@implementation PDNetworkClientProvider

- (id)networkClientWithNetworkResource:(id<PDNetworkResource>)networkResource
                    domainObjectClient:(PDDomainObjectClient *)domainObjectClient
{
    _PDBaseClient *client;
    NSString *HTTPMethod = networkResource.HTTPMethod;
    if ([HTTPMethod isEqualToString:@"GET"]) {
        client = [[_PDRetreivalClient alloc] init];
    }
    else if ([HTTPMethod isEqualToString:@"POST"]) {
        client = [[_PDCreationClient alloc] init];
    }
    else if ([HTTPMethod isEqualToString:@"PUT"]) {
        client = [[_PDUpdateClient alloc] init];
    }
    else if ([HTTPMethod isEqualToString:@"DELETE"]) {
        client = [[_PDDeletionClient alloc] init];
    }
    client.networkResource = networkResource;
    client.domainObjectClient = domainObjectClient;
    return client;
}

@end


@implementation _PDBaseClient

- (instancetype)initWithNetworkResource:(id<PDNetworkResource>)networkResource
                     domainObjectClient:(PDDomainObjectClient *)domainObjectClient
{
    self = [super init];
    if (self) {
        self.networkResource = networkResource;
        self.domainObjectClient = domainObjectClient;
    }
    return self;
}

@end


@implementation _PDCreationClient

#pragma mark - <PDCreationClient>

- (KSPromise *)creationPromiseWithRequestParameters:(id)requestParameters
{
    id <PDNetworkResource> networkResource = self.networkResource;
    return [self.domainObjectClient promiseWithNetworkResource:networkResource
                                             requestParameters:requestParameters];
}

@end


@implementation _PDRetreivalClient

#pragma mark - <PDRetreivalClient>

- (KSPromise *)retrievalClientPromiseWithRequestParameters:(id)requestParameters
{
    id <PDNetworkResource> networkResource = self.networkResource;
    return [self.domainObjectClient promiseWithNetworkResource:networkResource
                                             requestParameters:requestParameters];
}

@end


@implementation _PDDeletionClient

#pragma mark - <PDDeletionClient>

- (KSPromise *)deletionPromiseWithRequestParameters:(id)requestParameters
{
    id <PDNetworkResource> networkResource = self.networkResource;
    return [self.domainObjectClient promiseWithNetworkResource:networkResource
                                             requestParameters:requestParameters];
}

@end


@implementation _PDUpdateClient

#pragma mark - <PDUpdateClient>

- (KSPromise *)updatePromiseWithRequestParameters:(id)requestParameters
{
    id <PDNetworkResource> networkResource = self.networkResource;
    return [self.domainObjectClient promiseWithNetworkResource:networkResource
                                             requestParameters:requestParameters];
}

@end
