import SwiftUI

struct CreditCardView: View {
    let card: ChatResponseContent.CardInfo

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            AsyncImage(url: URL(string: card.image_url)) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                Color.gray.frame(height: 140)
            }

            Text(card.title).bold().font(.headline)


            Text(card.descriptions).font(.subheadline)
            
            HStack {
                Link("Learn More", destination: URL(string: card.learn_more_url)!)
                Spacer()
                Link("Apply Now", destination: URL(string: card.apply_now_url)!)
            }
            .font(.footnote)
            .padding(.top, 5)
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 4)
    }
}
