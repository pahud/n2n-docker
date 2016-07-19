# start supernode

```
// foreground mode
docker run --privileged -p 53:53/udp --rm -ti pahud/n2n-docker \
supernode -l 53 -f

// daemon mode
docker run -d --privileged -p 53:53/udp --name n2n_supernode pahud/n2n-docker supernode -l 53 -f
```



# start edge

```
// foreground mode
docker run --privileged --rm -ti pahud/n2n-docker \
edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <supernode_host>:<port> -f

// daemon mode
docker run -d --privileged  --name n2n_edge pahud/n2n-docker edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <supernode_host>:<port> -f
```

