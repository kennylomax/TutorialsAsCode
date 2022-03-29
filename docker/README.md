# Based on Peter Thonmas' Karate Docker File

- This is identical to https://github.com/karatelabs/karate/tree/develop/karate-docker/karate-chrome but with a homepage specified for chrome and java11

To deploy:

docker build -t kenlomax/karatejourneys:v1.06 .
docker push
