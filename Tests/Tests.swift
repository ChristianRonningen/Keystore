
import XCTest

import Keystore

class KeystoreTestCase: XCTestCase {
    let account = "account"
    let password = "password123"
    
    let keystore = Keystore(accessGroup: nil)
    
    override func tearDown() {
        super.tearDown()
        
        _ = keystore.deletePassword(for: account)
    }
    
    override func setUp() {
        super.setUp()
        
        _ = keystore.deletePassword(for: account)
    }
    
    func testSavePassword() {
        XCTAssertEqual(keystore.savePassword(password, for: account), KeystoreResult.success(nil))
        XCTAssertEqual(keystore.retrievePassword(for: account), KeystoreResult.success(password))
    }
    
    func testSaveEncryptedPassword() {
        XCTAssertEqual(keystore.encryptAndSavePassword(password, salt: Array("salt".utf8), for: account), KeystoreResult.success(nil))
        XCTAssertFalse(keystore.retrievePassword(for: account).isError)
    }
    
    func testSaveEmptyPasswordShouldReturnError() {
        XCTAssertEqual(keystore.savePassword("", for: account), KeystoreResult.error(-1))
    }
    
    func testSaveEmptyEncryptedPassword() {
        XCTAssertEqual(keystore.encryptAndSavePassword("", salt: nil, for: account), KeystoreResult.error(-1))
    }
}
