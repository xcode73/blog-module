//
//  BlogAuthorLinkModel+View.swift
//  BlogModule
//
//  Created by Tibor Bodecs on 2020. 11. 06..
//

import FeatherCore

extension BlogAuthorLinkModel: TemplateDataRepresentable {
    
    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "label": label,
            "url": url,
            "priority": priority,
        ])
    }
}
