#!/bin/bash
cd `dirname $0`
cd ..

docker build -t cartify/frontend:0.1 ../cartify-frontend
docker build -t cartify/bff:0.1 ../cartify-bff
docker build -t cartify/catalogue-db:0.1 ../cartify-catalogue-db
docker build -t cartify/order-db:0.1 ../cartify-order-db
docker build -t cartify/catalogue:0.1 ../cartify-catalogue
docker build -t cartify/order:0.1 ../cartify-order
docker build -t cartify/shipping:0.1 ../cartify-shipping
#docker run -it --rm --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3.12-management

kind load docker-image cartify/catalogue-db:0.1
kind load docker-image cartify/order-db:0.1
kind load docker-image cartify/frontend:0.1
kind load docker-image cartify/bff:0.1
kind load docker-image cartify/catalogue:0.1
kind load docker-image cartify/order:0.1
kind load docker-image cartify/shipping:0.1


kubectl apply -f frontend/k8s/frontend.yaml
kubectl apply -f bff/k8s/bff.yaml
kubectl apply -f catalogue/k8s/catalogue.yaml
kubectl apply -f catalogue/k8s/catalogue-db.yaml

kubectl apply -f order/k8s/order.yaml
kubectl apply -f order/k8s/order-db.yaml
kubectl apply -f shipping/k8s/shipping.yaml
kubectl apply -f rabbitmq/k8s/rabbitmq.yaml

echo "wait..."
kubectl wait --for=condition=ready pods --all --timeout=90s
echo "deploy done"
