//
//  ContentSizedTableView.swift
//  Yogit
//
//  Created by Junseo Park on 2022/12/29.
//

import UIKit

final class ContentSizedTableView: UITableView {
    var isDynamicSizeRequired = false
        
    override func layoutSubviews() {
        super.layoutSubviews()
        
        if bounds.size != self.intrinsicContentSize {

            if self.intrinsicContentSize.height > frame.size.height {
                self.invalidateIntrinsicContentSize()
            }

        }

        if isDynamicSizeRequired {
            self.invalidateIntrinsicContentSize()
        }

    }
    
    override var intrinsicContentSize: CGSize {
        return contentSize
    }
}
