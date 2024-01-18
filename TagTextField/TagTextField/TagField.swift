//
//  TagField.swift
//  TagTextField
//
//  Created by JXW003 on 2024/1/17.
//

import SwiftUI

struct TagField: View {
    
    @Binding var tags: [Tag]
    
    var body: some View {
        TagLayout(alignment: .leading) {
            ForEach($tags) { $tag in
                TagView(tag: $tag, allTags: $tags)
                    .onChange(of: tag.value) { oldValue, newValue in
                        if newValue.last == "," {
                            /// Removing Comma
                            tag.value.removeLast()
                            /// Inserting New Tag Item
                            if !tag.value.isEmpty {
                                tags.append(.init(value: ""))
                            }
                        }
                    }
            }
        }
        .clipped()
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
        .background(.bar, in: .rect(cornerRadius: 12))
        .onAppear(perform: {
            if tags.isEmpty {
                tags.append(.init(value: "", isInitial: true))
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            if let lastTag = tags.last, !lastTag.value.isEmpty {
                /// Inserting empty tag at last
                tags.append(.init(value: "", isInitial: true))
            }
        }
    }
}


fileprivate struct TagView: View {
    @Binding var tag: Tag
    @Binding var allTags: [Tag]
    @FocusState private var isFocused: Bool
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        BackSpaceListerTextField(hint: "Tag", text: $tag.value, onBackPressed: {
            print("Back Button Click")
            if allTags.count > 1 {
                if tag.value.isEmpty {
                    allTags.removeAll(where: { $0.id == tag.id })
                    /// Activating the previously available Tag
                    if let lastIndex = allTags.indices.last {
                        allTags[lastIndex].isInitial = false
                    }
                }
            }
        })
        .focused($isFocused)
        .padding(.horizontal, isFocused || tag.value.isEmpty ? 0 :10)
        .padding(.vertical, 10)
        .background((colorScheme == .dark ? Color.black : Color.white).opacity(isFocused || tag.value.isEmpty ? 0 : 1), in: .rect(cornerRadius: 5))
        .disabled(tag.isInitial)
        .onChange(of: allTags, initial: true, { oldValue, newValue in
            if (newValue.last?.id == tag.id) && !(newValue.last?.isInitial ?? false) && !isFocused {
                isFocused = true
            }
        })
        .overlay {
            if tag.isInitial {
                Rectangle()
                    .fill(.clear)
                    .contentShape(.rect)
                    .onTapGesture {
                        /// Activating only for last tag
                        if allTags.last?.id == tag.id {
                            tag.isInitial = false
                            isFocused = true
                        }
                    }
            }
        }
        .onChange(of: isFocused) { _, _ in
            if !isFocused {
                tag.isInitial = true
            }
        }
    }
}


fileprivate struct BackSpaceListerTextField: UIViewRepresentable {
    var hint: String = "Tag"
    @Binding var text: String
    var onBackPressed: () -> ()
    
    func makeUIView(context: Context) -> CustomTextField {
        let textfield = CustomTextField()
        textfield.placeholder = hint
        textfield.delegate = context.coordinator
        textfield.autocorrectionType = .no
        textfield.autocapitalizationType = .words
        textfield.backgroundColor = .clear
        textfield.onBackPressed = onBackPressed
        textfield.addTarget(context.coordinator, action: #selector(Coordinator.textChange(textField:)), for: .editingChanged)
        return textfield
    }
    
    func updateUIView(_ uiView: CustomTextField, context: Context) {
        uiView.text = text
    }
    
    func sizeThatFits(_ proposal: ProposedViewSize, uiView: CustomTextField, context: Context) -> CGSize? {
        return uiView.intrinsicContentSize
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(text: $text)
    }
    
    class Coordinator: NSObject, UITextFieldDelegate {
        @Binding var text: String
        init(text: Binding<String>) {
            self._text = text
        }
        
        @objc func textChange(textField: UITextField) {
            text = textField.text ?? ""
        }
        
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            textField.resignFirstResponder()
            return true
        }
    }
}


fileprivate class CustomTextField: UITextField {
    open var onBackPressed: (() -> ())?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func deleteBackward() {
        /// This will be called when ever keyboard back button is pressed
        onBackPressed?()
        super.deleteBackward()
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return false
    }
}

#Preview {
    ContentView()
}
