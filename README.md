[![MIT License](http://img.shields.io/badge/license-MIT-blue.svg?style=flat)](LICENSE)

# react-native-payjp

[PAY.JP](https://pay.jp/) の [cardtoken](https://pay.jp/docs/cardtoken) を React Native アプリで使うためのコンポーネントです。
現在、Androidのみ対応。

## インストール方法

```
npm install --save react-native-payjp
```

パッケージをインストール後、次のコマンドを実行してください。

```
react-native link react-native-payjp
```

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

## 開発に参加する方法

ソースコードのコメント、GitHub のイシューやプルリクエストでは、日本語か英語を使用して下さい。

## ライセンス

MIT

## 作者

Sunao Kumura (sunao.kumura@gmail.com)