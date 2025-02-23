//
//  EditPetView.swift
//  Paws
//
//  Created by Weerawut Chaiyasomboon on 23/2/2568 BE.
//

import SwiftUI
import SwiftData
import PhotosUI

struct EditPetView: View {
    @Bindable var pet: Pet
    @State private var photoPickerItem: PhotosPickerItem?
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    var body: some View {
        Form {
            //Image
            if let imageData = pet.photo, let image = UIImage(data: imageData) {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .clipShape(.rect(cornerRadius: 8))
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 300)
                    .padding(.top)
            } else {
                CustomContentUnavailabelView(icon: "pawprint.circle", title: "No Photo", description: "Add a photo of your favorite pet to make it easier to find them.")
                    .padding(.top)
            }
            
            //Photo Picker
            PhotosPicker(selection: $photoPickerItem, matching: .images) {
                Label("Select a photo", systemImage: "photo.badge.plus")
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .listRowSeparator(.hidden)
            
            //TextField
            TextField("Name", text: $pet.name)
                .textFieldStyle(.roundedBorder)
                .font(.largeTitle.weight(.light))
                .padding(.vertical)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.sentences)
            
            //Button
            Button {
                //Save to SwiftData
                try? modelContext.save()
                dismiss()
            } label: {
                Text("Save")
                    .font(.title2.weight(.medium))
                    .padding(8)
                    .frame(minWidth: 0, maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .listRowSeparator(.hidden)
            .padding(.bottom)

        }
        .listStyle(.plain)
        .navigationTitle("Edit \(pet.name)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onChange(of: photoPickerItem) {
            Task {
                pet.photo = try? await photoPickerItem?.loadTransferable(type: Data.self)
            }
        }
    }
}

#Preview {
    NavigationStack {
        do {
            let configuration = ModelConfiguration(isStoredInMemoryOnly: true)
            let container = try ModelContainer(for: Pet.self, configurations: configuration)
            let sampleData = Pet(name: "Daisy")
            
            return EditPetView(pet: sampleData)
                .modelContainer(container)
        } catch {
            fatalError("Could not load preview data: \(error.localizedDescription)")
        }
    }
}
