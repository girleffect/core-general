function FindProxyForURL(url, host) {
    PROXY = "PROXY localhost:3128"

    // Docker containers via proxy
    if (isInNet(host, "172.18.0.0", "255.255.255.0")) i
        return PROXY;

    // HTTP services
    if (shExpMatch(url, "http://wagtail-demo-*") || shExpMatch(url, "http://core-*"))
        return PROXY;

    // HTTPS services
    if (shExpMatch(url, "https://wagtail-demo-*") || shExpMatch(url, "https://core-*"))
        return PROXY;

    // Everything else directly!
    return "DIRECT";
}
