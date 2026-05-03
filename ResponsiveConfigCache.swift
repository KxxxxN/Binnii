//
//  ResponsiveConfigCache.swift
//  Thesis
//
//  Created by Kansinee Klinkhachon on 3/5/2569 BE.
//

import SwiftUI

class ResponsiveConfigCache: ObservableObject {
    @Published private(set) var config: ResponsiveConfig?
    
    func update(sizeClass: UserInterfaceSizeClass?, geo: GeometryProxy) {
        let newConfig = ResponsiveConfig(horizontalSizeClass: sizeClass, geo: geo)
        if config == nil || config != newConfig {
            config = newConfig
        }
    }
}
