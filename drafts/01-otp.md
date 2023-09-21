title: Touch-triggered OTP in YubiKey
date: 2023-09-12
----
One of many YubiKeys' functions is touch-triggered one-time password that works in the following manner:
- YubiKey presents itself to a host computer as a keyboard.
- When a user touches a sensor, YubiKey emits one-time password to the host.

YubiKey has two slots for one-time passwords. Short touch activates one slot,
long touch activates another.

How is the one-time password generated? YubiKey supports 4 OTP protocols,
both slots can be independently configured to use one or another.

The following description is simplified to the maximum extent possible.
Actual protocols have all kinds of nonces, checksums, counters,
paddings and other gizmos to obtain the relevant security properties.
This description serves only to create a mental model of the protocols,
not to guide anyone to implement them.

## Yubico OTP

This protocol is developed by Yubico, and works with their servers.
Every YubiKey contains a unique AES key plus some data, stored by
Yubico during manufacturing.

Whenever user activates OTP, the following happens:
- The key emits a public ID and an AES-encrypted blob of data,
- Application forwards this blob to Yubico servers,
- Yubico checks the blob and returns verification result.

FIXME (selfhosted)

## OATH-HOTP

NB: YubiKey also provides OATH-HOTP application via CCID protocol. OATH-HOTP via OTP is a rudiment.

Whenever user activates OTP, the following happens:
- The key emits a HMAC-protected blob of data,
- Application forwards this blob to Yubico servers,
- Yubico checks the blob and returns verification result.

FIXME (selfhosted).

## Static password

Whenever user activates OTP, the key emits a static password.

FIXME (how to configure)

## Challenge-response

This protocol uses custom HID commands and is initiated by the host, so it is quite different from
other three OTP protocols. It works in the following way:
- A host sends a challenge to a key
- (Optionally) The key awaits user touch to activate OTP
- The key sends the response back to the host

There are two options for response calculation:
- HMAC-SHA1. The response is HMAC(SHA1(secret + challenge)).
- Yubico OTP. The response is AES(secret, challenge).

FIXME (how to configure)

## References

- [Touch-triggered OTP](https://developers.yubico.com/Developer_Program/Guides/Touch_triggered_OTP.html)
- [OTP Explained](https://developers.yubico.com/OTP/OTPs_Explained.html)
- [RFC 4226: HOTP](https://www.rfc-editor.org/rfc/rfc4226)
