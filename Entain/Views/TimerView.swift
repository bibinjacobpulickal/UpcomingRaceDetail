//
//  TimerView.swift
//  Entain
//
//  Created by Bibin Jacob Pulickal on 11/12/23.
//

import SwiftUI

/*
 This is the timer view that shows a countdown timer.
 */

struct TimerView: View {

    var seconds: Double

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { _ in
            HStack(spacing: 0) {
                Text(Date(timeIntervalSince1970: seconds) > Date() ? "" : "-")
                Text(Date(timeIntervalSince1970: seconds), style: .timer)
                    .accessibilityLabel("\(seconds) seconds to expire")
            }
            .frame(width: 64, height: 64)
            .background(Date(timeIntervalSince1970: seconds) > Date() ? .orange : .red)
            .cornerRadius(8)
        }
    }
}

struct TimerViewPreview: PreviewProvider {
    static var previews: some View {
        TimerView(seconds: Date().timeIntervalSince1970)
            .previewLayout(.sizeThatFits)
    }
}
