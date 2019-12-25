#!/bin/bash

for vni in 31 33 50; do
    brctl delif br${vni} vxlan${vni}
    ip link set br${vni} down
    brctl delbr br${vni}

    ip link set vxlan${vni} down
    ip link del vxlan${vni}

    ip link set eth${vni}p down
    ip link del eth${vni}p
#    ip netns exec ns ip link set eth${vni} down
#    ip netns exec ns ip link del eth${vni}
done
