//
//  ContentView.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 07/12/23.
//

import SwiftUI

/*
 This is the content view for the app.
 */
struct ContentView: View {

    @StateObject private var viewModel = ContentViewModel(networkManager: NetworkManager())

    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                CategorySelectorView(
                    selectedCategories: viewModel.selectedRaceCategories) { category in
                        viewModel.selectCategory(category)
                    }
                List {
                    Section {
                        ForEach(viewModel.races) { race in
                            HStack {
                                TimerView(seconds: race.advertisedStart.seconds)
                                Text("R\(race.raceNumber) \(race.meetingName)")
                                    .accessibilityLabel(Text("Race number \(race.raceNumber), Meeting Name \(race.meetingName)"))
                                Spacer()
                                Image(race.categoryID.name)
                                    .resizable()
                                    .renderingMode(.template)
                                    .foregroundColor(.orange)
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 36)
                                    .accessibilityLabel(Text("\(race.categoryID.name) Category"))
                            }
                            .accessibilityElement(children: .combine)
                        }
                    } header: {
                        Text("Next to Go")
                            .accessibilityAddTraits(.isHeader)
                    }
                }
                .task {
                    await viewModel.fetchRaces()
                }
            }
            .navigationTitle("Races")
            .toolbarBackground(.visible)
            .toolbarBackground(.orange)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
