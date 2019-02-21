//
//  ViewController.swift
//  TreeControl
//
//  Created by Gene De Lisa on 7/18/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Cocoa

/// A View Controller that doesn't do much due to binding.
/// - Author: Gene

class ViewController: NSViewController {
    
    @IBOutlet var treeController: NSTreeController!
    
    @IBOutlet var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // in case you want to see these.
        
        //        let treeContentArrayBinding = convertFromOptionalNSBindingInfoKeyDictionary(self.treeController.infoForBinding(NSBindingName(rawValue: "contentArray")))
        //        let treeSelectionIndexes = convertFromOptionalNSBindingInfoKeyDictionary(self.treeController.infoForBinding(NSBindingName(rawValue: "selectionIndexPaths")))
        //        let outlineViewContentBinding = convertFromOptionalNSBindingInfoKeyDictionary(self.outlineView.infoForBinding(NSBindingName(rawValue: "content")))
        //        print(treeContentArrayBinding)
        //        print(treeSelectionIndexes)
        //        print(outlineViewContentBinding)
        
    }
    
    override var representedObject: Any? {
        didSet {
        }
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
private func convertFromOptionalNSBindingInfoKeyDictionary(_ input: [NSBindingInfoKey: Any]?) -> [String: Any]? {
    guard let input = input else { return nil }
    return Dictionary(uniqueKeysWithValues: input.map {key, value in (key.rawValue, value)})
}
