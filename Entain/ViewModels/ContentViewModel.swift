//
//  ContentViewModel.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 08/12/23.
//

import SwiftUI
import Combine

@MainActor class ContentViewModel: ObservableObject {

    @Published var races = [RaceSummary]()
    @Published var selectedRaceCategories = [RaceCategory]()

    private var nextToGoIds = [String]()
    private var raceSummaries = [String: RaceSummary]()

    private var fetchCount = 5
    private var removeExpiredWorkItem: DispatchWorkItem?

    private var model = NextRaceNetworkModel()
    private var cancellables = Set<AnyCancellable>()
    private let networkManager: NetworkManagable

    init(networkManager: NetworkManagable) {
        self.networkManager = networkManager
    }

    /*
     This method fetches the races from the API via GET method.
     */
    func fetchRaces() async {
        model.fetchCount = fetchCount
        await networkManager.send(model) { [weak self] (result: Result<RaceData, Error>) in
            switch result {
            case .success(let raceData):
                self?.handleRaceData(raceData)
            case .failure(let error):
                print(error)
            }
        }
    }

    /*
     This method fetches the races from the API via GET method using publishers.
     */
    func fetchRacesUsingPublisher() {
        model.fetchCount = fetchCount
        networkManager.getData(model)
            .sink { error in
                print(error)
            } receiveValue: { [weak self] (raceData: RaceData) in
                self?.handleRaceData(raceData)
            }
            .store(in: &cancellables)
    }

    func handleRaceData(_ data: RaceData) {
        nextToGoIds = data.nextToGoIDS
        raceSummaries = data.raceSummaries
        updateRaces()
    }

    /*
     This method handles selection of Race Category.
     */
    func selectCategory(_ category: RaceCategory) {
        selectedRaceCategories.contains(category) ? selectedRaceCategories.removeAll(where: { $0 == category }) : selectedRaceCategories.append(category)
        updateRaces()
    }

    /*
     This method handles filtering and displaying the races according to selected category and expiry.
     */
    private func updateRaces() {
        withAnimation {
            races = Array(nextToGoIds
                .compactMap({ raceSummaries[$0] })
                .filter({ selectedRaceCategories.isEmpty ? true : selectedRaceCategories.contains($0.categoryID) })
                .filter({ Int($0.advertisedStart.seconds) - Int(Date().timeIntervalSince1970) > -60 })
                .prefix(5)
            )
        }
        if races.count < 5 {
            fetchCount += 5 - races.count
            Task {
                await fetchRaces()
            }
        } else {
            removeExpiredRaces()
        }
    }

    /*
     This method handles removal of races after expiry.
     */
    private func removeExpiredRaces() {
        guard let firstRace = races.first else { return }
        let secondsTillExpiry = Int(firstRace.advertisedStart.seconds) + 60 - Int(Date().timeIntervalSince1970)
        if secondsTillExpiry > 0 {
            updateRacesAfter(secondsTillExpiry)
        } else {
            updateRaces()
        }
    }

    /*
     This method calls update races after seconds.

     - Parameter seconds: The number seconds to wait before
     */
    private func updateRacesAfter(_ seconds: Int) {
        removeExpiredWorkItem?.cancel()
        removeExpiredWorkItem = DispatchWorkItem { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.updateRaces()
            }
        }
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + Double(seconds), execute: removeExpiredWorkItem!)
    }

    /* This method is the modern approach but is not being used due to some inconsistencies found during testing.
    private func updateRacesUsingTaskAfter(_ seconds: Int) {
        Task {
            do {
                let nanoseconds = UInt64(seconds) * 1_000_000_000
                try await Task.sleep(nanoseconds: nanoseconds)
                updateRaces()
            } catch {
                print(error)
            }
        }
    }
    */
}

struct NextRaceNetworkModel: NetworkModel {
    var fetchCount = 0
    var url: URL { URL(string: "https://api.neds.com.au/rest/v1/racing/?method=nextraces&count=\(fetchCount)")! }
}
