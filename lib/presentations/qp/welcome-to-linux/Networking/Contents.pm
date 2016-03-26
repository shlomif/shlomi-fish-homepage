package Contents;

use strict;

my $contents =
{
    'title' => "Networking in Linux Lecture",
    'subs' =>
    [
        {
            'url' => "goals.html",
            'title' => "Lecture Goals",
        },
        {
            'url' => "osi.html",
            'title' => "The OSI 7 Layers Model",
        },
        {
            'url' => "layer1",
            'title' => "Layer I - the Physical Layer",
            'subs' =>
            [
                {
                    'url' => "ethernet.html",
                    'title' => "Ethernet",
                },
                {
                    'url' => "dial-up.html",
                    'title' => "Dial-Up Modem Connection",
                },
                {
                    'url' => "cable-adsl.html",
                    'title' => "Cable TV/ADSL link",
                },
                {
                    'url' => "wifi.html",
                    'title' => "Wireless (WiFi)",
                },
            ],
        },
        {
            'url' => "layer2",
            'title' => "Layer II - the Data Link Layer",
            'subs' =>
            [
                {
                    'url' => "ppp.html",
                    'title' => "PPP",
                },
                {
                    'url' => "pptp-pppoe",
                    'title' => "VPN - PPTP, PPPoE and L2TP",
                    'subs' =>
                    [
                        {
                            'url' => "adsl.html",
                            'title' => "ADSL and Cable under Linux",
                        },
                        {
                            'url' => "dhcp.html",
                            'title' => "DHCP",
                        },
                        {
                            'url' => "pptp-l2tp.html",
                            'title' => "Back to Cable TV Connections...",
                        },
                    ],
                },
            ],
        },
        {
            'url' => "layer3",
            'title' => "Layer III - the Network Layer",
            'subs' =>
            [
                {
                    'url' => "ip.html",
                    'title' => "Layer 3 Protocols",
                },
                {
                    'url' => "ipv4-protocol.html",
                    'title' => "The IPv4 Protocol",
                },
                {
                    'url' => "masquerading.html",
                    'title' => "Masquerading",
                },
            ],
        },
        {
            'url' => "layer4",
            'title' => "Layer IV - the Transport Layer",
            'subs' =>
            [
                {
                    'url' => "firewalls.html",
                    'title' => "Firewalls",
                },
            ],
        },
        {
            'url' => "layer5.html",
            'title' => "Layer V - the Session Layer",
        },
        {
            'url' => "layer6.html",
            'title' => "Layer VI - the Presentation Layer",
        },
        {
            'url' => "layer7.html",
            'title' => "Layer VII - the Application Layer",
        },
        {
            'url' => "bibliography.html",
            'title' => "Bibliography",
        },
    ],
    'images' =>
    [
        'style.css',
        '7layer.gif',
    ],
};

sub get_contents
{
    return $contents;
}

1;
