//
//  ContentView.swift
//  DragImagePicker
//
//  Created by JXW003 on 2024/1/19.
//

import SwiftUI
import PhotosUI


struct ContentView: View {
    var body: some View {
        NavigationStack {
            VStack {
                ImagePicker(title: "Drag & Drop", subTitle: "Tap to add an Image", systemImage: "square.and.arrow.up", tint: .blue) { image in
                    print(image)
                }
                .frame(maxWidth: 300, maxHeight: 250)
                .padding(.top, 20)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Image Picker")
        }
    }
}



struct ImagePicker: View {
    var title: String
    var subTitle: String
    var systemImage: String
    var tint: Color
    var onImageChange: (UIImage) -> ()
    
    @State private var showImagePicker: Bool = false
    @State private var photoItem: PhotosPickerItem?
    @State private var previewImage: UIImage?
    @State private var isLoading: Bool = false
    
    var body: some View {
        GeometryReader(content: { geometry in
            let size = geometry.size
            
            VStack(spacing: 4) {
                Image(systemName: systemImage)
                    .font(.largeTitle)
                    .imageScale(.large)
                    .foregroundStyle(tint)
                Text(title)
                    .font(.callout)
                    .padding(.top, 15)
                Text(subTitle)
                    .font(.caption)
                    .foregroundStyle(.gray)
            }
            /// Displaying Preview Image
            .opacity(previewImage == nil ? 1 : 0)
            .frame(width: size.width, height: size.height)
            .overlay {
                if let previewImage {
                    Image(uiImage: previewImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(15)
                }
            }
            /// Displaying Loading UI
            .overlay {
                if isLoading {
                    ProgressView()
                        .padding(10)
                        .background(.ultraThinMaterial, in: .rect(cornerRadius: 5))
                }
            }
            /// Animation
            .animation(.snappy, value: isLoading)
            .animation(.snappy, value: previewImage)
            .contentShape(.rect)
            /// Implementing Drop Action and Retreving Dropped Image
            .dropDestination(for: Data.self, action: { items, location in
                if let firstItem = items.first, let droppedImage = UIImage(data: firstItem) {
                    generateImageThumbnail(droppedImage, size)
                    onImageChange(droppedImage)
                    return true
                }
                return false
            }, isTargeted: { _ in
                
            })
            .onTapGesture {
                showImagePicker.toggle()
            }
            /// Now Let's Implement Manaual Image Picker
            .photosPicker(isPresented: $showImagePicker, selection: $photoItem)
            /// Let's Process the Selected Image
            .optionalViewModifier(content: { contentView in
                if #available(iOS 17.0, *) {
                    contentView
                        .onChange(of: photoItem.self) { oldValue, newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                } else {
                    contentView
                        .onChange(of: photoItem.self) { newValue in
                            if let newValue {
                                extractImage(newValue, size)
                            }
                        }
                }
            })
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(tint.opacity(0.08).gradient)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .stroke(tint, style: .init(lineWidth: 1, dash: [12]))
                        .padding(1)
                }
            }
        })
    }
    
    /// Extracting Image from PhotoItem
    func extractImage(_ photoItem: PhotosPickerItem, _ size: CGSize) {
        Task.detached {
            guard let imageData = try? await photoItem.loadTransferable(type: Data.self) else { return }
            await MainActor.run {
                if let selectedImage = UIImage(data: imageData) {
                    generateImageThumbnail(selectedImage, size)
                    onImageChange(selectedImage)
                }
                self.photoItem = nil
            }
        }
    }
    
    /// Creating Image Thumbnail
    func generateImageThumbnail(_ image: UIImage, _ size: CGSize) {
        Task.detached {
            let thumbnailImage = await image.byPreparingThumbnail(ofSize: size)
            /// UI must be updated on Main Thread
            await MainActor.run {
                previewImage = thumbnailImage
            }
        }
    }
}


extension View {
    @ViewBuilder
    func optionalViewModifier<Content: View>(@ViewBuilder content: @escaping (Self) -> Content) -> some View {
        content(self)
    }
}


#Preview {
    ContentView()
//        .preferredColorScheme(.dark)
}
