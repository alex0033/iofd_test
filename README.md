# iofd_test
rubyにおける、コンソール、ファイル、ディレクトリの入出力を確認するために作ってみたテストライブラリーっぽいやつです。

## 使い方（要変更）
現時点では、少し不便なので後ほど、変更していきます。

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
    test_file = "output_files/test_file.output"
    iofd.io_contents = [
        { output: "what action: ", input: "mkfile" },
        { output: "file name: ", input: "test_file" },
    ]
    iofd.files = [
        { original: test_file, comparison: "iofd_test/comparison_files/new_file.txt" }
    ]
    iofd # この一行は毎回忘れずに記述してください。
end
```
