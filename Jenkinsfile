pipeline {
    agent {
        label 'terraform-agent'
    }

    stages {

        stage('Checkout SCM') {
            steps {
                checkout scm
            }
        }

        stage('Agent Test') {
            steps {
                sh '''
                    echo "Hostname:"
                    hostname

                    echo "User:"
                    whoami

                    echo "Terraform:"
                    terraform --version

                    echo "Azure CLI:"
                    az --version
                '''
            }
        }

        stage('Azure Login') {
            steps {
                withCredentials([
                    azureServicePrincipal(
                        credentialsId: 'Azure-SP',
                        subscriptionIdVariable: 'ARM_SUBSCRIPTION_ID',
                        clientIdVariable: 'ARM_CLIENT_ID',
                        clientSecretVariable: 'ARM_CLIENT_SECRET',
                        tenantIdVariable: 'ARM_TENANT_ID'
                    )
                ]) {
                    sh '''
                        az login \
                          --service-principal \
                          --username "$ARM_CLIENT_ID" \
                          --password "$ARM_CLIENT_SECRET" \
                          --tenant "$ARM_TENANT_ID"

                        az account show
                    '''
                }
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
