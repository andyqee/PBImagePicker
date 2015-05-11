PBImageKit
=========
PBImageKit is an async assets fetcher built on top of NSOperation
As I have tested, decomposite image from ALAsset instance is quite cpu consuming. The PBImageKit decomposition image from asset instance in the background thread.

### How to use?
It's queit easy<br>
You can call the ```PBImageManager``` instance selector
```objective-c
- (PBFetchImageTask *)fetchImageWithAssets:(NSArray *)assets
                            resolutionType:(PBAssetImageResolution)type
                                completion:(void (^)(NSArray *images, NSError *error))completion;

```
or you can use the ```UIImageView``` Category
```
- (void)setImageWithAsset:(ALAsset *)asset withResolution:(PBAssetImageResolution)resolution;

- (void)setImageWithAssetURL:(NSURL *)url withResolution:(PBAssetImageResolution)resolution;
```

It provides 

- An UIImageView category adding asset image fetch to the Cocoa Touch framework
- An asynchronous image asset fetcher
- A guarantee that main thread will never be blocked
- Performances!
- Use GCD and ARC
- Use NSOpearation

### Sample 
You can view the [PBImagePicker](https://github.com/andyqee/PBImagePicker) which is an instagram style image picker built on this framework.

## Creater
Ethon Qee(vitasone(AT)gmail.com)

## License