#include <stdio.h>

int main()
{
    FILE* in = fopen("/dev/zero", "rb");
    FILE* out = fopen("/dev/null", "wb");
    char buf[4096];
    int i;
    for(i = 0; i < 256000; ++i)
    {
        fread(buf, 4096, 1, in);
        fwrite(buf, 4096, 1, out);
    }
    fclose(out);
    fclose(in);
    return 0;
}
