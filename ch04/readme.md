Running assignments for Udacity Deep Learning class with TensorFlow
=====
## Preparation
- Running docker machine
```
docker-machine create -d virtualbox --virtualbox-memory 8196 tensorflow
eval $(docker-machine.exe env tensorflow)
```
- Running docker container 
```
docker run -p 8888:8888 --memory=8g --name tensorflow-udacity -it gcr.io/tensorflow/udacity-assignments:1.0.0
```
- Return to the docker container, if you ever exit the container
```
docker start -ai tensorflow-udacity
```
- Accessing notebook :  http://IP:8888
```
docker-machine ip tensorflow
```
-  GPU support..(May not supported in windows)
```
docker run -m 4g -d -it -p 8888:8888 -p 6006:6006 gcr.io/tensorflow/tensorflow:latest-gpu
```


## Reference
- https://github.com/tensorflow/tensorflow/tree/master/tensorflow/examples/udacity
