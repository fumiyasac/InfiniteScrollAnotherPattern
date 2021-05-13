# InfiniteScrollAnotherPattern
[ING] - UICollectionViewの性質を活用した無限循環スクロールの実装の別パターン実装サンプル

以前にもこちらで[UICollectionViewの性質を活用した無限循環スクロール](https://qiita.com/fumiyasac@github/items/af4fed8ea4d0b94e6bc4)に関する実装解説をしましたが、この方法とは別の方法で実装したサンプルを自分なりに紐解いた上で再度実装を試みてみたサンプルになります。

### 本サンプルの画面キャプチャ

<img height="300" src="https://user-images.githubusercontent.com/949561/118068410-4ca5a300-b3dd-11eb-9af7-bc67064e8c61.png"> <img height="300" src="https://user-images.githubusercontent.com/949561/118068417-4fa09380-b3dd-11eb-9a52-44fd37c7026a.png">

※ このサンプルは必要最低限の機能のみを実装したものになっています。

### 今回の実装において参考にした記事＆リポジトリ

このUIサンプルの実装にあたっては下記資料を参考にしています。
また、今回の処理に関しては`UIScrollViewDelegate`の処理のハンドリング及び位置調整に関する処理に注目するとイメージが掴みやすいかと思います。

__【参考1】__
- 元記事: https://qiita.com/MoeTakeuchi0401/items/d2a75c6d3db59e5673f5
- 元リポジトリ: https://github.com/MoeTakeuchi0401/LoopPageDemo

__【参考2】__
- 元記事: https://qiita.com/HirotoshiKawauchi/items/92bccea0fcd4468e59a0
- 元リポジトリ: https://github.com/HirotoshiKawauchi/InfinitePaging
