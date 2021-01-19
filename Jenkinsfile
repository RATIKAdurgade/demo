#!/usr/bin/groovy
podTemplate(yaml: '''
apiVersion: v1
kind: Pod
spec:
  imagePullSecrets:
    - name: demo-jenkins-pull-secret
  containers:
  - name: jnlp
    image: 415911685446.dkr.ecr.us-east-1.amazonaws.com/jnlp-image:latest
    args: ['\${computer.jnlpmac}','\${computer.name}']
  - name: docker
    image: docker:19.03.1-dind
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run
    - name: gems
      mountPath: /usr/local/bundle
  - name: rails
    image: 415911685446.dkr.ecr.us-east-1.amazonaws.com/rails-image:latest
    command:
    - cat
    securityContext:
      privileged: true
    volumeMounts:
    - name: docker-socket
      mountPath: /var/run
    - name: gems
      mountPath: /usr/local/bundle
  volumes:
  - name: docker-socket
    emptyDir: {}
  - name: gems
    emptyDir: {}
'''
)
{
  node ('notejam-build') {
    checkout scm
    stage ('Build') {
     withCredentials([usernamePassword(credentialsId: 'quay', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        container('rails') {
          dir("${env.WORKSPACE}"){
          sh '''
            ls -alr
            pwd
            make build
            '''
          }
        }
      }
    }
    stage ('Test') {
     withCredentials([usernamePassword(credentialsId: 'quay', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        container('rails') {
          dir("${env.WORKSPACE}"){
          sh '''
            ls -alr
            pwd
            make test
            '''
          }
        }
      }
    }
    stage ('DockerBuild') {
     withCredentials([usernamePassword(credentialsId: 'quay', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {
        container('docker') {
          dir("${env.WORKSPACE}"){
          sh '''
            ls -alr
            pwd
            docker info;
            docker login --username $USERNAME --password $PASSWORD 415911685446.dkr.ecr.us-east-1.amazonaws.com
            make docker-build
            make docker-push
            '''
          }
        }
      }
    }
    stage ('Deploy') {
     withCredentials([file(credentialsId: 'k8config', variable: 'KUBECONFIG')]) {
        container('docker') {
          dir("${env.WORKSPACE}"){
          sh '''
            make kubernetes-deploy
            '''
          }
        }
      }
    }
  }
}