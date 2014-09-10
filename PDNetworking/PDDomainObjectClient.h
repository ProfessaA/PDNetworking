#import <Foundation/Foundation.h>


@class KSPromise;
@protocol PDRequestProvider;
@protocol PDRequester;
@protocol PDNetworkResource;


@interface PDDomainObjectClient : NSObject

- (instancetype)init __attribute__((unavailable("Please use initWithRequester:requestProvider:queue: when initializing PDDomainObjectClient")));

- (instancetype)initWithRequester:(id<PDRequester>)requester
                  requestProvider:(id<PDRequestProvider>)requestProvider
                            queue:(NSOperationQueue *)queue;

- (KSPromise *)promiseWithNetworkResource:(id<PDNetworkResource>)networkResource
                        requestParameters:(id)requestParameters;
@end
