#import <PDDomainObjectClient.h>


@protocol PDRequester;
@protocol PDRequestProvider;


@interface PDGenericDomainObjectClient : NSObject <PDDomainObjectClient>

@property (nonatomic, readonly) id<PDRequester> requester;
@property (nonatomic, readonly) id<PDRequestProvider> requestProvider;
@property (nonatomic, readonly) NSOperationQueue *queue;

- (instancetype)init __attribute__((unavailable("Please use initWithRequester:requestProvider:queue: when initializing PDGenericDomainObjectClient")));

- (instancetype)initWithRequester:(id<PDRequester>)requester
                  requestProvider:(id<PDRequestProvider>)requestProvider
                            queue:(NSOperationQueue *)queue;

@end