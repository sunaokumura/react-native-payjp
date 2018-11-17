[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

# react-native-payjp

[PAY.JP](https://pay.jp/) の [cardtoken](https://pay.jp/docs/cardtoken) を React Native アプリで使うためのコンポーネントです。

## インストール方法

```
npm install --save react-native-payjp
```

パッケージをインストール後、次のコマンドを実行してください。

```
react-native link react-native-payjp
```

続いて、iOSの場合は[Homebrew](https://brew.sh/index_ja)を使って、次のコマンドを実行し[Carthage](https://github.com/Carthage/Carthage)をインストールしてください。

```
brew install carthage
```

その後、ReactNativeプロジェクトフォルダー配下のnode_modules/react-native-payjp/ios/まで移動して次のコマンドを実行してください。
[PAY.JP iOS SDK Beta](https://github.com/payjp/payjp-ios)がダウンロードされビルドされます。

```
carthage update
```

以上でインストールの完了です。

## 使用方法

```
import Payjp from 'react-native-payjp';

class App extends Component {
    render() {
        //パブリックキーをセット
        Payjp.setPublicKey("pk_test_c62fade9d045b54cd76d7036");
        //トークンを作成
        Payjp.createToken(
            "4242424242424242", //カード番号
            "123",              //CVC
            "12",               //月
            "2020",             //年
            "TARO YAMADA")      //名前
            .then(res) {
                console.log("token:", res); //resに"error"かトークンの文字列が返ります。
            }
            ...
        }
        return (
            ...
        )
```

## ライセンス

MIT

## 作者

Sunao K