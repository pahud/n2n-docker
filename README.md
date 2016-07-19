# start supernode

```
docker run --privileged --rm -ti pahud/n2n-docker \
supernode -l 53 -f
```



# start edge

```
docker run --privileged --rm -ti pahud/n2n-docker \
edge -d n2n0 -a 10.9.9.1 -c mypbxnet -k mypass -l <supernode_host>:<port> -f
```

