pipeline {
    agent {
        label 'terraform-agent'
    }

    stages {

        stage('Agent Test') {
            steps {
                sh 'hostname'
                sh 'whoami'
                sh 'terraform --version'
                sh 'az --version'
                sh 'git --version'
            }
        }

        stage('Terraform Init') {
            steps {
                dir('Environment/preprod') {
                    sh 'terraform init'
                }
            }
        }

        stage('Terraform Validate') {
            steps {
                dir('Environment/preprod') {
                    sh 'terraform validate'
                }
            }
        }

        stage('Terraform Plan') {
            steps {
                dir('Environment/preprod') {
                    sh 'terraform plan'
                }
            }
        }
    }
}
