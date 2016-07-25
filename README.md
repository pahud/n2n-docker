# About

[n2n](https://web.archive.org/web/20110924083045/http://www.ntop.org:80/products/n2n/) is is a **Layer two Peer-to-Peer VPN** created by the [ntop team](http://www.ntop.org/) with very good NAT-friendly support. n2n-docker is a docker wrapping of it.



# Diagram



![](https://web.archive.org/web/20110924083045im_/http://www.ntop.org/wp-content/uploads/2011/08/n2n_network.png)



![](https://web.archive.org/web/20110924083045im_/http://www.ntop.org/wp-content/uploads/2011/08/n2n_com.png)



# Howto - start supernode

```
// foreground mode
docker run --privileged --net=host -p 53/udp --rm -ti pahud/n2n-docker \
supernode -l 53 -f

// daemon mode
docker run -d --privileged --net=host -p 53/udp --name n2n_supernode pahud/n2n-docker supernode -l 53 -f
```



# Howto - start edge

```
// foreground mode
docker run --privileged --net=host --rm -ti pahud/n2n-docker \
edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <supernode_host>:<port> -f

// daemon mode
docker run -d --privileged --net=host --name n2n_edge pahud/n2n-docker edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <supernode_host>:<port> -f
```



# Examples



## building n2n network for GCP(Google Cloud Platform),  AWS and Aliyun

make sure **GCP networks->Firewall rules** has **up:53** open to **0.0.0.0/0** 
(you may specify some source IP addresses later)

### create supernode and 1st edge in GCP

```
// create supernode in GCP
docker run -d --privileged --name=n2n_supernode --net=host -p 53/udp pahud/n2n-docker supernode -l 53 -f

// create 1st edge in the same host with supernode
docker run -d --privileged --name=n2n_edge --net=host pahud/n2n-docker  edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <my_public_ip_address>:53 -f
```

you should see this with `docker ps` in the GCP supernode

```
# docker ps
CONTAINER ID        IMAGE               COMMAND                  CREATED             STATUS              PORTS               NAMES
7a0a2d6f3635        pahud/n2n-docker    "edge -d n2n0 -a 10.9"   5 seconds ago       Up 5 seconds                            n2n_edge01
39ee2caa461f        pahud/n2n-docker    "supernode -l 53 -f"     25 seconds ago      Up 25 seconds                           n2n_supernode
```

and you may ping yourself

```
# ping 10.9.9.1
PING 10.9.9.1 (10.9.9.1) 56(84) bytes of data.
64 bytes from 10.9.9.1: icmp_seq=1 ttl=64 time=0.043 ms
64 bytes from 10.9.9.1: icmp_seq=2 ttl=64 time=0.055 ms
64 bytes from 10.9.9.1: icmp_seq=3 ttl=64 time=0.046 ms
```

and even telnet tcp:22 to see the SSH prompt like this

```
# telnet 10.9.9.1 22
Trying 10.9.9.1...
Connected to 10.9.9.1.
Escape character is '^]'.
SSH-2.0-OpenSSH_6.6.1p1 Ubuntu-2ubuntu2.7
(press Ctrl-]<enter> and q<enter> to quit)
```

### create 2nd edge in AWS

```
docker run -d --privileged -name=n2n_edge --net=host  pahud/n2n-docker  edge -d n2n0 -a 10.9.9.2 -c mypbxnet -k mypass -l <public_ip_of_supernode>:53 -f
```

- please note we specify 10.9.9.2 as the n2n private IP in the 2nd edge
- make sure you specify the same -c and -k parameters just like 1st edge in GCP



then you can ping yourself like this

```
# ping 10.9.9.2PING 10.9.9.2 (10.9.9.2) 56(84) bytes of data.
64 bytes from 10.9.9.2: icmp_seq=1 ttl=255 time=0.035 ms
64 bytes from 10.9.9.2: icmp_seq=2 ttl=255 time=0.032 ms
```

and now ping the 1st edge like this

```
# ping 10.9.9.1
PING 10.9.9.1 (10.9.9.1) 56(84) bytes of data.
64 bytes from 10.9.9.1: icmp_seq=1 ttl=64 time=72.1 ms
64 bytes from 10.9.9.1: icmp_seq=2 ttl=64 time=35.4 ms
64 bytes from 10.9.9.1: icmp_seq=3 ttl=64 time=35.4 ms
```

try telnet SSH port on the 1st edge to see SSH prompt

```
# telnet 10.9.9.1 22
Trying 10.9.9.1...
Connected to 10.9.9.1.
Escape character is '^]'.
SSH-2.0-OpenSSH_6.6.1p1 Ubuntu-2ubuntu2.7
```



### create 3rd edge in Aliyun

```
docker run -d --privileged  -name=n2n_edge --net=host  pahud/n2n-docker  edge -d n2n0 -a 10.9.9.3 -c mypbxnet -k mypass -l <public_ip_of_supernode>:53 -f
```

and you will be able to ping 10.9.9.1 and 10.9.9.2 from AliYun instance.

Finally, you have a n2n network among **GCP(10.9.9.1)**, **AWS(10.9.9.2)** and **Aliyun(10.9.9.3)**

It is also possible to route traffic through n2n to GCP out but may require some iptables rules. Let me know if you have made it.