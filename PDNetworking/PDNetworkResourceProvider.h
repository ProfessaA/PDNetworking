#import <Foundation/Foundation.h>


@protocol PDNetworkResource;
@protocol PDDeserializer;
@protocol PDRequestParametersSerializer;


@interface PDNetworkResourceProvider : NSObject

- (id<PDNetworkResource>)fetchResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                     requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                    deserializer:(id<PDDeserializer>)deserializer;

- (id<PDNetworkResource>)creationResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                        requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                       deserializer:(id<PDDeserializer>)deserializer;

- (id<PDNetworkResource>)updateResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                      requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                     deserializer:(id<PDDeserializer>)deserializer;

- (id<PDNetworkResource>)deletionResourceWithPathConfigurationBlock:(NSString * (^)(id))pathConfigurationBlock
                                        requestParametersSerializer:(id<PDRequestParametersSerializer>)requestParametersSerializer
                                                       deserializer:(id<PDDeserializer>)deserializer;


@end
