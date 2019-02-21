//
//  FileSystemItem.swift
//  TreeControl
//
//  Created by Gene De Lisa on 7/16/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Foundation


/// A representation of the file system.
/// It is KVO compliant, so a `TreeControl` can be bound to it.
/// - Author: Gene De Lisa

@objcMembers
class FileSystemItem: NSObject {
    

    var relativePath: String!
    
    var parent: FileSystemItem?
    
    var children: [FileSystemItem]? {
        
        let fileManager = FileManager.default
        
        var isDir: ObjCBool = false
        let valid = fileManager.fileExists(atPath: fullPath, isDirectory: &isDir)
        
        if valid && isDir.boolValue {
            self.isLeaf = false
            do {
                let array = try fileManager.contentsOfDirectory(atPath: fullPath)
                var kids = [FileSystemItem]()
                for name in array {
                    let child = FileSystemItem(path: name, parent: self)
                    do {
                        let fileAttributes = try FileManager.default.attributesOfItem(atPath: child.fullPath)
                        
                        if let fileType = fileAttributes[.type] as? FileAttributeType {
                            switch fileType {
                            case FileAttributeType.typeRegular:
                                child.isLeaf = true
                                print("\(child.fullPath) regular")
                            case FileAttributeType.typeDirectory:
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
    
    
    class var rootItem: FileSystemItem {
        return FileSystemItem(path: "/", parent: nil)
    }
    
    var fullPath: String {
        if let p = parent {
            // recurse up the hierarchy, prepending each parent’s path
            return URL(string: p.fullPath)!.appendingPathComponent(relativePath).absoluteString
        } else {
            // If no parent, return our own relative path
            return relativePath
        }
    }
    
    var isLeaf = false
    
    var size: Int {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullPath)
            if let size = fileAttributes[.size] as? Int {
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
    
    var creationDate: Date? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullPath)
            if let date = fileAttributes[.creationDate] as? Date {
                return date
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    var modificationDate: Date? {
        do {
            let fileAttributes = try FileManager.default.attributesOfItem(atPath: fullPath)
            if let date = fileAttributes[.modificationDate] as? Date {
                return date
            } else {
                return nil
            }
        } catch {
            return nil
        }
    }
    
    // MARK: Initializers
    
    override init() {
        self.relativePath = "/"
        super.init()
    }
    
    init(path: String, parent: FileSystemItem?) {
        self.relativePath = URL(fileURLWithPath: path).lastPathComponent
        self.parent = parent
        super.init()
    }
    
    
    func getChild(_ atIndex: Int) -> FileSystemItem {
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
