//
//  FileProvider.swift
//  DocumentPickerFileProvider
//
//  Created by yanghongyan on 14/12/7.
//  Copyright (c) 2014年 yanghongyan. All rights reserved.
//

import UIKit

class FileProvider: NSFileProviderExtension {

    var fileCoordinator: NSFileCoordinator {
        let fileCoordinator = NSFileCoordinator()
        fileCoordinator.purposeIdentifier = self.providerIdentifier()
        return fileCoordinator
    }

    override init() {
        super.init()
        
        self.fileCoordinator.coordinateWritingItemAtURL(self.documentStorageURL(), options: NSFileCoordinatorWritingOptions(), error: nil, byAccessor: { newURL in
            // ensure the documentStorageURL actually exists
            var error: NSError? = nil
            NSFileManager.defaultManager().createDirectoryAtURL(newURL, withIntermediateDirectories: true, attributes: nil, error: &error)
        })
    }

    override func providePlaceholderAtURL(url: NSURL, completionHandler: ((error: NSError?) -> Void)?) {
        // Should call writePlaceholderAtURL(_:withMetadata:error:) with the placeholder URL, then call the completion handler with the error if applicable.
        let fileName = url.lastPathComponent
    
        let placeholderURL = NSFileProviderExtension.placeholderURLForURL(self.documentStorageURL().URLByAppendingPathComponent(fileName))
    
        self.fileCoordinator.coordinateWritingItemAtURL(placeholderURL, options: NSFileCoordinatorWritingOptions(), error: nil, byAccessor: { newURL in
            var metadata = [NSURLFileSizeKey: fileName.lengthOfBytesUsingEncoding(NSUTF8StringEncoding)]
            NSFileProviderExtension.writePlaceholderAtURL(placeholderURL, withMetadata: metadata, error: nil)
        })
        completionHandler?(error: nil)
    }

    override func startProvidingItemAtURL(url: NSURL, completionHandler: ((error: NSError?) -> Void)?) {
        // 1
        let fileManager = NSFileManager()
        let path = url.path!
        if fileManager.fileExistsAtPath(path) {
            //if the file is already, just return
            completionHandler?(error: nil)
            return
        }
        // 2
        let filename = url.lastPathComponent
        // 3
        registerBmob()
        // 4
        loadFileData(filename, { (data) -> Void in
            
            var error: NSError? = nil
            var fileError: NSError? = nil
            // 5
            self.fileCoordinator.coordinateWritingItemAtURL(url,
                options: .ForReplacing,
                error: &error,
                byAccessor: { newURL in
                    // 6
                    _ = data.writeToURL(newURL, options: .AtomicWrite, error: &fileError)
            })
            // 7
            if error != nil {
                completionHandler?(error: error);
            } else {
                completionHandler?(error: fileError);
            }
        })
    }


    override func itemChangedAtURL(url: NSURL) {
        // Called at some point after the file has changed; the provider may then trigger an upload

        // TODO: mark file at <url> as needing an update in the model; kick off update process
        NSLog("Item changed at URL %@", url)
    }

    override func stopProvidingItemAtURL(url: NSURL) {
        // Called after the last claim to the file has been released. At this point, it is safe for the file provider to remove the content file.
        // Care should be taken that the corresponding placeholder file stays behind after the content file has been deleted.
        self.fileCoordinator.coordinateWritingItemAtURL(url, options: .ForDeleting, error: nil, byAccessor: { newURL in
            _ = NSFileManager.defaultManager().removeItemAtURL(newURL, error: nil)
        })
        self.providePlaceholderAtURL(url, completionHandler: nil)
    }

}
