TYPE		= VIO
SRC 		= authenc commands main network ring sys_bsd telnet terminal tn3270 utilities
PROG		= telnet
CFLAGS		= -I../include -I../headers -I../bsd-h 
CFLAGS		+= -DHAVE_TERMIO_H -DHAVE_TERMIOS_H -DHAVE_MALLOC_H -DHAVE_NETINET_IP_H \
		   -DHAVE_NETINET_IN_SYSTM_H -DHAS_GETTOS \
		   -DNO_CC_T -DRETSIGTYPE=void -Dstrncasecmp=strnicmp -Dunix \
                   -DTERMCAP -DENV_HACK 
LFLAGS		= -lsocket -lcurses \
                  -L../libtelnet -llibtelnet \
                  -L../libinetutils -llibinetutils
ALLWARNINGS	= N
WARNERR		= N
NICE		= N
DEBUG		= N
OPTIMIZE	= Y

MAXPROCESS	= 1

.INCLUDE: "../std.mk"
