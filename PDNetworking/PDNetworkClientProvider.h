#import <Foundation/Foundation.h>


@protocol PDDomainObjectClient;
@protocol PDNetworkResource;


@interface PDNetworkClientProvider : NSObject

- (id)networkClientWithNetworkResource:(id<PDNetworkResource>)networkResource
                    domainObjectClient:(id<PDDomainObjectClient>)domainObjectClient;

@end
