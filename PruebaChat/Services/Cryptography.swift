//  Cryptography.swift
//  prueba
//
//  Created by Oscar Myerstone on 18/05/20.
//  Copyright © 2020 Oscar Myerston. All rights reserved.
//

import Foundation
import CryptoSwift

class Cryptography {
    
    /* Cifrado de Mensaje
       *  @param plainText tipo String
       *  @param secret_master tipo ByteArray
       *  @return cipherText tipo String y el ivHex tipo Hexadecimal
       * */
    @discardableResult
    func encrypted(_ plaintext: String, _ secret_master: Array<UInt8> ) -> [String] {
    
            // Generation of random iv
            let text = Array(plaintext.utf8)
            let iv = AES.randomIV(AES.blockSize)
            // Conversión de iv a Hexadecimal
            let ivstring = iv.toHexString()
            let ivarray = Array<UInt8>(hex: ivstring)
            print("ivArray: \(ivarray)")
            // let ivconvert = ivarray.toHexString()
            do {
                let gcm = GCM(iv: iv, mode: .combined)
                let aes = try AES(key: secret_master, blockMode: gcm, padding: .noPadding)
                let encrypted = try aes.encrypt(text)
                
                let rndEncryptedHex = encrypted.toHexString()
                // Call method to decrypt text
                let event:[String] = [rndEncryptedHex, ivstring]
                return event
            } catch {
                 print("Failed Encrypt\n")
                return [String]()
            }
    }
    
    /*
      * Descifrado de Mensaje
      * @param cipherText tipo String
      * @param secret_master tipo ByteArray
      * @param ivHex tipo Hexadecimal String, será decodificado a ByteArray
      * @return plainText tipo String
      * */
    func decrypted(_ textEncrypted: String, _ key:Array<UInt8>, _ iv:String) -> String {
        do {
            let ivToArrayUInt8  = Array<UInt8>(hex: iv)
            let textCipher =  Array<UInt8>(hex: textEncrypted)
            let gcm = GCM(iv: ivToArrayUInt8, mode: .combined)
            let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
            // Decrypting message to bytes:[UInt8]
            let decrypted = try aes.decrypt(textCipher)
            print("decryptedx: \(decrypted.toHexString())")
            // Convert message bytes: [UInt8] to plane text
            let text = String(bytes: decrypted, encoding: .utf8)
            if  (text != nil ) {
                print("Decrypted message, \(String(describing: text))\n")
            } else {
               print("not a valid UTF-8 sequence\n")
            }
            return text ?? ""
        } catch let error as NSError {
            // failed
            print("errorlocal \(error.localizedDescription)\n")
            print("domain \(error.domain)\n")
            print("Failed decrypt\n")
            return ""
        }
    }
        
      /*
      * Código para la key del random
      * return secret_rnd tipo [UInt8]
      **/
     func cryptRandom() -> [UInt8] {
          do {
             let codigo = "8d04ae74ef7a29e154ad56324a26985190d3cbc0c94b562b7566647db9c9e019"
             let secret_rnd = Array<UInt8>(hex: codigo)
             return secret_rnd
          } catch let error as NSError {
              print("errorlocal \(error.localizedDescription)")
              print("domain \(error.domain)")
              print("Failed decrypt")
              return []
          }
      }
        
    func genkeyPairs(random: Array<UInt8>) -> AxlSign.Keys {
           do {
               let keyPairs = axlsign.generateKeyPair(random)
               return keyPairs
           } catch let error as NSError  {
              // failed
               print("errorlocal \(error.localizedDescription)")
               print("domain \(error.domain)")
               print("Failed decrypt")
               return AxlSign.Keys(pk: [], sk: [])
        }

    }
    
    /* Cifrado de Random
      *  @param random tipo String
      *  @param secret_master tipo ByteArray
      *  @return Array [event tipo String y el ivstring tipo Hexadecimal]
      * */
    
    func encryptRandom(_ random: String, _ key: Array<UInt8>) -> [String] {
          do {
            let rnd = Array<UInt8>(hex: random)
            // Generation of random iv
               let iv = AES.randomIV(AES.blockSize)
               print("iv: \(iv)")
               // Conversión de iv a Hexadecimal
               let ivstring = iv.toHexString()
               
               print("ivstring: \(ivstring)")
               
               let ivarray = Array<UInt8>(hex: ivstring)
               print("ivArray: \(ivarray)")
               
               let ivconvert = ivarray.toHexString()
               print("ivconvert: \(ivconvert)")
                       
              let gcm = GCM(iv: iv, mode: .combined)
              let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
              let encrypted = try aes.encrypt(rnd)
              
              let rndEncryptedHex = encrypted.toHexString()
              print("rndEncryptedHex: \(rndEncryptedHex)")
              
              // Call method to decrypt text
              print("RandomEncryptar: \(encrypted)")
              print("key: \(key)")
              print("iv a RandomDecrypted: \(ivconvert)")
              let event:[String] = [rndEncryptedHex, ivstring]
              return event
          } catch let error as NSError {
              // failed
              print("errorlocal \(error.localizedDescription)")
              print("domain \(error.domain)")
              print("Failed decrypt")
              return [String]()
          }
    }
    
    /*
       * Descifrado de Mensaje
       * @param randomCipher tipo String
       * @param key tipo UInt8
       * @param iv tipo String
       * @return randomDecrypted tipo Hexadecimal
       * */
    func decryptRandom(_ randomCipher: String, _ key: [UInt8], _ iv:String) -> String {
           do {
                let ivx = Array<UInt8>(hex: iv)
                let random = strToArray(randomCipher)
                let gcm = GCM(iv: ivx, mode: .combined)
                let aes = try AES(key: key, blockMode: gcm, padding: .noPadding)
                // Decrypting random to bytes:[UInt8]
                let decrypted = try aes.decrypt(random)
                print("decryptedx: \(decrypted)")
                // Convert message bytes: [UInt8] to plane text
            let randomDecrypted = decrypted.toHexString()
            return randomDecrypted
           } catch let error as NSError {
               // failed
               print("errorlocal \(error.localizedDescription)")
               print("domain \(error.domain)")
               print("Failed decrypt")
               return ""
           }
    }
        
    /* Derivación del secreto maestro, llave secreta o privada y la pública de otro usuario
       *  @param secret_key como ByteArray
       *  @param publicKey como ByteArray
       * @ return secret_master
       * */
   func secret_master(secret_key: [UInt8],  publicKey: [UInt8]) -> [UInt8] {
       do {
        let secret_master = axlsign.sharedKey (secretKey : secret_key , publicKey : publicKey)
        return secret_master
       } catch let error as NSError {
           // failed
           print("errorlocal \(error.localizedDescription)")
           print("domain \(error.domain)")
           print("Failed decrypt")
           return []
       }
   }
}
