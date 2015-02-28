#!/usr/bin/python
import re, sys, subprocess, conf

def decrypt(passphrase, infile, outfile):
    with open(outfile, 'w') as ofh:
        p = subprocess.Popen(['gpg', '-q', '--batch',
                              '--passphrase', passphrase,
                              '-d', infile], stdout=ofh)
        if p.wait() != 0:
            raise RuntimeError('gpg --decrypt finished with exit code '
                               + p.returncode)
    sys.stdout.write('Decrypted {0} succesfully\n'.format(outfile))

def get_secret_parts(infh, nreq, nparts):
    parts = {}
    for line in infh:
        r = re.match(r'^(\d+)\. splitPasswd = ([0-9a-f]+) *\n$', line)
        if r:
            n = int(r.group(1))
            v = r.group(2)
            if n < 1 or n > nparts:
                raise RuntimeError('Errorneous part, should be 1..{0}: {1}'
                                   .format(nparts, line))
            if n in parts:
                raise RuntimeError('Duplicate part: {0}'.format(line))
            parts[n] = v
    if len(parts) < nreq:
        raise RuntimeError('Not enough parts. Supplied: {1}. Required: {2}'
                           .format(len(parts), nreq))
    ret = []
    for i in range(1, nparts+1):
        ret.append(parts.get(i, 'NULL'))
    return ret

def get_passphrase(parts):
    p = subprocess.Popen(['ssss-join-passwd', '-q'] + parts,
                        stdout=subprocess.PIPE, stderr=None)
    out, err = p.communicate()
    if p.returncode != 0:
        raise RuntimeError('ssss-join-passwd finished with exit code '
                           +p.returncode)
    return out.rstrip()

passphrase = get_passphrase(get_secret_parts(sys.stdin,
                                             conf.REQUIRED, conf.PARTS))

decrypt(passphrase, conf.GPG_KEY+'.key.gpg', conf.GPG_KEY+'.key')
decrypt(passphrase, conf.SSH_KEY+'.gpg', conf.SSH_KEY)
