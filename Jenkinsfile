#!/usr/bin/groovy
podTemplate(label: 'notejam-build', 
  containers: [
    containerTemplate(
      name: 'jnlp',
      image: '415911685446.dkr.ecr.us-east-1.amazonaws.com/jnlp-image:latest',
      alwaysPullImage: true,
      args: '${computer.jnlpmac} ${computer.name}'
    ),
    containerTemplate(
      name: 'docker',
      image: '415911685446.dkr.ecr.us-east-1.amazonaws.com/dnd-image:latest',
      alwaysPullImage: true,
      command: 'cat',
      ttyEnabled: true
    ),
    containerTemplate(
      name: 'rails',
      image: '415911685446.dkr.ecr.us-east-1.amazonaws.com/rails-image:latest',
      alwaysPullImage: true,
      command: 'sh -c "while true; do sleep 15 ; done"',
      ttyEnabled: true
    ),
  ],
  volumes: [ 
    hostPathVolume(mountPath: '/var/run/docker.sock', hostPath: '/var/run/docker.sock'), 
    emptyDirVolume(mountPath: '/usr/local/bundle', memory: true)
  ],
  imagePullSecrets: ['demo-jenkins-pull-secret']
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