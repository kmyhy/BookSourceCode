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
        // Should ensure that the actual file is in the position returned by URLForItemWithIdentifier, then call the completion handler
        var error: NSError? = nil
        var fileError: NSError? = nil
      
        let fileData = NSData()
        // TODO: get the contents of file at <url> from model

        self.fileCoordinator.coordinateWritingItemAtURL(url, options: NSFileCoordinatorWritingOptions(), error: &error, byAccessor: { newURL in
            _ = fileData.writeToURL(newURL, options: NSDataWritingOptions(), error: &fileError)
        })
        if error != nil {
            completionHandler?(error: error);
        } else {
            completionHandler?(error: fileError);
        }
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
