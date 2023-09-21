title: PIV in YubiKey
date: 2023-09-12
----
One of many YubiKeys' functions is PIV. PIV stands for Personal Identity Verification,
but nobody relaly cares.

As usual, the following description is simplified to the maximum extent possible.

Yubikey PIV allows one to do sign/verify/encrypt/decrypt operations on stored keys. These
keys may be RSA1024, RSA2048, ECC P-256 or ECC P-384.

There are 25 slots for keys:
- 1 slot for authentication (signing) FIXME authentication of what?
- 1 slot for signing documents
- 1 slot for encrypting documents
- 1 slot for physical access (signing)
- 1 slot for attestation (attesting that keys are produced on the device)
- 20 slots for rotated keys (decrypting old encrypted documents)

The operations are available to the host via CCID protocol.

## References

- [Yubico PIV Tool](https://developers.yubico.com/yubico-piv-tool/YubiKey_PIV_introduction.html)
- [PIV Attestation](https://developers.yubico.com/PIV/Introduction/PIV_attestation.html)
