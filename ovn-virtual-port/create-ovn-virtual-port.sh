#!/bin/bash

ip link add hv1-vif1 type veth peer hv1-vif1-peer
ip link add hv1-vif2 type veth peer hv1-vif2-peer
ip link add hv1-vif3 type veth peer hv1-vif3-peer

ovs-vsctl add-br br-phys
ovs-vsctl -- add-port br-int hv1-vif1 -- \
    set interface hv1-vif1 external-ids:iface-id=sw0-p1 \
    options:tx_pcap=hv1/vif1-tx.pcap \
    options:rxq_pcap=hv1/vif1-rx.pcap \
    ofport-request=1
ovs-vsctl -- add-port br-int hv1-vif2 -- \
    set interface hv1-vif2 external-ids:iface-id=sw0-p3 \
    options:tx_pcap=hv1/vif2-tx.pcap \
    options:rxq_pcap=hv1/vif2-rx.pcap \
    ofport-request=2
ovs-vsctl -- add-port br-int hv1-vif3 -- \
    set interface hv1-vif3 \
    options:tx_pcap=hv1/vif3-tx.pcap \
    options:rxq_pcap=hv1/vif3-rx.pcap \
    ofport-request=3


ovn-nbctl ls-add sw0

ovn-nbctl lsp-add sw0 sw0-vir
ovn-nbctl lsp-set-addresses sw0-vir "fa:16:3e:aa:d8:59 172.24.100.25"
ovn-nbctl lsp-set-port-security sw0-vir "fa:16:3e:aa:d8:59 172.24.100.25"
ovn-nbctl lsp-set-type sw0-vir virtual
ovn-nbctl set logical_switch_port sw0-vir options:virtual-ip=172.24.100.25
ovn-nbctl set logical_switch_port sw0-vir options:virtual-parents=sw0-port1,sw0-port3,sw0-port4

ovn-nbctl lsp-add sw0 sw0-vir1
ovn-nbctl lsp-set-addresses sw0-vir1 "fa:16:3e:9b:61:d1 2001:db8::f816:3eff:fe9b:61d1"
ovn-nbctl lsp-set-port-security sw0-vir1 "fa:16:3e:9b:61:d1 2001:db8::f816:3eff:fe9b:61d1"
ovn-nbctl lsp-set-type sw0-vir1 virtual
ovn-nbctl set logical_switch_port sw0-vir1 options:virtual-ip=2001:db8::f816:3eff:fe9b:61d1
ovn-nbctl set logical_switch_port sw0-vir1 options:virtual-parents=sw0-port1,sw0-port3,sw0-port4

ovn-nbctl lsp-add sw0 sw0-p1
ovn-nbctl lsp-set-addresses sw0-p1 "50:54:00:00:00:03 10.0.0.3"
ovn-nbctl lsp-set-port-security sw0-p1 "50:54:00:00:00:03 10.0.0.3 10.0.0.10"

ovn-nbctl lsp-add sw0 sw0-p3
ovn-nbctl lsp-set-addresses sw0-p3 "50:54:00:00:00:05 10.0.0.5"
ovn-nbctl lsp-set-port-security sw0-p3 "50:54:00:00:00:05 10.0.0.5 10.0.0.10"


