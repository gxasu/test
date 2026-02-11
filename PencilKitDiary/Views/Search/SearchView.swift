import SwiftUI

/// 検索画面 — キーワード検索 + ハッシュタグ絞り込み（UC 13-16）
struct SearchView: View {
    var diaryStore: DiaryStore
    @State private var searchText = ""
    @State private var searchResults: [DiaryEntry] = []
    @State private var selectedTag: String?
    @State private var allTags: [(name: String, count: Int)] = []

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // ハッシュタグ一覧（UC 11, 16）
                if !allTags.isEmpty && searchText.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 8) {
                            ForEach(allTags, id: \.name) { tag in
                                Button(action: { selectTag(tag.name) }) {
                                    HStack(spacing: 4) {
                                        Text("#\(tag.name)")
                                        Text("\(tag.count)")
                                            .font(.caption2)
                                            .foregroundStyle(.secondary)
                                    }
                                    .font(.caption)
                                    .padding(.horizontal, 10)
                                    .padding(.vertical, 6)
                                    .background(
                                        selectedTag == tag.name
                                            ? Color.accentColor.opacity(0.2)
                                            : Color(.systemGray5)
                                    )
                                    .clipShape(Capsule())
                                }
                            }
                        }
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                    }
                }

                // 検索結果リスト（UC 15）
                List(searchResults, id: \.date) { entry in
                    SearchResultRow(entry: entry)
                        .onTapGesture {
                            diaryStore.goToDate(entry.date)
                        }
                }
                .listStyle(.plain)
                .overlay {
                    if searchResults.isEmpty && !searchText.isEmpty {
                        ContentUnavailableView.search(text: searchText)
                    }
                    if searchResults.isEmpty && searchText.isEmpty && selectedTag == nil {
                        ContentUnavailableView(
                            "日記を検索",
                            systemImage: "magnifyingglass",
                            description: Text("キーワードまたはハッシュタグで検索できます")
                        )
                    }
                }
            }
            .navigationTitle("検索")
            .searchable(text: $searchText, prompt: "キーワードで検索")
            .onChange(of: searchText) { performSearch() }
            .onAppear { allTags = diaryStore.allHashtags() }
        }
    }

    // MARK: - 検索実行

    /// キーワード検索（UC 13）
    private func performSearch() {
        selectedTag = nil
        if searchText.isEmpty {
            searchResults = []
        } else {
            searchResults = diaryStore.searchByKeyword(searchText)
        }
    }

    /// ハッシュタグ選択（UC 14, 16）
    private func selectTag(_ name: String) {
        if selectedTag == name {
            selectedTag = nil
            searchResults = []
        } else {
            selectedTag = name
            searchText = ""
            searchResults = diaryStore.searchByHashtag(name)
        }
    }
}
