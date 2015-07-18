//
//  ViewController.swift
//  TreeControl
//
//  Created by Gene De Lisa on 7/18/15.
//  Copyright © 2015 Gene De Lisa. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {

    @IBOutlet var treeController: NSTreeController!
    
    @IBOutlet var outlineView: NSOutlineView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let treeContentArrayBinding = self.treeController.infoForBinding("contentArray")
        let treeSelectionIndexes = self.treeController.infoForBinding("selectionIndexPaths")
        let outlineViewContentBinding = self.outlineView.infoForBinding("content")
        print(treeContentArrayBinding)
        print(treeSelectionIndexes)
        print(outlineViewContentBinding)

    }

    override var representedObject: AnyObject? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

