#!/usr/bin/env python
import re, sys, subprocess, getpass, uuid, conf
from OpenSSL import crypto

def encrypt(passphrase, content, outfile):
    with open(outfile, 'w') as ofh:
        p = subprocess.Popen(['gpg', '-q', '--batch', '--armor', '-c',
                              '--cipher-algo', 'TWOFISH', '--passphrase',
                              passphrase], stdin=subprocess.PIPE, stdout=ofh)
        p.communicate(content)
        if p.returncode != 0:
            raise RuntimeError('gpg --encrypt finished with exit code '
                               + p.returncode)

def ssh_export(filename):
    with open(filename) as fh:
        key = crypto.load_privatekey(crypto.FILETYPE_PEM, fh.read())
        return crypto.dump_privatekey(crypto.FILETYPE_PEM, key)

def gpg_export(keyid):
    p = subprocess.Popen(['gpg', '--armor', '--export-secret-key', keyid],
                         stdout=subprocess.PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        raise RuntimeError('gpg --export-secrete-key finished with exit code '
                           + p.returncode)
    return out

def split(passphrase, nreq, nparts):
    p = subprocess.Popen(['ssss-split-passwd', str(nparts), str(nreq),
                          passphrase], stdout=subprocess.PIPE)
    out, err = p.communicate()
    if p.returncode != 0:
        raise RuntimeError('ssss-split-passwd finished with exit code '
                           + p.returncode)
    parts = {}
    for line in out.split('\n'):
        r = re.match(r'^(\d+)\. splitPasswd = ([0-9a-f]+) *$', line)
        if r:
            parts[int(r.group(1))] = line
    return parts

def pwgen():
    return uuid.uuid4().hex

passphrase = pwgen()

encrypt(passphrase, gpg_export(conf.GPG_KEY), conf.GPG_KEY+'.key.gpg')
encrypt(passphrase, ssh_export(conf.SSH_KEY),
        os.path.basename(conf.SSH_KEY)+'.gpg')

shares = split(passphrase, conf.REQUIRED, conf.PARTS)

def get_elems(m, f, t):
    while f<t:
        yield m[f]
        f += 1

with open('message.txt') as fh:
    message = fh.read()

cur = 1
for bearer in conf.BEARERS:
    bearer_shares = '\n'.join(get_elems(shares, cur, cur + bearer['nshares']))
    print message.replace('@BEARER@', bearer['name']) \
                 .replace('@SHARES@', bearer_shares)
    print "-8<---"
    cur += bearer['nshares']

if cur != conf.PARTS + 1:
    print "Not all shares were distributed!"
    sys.exit(1)
