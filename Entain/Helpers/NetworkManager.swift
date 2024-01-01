//
//  NetworkManager.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 31/12/23.
//

import Foundation
import Combine

protocol NetworkManagable {
    func send<T: Codable>(_ model: NetworkModel, completion: @escaping (Result<T, Error>) -> Void) async
    func getData<T: Codable>(_ model: NetworkModel) -> AnyPublisher<T, Error>
}

final class NetworkManager: NetworkManagable {

    func send<T: Codable>(_ model: NetworkModel, completion: @escaping (Result<T, Error>) -> Void) async {
        do {
            let (data, _) = try await URLSession.shared.data(from: model.url)
            let response = try JSONDecoder().decode(ContentModel<T>.self, from: data)
            DispatchQueue.main.async {
                completion(.success(response.data))
            }
        } catch {
            completion(.failure(error))
        }
    }

    func getData<T: Codable>(_ model: NetworkModel) -> AnyPublisher<T, Error> {
        URLSession.shared.dataTaskPublisher(for: model.url)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}

protocol NetworkModel {
    var url: URL { get }
}
