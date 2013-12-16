with open('/dev/zero', 'rb') as in_:
    with open('/dev/null', 'wb') as out:
        for i in range(256000):
            out.write(in_.read(4096))
