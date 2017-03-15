/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

#include "mozilla/net/DNS.h"

#include "mozilla/Assertions.h"
#include "mozilla/mozalloc.h"
#include "mozilla/ArrayUtils.h"
#include <string.h>

#ifdef XP_WIN
#include "ws2tcpip.h"
#endif

namespace mozilla {
namespace net {

const char *inet_ntop_internal(int af, const void *src, char *dst, socklen_t size)
{
#ifdef XP_WIN
  if (af == AF_INET) {
    struct sockaddr_in s;
    memset(&s, 0, sizeof(s));
    s.sin_family = AF_INET;
    memcpy(&s.sin_addr, src, sizeof(struct in_addr));
    int result = getnameinfo((struct sockaddr *)&s, sizeof(struct sockaddr_in),
                             dst, size, nullptr, 0, NI_NUMERICHOST);
    if (result == 0) {
      return dst;
    }
  }
  else if (af == AF_INET6) {
    struct sockaddr_in6 s;
    memset(&s, 0, sizeof(s));
    s.sin6_family = AF_INET6;
    memcpy(&s.sin6_addr, src, sizeof(struct in_addr6));
    int result = getnameinfo((struct sockaddr *)&s, sizeof(struct sockaddr_in6),
                             dst, size, nullptr, 0, NI_NUMERICHOST);
    if (result == 0) {
      return dst;
    }
  }
  return nullptr;
#else
  return inet_ntop(af, src, dst, size);
#endif
}

// Copies the contents of a PRNetAddr to a NetAddr.
// Does not do a ptr safety check!
void PRNetAddrToNetAddr(const PRNetAddr *prAddr, NetAddr *addr)
{
  if (prAddr->raw.family == PR_AF_INET) {
    addr->inet.family = AF_INET;
    addr->inet.port = prAddr->inet.port;
    addr->inet.ip = prAddr->inet.ip;
  }
  else if (prAddr->raw.family == PR_AF_INET6) {
    addr->inet6.family = AF_INET6;
    addr->inet6.port = prAddr->ipv6.port;
    addr->inet6.flowinfo = prAddr->ipv6.flowinfo;
    memcpy(&addr->inet6.ip, &prAddr->ipv6.ip, sizeof(addr->inet6.ip.u8));
    addr->inet6.scope_id = prAddr->ipv6.scope_id;
  }
#if defined(XP_UNIX)
  else if (prAddr->raw.family == PR_AF_LOCAL) {
    addr->local.family = AF_LOCAL;
    memcpy(addr->local.path, prAddr->local.path, sizeof(addr->local.path));
  }
#endif
}

// Copies the contents of a NetAddr to a PRNetAddr.
// Does not do a ptr safety check!
void NetAddrToPRNetAddr(const NetAddr *addr, PRNetAddr *prAddr)
{
  if (addr->raw.family == AF_INET) {
    prAddr->inet.family = PR_AF_INET;
    prAddr->inet.port = addr->inet.port;
    prAddr->inet.ip = addr->inet.ip;
  }
  else if (addr->raw.family == AF_INET6) {
    prAddr->ipv6.family = PR_AF_INET6;
    prAddr->ipv6.port = addr->inet6.port;
    prAddr->ipv6.flowinfo = addr->inet6.flowinfo;
    memcpy(&prAddr->ipv6.ip, &addr->inet6.ip, sizeof(addr->inet6.ip.u8));
    prAddr->ipv6.scope_id = addr->inet6.scope_id;
  }
#if defined(XP_UNIX)
  else if (addr->raw.family == AF_LOCAL) {
    prAddr->local.family = PR_AF_LOCAL;
    memcpy(prAddr->local.path, addr->local.path, sizeof(addr->local.path));
  }
#elif defined(XP_WIN)
  else if (addr->raw.family == AF_LOCAL) {
    prAddr->local.family = PR_AF_LOCAL;
    memcpy(prAddr->local.path, addr->local.path, sizeof(addr->local.path));
  }
#endif
}

bool NetAddrToString(const NetAddr *addr, char *buf, uint32_t bufSize)
{
  if (addr->raw.family == AF_INET) {
    if (bufSize < INET_ADDRSTRLEN) {
      return false;
    }
    struct in_addr nativeAddr = {};
    nativeAddr.s_addr = addr->inet.ip;
    return !!inet_ntop_internal(AF_INET, &nativeAddr, buf, bufSize);
  }
  else if (addr->raw.family == AF_INET6) {
    if (bufSize < INET6_ADDRSTRLEN) {
      return false;
    }
    struct in6_addr nativeAddr = {};
    memcpy(&nativeAddr.s6_addr, &addr->inet6.ip, sizeof(addr->inet6.ip.u8));
    return !!inet_ntop_internal(AF_INET6, &nativeAddr, buf, bufSize);
  }
#if defined(XP_UNIX)
  else if (addr->raw.family == AF_LOCAL) {
    if (bufSize < sizeof(addr->local.path)) {
      // Many callers don't bother checking our return value, so
      // null-terminate just in case.
      if (bufSize > 0) {
          buf[0] = '\0';
      }
      return false;
    }

    // Usually, the size passed to memcpy should be the size of the
    // destination. Here, we know that the source is no larger than the
    // destination, so using the source's size is always safe, whereas
    // using the destination's size may cause us to read off the end of the
    // source.
    memcpy(buf, addr->local.path, sizeof(addr->local.path));
    return true;
  }
#endif
  return false;
}

bool IsLoopBackAddress(const NetAddr *addr)
{
  if (addr->raw.family == AF_INET) {
    return (addr->inet.ip == htonl(INADDR_LOOPBACK));
  }
  else if (addr->raw.family == AF_INET6) {
    if (IPv6ADDR_IS_LOOPBACK(&addr->inet6.ip)) {
      return true;
    } else if (IPv6ADDR_IS_V4MAPPED(&addr->inet6.ip) &&
               IPv6ADDR_V4MAPPED_TO_IPADDR(&addr->inet6.ip) == htonl(INADDR_LOOPBACK)) {
      return true;
    }
  }
  return false;
}

bool IsIPAddrAny(const NetAddr *addr)
{
  if (addr->raw.family == AF_INET) {
    if (addr->inet.ip == htonl(INADDR_ANY)) {
      return true;
    }
  }
  else if (addr->raw.family == AF_INET6) {
    if (IPv6ADDR_IS_UNSPECIFIED(&addr->inet6.ip)) {
      return true;
    } else if (IPv6ADDR_IS_V4MAPPED(&addr->inet6.ip) &&
               IPv6ADDR_V4MAPPED_TO_IPADDR(&addr->inet6.ip) == htonl(INADDR_ANY)) {
      return true;
    }
  }
  return false;
}

bool IsIPAddrV4Mapped(const NetAddr *addr)
{
  if (addr->raw.family == AF_INET6) {
    return IPv6ADDR_IS_V4MAPPED(&addr->inet6.ip);
  }
  return false;
}

bool IsIPAddrLocal(const NetAddr *addr)
{
  MOZ_ASSERT(addr);

  // IPv4 RFC1918 and Link Local Addresses.
  if (addr->raw.family == AF_INET) {
    uint32_t addr32 = ntohl(addr->inet.ip);
    if (addr32 >> 24 == 0x0A ||    // 10/8 prefix (RFC 1918).
        addr32 >> 20 == 0xAC1 ||   // 172.16/12 prefix (RFC 1918).
        addr32 >> 16 == 0xC0A8 ||  // 192.168/16 prefix (RFC 1918).
        addr32 >> 16 == 0xA9FE) {  // 169.254/16 prefix (Link Local).
      return true;
    }
  }
  // IPv6 Unique and Link Local Addresses.
  if (addr->raw.family == AF_INET6) {
    uint16_t addr16 = ntohs(addr->inet6.ip.u16[0]);
    if (addr16 >> 9 == 0xfc >> 1 ||   // fc00::/7 Unique Local Address.
        addr16 >> 6 == 0xfe80 >> 6) { // fe80::/10 Link Local Address.
      return true;
    }
  }
  // Not an IPv4/6 local address.
  return false;
}

nsresult
GetPort(const NetAddr *aAddr, uint16_t *aResult)
{
  uint16_t port;
  if (aAddr->raw.family == PR_AF_INET) {
    port = aAddr->inet.port;
  } else if (aAddr->raw.family == PR_AF_INET6) {
    port = aAddr->inet6.port;
  } else {
    return NS_ERROR_NOT_INITIALIZED;
  }

  *aResult = ntohs(port);
  return NS_OK;
}

bool
NetAddr::operator == (const NetAddr& other) const
{
  if (this->raw.family != other.raw.family) {
    return false;
  } else if (this->raw.family == AF_INET) {
    return (this->inet.port == other.inet.port) &&
           (this->inet.ip == other.inet.ip);
  } else if (this->raw.family == AF_INET6) {
    return (this->inet6.port == other.inet6.port) &&
           (this->inet6.flowinfo == other.inet6.flowinfo) &&
           (memcmp(&this->inet6.ip, &other.inet6.ip,
                   sizeof(this->inet6.ip)) == 0) &&
           (this->inet6.scope_id == other.inet6.scope_id);
#if defined(XP_UNIX)
  } else if (this->raw.family == AF_LOCAL) {
    return PL_strncmp(this->local.path, other.local.path,
                      ArrayLength(this->local.path));
#endif
  }
  return false;
}

bool
NetAddr::operator < (const NetAddr& other) const
{
    if (this->raw.family != other.raw.family) {
        return this->raw.family < other.raw.family;
    } else if (this->raw.family == AF_INET) {
        if (this->inet.ip == other.inet.ip) {
            return this->inet.port < other.inet.port;
        } else {
            return this->inet.ip < other.inet.ip;
        }
    } else if (this->raw.family == AF_INET6) {
        int cmpResult = memcmp(&this->inet6.ip, &other.inet6.ip,
                               sizeof(this->inet6.ip));
        if (cmpResult) {
            return cmpResult < 0;
        } else if (this->inet6.port != other.inet6.port) {
            return this->inet6.port < other.inet6.port;
        } else {
            return this->inet6.flowinfo < other.inet6.flowinfo;
        }
    }
    return false;
}

NetAddrElement::NetAddrElement(const PRNetAddr *prNetAddr)
{
  PRNetAddrToNetAddr(prNetAddr, &mAddress);
}

NetAddrElement::NetAddrElement(const NetAddrElement& netAddr)
{
  mAddress = netAddr.mAddress;
}

NetAddrElement::~NetAddrElement() = default;

AddrInfo::AddrInfo(const char *host, const PRAddrInfo *prAddrInfo,
                   bool disableIPv4, bool filterNameCollision, const char *cname)
  : mHostName(nullptr)
  , mCanonicalName(nullptr)
  , ttl(NO_TTL_DATA)
{
  MOZ_ASSERT(prAddrInfo, "Cannot construct AddrInfo with a null prAddrInfo pointer!");
  const uint32_t nameCollisionAddr = htonl(0x7f003535); // 127.0.53.53

  Init(host, cname);
  PRNetAddr tmpAddr;
  void *iter = nullptr;
  do {
    iter = PR_EnumerateAddrInfo(iter, prAddrInfo, 0, &tmpAddr);
    bool addIt = iter &&
        (!disableIPv4 || tmpAddr.raw.family != PR_AF_INET) &&
        (!filterNameCollision || tmpAddr.raw.family != PR_AF_INET || (tmpAddr.inet.ip != nameCollisionAddr));
    if (addIt) {
        auto *addrElement = new NetAddrElement(&tmpAddr);
        mAddresses.insertBack(addrElement);
    }
  } while (iter);
}

AddrInfo::AddrInfo(const char *host, const char *cname)
  : mHostName(nullptr)
  , mCanonicalName(nullptr)
  , ttl(NO_TTL_DATA)
{
  Init(host, cname);
}

AddrInfo::~AddrInfo()
{
  NetAddrElement *addrElement;
  while ((addrElement = mAddresses.popLast())) {
    delete addrElement;
  }
  free(mHostName);
  free(mCanonicalName);
}

void
AddrInfo::Init(const char *host, const char *cname)
{
  MOZ_ASSERT(host, "Cannot initialize AddrInfo with a null host pointer!");

  ttl = NO_TTL_DATA;
  size_t hostlen = strlen(host);
  mHostName = static_cast<char*>(moz_xmalloc(hostlen + 1));
  memcpy(mHostName, host, hostlen + 1);
  if (cname) {
    size_t cnameLen = strlen(cname);
    mCanonicalName = static_cast<char*>(moz_xmalloc(cnameLen + 1));
    memcpy(mCanonicalName, cname, cnameLen + 1);
  }
  else {
    mCanonicalName = nullptr;
  }
}

void
AddrInfo::AddAddress(NetAddrElement *address)
{
  MOZ_ASSERT(address, "Cannot add the address to an uninitialized list");

  mAddresses.insertBack(address);
}

size_t
AddrInfo::SizeOfIncludingThis(MallocSizeOf mallocSizeOf) const
{
  size_t n = mallocSizeOf(this);
  n += mallocSizeOf(mHostName);
  n += mallocSizeOf(mCanonicalName);
  n += mAddresses.sizeOfExcludingThis(mallocSizeOf);
  return n;
}

} // namespace net
} // namespace mozilla
