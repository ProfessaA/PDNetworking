#import "PDGenericDomainObjectClient.h"
#import "PDRequestParametersSerializer.h"
#import "KSDeferred.h"
#import "PDNetworkResource.h"
#import "PDRequestProvider.h"
#import "PDRequester.h"
#import "PDDeserializer.h"


@interface PDGenericDomainObjectClient ()

@property (nonatomic) id<PDRequester> requester;
@property (nonatomic) id<PDRequestProvider> requestProvider;
@property (nonatomic) NSOperationQueue *queue;

@end


@implementation PDGenericDomainObjectClient

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