//
//  HomeView.swift
//  NHabbitTracker
//
//  Created by Adrino Rosario on 18/11/24.
//

import SwiftUI

struct HomeView: View {
    
    @State private var activities = Activities()
    @State private var showingAddActivities: Bool = false
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    ForEach(activities.activities, id: \.id) { activity in
                        NavigationLink {
                            ActivityView(activity: activity)
                        } label: {
                            RoundedRectangle(cornerRadius: 24)
                                .fill(.blue)
                                .frame(height: 100)
                                .overlay {
                                    VStack(alignment: .leading) {
                                        HStack(spacing: 30) {
                                            Image(systemName: activity.iconName)
                                                .resizable()
                                                .scaledToFit()
                                                .frame(width: 60, height: 60)
                                                .foregroundStyle(.white)
                                            
                                            VStack {
                                                Text(activity.name)
                                                    .font(.title)
                                                    .foregroundStyle(.white)
                                                    .fontWeight(.medium)
                                                
                                                Text("\(activity.activityDate.formatted(date: .abbreviated, time: .omitted))")
                                                    .font(.subheadline)
                                                    .foregroundStyle(.white)
                                            }
                                        }
                                    }
                                }
                                .visualEffect { content, proxy in
                                    content
                                        .hueRotation(Angle(degrees: proxy.frame(in: .global).origin.y / 10
                                        ))
                                }
                        }
                    }
                    .onDelete(perform: deleteActivity)
                }
            }
            .navigationTitle("Habbit Tracker")
            .preferredColorScheme(.dark)
            .toolbar {
                Button("Add new activity", systemImage: "plus.circle.fill") {
                    showingAddActivities.toggle()
                }
                .sheet(isPresented: $showingAddActivities) {
                    AddActivityView(activities: activities)
                }
            }
        }
    }
    
    func deleteActivity(at offsets: IndexSet) {
        for offset in offsets {
            activities.activities.remove(at: offset)
        }
    }
}

#Preview {
    HomeView()
}
