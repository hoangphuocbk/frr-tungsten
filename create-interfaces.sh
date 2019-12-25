#!/bin/bash

for vni in 31 33 50; do
    # Create VXLAN interface
    ip link add vxlan${vni} type vxlan \
        id ${vni} \
        local 10.60.17.238 \
        dstport 4789 \
        dev ext0.100 \
        nolearning
    # Create companion bridge
    brctl addbr br${vni}
    brctl addif br${vni} vxlan${vni}
    brctl stp br${vni} off
    ip link set up dev br${vni}
    ip link set up dev vxlan${vni}

    ip link add eth${vni} type veth peer name eth${vni}p
    ip link set eth${vni}p master br${vni}

    ip link set eth${vni} netns ns
    ip link set eth${vni}p up
    ip netns exec ns ip link set eth${vni} up
done

# Attach each VM to the appropriate segment
# ip addr add 10.50.50.100/24 dev eth31
# ip addr add 10.120.0.100/24 dev eth33

ip netns exec ns ip addr add 10.50.50.100/24 dev eth31
ip netns exec ns ip addr add 10.120.0.100/24 dev eth33
ip netns exec ns ip addr add 192.168.131.254/24 dev eth50
