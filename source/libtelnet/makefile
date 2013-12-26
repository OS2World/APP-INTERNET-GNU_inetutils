TYPE		= LIBA
SRC 		= auth enc_des encrypt genget getent kerberos kerberos5 krb4encpwd \
		  misc read_password rsaencpwd spx
PROG		= libtelnet
CFLAGS		= -I../include -I../headers -I../bsd-h 
CFLAGS		+= -DHAVE_TERMIO_H -DHAVE_TERMIOS_H -DHAVE_MALLOC_H -DHAVE_NETINET_IP_H \
		   -DHAVE_NETINET_IN_SYSTM_H -DHAS_GETTOS \
		   -DNO_CC_T -DRETSIGTYPE=void -Dstrncasecmp=strnicmp -Dunix \
                   -DTERMCAP -DENV_HACK 
LFLAGS		= -lsocket
ALLWARNINGS	= N
WARNERR		= N
NICE		= N
DEBUG		= N
OPTIMIZE	= Y

.INCLUDE: "../std.mk"
