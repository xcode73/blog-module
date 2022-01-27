//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

final class BlogInstallForm: AbstractForm {

    var sample: Bool = true
    
    init() {
        super.init()
        self.action.url = "/install/blog/?next=true"
        self.submit = "Next"
    }

    @FormFieldBuilder
    override func createFields(_ req: Request) -> [FormField] {
        ToggleField("sample")
            .config {
                $0.output.context.label.title = "Install sample content"
            }
            .read { [unowned self] in $1.output.context.value = sample }
            .write { [unowned self] in sample = $1.input }
    }    
}
