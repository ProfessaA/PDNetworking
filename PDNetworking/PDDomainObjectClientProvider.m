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


@interface _PDDomainObjectClient : NSObject <PDDomainObjectClient>

@property (nonatomic) id<PDRequester> requester;
@property (nonatomic) id<PDRequestProvider> requestProvider;
@property (nonatomic) NSOperationQueue *queue;

- (instancetype)init __attribute__((unavailable("Please use initWithRequester:requestProvider:queue: when initializing PDDomainObjectClient")));

- (instancetype)initWithRequester:(id<PDRequester>)requester
                  requestProvider:(id<PDRequestProvider>)requestProvider
                            queue:(NSOperationQueue *)queue;

@end



@implementation PDDomainObjectClientProvider

- (id<PDDomainObjectClient>)domainObjectClientWithURLSession:(NSURLSession *)urlSession
                                    urlSessionClientDelegate:(id<PDURLSessionClientDelegate>)urlSessionClientDelegate
                                   acceptableHTTPStatusCodes:(NSIndexSet *)acceptableHTTPStatusCodes
                                             requestProvider:(id<PDRequestProvider>)requestProvider
                                             httpErrorDomain:(NSString *)httpErrorDomain
                                             jsonErrorDomain:(NSString *)jsonErrorDomain
                                                       queue:(NSOperationQueue *)queue
{
    PDURLSessionClient *urlSessionClient = [[PDURLSessionClient alloc] initWithURLSession:urlSession queue:queue];
    urlSessionClient.delegate = urlSessionClientDelegate;
    id<PDRequester> httpClient = [[PDHTTPClient alloc] initWithRequester:urlSessionClient
                                                   acceptableStatusCodes:acceptableHTTPStatusCodes
                                                             errorDomain:httpErrorDomain];
    id<PDRequester> jsonClient = [[PDJSONClient alloc] initWithRequester:httpClient];
    id<PDDomainObjectClient> domainObjectClient = [[_PDDomainObjectClient alloc] initWithRequester:jsonClient
                                                                                   requestProvider:requestProvider
                                                                                             queue:queue];
    return domainObjectClient;
}

@end


@implementation _PDDomainObjectClient

- (instancetype)initWithRequester:(id<PDRequester>)requester
                  requestProvider:(id<PDRequestProvider>)requestProvider
                            queue:(NSOperationQueue *)queue
{
    self = [super init];
    if (self) {
        self.requester = requester;
        self.requestProvider = requestProvider;
        self.queue = queue;
    }
    return self;
}

- (KSPromise *)promiseWithNetworkResource:(id<PDNetworkResource>)networkResource
                        requestParameters:(id)requestParameters
{
    KSDeferred *deferred = [KSDeferred defer];
    id <PDRequestParametersSerializer> serializer = networkResource.requestParametersSerializer;
    
    NSError *serializationError;
    NSDictionary *parameters = [serializer serialize:requestParameters error:&serializationError];
    if (!serializationError) {
        NSString *HTTPMethod = networkResource.HTTPMethod;
        NSString *path = networkResource.pathConfigurationBlock(requestParameters);
        NSURLRequest *request = [self.requestProvider requestWithHTTPMethod:HTTPMethod path:path parameters:parameters];
        KSPromise *promise = [self.requester promiseWithRequest:request];
        [promise then:^id(id foundationCollection) {
            if (foundationCollection) {
                id <PDDeserializer> deserializer = networkResource.deserializer;
                if (deserializer) {
                    NSError *deserializationError;
                    id domainObject = [deserializer deserialize:foundationCollection error:&deserializationError];
                    if (!deserializationError) {
                        [self.queue addOperationWithBlock:^{
                            [deferred resolveWithValue:domainObject];
                        }];
                    }
                    else {
                        [self.queue addOperationWithBlock:^{
                            [deferred rejectWithError:deserializationError];
                        }];
                    }
                }
                else {
                    [self.queue addOperationWithBlock:^{
                        [deferred resolveWithValue:foundationCollection];
                    }];
                }
            }
            else {
                [self.queue addOperationWithBlock:^{
                    [deferred resolveWithValue:nil];
                }];
            }
            return nil;
        } error:^id(NSError *error) {
            [self.queue addOperationWithBlock:^{
                [deferred rejectWithError:error];
            }];
            return nil;
        }];
    }
    else {
        [self.queue addOperationWithBlock:^{
            [deferred rejectWithError:serializationError];
        }];
    }
    return deferred.promise;
}

#pragma mark - NSObject

- (instancetype)init
{
    [self doesNotRecognizeSelector:_cmd];
    return nil;
}

@end