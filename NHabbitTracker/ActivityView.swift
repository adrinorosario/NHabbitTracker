//
//  ActivityView.swift
//  NHabbitTracker
//
//  Created by Adrino Rosario on 17/11/24.
//

import SwiftUI
import PhotosUI

struct ActivityView: View {
    
    @State private var selectedImages = [Image]()
    @State private var pickerItems =  [PhotosPickerItem]()
    
    var activity: Activity
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                HStack(spacing: 100) {
                    VStack(alignment: .leading) {
                        Text("Habit: \(activity.habit)")
                        Text("Category: \(activity.category)")
                    }
                    VStack {
                        Text("\(activity.activityDate.formatted(date: .abbreviated, time: .omitted))")
                    }
                }
                
                Spacer()
                
                Text(activity.description ?? "No description available")
                
                Spacer()
                
                VStack {
                    if activity.activityImages.count > 0 {
                        Text("Photos related to your activity: ")
                            .font(.headline)
                        
                        ScrollView(.horizontal) {
                            LazyHStack(spacing: 15) {
                                ForEach(0..<activity.activityImages.count, id: \.self) { i in
                                    
                                    ZStack {
                                        if let uiImage = UIImage(data: activity.activityImages[i]) {
                                            Image(uiImage: uiImage)
                                                .resizable()
                                                .scaledToFit()
                                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                                .scrollTransition(axis: .horizontal) {
                                                    content, phase in
                                                    return content
                                                        .offset(x: phase.value * -250)
                                                }
                                        }
                                    }
                                    .containerRelativeFrame(.horizontal)
                                    .clipShape(RoundedRectangle(cornerRadius: 32))
                                }
                            }
                        }
                    } else {
                        PhotosPicker(selection: $pickerItems) {
                            if selectedImages.count > 0 {
                                ScrollView(.horizontal) {
                                    LazyHStack(spacing: 15) {
                                        ForEach(0..<selectedImages.count, id: \.self) { i in
                                            ZStack {
                                                selectedImages[i]
                                                    .resizable()
                                                    .scaledToFit()
                                                    .clipShape(.rect(cornerRadius: 20))
                                                    .scrollTransition(axis: .horizontal) {
                                                        content, phase in
                                                        return content
                                                            .offset(x: phase.value * -250)
                                                    }
                                            }
                                            .containerRelativeFrame(.horizontal)
                                            .clipShape(RoundedRectangle(cornerRadius: 32))
                                        }
                                    }
                                }
                            } else {
                                ContentUnavailableView("No pictures", systemImage: "photo.badge.plus", description: Text("Tap to add photos"))
                            }
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 380, height: 380)
                .onChange(of: pickerItems) {
                    Task {
                        selectedImages.removeAll()
                        
                        for item in pickerItems {
                            if let loadedImage = try await item.loadTransferable(type: Image.self) {
                                selectedImages.append(loadedImage)
                            }
                        }
                    }
                }
                
                Spacer()
                
            }
            .navigationTitle(activity.name)
        }
    }
}

#Preview {
    ActivityView(activity: Activity(name: "Cooking", category: "Leisure", description: "Just cooking", habit: "Cooking", activityDate: Date.now,  iconName: "Cooking"))
}
