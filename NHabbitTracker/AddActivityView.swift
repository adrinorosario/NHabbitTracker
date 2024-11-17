//
//  AddActivityView.swift
//  NHabbitTracker
//
//  Created by Adrino Rosario on 17/11/24.
//

import PhotosUI
import SwiftUI

struct AddActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    @State private var name: String = ""
    @State private var category: String = ""
    @State private var description: String = ""
    @State private var habit: String = ""
    @State private var date: Date = Date.now
    @State private var imageData: [Data] = []
    
    @State private var selectedImages = [Image]()
    @State private var pickerItems = [PhotosPickerItem]()
    
    var activities: Activities
    
    var body: some View {
        NavigationStack {
            Form {
                Section("Add a name for your habit") {
                    TextField("Name", text: $name)
                }
                
                Section("Pick a category and habit") {
                    Picker("Category", selection: $category) {
                        ForEach(habitCategories, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.menu)
                    
                    Picker("Habit", selection: $habit) {
                        ForEach(Array(habitSymbols.keys), id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.navigationLink)
                }
                
                Section("Describe what you did") {
                    TextField("Write a short description", text: $description, axis: .vertical)
                }
                
                Section("Choose when did you do this") {
                    HStack(spacing: 20) {
                        Text("When did you do this?")
                        DatePicker("Select the date", selection: $date, displayedComponents: .date)
                            .labelsHidden()
                    }
                }
                
                Section("Add photos related to your activity") {
                    PhotosPicker(selection: $pickerItems) {
                        if selectedImages.count > 0 {
                            ScrollView(.vertical) {
                                LazyVStack(spacing: 15) {
                                    ForEach(0..<selectedImages.count, id: \.self) { i in
//                                        ZStack {
                                            selectedImages[i]
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(Rectangle())
                                                .frame(maxWidth: .infinity)
//                                        }
//                                        .containerRelativeFrame(.vertical)
//                                        .clipShape(RoundedRectangle(cornerRadius: 32))
                                    }
                                }
                            }
                        } else {
                            ContentUnavailableView("No photos", systemImage: "photo.badge.plus", description: Text("Tap to add photos"))
                        }
                    }
                    .buttonStyle(.plain)
                }
                .onChange(of: pickerItems) {
                    handleImageSelection()
                }
            }
            .navigationTitle("Add new activity")
            .toolbar {
                Button("Add") {
                    let activity = Activity(name: name, category: category, description: description, habit: habit, activityDate: date, iconName: habitSymbols[habit]!, activityImages: imageData)
                    
                    activities.activities.append(activity)
                    dismiss()
                }
            }
        }
    }
    
    func handleImageSelection() {
        Task {
            for item in pickerItems {
                guard let imageData = try? await item.loadTransferable(type: Data.self) else { return }
                if let loadedImage = try await item.loadTransferable(type: Image.self) {
                    selectedImages.append(loadedImage)
                    self.imageData.append(imageData)
                }
            }
        }
    }
}

#Preview {
    AddActivityView(activities: Activities())
}
