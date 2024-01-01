//
//  CategorySelectorView.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 11/12/23.
//

import SwiftUI

/*
 This is the category selector view for selecting the race category.
 */
struct CategorySelectorView: View {

    var selectedCategories: [RaceCategory]
    var completion: ((RaceCategory) -> Void)

    var body: some View {
        HStack(spacing: 0) {
            ForEach(RaceCategory.allCases, id: \.rawValue) { category in
                Button {
                    completion(category)
                } label: {
                    VStack(spacing: 0) {
                        Image(category.name)
                            .resizable()
                            .renderingMode(.template)
                            .aspectRatio(contentMode: .fit)
                            .tint(selectedCategories.contains(category) ? .orange : .black)
                            .frame(width: 50)
                        Rectangle()
                            .foregroundColor(selectedCategories.contains(category) ? .orange : .black)
                            .frame(height: 6)
                    }
                    .background(selectedCategories.contains(category) ? .black : .orange)
                }
            }
        }
        .accessibilityLabel("Category Selector")
    }
}

struct CategorySelectorView_Preview: PreviewProvider {
    static var previews: some View {
        CategorySelectorView(
            selectedCategories: [],
            completion: { _ in }
        )
        .previewLayout(.sizeThatFits)
    }
}
