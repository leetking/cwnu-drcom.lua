#ifndef _EAPOL_H
#define _EAPOL_H

#include "type.h"

#ifndef _WINDOWS
# include <netinet/if_ether.h>
#else
# define ETH_ALEN	(6)
#endif

#define IDEN_LEN	UNAME_LEN

#define TRY_TIMES	(7)
#define TIMEOUT		(3)

/* 最多16个接口 */
#define IFS_MAX		(16)

/* ethii层取0x888e表示上层是8021.x */
#define ETHII_8021X	(0x888e)

#define EAPOL_VER		(0x01)
#define EAPOL_PACKET	(0x00)
#define EAPOL_START		(0x01)
#define EAPOL_LOGOFF	(0x02)
/* 貌似请求下线的id都是这个 */
#define EAPOL_LOGOFF_ID	(255)

#define EAP_CODE_REQ	(0x01)
#define EAP_CODE_RES	(0x02)
#define EAP_CODE_SUCS	(0x03)
#define EAP_CODE_FAIL	(0x04)
#define EAP_TYPE_IDEN	(0x01)
#define EAP_TYPE_MD5	(0x04)


#pragma pack(1)
/* ethii 帧 */
/* 其实这个和struct ether_header是一样的结构 */
typedef struct {
	uchar dst_mac[ETH_ALEN];
	uchar src_mac[ETH_ALEN];
	uint16 type;		/* 取值0x888e，表明是8021.x */
}ethII_t;
/* eapol 帧 */
typedef struct {
	uchar ver;			/* 取值0x01 */
	/*
	 * 0x00: eapol-packet
	 * 0x01: eapol-start
	 * 0x02: eapol-logoff
	 */
	uchar type;
	uint16 len;
}eapol_t;
/* eap报文头 */
typedef struct {
	/*
	 * 0x01: request
	 * 0x02: response
	 * 0x03: success
	 * 0x04: failure
	 */
	uchar code;
	uchar id;
	uint16 len;
	/*
	 * 0x01: identity
	 * 0x04: md5-challenge
	 */
	uchar type;
}eap_t;
/* 报文体 */
#define MD5_SIZE	16
typedef union {
	uchar identity[IDEN_LEN];
	struct {
		uchar _size;
		uchar _md5value[MD5_SIZE];
		uchar _exdata[STUFF_LEN];
	}md5clg;
}eapbody_t;
#define md5size		md5clg._size
#define md5value	md5clg._md5value
#define md5exdata	md5clg._exdata
#pragma pack()

/*
 * eap认证
 * uname: 用户名
 * pwd: 密码
 * sucess_handle: 认证成功之后调用下一步认证
 * args: sucess_handle需要的参数
 * 如果不需要继续认证，sucess_handle为NULL
 * 如果sucess_handle不需要参数，args为NULL
 * @return: 0: 成功
 *          1: 用户不存在
 *          2: 密码错误
 *          3: 其他超时
 *          4: 服务器拒绝请求登录
 *          -1: 没有找到合适网络接口
 *          -2: 没有找到服务器
 */
int eaplogin(char const *uname, char const *pwd,
		int (*sucess_handle)(void const*), void const *args);
/*
 * eap下线
 */
int eaplogoff(void);
/*
 * eap重新登录
 */
int eaprefresh(char const *uname, char const *pwd,
		int (*sucess_handle)(void const*), void const *args);
/*
 * 用来设置ifname
 */
void setifname(char *ifname);
#endif
