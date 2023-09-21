# YubiKey

YubiKey contains several applications.

All applications are independent from each other (contain separate keys etc).

All these applications can be enabled/disabled separately.

## Applications

- OTP
- FIDO2/FIDO/U2F
- CCID ("Smart Card interface")
  - PIV
  - OATH
  - OpenPGP

### OTP

Exposed as USB keyboard.

Has two slots for credentials, each of them can be one of:

- Yubico OTP
- Static password
- HMAC-SHA1
- OATH-HOTP (not related to CCID/OATH)

These slots are activated by a specific gesture, configured on device.

#### Yubico OTP

https://developers.yubico.com/OTP/

Works for apps that have it integrated. Probably superseded by FIDO/U2F

#### Static password

Just spews out the password.

#### HMAC-SHA1

No clue how it works.

#### OATH-HOTP

No clue how it works.

### FIDO2/FIDO/U2F

Exposed as USB HID.

There is a single cryptographic key.

U2F in a nutshell:
- C>S "I'm John, here's my public key and a bunch of data I don't want to store"
- S>C "OK"
...
- C>S "I'm John"
- S>C "Here's challenge and your static data"
- C>S "Here's signed challenge"
- S>C "Welcome in"

FIDO2 is U2F + 25 "resident keys".

FIDO2 is only available in YubiKey 5 and later.

Not sure of the difference betwen FIDO and FIDO2.

Resident keys: website does not need to store anything except the public key.

WebAuthn uses FIDO2 protocols.

### PIV

Encrypt/decrypt/sign/verify operations on RSA1024/2048, ECC P-256/384.

There are 25 slots:

- 1 slot for authentication (signing)
- 1 slot for signing documents
- 1 slot for encrypting documents
- 1 slot for physical access (signing)
- 20 slots for rotated keys (decrypting old encrypted files)
- 1 slot for attestation (attesting that keys are produced on the device)

### OATH

32 slots for HOTP, TOTP

### OpenPGP

Encrypt/decrypt/sign/verify operations on RSA1024/2048/3072/4096 (no ECC?)

There are 3 slots:

- 1 slot for authentication
- 1 slot for signatures
- 1 slot for encryption
