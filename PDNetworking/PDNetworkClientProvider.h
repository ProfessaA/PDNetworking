#import <Foundation/Foundation.h>


@class PDDomainObjectClient;
@protocol PDRequester;
@protocol PDNetworkResource;
@protocol PDCreationClient;
@protocol PDUpdateClient;
@protocol PDDeletionClient;
@protocol PDCollectionClient;
@protocol PDDetailClient;


@interface PDNetworkClientProvider : NSObject

- (id)networkClientWithNetworkResource:(id<PDNetworkResource>)networkResource
                    domainObjectClient:(PDDomainObjectClient *)domainObjectClient;

@end
