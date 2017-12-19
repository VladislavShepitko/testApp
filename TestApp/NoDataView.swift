//
//  NoDataView.swift
//  TestApp
//
//  Created by Vladyslav Shepitko on 12/18/17.
//  Copyright © 2017 Vladyslav Shepitko. All rights reserved.
//

import UIKit

class NoDataView: UIView {
    lazy var labelView:UIView = {
        let lbl = UILabel()
        lbl.backgroundColor = UIColor.greenColor()
        lbl.text = "DATA NOT FOUND"
        return lbl
    }()
    override init(frame:CGRect){
        super.init(frame: frame)
        print(frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    private func setupView(){
        self.backgroundColor = UIColor.redColor()
        addSubview(labelView)
        labelView.centerXAnchor.constraintEqualToAnchor(self.centerXAnchor)
        labelView.centerYAnchor.constraintEqualToAnchor(self.centerYAnchor) 
    }
}
