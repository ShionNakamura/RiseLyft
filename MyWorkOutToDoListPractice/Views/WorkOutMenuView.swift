import SwiftUI

struct WorkOutMenuView: View {
    @EnvironmentObject var listViewModel: ListViewModel
    @Environment(\.presentationMode) var presentationMode // To pop back to the previous view
    
    @State private var selectedCategory: String? = nil
    @State private var checkMarks: [String: Bool] = [:]
    @State private var selected: Date = Date()
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                NavigationLink(destination: AddView()) {
                    Text("自分でトレーニングメニューを作る")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .cornerRadius(10)
                        .padding(.horizontal)
                }
                
                Spacer()
                
                List {
                    ForEach(ItemModel.workoutCategories.keys.sorted(), id: \.self) { category in
                        Section {
                            HStack {
                                Text(category)
                                    .fontWeight(.bold)
                                Spacer()
                                Button {
                                    withAnimation {
                                        selectedCategory = (selectedCategory == category) ? nil : category
                                    }
                                } label: {
                                    withAnimation {
                                        Image(systemName: selectedCategory == category ? "chevron.down" : "chevron.right")
                                    }
                                }
                            }
                            .onTapGesture {
                                withAnimation {
                                    selectedCategory = (selectedCategory == category) ? nil : category
                                }
                            }
                            // inside
                            if selectedCategory == category {
                                if let exercises = ItemModel.workoutCategories[category] {
                                    ForEach(exercises, id: \.self) { exercise in
                                        HStack {
                                            Image(systemName: checkMarks[exercise] == true ? "circle.fill" : "circle")
                                                .foregroundStyle(checkMarks[exercise] == true ? .blue.opacity(0.5) : .gray)
                                            Text(exercise)
                                                .padding(.leading, 20)
                                                .foregroundColor(.gray)
                                        }
                                        .onTapGesture {
                                            checkMarks[exercise, default: false].toggle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                .listStyle(PlainListStyle())

                NavigationLink(destination: WorkOutConfirmationView()) {
                                   Text("トレーニング種目を確認する")
                                       .font(.headline)
                                       .foregroundColor(.white)
                                       .padding()
                                       .frame(maxWidth: .infinity)
                                       .background(Color.green)
                                       .cornerRadius(10)
                                       .padding(.horizontal)
                               }
                               .simultaneousGesture(TapGesture().onEnded {
                                   saveExercises() // Save exercises before navigating
                               })

                Spacer()
            }
            .navigationTitle("Workout Menu")
        }
    }

    private func saveExercises() {
        let selectedExercises = checkMarks.filter { $0.value }.map { $0.key }
        // Add each selected exercise to the ListViewModel
        for exercise in selectedExercises {
            let newItem = ItemModel(title: exercise, isCompleted: false, date: Date(),setCount: 1) // Customize if needed
            listViewModel.addItem(newItem)
        }
    }
}



#Preview {
    NavigationStack {
        WorkOutMenuView()
    }
    .environmentObject(ListViewModel())
}

