import React from 'react';
import { NativeModules, Platform } from 'react-native';
const invariant = require('invariant');
const RNPayjpIOS = NativeModules.RNPayjpIOS;
const RNPayjpAndroid = NativeModules.RNPayjpAndroid;

let Payjp;

if (Platform.OS === 'ios') {
    invariant(RNPayjpIOS,
        'react-native-payjp: Import libraries to iOS "react-native link react-native-payjp');
    Payjp = RNPayjpIOS;
} else if (Platform.OS === 'android') {
    invariant(RNPayjpAndroid,
        'react-native-payjp: Import libraries to android "react-native link react-native-payjp"');
    Payjp = RNPayjpAndroid;
} else {
    invariant(Payjp, 'react-native-payjp: Invalid platform. This library only supports Android and iOS.');
}

const functions = [
    'setPublicKey',
    'createToken',
];

module.exports = {}
for (var i = 0; i < functions.length; i++) {
    module.exports[functions[i]] = Payjp[functions[i]];
}
