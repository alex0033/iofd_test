# iofd_test
rubyにおける、コンソール、ファイル、ディレクトリの入出力を確認するために作ってみたテストライブフレームワークです。

## 問題点
・絶対パスに影響を与えるプログラムのテストを実施すると、実際に起動してしまう。
・~~期待する入力値や出力値の値を間違えると無限ループに陥る。~~もしくは、言語仕様のエラー文が出力されるため、エラー要因の分かりにくさがある。

## 改善点
・RSpecのcontextのように、テストを階層化する機能の追加。
・ライブラリ化することで使いやすくする。

## 使い方
以下は現時点での使い方です。

### ①テストコマンド用のファイルを置く
「./iofd」をパスの通ったディレクトリに置きましょう。

### ②テスト関数が入ったファイルを置く
テストを実行したいディレクトリ(以後ホームディレクトリと呼ぶ)に「iofd_test」ディレクトリを作成します。その上で、「./iofd_test」を「iofd_test」に置きましょう。「./iofd_test/sample_iofd.rb」はテストのサンプルファイルなので削除してください。

### ③テストファイルを作る
まずは必要なファイルをrequireしましょう。
```rb
require './iofd_test/test_core.rb'
```
その上で、テストするファイルを設定しましょう。（"sample.rb"の箇所は、自分のテストしたいファイルパスを指定）
```rb
set_cmd "sample.rb"
```
具体的なテストは以下のように書きます。
```rb
iofd "new_file_eq" do |iofd|
    # ここで、テストに必要なデータをオブジェクト(iofd)に入力する
    iofd.io_contents = [
        { output: "what action: ", input: "mkfile" },
        { output: "file name: ", input: "test_file" },
    ]
    iofd.files = [
        { original: "output_files/test_file.output", comparison: "iofd_test/comparison_files/new_file.txt" }
    ]
    iofd # この一行は毎回忘れずに記述してください。
end
```
## テストの考え方
### データの意味
io_contents：コンソールにおけるアウトプットと自動インプットをデータ登録する

files：存在するべきファイルをデータ登録する

remove_files：存在するべきでないファイルをデータ登録する

directories：存在するべきディレクトリをデータ登録する

remove_directories：存在するべきでないディレクトリをデータ登録する

error_contents：エラーメッセージをデータ登録する

test_data：テストのみに使うデータを登録する
### データ形式
```rb
io_contents = [
    { output: "output1", input: "input" },
    { output: "output2", input: nil }
]
files = [
    { original: "path1", comparison: "path_a"},
    { original: "path2", comparison: "path_b"}
]
remove_files = ["path1", "path2"]
directories = ["path1", "path2"]
remove_directories = ["path1", "path2"]
error_contents = ["message1", "message2"]
test_data = {
    files: ["path1", "path2"], directories: ["path_a", "path_b"]
}
```
