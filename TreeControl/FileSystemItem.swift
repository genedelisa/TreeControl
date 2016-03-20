//
//  FileSystemItem.swift
//  TreeControl
//
//  Created by Gene De Lisa on 7/16/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Foundation


class FileSystemItem: NSObject {
    
    var relativePath:String!
    
    var parent:FileSystemItem?
    
    var children:[FileSystemItem]? {
        get {
            let fileManager = NSFileManager.defaultManager()
            
            var isDir: ObjCBool = false
            let valid = fileManager.fileExistsAtPath(fullPath, isDirectory:&isDir)
            
            if valid && isDir {
                self.isLeaf = false
                do {
                    let array = try fileManager.contentsOfDirectoryAtPath(fullPath)
                    var kids = [FileSystemItem]()
                    for name in array {
                        let child = FileSystemItem(path: name, parent: self)
                        do {
                            let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(child.fullPath)
                            if let fileType = fileAttributes["NSFileType"] as? String {
                                switch fileType {
                                case "NSFileTypeRegular" :
                                    child.isLeaf = true
                                    print("\(child.fullPath) regular")
                                case "NSFileTypeDirectory" :
                                    child.isLeaf = false
                                    print("\(child.fullPath) directory")
                                default: break
                                }
                            }
                        } catch {
                            print("couldnt get attribs for \(child)")
                        }
                        
                        kids.append(child)
                    }
                    return kids
                } catch {
                    print("oops. couldn't get contents at \(fullPath)")
                }

            } else {
                self.isLeaf = true
                return nil
            }
            return nil
        }
        
        set {
            self.children = newValue
        }
    }
    
    
    class var rootItem:FileSystemItem {
        get {
            return FileSystemItem(path: "/", parent: nil)
        }
    }
    
    var fullPath:String {
        get {
            if let p = parent {
                // recurse up the hierarchy, prepending each parent’s path
                return NSURL(string: p.fullPath)!.URLByAppendingPathComponent(relativePath).absoluteString
                //return p.fullPath.stringByAppendingPathComponent(relativePath)
            } else {
                // If no parent, return our own relative path
                return relativePath
            }
        }
    }
    
    var isLeaf = false
    
    var size:Int {
        get {
            do {
                let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(fullPath)
                if let size = fileAttributes["NSFileSize"] as? Int {
                    //                let kb = Double(size.doubleValue / 1000.0)
                    //                let mb = Double(size.doubleValue / 1000000.0)
                    return size
                    
                } else {
                    return 0
                }
            } catch {
                return 0
            }
        }
    }
    
    var creationDate:NSDate? {
        get {
            do {
                let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(fullPath)
                if let date = fileAttributes["NSFileCreationDate"] as? NSDate {
                    return date
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
    }
    
    var modificationDate:NSDate? {
        get {
            do {
                let fileAttributes = try NSFileManager.defaultManager().attributesOfItemAtPath(fullPath)
                if let date = fileAttributes["NSFileModificationDate"] as? NSDate {
                    return date
                } else {
                    return nil
                }
            } catch {
                return nil
            }
        }
    }
    
    override init() {
        self.relativePath = "/"
        super.init()
    }
    
    init(path:String, parent:FileSystemItem?) {
        self.relativePath = NSURL(fileURLWithPath: path).lastPathComponent
        self.parent = parent
        super.init()
    }
    

    func getChild(atIndex:Int) -> FileSystemItem {
        return children![atIndex]
    }
    
    func getNumberOfChildren() -> Int {
        if let tmp = children {
            return tmp.count
        } else {
            return 0
        }
    }
    
    
}