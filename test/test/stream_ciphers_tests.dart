// Copyright (c) 2013, Iván Zaera Avellón - izaera@gmail.com  
// Use of this source code is governed by a LGPL v3 license. 
// See the LICENSE file for more information.

library cipher.test.test.stream_ciphers_tests;

import "dart:typed_data";

import "package:cipher/api.dart";

import "package:unittest/unittest.dart";

import "./helpers.dart";

void runStreamCipherTests( StreamCipher cipher, CipherParameters params, 
                     List<String> plainCipherTextPairs ) {
  
  group( "${cipher.algorithmName}:", () {

    group( "cipher  :", () { 
      
      for( var i=0 ; i<plainCipherTextPairs.length ; i+=2 ) {
        
        var plainText = plainCipherTextPairs[i];
        var cipherText = plainCipherTextPairs[i+1];

        test( "${formatAsTruncated(plainText)}", () =>
          _runStreamCipherTest( cipher, params, plainText, cipherText )
        );
        
      }
    });

    group( "decipher:", () { 
      
      for( var i=0 ; i<plainCipherTextPairs.length ; i+=2 ) {
      
        var plainText = plainCipherTextPairs[i];
        var cipherText = plainCipherTextPairs[i+1];
        
        test( "${formatAsTruncated(plainText)}", () =>
          _runStreamDecipherTest( cipher, params, cipherText, plainText )
        );
        
      }
    });
  
    group( "ciph&dec:", () {
      
      var plainText = createUint8ListFromSequentialNumbers(1024);
      test( "1KB of sequential bytes", () =>
        _runStreamCipherDecipherTest(cipher, params, plainText )
      );
      
    });
  
  });
  
}

void _resetCipher( StreamCipher cipher, bool forEncryption, CipherParameters params ) {
  cipher
    ..reset()
    ..init( forEncryption, params );
}

void _runStreamCipherTest( StreamCipher cipher, CipherParameters params, String plainTextString, String expectedHexCipherText ) {
  var plainText = createUint8ListFromString( plainTextString );

  _resetCipher( cipher, true, params );
  var cipherText = processStream( cipher, plainText );
  var hexCipherText = formatBytesAsHexString(cipherText);

  expect( hexCipherText, equals(expectedHexCipherText) );
}

void _runStreamDecipherTest( StreamCipher cipher, CipherParameters params, String hexCipherText, String expectedPlainText ) {
  var cipherText = createUint8ListFromHexString(hexCipherText);

  _resetCipher( cipher, false, params );
  var plainText = processStream( cipher, cipherText );

  expect( new String.fromCharCodes(plainText), equals(expectedPlainText) );
}

void _runStreamCipherDecipherTest( StreamCipher cipher, CipherParameters params, Uint8List plainText ) {

  _resetCipher( cipher, true, params );
  var cipherText = processStream( cipher, plainText );

  _resetCipher( cipher, false, params );
  var plainTextAgain = processStream( cipher, cipherText );

  expect( plainTextAgain, equals(plainText) );
  
}

