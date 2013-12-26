#include <stdarg.h>
#include <stdio.h>

void warnx(char *msg,...)
{
    va_list arg;
    va_start(arg,msg);
    vfprintf(stderr,msg,arg);
    va_end(arg);
    fprintf(stderr,"\n");
}

void warn(char *msg,...)
{
    va_list arg;
    va_start(arg,msg);
    vfprintf(stderr,msg,arg);
    va_end(arg);
    fprintf(stderr,"\n");
}

void errx(int rc,char *msg,...)
{
    va_list arg;
    va_start(arg,msg);
    vfprintf(stderr,msg,arg);
    va_end(arg);
    fprintf(stderr,"\n");
    exit(rc);
}
 
