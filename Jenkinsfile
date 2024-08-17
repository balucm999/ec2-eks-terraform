pipeline {
    agent any
    environment {
       // withAWS(credentials: 'aws-creds', region: 'us-west-1')
        AWS_CREDENTIALS = 'aws-creds'
        AWS_DEFAULT_REGION = 'us-west-1'
    }
    stages{
        stage('Preparing') {
            steps {
                sh 'echo Preparing'
            }
        }
        stage('Checkout SCM'){
            steps{
                script{
                    checkout scmGit(branches: [[name: '*/main']], extensions: [], userRemoteConfigs: [[url: '']])
                }
            }
        }
        stage('Initializing Terraform'){
            steps{
                script{
                    dir('terraform'){
                         withAWS(credentials: 'aws-creds', region: 'us-west-1') {
                sh 'terraform init'
                }
                    }
                }
            }
        }
        stage('Validating Terraform'){
            steps{
                script{
                    dir('terraform'){
                         withAWS(credentials: 'aws-creds', region: 'us-west-1') {
                sh 'terraform validate'
                }
                    }
                }
            }
        }
        stage('Previewing the infrastructure'){
            steps{
                script{
                    dir('terraform'){
                         withAWS(credentials: 'aws-creds', region: 'us-west-1') {
                sh 'terraform plan'
                }
                    }
                    input(message: "Approve?", ok: "proceed")
                }
            }
        }
        stage('Create/Destroy an EKS cluster'){
            steps{
                script{
                    dir('terraform'){
                        withAWS(credentials: 'aws-creds', region: 'us-west-1') {
                sh 'terraform $action --auto-approve'
                }
                    }
                }
            }
        }
    }
}