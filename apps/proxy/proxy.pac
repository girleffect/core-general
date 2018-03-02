function FindProxyForURL(url, host) {
    PROXY = "PROXY localhost:3128"

    // Docker containers via proxy
    if (isInNet(host, "172.18.0.0", "255.255.255.0")) return PROXY;

    // Everything else directly!
    return "DIRECT";
}
